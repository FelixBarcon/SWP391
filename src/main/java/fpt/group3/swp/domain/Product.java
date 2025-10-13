package fpt.group3.swp.domain;

import fpt.group3.swp.common.Status;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.Nationalized;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "products")
public class Product implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "product_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "shop_id", nullable = false)
    @ToString.Exclude
    private Shop shop;

    @Nationalized
    @Column(nullable = false)
    private String name;

    @Nationalized
    @Column(length = 5000)
    private String description = "";

    private Double price;
    private Double priceMin;
    private Double priceMax;

    @Nationalized
    @Column(name = "image_url")
    private String imageUrl; // cover

    @ElementCollection
    @CollectionTable(name = "product_images", joinColumns = @JoinColumn(name = "product_id"))
    @Nationalized
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

    @ManyToMany
    @JoinTable(
            name = "products_categories",
            joinColumns = @JoinColumn(name = "product_id"),
            inverseJoinColumns = @JoinColumn(name = "category_id")
    )
    @ToString.Exclude
    private Set<Category> categories = new HashSet<>();

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
