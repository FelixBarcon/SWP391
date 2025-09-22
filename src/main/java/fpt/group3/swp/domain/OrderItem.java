package fpt.group3.swp.domain;/* AnVo
    
    @author: Admin
    Date: 20/09/2025
    Time: 6:41 PM
    
    ProjectName: swp 
*/

import fpt.group3.swp.common.OrderItemStatus;
import jakarta.persistence.*;
import lombok.*;

@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "orders")
public class OrderItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "order_item_id")
    private long id;

    private int quantity;

    @Column(name = "unit_price")
    private int unitPrice;

    @Column(name = "total_price")
    private int totalPrice;

    @Enumerated(EnumType.STRING)
    private OrderItemStatus status;

    // Quan hệ tới Order (nhiều OrderItem thuộc 1 Order)
    @ManyToOne
    @JoinColumn(name = "order_id", nullable = false)
    private Order order;

    // Quan hệ tới Product (nhiều OrderItem thuộc 1 Product)
    @ManyToOne
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    // Quan hệ tới Shop (nhiều OrderItem thuộc 1 Shop)
    @ManyToOne
    @JoinColumn(name = "shop_id", nullable = false)
    private Shop shop;
}
