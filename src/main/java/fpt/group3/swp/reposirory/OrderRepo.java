package fpt.group3.swp.reposirory;

import fpt.group3.swp.domain.Order;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OrderRepo extends JpaRepository<Order, Long> {}
