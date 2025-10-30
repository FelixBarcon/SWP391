package fpt.group3.swp.controller.seller;

import fpt.group3.swp.domain.Shop;
import fpt.group3.swp.domain.Order;
import fpt.group3.swp.reposirory.ShopRepository;
import fpt.group3.swp.service.OrderService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class SellerOrderController {

    private final OrderService orderService;
    private final ShopRepository shopRepo;

    private long shopIdFromSession(HttpSession session) {
        if (session == null) throw new IllegalStateException("Phiên làm việc hết hạn. Vui lòng đăng nhập lại.");
        Long userId = (Long) session.getAttribute("id");
        if (userId == null) throw new IllegalStateException("Không tìm thấy user trong session.");
        Shop shop = shopRepo.findByUser_Id(userId)
                .orElseThrow(() -> new IllegalStateException("Bạn chưa có shop. Vui lòng đăng ký shop trước."));
        return shop.getId();
    }

    @GetMapping("/seller/orders")
    public String listOrders(Model model, HttpServletRequest request,
                             @RequestParam(defaultValue = "0") int page,
                             @RequestParam(defaultValue = "10") int size) {
        HttpSession session = request.getSession(false);
        long shopId = shopIdFromSession(session);
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"));
        Page<Order> ordersPage = orderService.findAllByShop(shopId, pageable);
        model.addAttribute("orders", ordersPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", ordersPage.getTotalPages());
        model.addAttribute("pageSize", size);
        model.addAttribute("pageTitle", "Đơn hàng");
        model.addAttribute("pageDescription", "Danh sách đơn hàng của shop");
        model.addAttribute("contentPage", "../order/orders-content.jsp");
        model.addAttribute("shopId", shopId);
        return "seller/order/orders";
    }

    @GetMapping("/seller/orders/{id}")
    public String viewOrder(@PathVariable Long id, Model model, HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        long shopId = shopIdFromSession(session);

        Order order = orderService.getById(id);
        // Kiểm tra đơn có liên quan đến shop
        boolean belongs = order.getOrderItems() != null && order.getOrderItems().stream()
                .anyMatch(oi -> oi.getShop() != null && oi.getShop().getId() == shopId);
        if (!belongs) {
            return "redirect:/access-deny";
        }

        java.util.List<fpt.group3.swp.domain.OrderItem> shopItems = new java.util.ArrayList<>();
        int shopTotal = 0;
        if (order.getOrderItems() != null) {
            for (fpt.group3.swp.domain.OrderItem oi : order.getOrderItems()) {
                if (oi.getShop() != null && oi.getShop().getId() == shopId) {
                    shopItems.add(oi);
                    shopTotal += (oi.getTotalPrice() != 0 ? oi.getTotalPrice() : oi.getQuantity() * oi.getUnitPrice());
                }
            }
        }

        model.addAttribute("order", order);
        model.addAttribute("shopItems", shopItems);
        model.addAttribute("shopTotal", shopTotal);
        model.addAttribute("pageTitle", "Chi tiết đơn hàng");
        model.addAttribute("pageDescription", "Thông tin chi tiết đơn hàng");
        model.addAttribute("contentPage", "../order/order-detail-content.jsp");
        return "seller/order/order-detail";
    }
}
