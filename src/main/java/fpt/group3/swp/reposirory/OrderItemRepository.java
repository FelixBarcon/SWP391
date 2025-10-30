package fpt.group3.swp.reposirory;

import fpt.group3.swp.common.OrderStatus;
import fpt.group3.swp.domain.OrderItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface OrderItemRepository extends JpaRepository<OrderItem, Long> {

    List<OrderItem> findAllByOrder_User_IdAndOrder_OrderStatus(Long userId, OrderStatus status);

    List<OrderItem> findAllByOrder_User_IdAndProduct_IdAndOrder_OrderStatus(Long userId,
                                                                           Long productId,
                                                                           OrderStatus status);
    
    // Tính tổng số lượng đã bán của một sản phẩm (chỉ tính đơn hàng đã thanh toán)
    @Query("SELECT COALESCE(SUM(oi.quantity), 0) FROM OrderItem oi WHERE oi.product.id = :productId AND oi.order.orderStatus = 'PAID'")
    Long countSoldByProduct(@Param("productId") Long productId);
}
