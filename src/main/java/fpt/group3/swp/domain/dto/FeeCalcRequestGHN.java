// fpt/group3/swp/domain/dto/FeeCalcRequestGHN.java
package fpt.group3.swp.domain.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter @Setter
public class FeeCalcRequestGHN {
    private List<Long> shopIds;

    private List<Long> cartDetailIds;

    private Long productId;

    private Integer toDistrictId;
    private String toWardCode;
}
