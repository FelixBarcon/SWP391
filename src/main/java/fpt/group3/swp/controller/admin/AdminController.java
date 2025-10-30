package fpt.group3.swp.controller.admin;

import fpt.group3.swp.common.Status;
import fpt.group3.swp.domain.Order;
import fpt.group3.swp.domain.Product;
import fpt.group3.swp.domain.User;
import fpt.group3.swp.reposirory.OrderRepo;
import fpt.group3.swp.reposirory.ProductRepository;
import fpt.group3.swp.reposirory.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class AdminController {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private OrderRepo orderRepo;
    
    @Autowired
    private ProductRepository productRepository;
    
    @GetMapping("/admin")
    public String getAdminHomePage() {
        return "redirect:/admin/dashboard";
    }
    
    @GetMapping("/admin/dashboard")
    public String getDashboardPage(Model model) {
        model.addAttribute("pageTitle", "Dashboard");
        model.addAttribute("pageDescription", "Tổng quan hệ thống quản lý ShopMart");
        
        try {
            // Lấy tất cả người dùng
            List<User> allUsers = userRepository.findAll();
            long totalUsers = allUsers.size();
            
            // Đếm người dùng hoạt động
            long activeUsers = allUsers.stream()
                    .filter(User::isActive)
                    .count();
            
            // Đếm tổng số đơn hàng
            long totalOrders = orderRepo.count();
            
            // Đếm tổng sản phẩm
            long totalProducts = productRepository.count();
            
            // Tính tỷ lệ người dùng hoạt động
            double activeUserPercentage = totalUsers > 0 ? (activeUsers * 100.0 / totalUsers) : 0;
            
            // Thêm vào model
            model.addAttribute("totalUsers", totalUsers);
            model.addAttribute("activeUsers", activeUsers);
            model.addAttribute("activeUserPercentage", String.format("%.1f", activeUserPercentage));
            model.addAttribute("totalOrders", totalOrders);
            model.addAttribute("totalProducts", totalProducts);
            model.addAttribute("pendingReports", 0); // Placeholder - chưa có bảng reports
            
        } catch (Exception e) {
            // Nếu có lỗi, set giá trị mặc định
            model.addAttribute("totalUsers", 0);
            model.addAttribute("activeUsers", 0);
            model.addAttribute("activeUserPercentage", "0.0");
            model.addAttribute("totalOrders", 0);
            model.addAttribute("totalProducts", 0);
            model.addAttribute("pendingReports", 0);
        }
        
        return "admin/dashboard/dashboard";
    }
}