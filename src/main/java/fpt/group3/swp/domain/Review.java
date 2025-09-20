package fpt.group3.swp.domain;/* AnVo
    
    @author: Admin
    Date: 18/09/2025
    Time: 5:11 PM
    
    ProjectName: swp 
*/

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
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@Table(name = "reviews")
public abstract class Review implements Serializable {

    @Id
    @EqualsAndHashCode.Include
    @Column(name = "review_id")
    protected long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    protected User user;

    @Column(
            nullable = false,
            columnDefinition = "INT CHECK (rating BETWEEN 1 AND 5)"
    )
    protected int rating;

    protected String comment;

    @Column(name = "is_visible", columnDefinition = "BOOLEAN DEFAULT TRUE")
    protected boolean isVisible = true;

    @Column(name = "is_deleted", columnDefinition = "BOOLEAN DEFAULT FALSE")
    private boolean isDeleted = false;

    protected LocalDate createdAt;
}
