package fpt.group3.swp.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Nationalized;

@Getter
@Setter
@Entity
@Table(name="product_variants")
public class ProductVariant {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="product_id", nullable=false)
    private Product product;

    @Nationalized
    @Column(nullable=false, length=100)  // Ví dụ: “Màu Đỏ”, “Size M”, “128GB”
    private String name;

    private Double price;

    @Nationalized
    private String imageUrl;
}
