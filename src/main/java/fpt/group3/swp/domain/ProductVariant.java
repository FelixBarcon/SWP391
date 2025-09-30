package fpt.group3.swp.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
@Entity
@Table(name="product_variants")
public class ProductVariant {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch=FetchType.LAZY) @JoinColumn(name="product_id", nullable=false)
    private Product product;

    @Column(nullable=false, length=100)  // VD: “Màu Đỏ”, “Size M”, “128GB”
    private String name;

    // Giá riêng cho biến thể (null -> rơi về product.price)
    private Double price;

    // Ảnh riêng (VD: ảnh màu đỏ)
    private String imageUrl;
}
