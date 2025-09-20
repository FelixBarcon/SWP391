package fpt.group3.swp.service;/* AnVo
    
    @author: Admin
    Date: 18/09/2025
    Time: 4:41 PM
    
    ProjectName: swp 
*/

import fpt.group3.swp.domain.Product;
import fpt.group3.swp.reposirory.ProductRepository;
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
}
