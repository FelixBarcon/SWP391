package fpt.group3.swp.reposirory;

import fpt.group3.swp.domain.ProductReview;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface ProductReviewRepository extends JpaRepository<ProductReview, Long> {

    Page<ProductReview> findAllByProduct_IdAndIsDeletedFalseAndIsVisibleTrue(Long productId, Pageable pageable);

    boolean existsByUser_IdAndProduct_Id(Long userId, Long productId);

    Optional<ProductReview> findByUser_IdAndProduct_Id(Long userId, Long productId);

    boolean existsByOrderItem_Id(Long orderItemId);

    Optional<ProductReview> findByOrderItem_Id(Long orderItemId);

    @Query("SELECT COALESCE(AVG(r.rating), 0) FROM ProductReview r WHERE r.product.id = :productId AND r.isDeleted = false AND r.isVisible = true")
    Double averageRatingByProduct(@Param("productId") Long productId);

    Long countByProduct_IdAndIsDeletedFalseAndIsVisibleTrue(Long productId);

    @Query(value = "SELECT r FROM ProductReview r " +
            "WHERE r.isDeleted = false " +
            "AND (:productId IS NULL OR r.product.id = :productId) " +
            "AND (:visible IS NULL OR r.isVisible = :visible) " +
            "AND (:q IS NULL OR :q = '' OR (" +
            "     lower(coalesce(r.title,'')) LIKE lower(concat('%', :q, '%')) OR " +
            "     lower(coalesce(r.comment,'')) LIKE lower(concat('%', :q, '%')) OR " +
            "     lower(coalesce(r.product.name,'')) LIKE lower(concat('%', :q, '%')) OR " +
            "     lower(coalesce(r.user.fullName,'')) LIKE lower(concat('%', :q, '%')) OR " +
            "     lower(coalesce(r.user.email,'')) LIKE lower(concat('%', :q, '%')) " +
            ")) ORDER BY r.createdAt DESC",
            countQuery = "SELECT COUNT(r) FROM ProductReview r " +
                    "WHERE r.isDeleted = false " +
                    "AND (:productId IS NULL OR r.product.id = :productId) " +
                    "AND (:visible IS NULL OR r.isVisible = :visible) " +
                    "AND (:q IS NULL OR :q = '' OR (" +
                    "     lower(coalesce(r.title,'')) LIKE lower(concat('%', :q, '%')) OR " +
                    "     lower(coalesce(r.comment,'')) LIKE lower(concat('%', :q, '%')) OR " +
                    "     lower(coalesce(r.product.name,'')) LIKE lower(concat('%', :q, '%')) OR " +
                    "     lower(coalesce(r.user.fullName,'')) LIKE lower(concat('%', :q, '%')) OR " +
                    "     lower(coalesce(r.user.email,'')) LIKE lower(concat('%', :q, '%')) " +
                    "))")
    Page<ProductReview> adminSearch(@Param("productId") Long productId,
                                    @Param("visible") Boolean visible,
                                    @Param("q") String q,
                                    Pageable pageable);
}
