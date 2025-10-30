package fpt.group3.swp.domain.dto;

import fpt.group3.swp.domain.OrderItem;
import fpt.group3.swp.domain.Product;
import fpt.group3.swp.domain.ProductReview;

public class PurchasedProductReviewView {
    private final Product product;
    private final OrderItem orderItem;
    private final ProductReview existingReview;
    private final boolean canReview;
    private final Double averageRating;
    private final String purchasedAt;

    public PurchasedProductReviewView(Product product,
                                      OrderItem orderItem,
                                      ProductReview existingReview,
                                      boolean canReview,
                                      Double averageRating,
                                      String purchasedAt) {
        this.product = product;
        this.orderItem = orderItem;
        this.existingReview = existingReview;
        this.canReview = canReview;
        this.averageRating = averageRating;
        this.purchasedAt = purchasedAt;
    }

    public Product getProduct() {
        return product;
    }

    public OrderItem getOrderItem() {
        return orderItem;
    }

    public ProductReview getExistingReview() {
        return existingReview;
    }

    public boolean isCanReview() {
        return canReview;
    }

    public Double getAverageRating() {
        return averageRating;
    }

    public String getPurchasedAt() {
        return purchasedAt;
    }
}
