package fpt.group3.swp.reposirory.spec;

import fpt.group3.swp.common.Status;
import fpt.group3.swp.domain.Category;
import fpt.group3.swp.domain.Product;
import fpt.group3.swp.domain.ProductReview;
import jakarta.persistence.criteria.*;
import org.springframework.data.jpa.domain.Specification;

import java.util.List;

public class ProductSpecifications {

    public static Specification<Product> active() {
        return (root, query, cb) -> cb.and(
                cb.equal(root.get("status"), Status.ACTIVE),
                cb.isFalse(root.get("deleted")));
    }

    public static Specification<Product> keyword(String q) {
        if (q == null || q.isBlank())
            return null;
        String likeRaw = "%" + q.trim() + "%";
        return (root, query, cb) -> cb.or(
                cb.like(cb.coalesce(root.get("name"), ""), likeRaw),
                cb.like(cb.coalesce(root.get("description"), ""), likeRaw));
    }

    public static Specification<Product> inCategories(List<Long> categoryIds) {
        if (categoryIds == null || categoryIds.isEmpty())
            return null;
        return (root, query, cb) -> {
            query.distinct(true);
            Join<Product, Category> cat = root.join("categories", JoinType.INNER);
            CriteriaBuilder.In<Long> inClause = cb.in(cat.get("id"));
            for (Long id : categoryIds) {
                inClause.value(id);
            }
            return inClause;
        };
    }

    public static Specification<Product> priceBetween(Double min, Double max) {
        if (min == null && max == null)
            return null;
        return (root, query, cb) -> {
            Expression<Double> priceMin = cb.coalesce(root.get("priceMin"), root.get("price"));
            Expression<Double> priceMax = cb.coalesce(root.get("priceMax"), root.get("price"));
            Predicate p = cb.conjunction();
            if (min != null) {
                p = cb.and(p, cb.greaterThanOrEqualTo(priceMax, min));
            }
            if (max != null) {
                p = cb.and(p, cb.lessThanOrEqualTo(priceMin, max));
            }
            return p;
        };
    }

    public static Specification<Product> ratingAtLeast(Integer minRating, boolean includeUnrated) {
        if (minRating == null || minRating <= 0)
            return null;
        return (root, query, cb) -> {
            // Subquery để tính average rating
            Subquery<Double> avgRatingSub = query.subquery(Double.class);
            Root<ProductReview> avgRoot = avgRatingSub.from(ProductReview.class);
            avgRatingSub.select(cb.avg(avgRoot.get("rating")));
            avgRatingSub.where(
                    cb.equal(avgRoot.get("product"), root),
                    cb.isFalse(avgRoot.get("isDeleted")),
                    cb.isTrue(avgRoot.get("isVisible"))
            );

            // Đơn giản: Lấy sản phẩm có average rating >= minRating
            // COALESCE xử lý NULL: sản phẩm chưa có review sẽ có rating = 0
            return cb.greaterThanOrEqualTo(
                    cb.coalesce(avgRatingSub, 0.0), 
                    minRating.doubleValue()
            );
        };
    }
}
