package fpt.group3.swp.reposirory;

import fpt.group3.swp.domain.CartDetail;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CartDetailRepo extends JpaRepository<CartDetail, Long> {
    Page<CartDetail> findByCart_User_IdOrderByIdAsc(Long userId, Pageable pageable);
    List<CartDetail> findByCart_Id(Long cartId);
    List<CartDetail> findByCart_User_Id(Long userId);
}
