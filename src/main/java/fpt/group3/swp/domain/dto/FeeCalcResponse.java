package fpt.group3.swp.domain.dto;

import lombok.Data;

import java.util.List;

@Data
public class FeeCalcResponse {
    private List<ShopFee> shops;
    private int totalFee;

    @Data
    public static class ShopFee {
        private Long shopId;
        private String shopName;
        private int fee;
        private int serviceTypeId;
    }
}
