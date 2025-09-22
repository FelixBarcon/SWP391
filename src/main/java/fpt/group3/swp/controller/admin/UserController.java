package fpt.group3.swp.controller.admin;

import fpt.group3.swp.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class UserController {
    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/admin/user")
    public String getUserPage(Model model) {
        model.addAttribute("pageTitle", "Quản lý người dùng");
        model.addAttribute("pageDescription", "Danh sách người dùng trong hệ thống");
        return "admin/user/hello";
    }
}
