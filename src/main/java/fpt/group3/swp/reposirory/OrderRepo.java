package fpt.group3.swp.reposirory;

import fpt.group3.swp.domain.Order;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface OrderRepo extends JpaRepository<Order, Long> {
    // Non-paged (legacy)
    List<Order> findAllByUser_IdOrderByCreatedAtDesc(Long userId);

    @Query("select distinct o from Order o join o.orderItems oi where oi.shop.id = :shopId order by o.createdAt desc")
    List<Order> findAllByShopId(@Param("shopId") Long shopId);

    // Paged
    Page<Order> findAllByUser_Id(Long userId, Pageable pageable);

    @Query("select distinct o from Order o join o.orderItems oi where oi.shop.id = :shopId")
    Page<Order> findAllByShopId(@Param("shopId") Long shopId, Pageable pageable);
}
