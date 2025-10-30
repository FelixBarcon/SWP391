package fpt.group3.swp.service;

import fpt.group3.swp.domain.ProductReview;
import fpt.group3.swp.reposirory.ProductReviewRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AdminReviewService {

    private final ProductReviewRepository productReviewRepository;

    public AdminReviewService(ProductReviewRepository productReviewRepository) {
        this.productReviewRepository = productReviewRepository;
    }

    public Page<ProductReview> search(Long productId, Boolean visible, String q, int page, int size) {
        Pageable pageable = PageRequest.of(Math.max(0, page), Math.max(1, size));
        return productReviewRepository.adminSearch(productId, visible, q, pageable);
    }

    @Transactional
    public void hideReview(Long reviewId) {
        ProductReview r = productReviewRepository.findById(reviewId).orElseThrow();
        r.setVisible(false);
        productReviewRepository.save(r);
    }

    @Transactional
    public void unhideReview(Long reviewId) {
        ProductReview r = productReviewRepository.findById(reviewId).orElseThrow();
        r.setVisible(true);
        productReviewRepository.save(r);
    }
}

