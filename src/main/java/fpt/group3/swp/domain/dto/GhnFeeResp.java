package fpt.group3.swp.domain.dto;

import lombok.Data;

@Data
public class GhnFeeResp {
    private int code;
    private String message;
    private DataObj data;

    @Data
    public static class DataObj {
        private int total;
    }
}
