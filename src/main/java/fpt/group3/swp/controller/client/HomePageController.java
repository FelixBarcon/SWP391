package fpt.group3.swp.controller.client;

import fpt.group3.swp.domain.User;
import fpt.group3.swp.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class HomePageController {

    @Autowired
    private UserService userService;

    @GetMapping("/")
    public String getHomePage(Model model) {
        return "client/homepage/homepage";
    }

    @GetMapping("/register")
    public String getRegisterPage(Model model) {
        model.addAttribute("newUser", new User());
        return "client/auth/register";
    }

    @PostMapping("/register")
    public String handleRegister(@ModelAttribute("newUser") User user,
                               @RequestParam(value = "firstName", required = true) String firstName,
                               @RequestParam(value = "lastName", required = true) String lastName,
                               BindingResult bindingResult,
                               Model model,
                               RedirectAttributes redirectAttributes) {
        
        // Kiểm tra các field bắt buộc
        if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
            model.addAttribute("emailError", "Email không được để trống");
            return "client/auth/register";
        }
        
        if (user.getPassWord() == null || user.getPassWord().trim().isEmpty()) {
            model.addAttribute("passwordError", "Mật khẩu không được để trống");
            return "client/auth/register";
        }
        
        if (firstName == null || firstName.trim().isEmpty()) {
            model.addAttribute("firstNameError", "Họ không được để trống");
            return "client/auth/register";
        }
        
        if (lastName == null || lastName.trim().isEmpty()) {
            model.addAttribute("lastNameError", "Tên không được để trống");
            return "client/auth/register";
        }
        
        // Kiểm tra email đã tồn tại
        if (userService.checkEmailExist(user.getEmail())) {
            model.addAttribute("emailError", "Email đã được sử dụng");
            return "client/auth/register";
        }
        
        try {
            // Thiết lập firstName và lastName
            user.setFirstName(firstName.trim());
            user.setLastName(lastName.trim());
            
            // Tạo fullName từ firstName và lastName
            user.setFullName(firstName.trim() + " " + lastName.trim());
            
            // Lưu user vào database
            userService.handleSaveUser(user);
            
            redirectAttributes.addFlashAttribute("successMessage", 
                "Đăng ký thành công! Vui lòng đăng nhập.");
            return "redirect:/login";
            
        } catch (Exception e) {
            model.addAttribute("errorMessage", 
                "Đăng ký thất bại. Vui lòng thử lại: " + e.getMessage());
            return "client/auth/register";
        }
    }

    @GetMapping("/login")
    public String getLoginPage(Model model) {
        return "client/auth/login";
    }

    @GetMapping("/forgot-password")
    public String getForgotPasswordPage(Model model) {
        return "client/auth/forgot-password";
    }

    @PostMapping("/forgot-password")
    public String handleForgotPassword(@RequestParam("email") String email, 
                                     Model model,
                                     RedirectAttributes redirectAttributes) {
        try {
            // TODO: Implement email sending logic
            redirectAttributes.addFlashAttribute("successMessage", 
                "Link reset mật khẩu đã được gửi tới email của bạn.");
            return "redirect:/forgot-password";
        } catch (Exception e) {
            model.addAttribute("errorMessage", 
                "Có lỗi xảy ra khi gửi email. Vui lòng thử lại.");
            return "client/auth/forgot-password";
        }
    }
}
