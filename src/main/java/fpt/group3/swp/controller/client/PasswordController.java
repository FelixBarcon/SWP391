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
            model.addAttribute("errorMessage", "Email không tồn tại trong hệ thống!");
            return "client/auth/forgot-password";
        }

        String token = userService.createPasswordResetToken(user);
        String resetLink = "http://localhost:8080/reset-password?token=" + token;
        mailService.sendResetPasswordEmail(user.getEmail(), resetLink);

        model.addAttribute("successMessage", "Link khôi phục mật khẩu đã được gửi đến email của bạn. Vui lòng kiểm tra hộp thư đến.");
        return "client/auth/forgot-password";
    }

    @GetMapping("/reset-password")
    public String showResetPasswordPage(@RequestParam("token") String token, Model model) {
        if (!userService.isValidPasswordResetToken(token)) {
            model.addAttribute("errorMessage", "Link khôi phục mật khẩu không hợp lệ hoặc đã hết hạn!");
            return "client/auth/forgot-password";
        }
        model.addAttribute("token", token);
        return "client/auth/reset-password";
    }

    @PostMapping("/reset-password")
    public String handleResetPassword(@RequestParam("token") String token,
                                    @RequestParam("password") String password,
                                    @RequestParam("confirmPassword") String confirmPassword,
                                    Model model) {
        if (!userService.isValidPasswordResetToken(token)) {
            model.addAttribute("errorMessage", "Link khôi phục mật khẩu không hợp lệ hoặc đã hết hạn!");
            return "client/auth/forgot-password";
        }

        if (!password.equals(confirmPassword)) {
            model.addAttribute("errorMessage", "Mật khẩu không trùng khớp!");
            model.addAttribute("token", token);
            return "client/auth/reset-password";
        }

        if (password.length() < 6) {
            model.addAttribute("errorMessage", "Mật khẩu phải có ít nhất 6 ký tự!");
            model.addAttribute("token", token);
            return "client/auth/reset-password";
        }

        User user = userService.getUserByPasswordResetToken(token);
        user.setPassword(passwordEncoder.encode(password));
        user.setResetToken(null);
        user.setResetTokenExpiry(null);
        userService.updateUser(user);

        model.addAttribute("successMessage", "Mật khẩu đã được đặt lại thành công! Bạn có thể đăng nhập với mật khẩu mới.");
        return "client/auth/login";
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
