package fpt.group3.swp.domain.dto;

import lombok.Data;
import java.util.List;

@Data
public class CreateProductForm {
    private Long shopId;
    private String name;
    private String description;
    private List<Long> categoryIds;
    private Boolean hasVariants;
    private Double price;
    private String group1Name;
    private String group1Values;
    private String group2Name;
    private String group2Values;
}