package fpt.group3.swp.domain;/* AnVo
    
    @author: Admin
    Date: 18/09/2025
    Time: 5:43 PM
    
    ProjectName: swp 
*/

import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.*;
import org.hibernate.annotations.Nationalized;

import java.io.Serializable;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true) // vì kế thừa Review
public class ProductReview extends Review implements Serializable {

    @ManyToOne
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    @Nationalized
    private String title;
}
