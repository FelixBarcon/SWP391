package fpt.group3.swp.domain.dto;

import fpt.group3.swp.domain.CartDetail;
import fpt.group3.swp.domain.Shop;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class ShopCartDto {
    private Shop shop;
    private List<CartDetail> items;
    private double shopTotal;

    public ShopCartDto(Shop shop, List<CartDetail> items) {
        this.shop = shop;
        this.items = items;
        this.shopTotal = items.stream()
                .mapToDouble(cd -> cd.getPrice() * cd.getQuantity()).sum();
    }
    public Shop getShop() { return shop; }
    public List<CartDetail> getItems() { return items; }
    public double getShopTotal() { return shopTotal; }
}
