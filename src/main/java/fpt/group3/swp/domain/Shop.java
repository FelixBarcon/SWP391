package fpt.group3.swp.domain;

import fpt.group3.swp.common.VerifyStatus;
import jakarta.persistence.*;
import lombok.*;
import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;
import org.hibernate.annotations.Nationalized;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Entity
@Table(
        name = "shops",
        uniqueConstraints = {
                @UniqueConstraint(name = "uk_shops_user", columnNames = "user_id"),
                @UniqueConstraint(name = "uk_shops_display_name", columnNames = "display_name")
        }
)
public class Shop implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "shop_id")
    private long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    @ToString.Exclude
    private User user;

    @Nationalized
    @Column(name = "display_name", length = 150, nullable = false)
    private String displayName;

    @Nationalized
    @Column(length = 1000)
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(name = "verify_status", length = 20, nullable = false)
    private VerifyStatus verifyStatus = VerifyStatus.DRAFT;

    private LocalDateTime verifiedAt;
    private Long verifyBy;

    @Nationalized
    @Column(length = 255)
    private String pickupAddress;

    @Nationalized
    @Column(length = 255)
    private String returnAddress;

    @Nationalized
    @Column(length = 30)
    private String contactPhone;

    @Nationalized
    @Column(length = 20)
    private String bankCode;

    @Nationalized
    @Column(length = 50)
    private String bankAccountNo;

    @Nationalized
    @Column(length = 150)
    private String bankAccountName;

    private Double ratingAvg = 0d;

    private LocalDate createdAt;

    @PrePersist
    void prePersist() {
        if (createdAt == null) createdAt = LocalDate.now();
        if (ratingAvg == null) ratingAvg = 0d;
        if (verifyStatus == null) verifyStatus = VerifyStatus.DRAFT;
    }

    @OneToMany(mappedBy = "shop", cascade = CascadeType.ALL, orphanRemoval = true)
    @ToString.Exclude
    private Set<Product> products = new HashSet<>();

    @OneToMany(mappedBy = "shop", cascade = CascadeType.ALL)
    @ToString.Exclude
    private Set<Review> reviews = new HashSet<>();
}