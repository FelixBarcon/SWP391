package fpt.group3.swp.service;

import org.springframework.stereotype.Service;

@Service
public class ShippingService {
    // Demo: 30k kiện đầu + 5k mỗi sản phẩm tiếp theo (theo shop)
    public int calcShopShippingFee(int itemsCount) {
        if (itemsCount <= 0) return 0;
        int base = 30000;
        int extra = Math.max(0, itemsCount - 1) * 5000;
        return base + extra;
    }
}
