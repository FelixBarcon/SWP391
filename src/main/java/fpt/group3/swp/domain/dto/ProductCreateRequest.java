package fpt.group3.swp.domain.dto;

import lombok.Getter; import lombok.Setter;
import java.util.*;

@Getter @Setter
public class ProductCreateRequest {
    private String name;
    private String description;
    private Set<Long> categoryIds = new HashSet<>();

    // Ảnh: list URL (đã upload ở nơi khác, hoặc dùng UploadService của bạn để lấy URL)
    private List<String> imageUrls = new ArrayList<>();

    // Specs đơn giản
    private Map<String, String> attributes = new HashMap<>();

    // Single vs Variant
    private Boolean hasVariants = false;
    private Double price; // nếu !hasVariants

    // Biến thể
    private List<OptionGroupDTO> optionGroups = new ArrayList<>();
    private List<VariantDTO> variants = new ArrayList<>();

    @Getter @Setter
    public static class OptionGroupDTO {
        private String name;             // "Màu"
        private List<String> values;     // ["Đỏ","Xanh"]
    }

    @Getter @Setter
    public static class VariantDTO {
        private Map<String, String> options; // {"Màu":"Đỏ","Size":"M"}
        private Double price;                 // optional, null => dùng product.price
        private String imageUrl;              // optional (ảnh theo biến thể)
    }
}
