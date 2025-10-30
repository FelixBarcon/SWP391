package fpt.group3.swp.controller.seller;

import fpt.group3.swp.common.OrderStatus;
import fpt.group3.swp.common.Status;
import fpt.group3.swp.domain.Order;
import fpt.group3.swp.domain.Product;
import fpt.group3.swp.domain.Shop;
import fpt.group3.swp.domain.User;
import fpt.group3.swp.reposirory.OrderRepo;
import fpt.group3.swp.reposirory.ProductRepository;
import fpt.group3.swp.reposirory.ShopRepository;
import fpt.group3.swp.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.security.Principal;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
public class SellerController {
    
    private final ShopRepository shopRepository;
    private final ProductRepository productRepository;
    private final OrderRepo orderRepo;
    private final UserService userService;
    
    @GetMapping("/seller")
    public String getSellerHomePage() {
        return "redirect:/seller/dashboard";
    }
    
    
    @GetMapping("/seller/dashboard")
    public String getDashboardPage(Principal principal, Model model) {
        model.addAttribute("pageTitle", "Dashboard");
        model.addAttribute("pageDescription", "Tổng quan hệ thống quản lý ShopMart");
        
        // Kiểm tra user đã đăng nhập chưa
        if (principal == null) {
            return "redirect:/login";
        }
        
        // Lấy user từ email (username trong Spring Security)
        String email = principal.getName();
        User user = userService.getUserByEmail(email);
        
        if (user == null) {
            return "redirect:/login";
        }
        
        // Lấy shop của seller
        Shop shop = shopRepository.findByUser_Id(user.getId()).orElse(null);
        if (shop == null) {
            model.addAttribute("error", "Bạn chưa có shop. Vui lòng tạo shop trước.");
            model.addAttribute("pendingOrdersCount", 0);
            model.addAttribute("totalProductsCount", 0);
            model.addAttribute("lowStockCount", 0);
            model.addAttribute("totalRevenue", 0.0);
            model.addAttribute("recentOrders", List.of());
            return "seller/dashboard/dashboard";
        }
        
        Long shopId = shop.getId();
        
        // 1. Đếm đơn hàng chờ xử lý (PENDING_CONFIRM hoặc PENDING_PAYMENT)
        List<Order> allOrders = orderRepo.findAllByShopId(shopId);
        long pendingOrdersCount = allOrders.stream()
                .filter(o -> o.getOrderStatus() == OrderStatus.PENDING_CONFIRM || 
                           o.getOrderStatus() == OrderStatus.PENDING_PAYMENT)
                .count();
        
        // 2. Đếm tổng số sản phẩm ACTIVE và không bị xóa
        List<Product> allProducts = productRepository.findAllByShop_IdOrderByUpdatedAtDesc(shopId);
        long totalProductsCount = allProducts.stream()
                .filter(p -> !p.isDeleted() && p.getStatus() == Status.ACTIVE)
                .count();
        
        // 3. Đếm sản phẩm sắp hết hàng (giả sử quantity < 10 hoặc logic khác)
        // Nếu chưa có field quantity trong Product, tạm set = 0
        long lowStockCount = 0; // TODO: implement logic đếm sản phẩm sắp hết hàng
        
        // 4. Tính tổng doanh thu (chỉ đơn hàng PAID)
        double totalRevenue = allOrders.stream()
                .filter(o -> o.getOrderStatus() == OrderStatus.PAID)
                .mapToDouble(o -> o.getTotalAmount())
                .sum();
        
        // 5. Lấy 5 đơn hàng gần nhất
        List<Order> recentOrders = allOrders.stream()
                .sorted((o1, o2) -> {
                    if (o2.getCreatedAt() == null) return -1;
                    if (o1.getCreatedAt() == null) return 1;
                    return o2.getCreatedAt().compareTo(o1.getCreatedAt());
                })
                .limit(5)
                .collect(Collectors.toList());
        
        // Thêm vào model
        model.addAttribute("pendingOrdersCount", pendingOrdersCount);
        model.addAttribute("totalProductsCount", totalProductsCount);
        model.addAttribute("lowStockCount", lowStockCount);
        model.addAttribute("totalRevenue", totalRevenue);
        model.addAttribute("recentOrders", recentOrders);
        
        return "seller/dashboard/dashboard";
    }
}