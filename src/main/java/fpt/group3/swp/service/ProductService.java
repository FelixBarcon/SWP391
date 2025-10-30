package fpt.group3.swp.service;/* AnVo
    
    @author: Admin
    Date: 18/09/2025
    Time: 4:41 PM
    
    ProjectName: swp 
*/

import fpt.group3.swp.domain.Product;
import fpt.group3.swp.reposirory.ProductRepository;
import fpt.group3.swp.reposirory.spec.ProductSpecifications;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService {
    private final ProductRepository productRepository;

    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    public List<Product> getAllProduct() {
        return this.productRepository.findAll();
    }

    public Page<Product> search(String q,
                                List<Long> categoryIds,
                                Double minPrice,
                                Double maxPrice,
                                Integer minRating,
                                int page,
                                int size,
                                String sort,
                                boolean includeUnrated) {
        int p = Math.max(0, page);
        int s = Math.min(Math.max(size, 1), 48);

        // Normalize price range if both provided and out of order
        if (minPrice != null && maxPrice != null && minPrice > maxPrice) {
            Double tmp = minPrice;
            minPrice = maxPrice;
            maxPrice = tmp;
        }
        Sort sortObj = Sort.by(Sort.Direction.DESC, "updatedAt");
        if (sort != null) {
            switch (sort) {
                case "gia-tang-dan" -> sortObj = Sort.by(Sort.Direction.ASC, "price");
                case "gia-giam-dan" -> sortObj = Sort.by(Sort.Direction.DESC, "price");
                case "moi-nhat" -> sortObj = Sort.by(Sort.Direction.DESC, "createdAt");
                default -> {}
            }
        }
        Pageable pageable = PageRequest.of(p, s, sortObj);

        Specification<Product> spec = Specification.where(ProductSpecifications.active());
        if (q != null && !q.isBlank()) spec = spec.and(ProductSpecifications.keyword(q));
        if (categoryIds != null && !categoryIds.isEmpty()) spec = spec.and(ProductSpecifications.inCategories(categoryIds));
        if (minPrice != null || maxPrice != null) spec = spec.and(ProductSpecifications.priceBetween(minPrice, maxPrice));
        if (minRating != null && minRating > 0) spec = spec.and(ProductSpecifications.ratingAtLeast(minRating, includeUnrated));

        return productRepository.findAll(spec, pageable);
    }
}
