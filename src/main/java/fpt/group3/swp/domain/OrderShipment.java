package fpt.group3.swp.domain;/* AnVo
    
    @author: Admin
    Date: 20/09/2025
    Time: 6:54 PM
    
    ProjectName: swp 
*/

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "order_shipments")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class OrderShipment {

    @Id
    @OneToOne
    @MapsId   // dùng cùng PK với Order
    @JoinColumn(name = "order_id")
    private Order order;

    @Column(name = "recipient_name", nullable = false)
    private String recipientName;

    @Column(name = "phone", nullable = false)
    private String phone;

    @Column(name = "line1", nullable = false)
    private String line1;

    @Column(name = "line2")
    private String line2;

    @Column(name = "city", nullable = false)
    private String city;

    @Column(name = "state")
    private String state;

    @Column(name = "postal_code")
    private String postalCode;

    @Column(name = "country", nullable = false)
    private String country;
}
