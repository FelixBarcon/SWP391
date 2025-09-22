package fpt.group3.swp.controller.seller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class SellerController {
    
    @GetMapping("/seller")
    public String getSellerHomePage() {
        return "redirect:/seller/dashboard";
    }
    
    
    @GetMapping("/seller/dashboard")
    public String getDashboardPage(Model model) {
        model.addAttribute("pageTitle", "Dashboard");
        model.addAttribute("pageDescription", "Tổng quan hệ thống quản lý ShopMart");
        return "seller/dashboard/dashboard";
    }
}