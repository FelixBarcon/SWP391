package fpt.group3.swp.domain;/* AnVo
    
    @author: Admin
    Date: 18/09/2025
    Time: 3:45 PM
    
    ProjectName: swp 
*/

import fpt.group3.swp.common.VerifyStatus;
import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "shops")
public class Shop implements Serializable {

    @Id
    @Column( name = "shop_id" )
    private long id;

    @OneToOne
    @JoinColumn(name = "user_id", unique = true)
    @ToString.Exclude
    private User user;

    private String displayName;

    private String description;

    private VerifyStatus verifyStatus;

    private LocalDateTime verifiedAt;

    private int verifyBy;

    private double ratingAvg;

    private LocalDate createdAt;

    @ManyToMany(mappedBy = "shops")
    @ToString.Exclude
    private Set<Product> products = new HashSet<>();
}
