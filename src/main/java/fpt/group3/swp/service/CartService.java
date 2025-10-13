package fpt.group3.swp.service;

import java.util.*;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import fpt.group3.swp.domain.*;
import fpt.group3.swp.domain.dto.ShopCartDto;
import fpt.group3.swp.reposirory.*;

@Service
public class CartService {
    private final CartRepo cartRepo;
    private final ProductRepository productRepo;
    private final ProductVariantRepository variantRepo;
    private final CartDetailRepo cartDetailRepo;

    public CartService(CartRepo cartRepo, ProductRepository productRepo, ProductVariantRepository variantRepo,  CartDetailRepo cartDetailRepo) {
        this.cartRepo = cartRepo;
        this.productRepo = productRepo;
        this.variantRepo = variantRepo;
        this.cartDetailRepo = cartDetailRepo;
    }

    /** Lấy (hoặc tạo) cart của user trong DB */
    @Transactional
    public Cart getOrCreateCart(User user) {
        return cartRepo.findByUser_Id(user.getId())
            .orElseGet(() -> {
                Cart c = new Cart(); c.setUser(user);
                return cartRepo.save(c);
            });
    }

    @Transactional
    public void addProduct(User user, Long productId, Long variantId, int qty) {
        Cart cart = getOrCreateCart(user);

        // tìm xem đã có dòng giống (sp + variant) chưa
        Optional<CartDetail> exist = cart.getCartDetails().stream()
            .filter(cd -> cd.getProduct().getId().equals(productId)
                    && Objects.equals(cd.getVariant() != null ? cd.getVariant().getId() : null, variantId))
            .findFirst();

        if (exist.isPresent()) {
            CartDetail cd = exist.get();
            cd.setQuantity(cd.getQuantity() + Math.max(1, qty));
        } else {
            Product p = productRepo.findById(productId).orElseThrow();
            ProductVariant v = (variantId == null) ? null :
                    variantRepo.findById(variantId).orElse(null);

            double price = (v != null && v.getPrice() != null) ? v.getPrice() : p.getPrice();

            CartDetail cd = new CartDetail();
            cd.setCart(cart);
            cd.setProduct(p);
            cd.setVariant(v);
            cd.setQuantity(Math.max(1, qty));
            cd.setPrice(price);

            cart.getCartDetails().add(cd);
        }
        cartRepo.save(cart);
    }

    @Transactional
    public void updateQty(User user, Long cartDetailId, int qty) {
        Cart cart = cartRepo.findByUser_Id(user.getId()).orElseThrow();
        cart.getCartDetails().forEach(cd -> {
            if (cd.getId().equals(cartDetailId)) {
                cd.setQuantity(Math.max(1, qty));
            }
        });
    }

    @Transactional
    public void removeDetail(User user, Long cartDetailId) {
        Cart cart = cartRepo.findByUser_Id(user.getId()).orElseThrow();
        cart.getCartDetails().removeIf(cd -> cd.getId().equals(cartDetailId));
    }

    public Cart getCart(User user) {
        return cartRepo.findByUser_Id(user.getId()).orElse(null);
    }

    /** Nhóm theo Shop để render giống Shopee */
    public List<ShopCartDto> groupByShop(User user) {
        Cart cart = getCart(user);
        if (cart == null || cart.getCartDetails().isEmpty()) return List.of();

        return cart.getCartDetails().stream()
            .collect(Collectors.groupingBy(cd -> cd.getProduct().getShop()))
            .entrySet().stream()
            .map(e -> new ShopCartDto(e.getKey(), e.getValue()))
            .toList();
    }

    public double calcGrandTotal(User user) {
        return groupByShop(user).stream().mapToDouble(ShopCartDto::getShopTotal).sum();
    }

    @Transactional
    public void changeVariant(User user, Long cartDetailId, Long newVariantId) {
        Cart cart = cartRepo.findByUser_Id(user.getId()).orElseThrow();
        CartDetail target = cart.getCartDetails().stream()
                .filter(cd -> cd.getId().equals(cartDetailId))
                .findFirst().orElseThrow();

        Product product = target.getProduct();
        ProductVariant newVariant = (newVariantId == null) ? null :
                variantRepo.findById(newVariantId).orElseThrow();

        if (newVariant != null && !newVariant.getProduct().getId().equals(product.getId())) {
            throw new IllegalArgumentException("Biến thể không thuộc sản phẩm này");
        }

        Optional<CartDetail> duplicated = cart.getCartDetails().stream()
                .filter(cd -> cd != target
                        && cd.getProduct().getId().equals(product.getId())
                        && Objects.equals(cd.getVariant() == null ? null : cd.getVariant().getId(),
                        newVariant == null ? null : newVariant.getId()))
                .findFirst();

        double newUnitPrice = (newVariant != null && newVariant.getPrice() != null)
                ? newVariant.getPrice()
                : product.getPrice();

        if (duplicated.isPresent()) {
            CartDetail dup = duplicated.get();
            dup.setQuantity(dup.getQuantity() + target.getQuantity());
            cart.getCartDetails().remove(target); // cần orphanRemoval=true ở mapping
        } else {
            target.setVariant(newVariant);
            target.setPrice(newUnitPrice);
        }

        cartRepo.save(cart);
    }


    public class PagedCartView {
        public List<ShopCartDto> groups;
        public int currentPage;
        public int totalPages;
        public long totalItems;
    }

    public PagedCartView getPagedGroups(User user, int page, int size) {
        Page<CartDetail> p = cartDetailRepo.findByCart_User_IdOrderByIdAsc(
                user.getId(),
                PageRequest.of(page - 1, size)
        );

        Map<Shop, List<CartDetail>> grouped = p.getContent().stream()
                .collect(Collectors.groupingBy(
                        cd -> cd.getProduct().getShop(),
                        LinkedHashMap::new,
                        Collectors.toList()
                ));

        List<ShopCartDto> groups = grouped.entrySet().stream()
                .map(e -> new ShopCartDto(e.getKey(), e.getValue()))
                .toList();

        PagedCartView view = new PagedCartView();
        view.groups = groups;
        view.currentPage = p.getNumber() + 1;
        view.totalPages = p.getTotalPages();
        view.totalItems = p.getTotalElements();
        return view;
    }

    public List<ShopCartDto> groupSelectionByShop(List<Long> cartDetailIds) {
        List<CartDetail> list = cartDetailRepo.findAllById(cartDetailIds);
        Map<Shop, List<CartDetail>> byShop = list.stream()
                .collect(Collectors.groupingBy(cd -> cd.getProduct().getShop(),
                        LinkedHashMap::new, Collectors.toList()));
        List<ShopCartDto> result = new ArrayList<>();
        byShop.forEach((shop, cds) -> result.add(new ShopCartDto(shop, cds)));
        return result;
    }

    // Gom dữ liệu cho 1 lựa chọn "mua ngay"
//    public List<ShopCartDto> groupDirectItemByShop(Long productId, Long variantId, int qty) {
//        Product p = productRepo.findById(productId).orElseThrow();
//        ProductVariant v = (variantId == null) ? null : variantRepo.findById(variantId).orElse(null);
//
//        double unitPrice = (v != null && v.getPrice() != null) ? v.getPrice() : p.getPrice();
//
//        CartDetail fake = new CartDetail()
//        fake.setProduct(p);
//        fake.setVariant(v);
//        fake.setQuantity(Math.max(1, qty));
//        fake.setPrice(unitPrice);
//
//        List<CartDetail> list = new ArrayList<>();
//        list.add(fake);
//
//        List<ShopCartDto> result = new ArrayList<>();
//        result.add(new ShopCartDto(p.getShop(), list));
//        return result;
//    }

//    public double estimateWeight(List<CartDetail> items) {
//        return items.stream().mapToDouble(cd -> cd.getQuantity() * 0.3).sum();
//    }

    // Tổng số loại sản phẩm trong giỏ hàng (dùng cho badge ở header)
    // VD: 10 áo loại 1 + 2 áo loại 2 = hiển thị 2 (không phải 12)
    public int getTotalCartItemsCount(User user) {
        // Use custom query to avoid lazy loading issues
        List<CartDetail> details = cartDetailRepo.findByCart_User_Id(user.getId());
        
        if (details == null || details.isEmpty()) {
            return 0;
        }
        
        // Đếm số dòng (số loại sản phẩm), không phải tổng quantity
        return details.size();
    }
}
