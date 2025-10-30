package fpt.group3.swp.service;

import fpt.group3.swp.common.OrderStatus;
import fpt.group3.swp.domain.OrderItem;
import fpt.group3.swp.domain.Product;
import fpt.group3.swp.domain.ProductReview;
import fpt.group3.swp.domain.Shop;
import fpt.group3.swp.domain.User;
import fpt.group3.swp.domain.dto.PurchasedProductReviewView;
import fpt.group3.swp.reposirory.OrderItemRepository;
import fpt.group3.swp.reposirory.ProductRepository;
import fpt.group3.swp.reposirory.ProductReviewRepository;
import fpt.group3.swp.reposirory.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class ProductReviewService {
    private final ProductReviewRepository productReviewRepository;
    private final ProductRepository productRepository;
    private final UserRepository userRepository;
    private final OrderItemRepository orderItemRepository;

    public ProductReviewService(ProductReviewRepository productReviewRepository,
                                ProductRepository productRepository,
                                UserRepository userRepository,
                                OrderItemRepository orderItemRepository) {
        this.productReviewRepository = productReviewRepository;
        this.productRepository = productRepository;
        this.userRepository = userRepository;
        this.orderItemRepository = orderItemRepository;
    }

    public Page<ProductReview> getVisibleByProduct(Long productId, int page, int size) {
        int safePage = Math.max(page, 0);
        int safeSize = Math.max(size, 1);
        Pageable pageable = PageRequest.of(safePage, safeSize, Sort.by(Sort.Direction.DESC, "createdAt"));
        Page<ProductReview> pageData = productReviewRepository
                .findAllByProduct_IdAndIsDeletedFalseAndIsVisibleTrue(productId, pageable);
        int totalPages = pageData.getTotalPages();
        if (totalPages > 0 && safePage >= totalPages) {
            int lastIndex = totalPages - 1;
            Pageable lastPageable = PageRequest.of(lastIndex, safeSize, Sort.by(Sort.Direction.DESC, "createdAt"));
            pageData = productReviewRepository
                    .findAllByProduct_IdAndIsDeletedFalseAndIsVisibleTrue(productId, lastPageable);
        }
        return pageData;
    }

    public Double getAverageRating(Long productId) {
        return productReviewRepository.averageRatingByProduct(productId);
    }

    @Transactional(readOnly = true)
    public Page<PurchasedProductReviewView> getPurchasedProductsForUser(Long userId, int page, int size) {
        List<OrderItem> items = orderItemRepository
                .findAllByOrder_User_IdAndOrder_OrderStatus(userId, OrderStatus.PAID);
        items.sort((a, b) -> {
            LocalDate da = a.getOrder() != null ? a.getOrder().getCreatedAt() : null;
            LocalDate db = b.getOrder() != null ? b.getOrder().getCreatedAt() : null;
            if (da == null && db == null) return 0;
            if (da == null) return 1;
            if (db == null) return -1;
            return db.compareTo(da);
        });
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        List<PurchasedProductReviewView> views = new ArrayList<>();
        for (OrderItem item : items) {
            Product product = item.getProduct();
            Shop shop = product.getShop();
            if (shop != null) {
                shop.getDisplayName();
            }
            ProductReview existing = productReviewRepository
                    .findByOrderItem_Id(item.getId())
                    .orElse(null);
            boolean canReview = existing == null;
            Double avg = Optional.ofNullable(getAverageRating(product.getId())).orElse(0d);
            LocalDate purchasedDate = item.getOrder() != null ? item.getOrder().getCreatedAt() : null;
            String purchasedAt = purchasedDate != null ? purchasedDate.format(formatter) : "";
            views.add(new PurchasedProductReviewView(
                    product,
                    item,
                    existing,
                    canReview,
                    avg,
                    purchasedAt
            ));
        }

        int safePage = Math.max(page, 0);
        int safeSize = Math.max(size, 1);
        int totalItems = views.size();
        int maxPageIndex = totalItems == 0 ? 0 : Math.max((totalItems - 1) / safeSize, 0);
        int effectivePage = totalItems == 0 ? 0 : Math.min(safePage, maxPageIndex);
        int fromIndex = Math.min(effectivePage * safeSize, totalItems);
        int toIndex = Math.min(fromIndex + safeSize, totalItems);
        List<PurchasedProductReviewView> pageContent = new ArrayList<>(views.subList(fromIndex, toIndex));
        Pageable pageable = PageRequest.of(effectivePage, safeSize);
        return new PageImpl<>(pageContent, pageable, views.size());
    }

    @Transactional
    public ProductReview createReview(Long productId,
                                      Long userId,
                                      Long orderItemId,
                                      int rating,
                                      String title,
                                      String comment) {
        Product product = productRepository.findById(productId).orElseThrow();
        User user = userRepository.findById(userId).orElseThrow();

        OrderItem orderItem;
        ProductReview existingReview = null;
        if (orderItemId != null) {
            orderItem = orderItemRepository.findById(orderItemId)
                    .orElseThrow(() -> new IllegalStateException("Không tìm thấy sản phẩm trong đơn hàng."));
            if (orderItem.getOrder() == null
                    || orderItem.getOrder().getUser() == null
                    || orderItem.getOrder().getUser().getId() != userId) {
                throw new IllegalStateException("Đơn hàng không thuộc về bạn.");
            }
            if (!orderItem.getProduct().getId().equals(productId)) {
                throw new IllegalStateException("Đơn hàng không khớp với sản phẩm cần đánh giá.");
            }
            if (orderItem.getOrder().getOrderStatus() != OrderStatus.PAID) {
                throw new IllegalStateException("Đơn hàng chưa hoàn tất thanh toán.");
            }
            existingReview = productReviewRepository.findByOrderItem_Id(orderItemId).orElse(null);
            if (existingReview != null && existingReview.getUser() != null
                    && existingReview.getUser().getId() != userId) {
                throw new IllegalStateException("Bạn không thể chỉnh sửa đánh giá của người khác.");
            }
        } else {
            orderItem = findFirstUnreviewedOrderItem(userId, productId)
                    .orElseThrow(() -> new IllegalStateException("Bạn đã đánh giá tất cả đơn hàng của sản phẩm này."));
        }

        Shop shop = product.getShop();

        if (existingReview != null) {
            existingReview.setRating(Math.max(1, Math.min(5, rating)));
            existingReview.setTitle(title);
            existingReview.setComment(comment);
            existingReview.setCreatedAt(LocalDate.now());
            existingReview.setVisible(true);
            existingReview.setDeleted(false);
            return productReviewRepository.save(existingReview);
        }

        ProductReview review = new ProductReview();
        review.setProduct(product);
        review.setUser(user);
        review.setShop(shop);
        review.setOrderItem(orderItem);
        review.setRating(Math.max(1, Math.min(5, rating)));
        review.setTitle(title);
        review.setComment(comment);
        review.setCreatedAt(LocalDate.now());
        review.setVisible(true);
        review.setDeleted(false);

        return productReviewRepository.save(review);
    }

    private Optional<OrderItem> findFirstUnreviewedOrderItem(Long userId, Long productId) {
        List<OrderItem> items = orderItemRepository
                .findAllByOrder_User_IdAndProduct_IdAndOrder_OrderStatus(userId, productId, OrderStatus.PAID);
        items.sort((a, b) -> {
            LocalDate da = a.getOrder() != null ? a.getOrder().getCreatedAt() : null;
            LocalDate db = b.getOrder() != null ? b.getOrder().getCreatedAt() : null;
            if (da == null && db == null) return 0;
            if (da == null) return 1;
            if (db == null) return -1;
            return db.compareTo(da);
        });
        for (OrderItem item : items) {
            if (!productReviewRepository.existsByOrderItem_Id(item.getId())) {
                return Optional.of(item);
            }
        }
        return Optional.empty();
    }}






