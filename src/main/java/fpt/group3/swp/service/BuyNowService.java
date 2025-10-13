// src/main/java/fpt/group3/swp/service/BuyNowService.java
package fpt.group3.swp.service;

import fpt.group3.swp.domain.*;
import fpt.group3.swp.domain.dto.ShopCartDto;
import fpt.group3.swp.reposirory.ProductRepository;
import fpt.group3.swp.reposirory.ProductVariantRepository;
import lombok.Getter;
import lombok.Setter;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.Serializable;   // <-- thêm
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class BuyNowService {

    private final ProductRepository productRepo;
    private final ProductVariantRepository variantRepo;

    @Getter @Setter
    public static class BuyNowRequest implements Serializable {
        private static final long serialVersionUID = 1L;

        private Long productId;
        private Long variantId;
        private int quantity;

        public BuyNowRequest() {}

        public BuyNowRequest(Long productId, Long variantId, int quantity) {
            this.productId = productId;
            this.variantId = variantId;
            this.quantity  = quantity;
        }
    }

    @Transactional(readOnly = true)
    public List<ShopCartDto> groupDirectItemByShop(Long productId, Long variantId, int qty) {
        if (qty <= 0) qty = 1;

        Product p = productRepo.findById(productId).orElseThrow();
        ProductVariant v = (variantId == null) ? null : variantRepo.findById(variantId).orElse(null);

        double unitPrice = (v != null && v.getPrice() != null) ? v.getPrice() : p.getPrice();

        CartDetail fake = new CartDetail();
        fake.setProduct(p);
        fake.setVariant(v);
        fake.setQuantity(qty);
        fake.setPrice(unitPrice);

        List<CartDetail> list = new ArrayList<>();
        list.add(fake);

        List<ShopCartDto> result = new ArrayList<>();
        result.add(new ShopCartDto(p.getShop(), list));
        return result;
    }
}
