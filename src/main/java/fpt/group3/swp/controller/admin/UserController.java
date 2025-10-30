package fpt.group3.swp.controller.admin;

import fpt.group3.swp.domain.User;
import fpt.group3.swp.service.MailService;
import fpt.group3.swp.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import org.springframework.data.domain.Page;
import fpt.group3.swp.common.Status;
import fpt.group3.swp.reposirory.RoleRepository;
import fpt.group3.swp.domain.Role;

@Controller
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;
    private final MailService mailService;
    private final RoleRepository roleRepository;

    @GetMapping("/admin/user")
    public String listUsers(Model model,
                            @RequestParam(value = "q", required = false) String q,
                            @RequestParam(value = "status", required = false) Status status,
                            @RequestParam(value = "role", required = false) String role,
                            @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                            @RequestParam(value = "size", required = false, defaultValue = "10") int size) {
        int pageIndex = Math.max(page - 1, 0);
        Page<User> userPage = userService.searchUsers(q, status, role, pageIndex, size);
        model.addAttribute("users", userPage.getContent());
        model.addAttribute("page", userPage);
        model.addAttribute("currentPage", userPage.getNumber() + 1);
        model.addAttribute("pageSize", userPage.getSize());
        model.addAttribute("totalPages", userPage.getTotalPages());
        model.addAttribute("totalElements", userPage.getTotalElements());
        model.addAttribute("q", q);
        model.addAttribute("filterStatus", status);
        model.addAttribute("filterRole", role);
        List<Role> roles = roleRepository.findAll().stream()
                .filter(r -> r.getName() != null && !r.getName().equalsIgnoreCase("ADMIN") && !r.getName().equalsIgnoreCase("SUPER_ADMIN"))
                .toList();
        model.addAttribute("roles", roles);

        model.addAttribute("pageTitle", "Quản lý người dùng");
        model.addAttribute("pageDescription", "Danh sách người dùng trong hệ thống");
        model.addAttribute("contentPage", "/WEB-INF/view/admin/user/user-list-content.jsp");
        return "admin/user/user-list";
    }

    @PostMapping("/admin/user/{id}/deactivate")
    public String deactivateUser(@PathVariable("id") long id,
                                 @RequestParam(value = "reason", required = false) String reason,
                                 RedirectAttributes ra) {
        try {
            User user = userService.getUserById(id);
            if (user == null) throw new IllegalArgumentException("Người dùng không tồn tại");
            userService.deactivateUser(id, reason);
            // Gửi email thông báo tới người dùng
            mailService.sendAccountDeactivationEmail(user.getEmail(), reason);
            ra.addFlashAttribute("successMessage", "Đã khóa tài khoản #" + id + " và gửi email thông báo.");
        } catch (Exception ex) {
            ra.addFlashAttribute("errorMessage", ex.getMessage());
        }
        return "redirect:/admin/user";
    }

    @PostMapping("/admin/user/{id}/restore")
    public String restoreUser(@PathVariable("id") long id,
                              RedirectAttributes ra) {
        try {
            userService.restoreUser(id);
            ra.addFlashAttribute("successMessage", "Đã khôi phục tài khoản #" + id + ".");
        } catch (Exception ex) {
            ra.addFlashAttribute("errorMessage", ex.getMessage());
        }
        return "redirect:/admin/user";
    }
}
