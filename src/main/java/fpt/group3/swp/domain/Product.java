package fpt.group3.swp.domain;

import fpt.group3.swp.common.Status;
import jakarta.persistence.*;
import lombok.*;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.*;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor
@Entity @Table(name = "products")
public class Product implements Serializable {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "product_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "shop_id", nullable = false)
    @ToString.Exclude
    private Shop shop;

    @Column(nullable = false)
    private String name;

    @Column(length = 5000)
    private String description = "";

    // Giá “base” khi không có biến thể hoặc biến thể không đặt giá riêng
    private Double price;

    // Tự tính từ biến thể để hiển thị “x – y”
    private Double priceMin;
    private Double priceMax;

    @Column(name = "image_url")
    private String imageUrl; // cover

    @ElementCollection
    @CollectionTable(name = "product_images", joinColumns = @JoinColumn(name = "product_id"))
    @Column(name = "url", length = 1000)
    @OrderColumn(name = "position")
    private List<String> imageUrls = new ArrayList<>();

    @Enumerated(EnumType.STRING)
    private Status status = Status.ACTIVE;

    @Column(name = "deleted", nullable = false)
    private boolean deleted = false;

    private Boolean hasVariants = false;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Giữ Category nếu bạn vẫn dùng
    @ManyToMany
    @JoinTable(
            name = "products_categories",
            joinColumns = @JoinColumn(name = "product_id"),
            inverseJoinColumns = @JoinColumn(name = "category_id")
    )
    @ToString.Exclude
    private Set<Category> categories = new HashSet<>();

    // Biến thể đơn giản: chỉ 1 tên (“Màu Đỏ”, “Size M”, “128GB”...)
    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderColumn(name = "position")
    @ToString.Exclude
    private List<ProductVariant> variants = new ArrayList<>();

    @PrePersist
    void prePersist() {
        if (createdAt == null) createdAt = LocalDateTime.now();
        if ((imageUrl == null || imageUrl.isBlank()) && !imageUrls.isEmpty()) {
            imageUrl = imageUrls.get(0);
        }
        if (priceMin == null) priceMin = price;
        if (priceMax == null) priceMax = price;
        if (status == null) status = Status.ACTIVE;
    }

    @PreUpdate
    void preUpdate() {
        updatedAt = LocalDateTime.now();
        if ((imageUrl == null || imageUrl.isBlank()) && !imageUrls.isEmpty()) {
            imageUrl = imageUrls.get(0);
        }
    }
}
