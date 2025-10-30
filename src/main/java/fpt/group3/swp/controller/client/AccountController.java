// src/main/java/fpt/group3/swp/controller/client/AccountController.java
package fpt.group3.swp.controller.client;

import fpt.group3.swp.domain.User;
import fpt.group3.swp.service.AccountService;
import fpt.group3.swp.service.AccountService.UpdateProfileReq;
import fpt.group3.swp.service.AccountService.BusinessException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.Map;
import org.springframework.web.multipart.MultipartFile;

import java.security.Principal;

@Controller
@RequestMapping("/account")
@RequiredArgsConstructor
public class AccountController {

    private final AccountService accountService;

    // ===== PROFILE =====
    @GetMapping("/profile")
    public String viewProfile(Principal principal, Model model) {
        User u = accountService.viewProfile(principal);
        model.addAttribute("u", u);
        return "account/profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(Principal principal,
                                @RequestParam String fullName,
                                @RequestParam(required = false) String firstName,
                                @RequestParam(required = false) String lastName,
                                @RequestParam String email,
                                @RequestParam(required = false) String phone,
                                @RequestParam(required = false) String address,
                                @RequestParam(name = "removeAvatar", defaultValue = "false") boolean removeAvatar,
                                @RequestParam(name = "avatarFile", required = false) MultipartFile avatarFile,
                                Model model) {
        try {
            UpdateProfileReq req =
                    new UpdateProfileReq(fullName, firstName, lastName, email, phone, address, removeAvatar);
            accountService.updateProfile(principal, req, avatarFile);
            return "redirect:/account/profile?updated=basic";
        } catch (BusinessException ex) {
            User u = accountService.viewProfile(principal);
            model.addAttribute("u", u);
            model.addAttribute("error", ex.getCode());
            model.addAttribute("msg", ex.getMessage());
            return "account/profile";
        }
    }

    // Lightweight JSON endpoint for fetching saved address in profile
    @GetMapping("/profile/address")
    @ResponseBody
    public Map<String, Object> getProfileAddress(Principal principal) {
        User u = accountService.viewProfile(principal);
        String addr = u.getAddress();
        return Map.of(
                "hasAddress", addr != null && !addr.trim().isEmpty(),
                "address", addr == null ? "" : addr.trim()
        );
    }

    // ===== CHANGE PASSWORD =====
    @GetMapping("/change-password")
    public String viewChangePassword() {
        return "account/change-password";
    }

    @PostMapping("/change-password")
    public String doChangePassword(Principal principal,
                                   @RequestParam String currentPassword,
                                   @RequestParam String newPassword,
                                   @RequestParam String confirmPassword,
                                   Model model) {
        try {
            accountService.changePassword(principal, currentPassword, newPassword, confirmPassword);
            return "redirect:/account/profile?updated=password";
        } catch (BusinessException ex) {
            model.addAttribute("error", ex.getCode());
            model.addAttribute("msg", ex.getMessage());
            return "account/change-password";
        }
    }
}
