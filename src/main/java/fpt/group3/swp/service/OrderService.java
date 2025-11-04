package fpt.group3.swp.service;

import fpt.group3.swp.common.OrderItemStatus;
import fpt.group3.swp.common.OrderStatus;
import fpt.group3.swp.common.PaymentMethod;
import fpt.group3.swp.domain.*;
import fpt.group3.swp.reposirory.CartDetailRepo;
import fpt.group3.swp.reposirory.OrderItemRepository;
import fpt.group3.swp.reposirory.OrderRepo;
// --- NEW: thêm 2 repo dưới để hỗ trợ Mua Ngay ---
import fpt.group3.swp.reposirory.ProductRepository;
import fpt.group3.swp.reposirory.ProductVariantRepository;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

@Service
@RequiredArgsConstructor
public class OrderService {
    private final OrderRepo orderRepo;
    private final OrderItemRepository orderItemRepo;
    private final CartDetailRepo cartDetailRepo;
    private final ShippingService shippingService;
    private final ProductRepository productRepo;
    private final ProductVariantRepository variantRepo;

    @Transactional
    public Order createFromCartSelection(
            User user,
            List<Long> selectedCartDetailIds,
            PaymentMethod payment,
            String rName, String rPhone,
            String rAddr, String rProv, String rDist, String rWard) {
        List<CartDetail> lines = cartDetailRepo.findAllById(selectedCartDetailIds);
        if (lines.isEmpty())
            throw new IllegalArgumentException("Không có sản phẩm hợp lệ.");

        // Validate that all products are sellable (ACTIVE, not deleted) and shop is not
        // locked
        for (CartDetail cd : lines) {
            Product p = cd.getProduct();
            if (p == null) {
                throw new IllegalStateException("Invalid cart item.");
            }
            if (p.getStatus() != fpt.group3.swp.common.Status.ACTIVE || p.isDeleted()) {
                throw new IllegalStateException("Product '" + p.getName() + "' is not available for sale.");
            }
            if (p.getShop() != null && p.getShop().getUser() != null
                    && p.getShop().getUser().getStatus() == fpt.group3.swp.common.Status.INACTIVE) {
                throw new IllegalStateException("Shop is locked and cannot sell.");
            }
        }

        Order order = new Order();
        order.setUser(user);
        order.setPaymentMethod(payment);
        order.setOrderStatus(payment == PaymentMethod.COD
                ? OrderStatus.PAID
                : OrderStatus.PENDING_PAYMENT);

        order.setReceiverName(rName);
        order.setReceiverPhone(rPhone);
        order.setReceiverAddress(rAddr);
        order.setReceiverProvince(rProv);
        order.setReceiverDistrict(rDist);
        order.setReceiverWard(rWard);

        order.setItemsTotal(0);
        order.setShippingFee(0);
        order.setTotalAmount(0);
        order = orderRepo.save(order);

        // Group theo shop
        Map<Shop, List<CartDetail>> byShop = lines.stream()
                .collect(Collectors.groupingBy(cd -> cd.getProduct().getShop(),
                        LinkedHashMap::new, Collectors.toList()));

        int itemsTotal = 0;
        int shippingTotal = 0;
        Set<OrderItem> orderItems = new HashSet<>();

        for (var entry : byShop.entrySet()) {
            Shop shop = entry.getKey();
            List<CartDetail> shopLines = entry.getValue();

            int shopItemsCount = shopLines.stream().mapToInt(CartDetail::getQuantity).sum();
            int shopShip = shippingService.calcShopShippingFee(shopItemsCount);
            shippingTotal += shopShip;

            for (CartDetail cd : shopLines) {
                int unit = (int) Math.round(cd.getPrice());
                int total = unit * cd.getQuantity();

                OrderItem oi = new OrderItem();
                oi.setOrder(order);
                oi.setShop(shop);
                oi.setProduct(cd.getProduct());
                // oi.setVariant(cd.getVariant());
                oi.setQuantity(cd.getQuantity());
                oi.setUnitPrice(unit);
                oi.setTotalPrice(total);
                oi.setStatus(OrderItemStatus.CONFIRMED);

                orderItems.add(oi);
                itemsTotal += total;
            }
        }

        order.setItemsTotal(itemsTotal);
        order.setShippingFee(shippingTotal);
        order.setTotalAmount(itemsTotal + shippingTotal);
        order.setOrderItems(orderItems);

        Order saved = orderRepo.save(order);

        if (payment == PaymentMethod.COD) {
            cartDetailRepo.deleteAll(lines);
        }

        return saved;
    }

    @Transactional
    public Order createFromDirectItem(
            User user,
            Long productId,
            Long variantId,
            int qty,
            PaymentMethod payment,
            String rName, String rPhone,
            String rAddr, String rProv, String rDist, String rWard) {
        if (qty <= 0)
            qty = 1;

        Product product = productRepo.findById(productId).orElseThrow();
        if (product.getStatus() != fpt.group3.swp.common.Status.ACTIVE || product.isDeleted()) {
            throw new IllegalStateException("Product is not available for sale.");
        }
        if (product.getShop() != null && product.getShop().getUser() != null
                && product.getShop().getUser().getStatus() == fpt.group3.swp.common.Status.INACTIVE) {
            throw new IllegalStateException("Shop is locked and cannot sell.");
        }
        ProductVariant variant = null;
        if (variantId != null) {
            variant = variantRepo.findById(variantId).orElseThrow();
            if (!variant.getProduct().getId().equals(product.getId())) {
                throw new IllegalArgumentException("Biến thể không thuộc sản phẩm.");
            }
        }

        double basePrice = (variant != null && variant.getPrice() != null)
                ? variant.getPrice()
                : product.getPrice();
        int unit = (int) Math.round(basePrice);
        int lineTotal = unit * qty;

        Order order = new Order();
        order.setUser(user);
        order.setPaymentMethod(payment);
        order.setOrderStatus(payment == PaymentMethod.COD
                ? OrderStatus.PAID
                : OrderStatus.PENDING_PAYMENT);

        order.setReceiverName(rName);
        order.setReceiverPhone(rPhone);
        order.setReceiverAddress(rAddr);
        order.setReceiverProvince(rProv);
        order.setReceiverDistrict(rDist);
        order.setReceiverWard(rWard);

        Shop shop = product.getShop();
        int shopShip = shippingService.calcShopShippingFee(qty);

        OrderItem oi = new OrderItem();
        oi.setOrder(order);
        oi.setShop(shop);
        oi.setProduct(product);
        // oi.setVariant(variant);
        oi.setQuantity(qty);
        oi.setUnitPrice(unit);
        oi.setTotalPrice(lineTotal);
        oi.setStatus(OrderItemStatus.CONFIRMED);

        Set<OrderItem> orderItems = new HashSet<>();
        orderItems.add(oi);

        order.setItemsTotal(lineTotal);
        order.setShippingFee(shopShip);
        order.setTotalAmount(lineTotal + shopShip);
        order.setOrderItems(orderItems);

        return orderRepo.save(order);
    }

    public Order getById(Long id) {
        return orderRepo.findById(id).orElseThrow();
    }

    public java.util.List<Order> findAllByUser(Long userId) {
        return orderRepo.findAllByUser_IdOrderByCreatedAtDesc(userId);
    }

    public java.util.List<Order> findAllByShop(Long shopId) {
        return orderRepo.findAllByShopId(shopId);
    }

    // Paged
    public Page<Order> findAllByUser(Long userId, Pageable pageable) {
        return orderRepo.findAllByUser_Id(userId, pageable);
    }

    public Page<Order> findAllByShop(Long shopId, Pageable pageable) {
        return orderRepo.findAllByShopId(shopId, pageable);
    }

    @Transactional
    public void markPaid(Long orderId) {
        Order o = orderRepo.findById(orderId).orElseThrow();
        o.setOrderStatus(OrderStatus.PAID);
        orderRepo.save(o);

        if (o.getPaymentMethod() == PaymentMethod.VNPAY && o.getOrderItems() != null && !o.getOrderItems().isEmpty()) {
            // Lấy TẤT CẢ cart details rồi lọc theo user
            List<CartDetail> userCartLines = cartDetailRepo.findAll().stream()
                    .filter(cd -> cd.getCart() != null
                            && cd.getCart().getUser() != null
                            && cd.getCart().getUser().getId() == o.getUser().getId())
                    // trừ FIFO theo thời gian thêm vào giỏ
                    .sorted(Comparator.comparing(CartDetail::getCreatedAt))
                    .collect(Collectors.toList());

            for (OrderItem oi : o.getOrderItems()) {
                long productId = oi.getProduct().getId();
                int need = oi.getQuantity();

                for (CartDetail cd : userCartLines) {
                    if (need <= 0)
                        break;
                    if (cd.getProduct() == null || cd.getProduct().getId() != productId)
                        continue;

                    int take = Math.min(cd.getQuantity(), need);
                    int remain = cd.getQuantity() - take;

                    if (remain > 0) {
                        cd.setQuantity(remain);
                        cartDetailRepo.save(cd);
                    } else {
                        cartDetailRepo.delete(cd);
                    }
                    need -= take;
                }
            }
        }
    }

    @Transactional
    public void markFailed(Long orderId) {
        orderRepo.findById(orderId).ifPresent(o -> {
            o.setOrderStatus(OrderStatus.CANCELED);
            orderRepo.save(o);
        });
    }
}
