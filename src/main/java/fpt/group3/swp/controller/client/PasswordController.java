package fpt.group3.swp.controller.client;

import fpt.group3.swp.domain.User;
import fpt.group3.swp.service.MailService;
import fpt.group3.swp.service.UserService;
import jakarta.mail.MessagingException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;

@Controller
public class PasswordController {

    private final UserService userService;
    private final MailService mailService;
    private final PasswordEncoder passwordEncoder;

    public PasswordController(UserService userService, MailService mailService,  PasswordEncoder passwordEncoder) {
        this.userService = userService;
        this.mailService = mailService;
        this.passwordEncoder = passwordEncoder;
    }

    @GetMapping("/forgot-password")
    public String showForgotPasswordPage() {
        return "client/auth/forgot-password";
    }

    @PostMapping("/forgot-password")
    public String handleForgotPassword(@RequestParam("email") String email, Model model) throws MessagingException {
        User user = userService.getUserByEmail(email);
        if (user == null) {
            model.addAttribute("error", "Email không tồn tại!");
            return "client/auth/forgot-password";
        }

        String token = userService.createPasswordResetToken(user);
        String resetLink = "http://localhost:8080/reset-password?token=" + token;
        mailService.sendResetPasswordEmail(user.getEmail(), resetLink);

        model.addAttribute("message", "Vui lòng kiểm tra email để reset mật khẩu.");
        return "client/auth/forgot-password";
    }

    @GetMapping("/change-password")
    public String showChangePasswordPage() {
        return "client/auth/change-password"; // form đổi mật khẩu
    }

    @PostMapping("/change-password")
    public String handleChangePassword(@RequestParam("oldPassword") String oldPassword,
                                       @RequestParam("newPassword") String newPassword,
                                       @RequestParam("confirmPassword") String confirmPassword,
                                       Model model,
                                       Principal principal) {
        // principal lấy email (username) từ session đang login
        User user = userService.getUserByEmail(principal.getName());

        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            model.addAttribute("error", "Mật khẩu cũ không đúng!");
            return "client/auth/change-password";
        }

        if (!newPassword.equals(confirmPassword)) {
            model.addAttribute("error", "Mật khẩu mới không trùng khớp!");
            return "client/auth/change-password";
        }

        user.setPassword(passwordEncoder.encode(newPassword));
        userService.updateUser(user);

        model.addAttribute("message", "Đổi mật khẩu thành công!");
        return "client/auth/change-password";
    }
}
