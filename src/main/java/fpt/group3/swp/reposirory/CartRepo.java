package fpt.group3.swp.reposirory;

import java.util.Optional;

import fpt.group3.swp.domain.Cart;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CartRepo extends JpaRepository<Cart, Long> {
    Optional<Cart> findByUser_Id(Long userId);
}
