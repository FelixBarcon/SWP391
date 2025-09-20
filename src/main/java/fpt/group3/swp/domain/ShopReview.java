package fpt.group3.swp.domain;/* AnVo
    
    @author: Admin
    Date: 18/09/2025
    Time: 5:45 PM
    
    ProjectName: swp 
*/

import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.*;

import java.io.Serializable;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class ShopReview extends Review implements Serializable {
    @ManyToOne
    @JoinColumn(name = "shop_id", nullable = false)
    private Shop shop;
}
