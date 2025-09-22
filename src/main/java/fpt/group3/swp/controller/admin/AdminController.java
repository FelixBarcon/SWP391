package fpt.group3.swp.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AdminController {
    
    @GetMapping("/admin")
    public String getAdminHomePage() {
        return "redirect:/admin/dashboard";
    }
    
    @GetMapping("/admin/dashboard")
    public String getDashboardPage(Model model) {
        model.addAttribute("pageTitle", "Dashboard");
        model.addAttribute("pageDescription", "Tổng quan hệ thống quản lý ShopMart");
        return "admin/dashboard/dashboard";
    }
}