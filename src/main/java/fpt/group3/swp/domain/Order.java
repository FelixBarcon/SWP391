package fpt.group3.swp.domain;/* AnVo
    
    @author: Admin
    Date: 18/09/2025
    Time: 6:04 PM
    
    ProjectName: swp 
*/

import fpt.group3.swp.common.OrderStatus;
import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;
import java.time.LocalDate;

@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "orders")
public class Order implements Serializable {

    @Id
    @Column(name = "order_id")
    private long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Enumerated(EnumType.STRING)
    private OrderStatus orderStatus;

    // Tổng tiền hàng (trước phí vận chuyển, giảm giá)
    @Column(name = "shipping_fee", nullable = false, columnDefinition = "INT DEFAULT 0")
    private int shippingFee;

    // Tổng tiền giảm giá
    @Column(name = "discount_total", nullable = false, columnDefinition = "INT DEFAULT 0")
    private int discountTotal;

    // Tổng tiền đơn hàng (sau phí vận chuyển, giảm giá)
    @Column(name = "total_amount", nullable = false, columnDefinition = "INT DEFAULT 0")
    private int totalAmount;

    private LocalDate createdAt = LocalDate.now();
}
