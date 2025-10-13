package fpt.group3.swp.domain;

import fpt.group3.swp.common.OrderStatus;
import fpt.group3.swp.common.PaymentMethod;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.Nationalized;

import java.io.Serializable;
import java.time.LocalDate;
import java.util.Set;

@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "orders")
public class Order implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "order_id")
    private long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Enumerated(EnumType.STRING)
    @Column(name = "order_status", nullable = false)
    private OrderStatus orderStatus;

    @Enumerated(EnumType.STRING)
    @Column(name = "payment_method", nullable = false)
    private PaymentMethod paymentMethod; // COD | VNPAY

    @Column(name = "items_total", nullable = false, columnDefinition = "INT DEFAULT 0")
    private int itemsTotal;

    @Column(name = "shipping_fee", nullable = false, columnDefinition = "INT DEFAULT 0")
    private int shippingFee;

    @Column(name = "total_amount", nullable = false, columnDefinition = "INT DEFAULT 0")
    private int totalAmount;

    @Nationalized
    @Column(name = "receiver_name", length = 150)
    private String receiverName;

    @Nationalized
    @Column(name = "receiver_phone", length = 20)
    private String receiverPhone;

    @Nationalized
    @Column(name = "receiver_address", length = 255)
    private String receiverAddress;

    @Nationalized
    @Column(name = "receiver_province", length = 100)
    private String receiverProvince;

    @Nationalized
    @Column(name = "receiver_district", length = 100)
    private String receiverDistrict;

    @Nationalized
    @Column(name = "receiver_ward", length = 100)
    private String receiverWard;

    @Column(name = "created_at", nullable = false)
    private LocalDate createdAt = LocalDate.now();

    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<OrderItem> orderItems;
}
