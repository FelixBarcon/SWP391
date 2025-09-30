package fpt.group3.swp.reposirory;/* AnVo
    
    @author: Admin
    Date: 18/09/2025
    Time: 4:39 PM
    
    ProjectName: swp 
*/

import fpt.group3.swp.common.Status;
import fpt.group3.swp.domain.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    List<Product> findAllByShop_IdOrderByUpdatedAtDesc(Long shopId);
    List<Product> findAllByShop_IdAndDeletedFalseOrderByUpdatedAtDesc(Long shopId);
}
