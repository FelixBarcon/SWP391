package fpt.group3.swp.controller.client;

import fpt.group3.swp.domain.Order;
import fpt.group3.swp.domain.dto.PurchasedProductReviewView;
import fpt.group3.swp.service.OrderService;
import fpt.group3.swp.service.ProductReviewService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;
    private final ProductReviewService productReviewService;

    private long userIdFromSession(HttpSession session) {
        if (session == null) throw new IllegalStateException("Phiên làm việc hết hạn. Vui lòng đăng nhập lại.");
        Long userId = (Long) session.getAttribute("id");
        if (userId == null) throw new IllegalStateException("Không tìm thấy user trong session.");
        return userId;
    }

    @GetMapping("/orders")
    public String listMyOrders(Model model,
                               HttpServletRequest request,
                               @RequestParam(defaultValue = "0") int page,
                               @RequestParam(defaultValue = "10") int size) {
        HttpSession session = request.getSession(false);
        long userId = userIdFromSession(session);
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"));
        Page<Order> ordersPage = orderService.findAllByUser(userId, pageable);
        model.addAttribute("orders", ordersPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", ordersPage.getTotalPages());
        model.addAttribute("pageSize", size);
        return "client/order/list";
    }

    @GetMapping("/orders/{id}")
    public String viewMyOrder(@PathVariable Long id, Model model, HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        long userId = userIdFromSession(session);
        Order order = orderService.getById(id);
        if (order.getUser() == null || order.getUser().getId() != userId) {
            return "redirect:/access-deny";
        }
        model.addAttribute("order", order);
        return "client/order/detail";
    }

    @GetMapping("/orders/reviews")
    public String reviewableProducts(Model model,
                                     HttpServletRequest request,
                                     @RequestParam(value = "page", defaultValue = "1") int page,
                                     @RequestParam(value = "size", defaultValue = "6") int size) {
        HttpSession session = request.getSession(false);
        long userId = userIdFromSession(session);
        int safePage = Math.max(page, 1);
        int safeSize = Math.max(size, 1);
        Page<PurchasedProductReviewView> itemsPage = productReviewService
                .getPurchasedProductsForUser(userId, safePage - 1, safeSize);
        model.addAttribute("purchasedItems", itemsPage.getContent());
        model.addAttribute("currentPage", itemsPage.getTotalPages() == 0 ? 1 : itemsPage.getNumber() + 1);
        model.addAttribute("totalPages", itemsPage.getTotalPages());
        model.addAttribute("pageSize", itemsPage.getSize());
        model.addAttribute("totalItems", itemsPage.getTotalElements());
        return "client/order/reviews";
    }
}
