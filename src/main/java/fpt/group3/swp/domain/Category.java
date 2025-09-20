package fpt.group3.swp.domain;/* AnVo
    
    @author: Admin
    Date: 18/09/2025
    Time: 3:28 PM
    
    ProjectName: swp 
*/

import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;
import java.util.Set;

@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "categories")
public class Category implements Serializable {

    @Id
    @EqualsAndHashCode.Include
    @Column(name = "category_id")
    private long id;

    private String name;

    @Column(name = "parent_id")
    private int parentId;

    @ManyToMany(mappedBy = "categories")
    private Set<Product> products;
}
