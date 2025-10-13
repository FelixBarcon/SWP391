package fpt.group3.swp.domain.dto;

import lombok.Data;

import java.util.List;

@Data
public class FeeCalcRequestGHN {
    private Integer toDistrictId;
    private String toWardCode;
    private List<Long> cartDetailIds;
}

