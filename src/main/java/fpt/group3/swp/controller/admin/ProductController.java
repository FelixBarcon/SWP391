package fpt.group3.swp.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ProductController {
    
    @GetMapping("/admin/products")
    public String getProductPage(Model model) {
        model.addAttribute("pageTitle", "Quản lý sản phẩm");
        model.addAttribute("pageDescription", "Danh sách sản phẩm trong hệ thống");
        return "admin/product/product";
    }
}
