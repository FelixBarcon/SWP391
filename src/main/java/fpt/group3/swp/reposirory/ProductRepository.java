package fpt.group3.swp.reposirory;/* AnVo
    
    @author: Admin
    Date: 18/09/2025
    Time: 4:39 PM
    
    ProjectName: swp 
*/

import fpt.group3.swp.domain.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {}
