package fpt.group3.swp.controller.admin;

import fpt.group3.swp.common.VerifyStatus;
import fpt.group3.swp.domain.Shop;
import fpt.group3.swp.domain.dto.SellerRegistrationDTO;
import fpt.group3.swp.reposirory.ShopRepository;
import fpt.group3.swp.service.SellerService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class SellerManageController {

    private final SellerService sellerService;
    private final ShopRepository shopRepo;
    private final UserDetailsService userDetailsService;

    /** Lấy userId từ session */
    private Long getUserIdFromSession(HttpSession session) {
        Object id = session.getAttribute("id");
        if (id == null) throw new IllegalStateException("User chưa đăng nhập");
        return Long.valueOf(id.toString());
    }

    // ===== CUSTOMER: hiển thị form đăng ký Seller (prefill từ DRAFT/REJECTED/PENDING) =====
    @GetMapping("/seller/register")
    public String showRegisterForm(Model model, HttpSession session) {
        Long userId = getUserIdFromSession(session);

        Shop existing = shopRepo.findByUser_Id(userId).orElse(null);

        if (existing != null && existing.getVerifyStatus() == VerifyStatus.APPROVED) {
            // Nếu chưa có ROLE_SELLER thì refresh authorities
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            boolean hasSellerRole = auth != null && auth.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_SELLER"));

            if (!hasSellerRole) {
                String username = auth.getName();
                UserDetails ud = userDetailsService.loadUserByUsername(username);
                UsernamePasswordAuthenticationToken newAuth =
                        new UsernamePasswordAuthenticationToken(ud, auth.getCredentials(), ud.getAuthorities());
                newAuth.setDetails(auth.getDetails());
                SecurityContextHolder.getContext().setAuthentication(newAuth);
            }
            return "redirect:/seller/dashboard";
        }

        SellerRegistrationDTO dto = new SellerRegistrationDTO();

        if (existing != null) {
            dto.setDisplayName(existing.getDisplayName());
            dto.setDescription(existing.getDescription());
            dto.setPickupAddress(existing.getPickupAddress());
            dto.setReturnAddress(existing.getReturnAddress());
            dto.setContactPhone(existing.getContactPhone());
            dto.setBankCode(existing.getBankCode());
            dto.setBankAccountNo(existing.getBankAccountNo());
            dto.setBankAccountName(existing.getBankAccountName());
            model.addAttribute("currentStatus", existing.getVerifyStatus());
        } else {
            model.addAttribute("currentStatus", VerifyStatus.DRAFT); // chưa có hồ sơ -> DRAFT
        }

        model.addAttribute("sellerForm", dto);
        return "seller/auth/register";
    }

    /** Lưu NHÁP (DRAFT) khi user bấm Next/Save trong wizard */
    @PostMapping("/seller/register/save-draft")
    public String saveDraft(@Valid @ModelAttribute("sellerForm") SellerRegistrationDTO form,
                            BindingResult br,
                            RedirectAttributes ra,
                            HttpSession session,
                            Model model) {
        Long userId = getUserIdFromSession(session);

        // ⛳ Nếu đã là SELLER -> dashboard
        Shop existing = shopRepo.findByUser_Id(userId).orElse(null);
        if (existing != null && existing.getVerifyStatus() == VerifyStatus.APPROVED) {
            return "redirect:/seller/dashboard";
        }

        if (br.hasErrors()) {
            model.addAttribute("error", "Vui lòng kiểm tra lại các trường.");
            return "seller/auth/register";
        }
        try {
            sellerService.saveDraft(userId, form);
            ra.addFlashAttribute("success", "Đã lưu nháp hồ sơ.");
            return "redirect:/seller/register";
        } catch (Exception ex) {
            model.addAttribute("error", ex.getMessage());
            return "seller/auth/register";
        }
    }

    /** GỬI XÉT DUYỆT (PENDING) */
    @PostMapping("/seller/register")
    public String submitRegister(@Valid @ModelAttribute("sellerForm") SellerRegistrationDTO form,
                                 BindingResult br,
                                 RedirectAttributes ra,
                                 HttpSession session,
                                 Model model) {
        Long userId = getUserIdFromSession(session);

        // ⛳ Nếu đã là SELLER -> dashboard
        Shop existing = shopRepo.findByUser_Id(userId).orElse(null);
        if (existing != null && existing.getVerifyStatus() == VerifyStatus.APPROVED) {
            return "redirect:/seller/dashboard";
        }

        if (br.hasErrors()) {
            model.addAttribute("error", "Vui lòng kiểm tra lại các trường bắt buộc.");
            return "seller/auth/register";
        }
        try {
            Shop shop = sellerService.submit(userId, form);
            ra.addFlashAttribute("success", "Đã gửi xét duyệt. Trạng thái: " + shop.getVerifyStatus());
            return "redirect:/seller/register";
        } catch (Exception ex) {
            // Nếu service ném lỗi “đã là người bán” (phòng trường hợp)
            if ("Tài khoản đã là người bán.".equals(ex.getMessage())) {
                return "redirect:/seller/dashboard";
            }
            model.addAttribute("error", ex.getMessage());
            return "seller/auth/register";
        }
    }

    // ===== ADMIN: danh sách đang chờ duyệt =====
    @GetMapping("/admin/seller/requests")
    public String listPending(Model model) {
        List<Shop> pending = shopRepo.findAllByVerifyStatus(VerifyStatus.PENDING);
        
        // Tính số lượng yêu cầu
        long totalPending = pending.size();
        
        // Tính thời gian chờ trung bình (từ createdAt đến hiện tại)
        double avgWaitingDays = 0.0;
        if (!pending.isEmpty()) {
            long totalDays = 0;
            java.time.LocalDate now = java.time.LocalDate.now();
            for (Shop s : pending) {
                if (s.getCreatedAt() != null) {
                    totalDays += java.time.temporal.ChronoUnit.DAYS.between(s.getCreatedAt(), now);
                }
            }
            avgWaitingDays = (double) totalDays / pending.size();
        }
        
        // Đếm số shop đã duyệt hôm nay
        java.time.LocalDate today = java.time.LocalDate.now();
        java.time.LocalDateTime startOfDay = today.atStartOfDay();
        
        long approvedToday = shopRepo.findAll().stream()
            .filter(s -> s.getVerifyStatus() == VerifyStatus.APPROVED 
                      && s.getVerifiedAt() != null 
                      && !s.getVerifiedAt().isBefore(startOfDay))
            .count();
        
        // Đếm số shop đã từ chối hôm nay
        long rejectedToday = shopRepo.findAll().stream()
            .filter(s -> s.getVerifyStatus() == VerifyStatus.REJECTED 
                      && s.getVerifiedAt() != null 
                      && !s.getVerifiedAt().isBefore(startOfDay))
            .count();
        
        model.addAttribute("pending", pending);
        model.addAttribute("totalPending", totalPending);
        model.addAttribute("avgWaitingDays", String.format("%.1f", avgWaitingDays));
        model.addAttribute("approvedToday", approvedToday);
        model.addAttribute("rejectedToday", rejectedToday);
        model.addAttribute("pageTitle", "Duyệt yêu cầu Seller");
        model.addAttribute("pageDescription", "Quản lý và xét duyệt các yêu cầu đăng ký bán hàng");
        model.addAttribute("contentPage", "/WEB-INF/view/admin/seller/seller-requests-content.jsp");
        return "admin/seller/seller-requests";
    }

    @PostMapping("/admin/seller/{shopId}/approve")
    public String approve(@PathVariable Long shopId, HttpSession session, RedirectAttributes ra) {
        try {
            Long adminId = getUserIdFromSession(session);
            sellerService.approve(shopId, adminId);
            ra.addFlashAttribute("success", "Đã duyệt shop #" + shopId);
        } catch (Exception e) {
            ra.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/admin/seller/requests";
    }

    @PostMapping("/admin/seller/{shopId}/reject")
    public String reject(@PathVariable Long shopId, HttpSession session, RedirectAttributes ra) {
        try {
            Long adminId = getUserIdFromSession(session);
            sellerService.reject(shopId, adminId);
            ra.addFlashAttribute("success", "Đã từ chối shop #" + shopId);
        } catch (Exception e) {
            ra.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/admin/seller/requests";
    }

    // ===== ADMIN: danh sách shop + khóa/mở khóa =====
    @GetMapping("/admin/seller/list")
    public String listAllShops(Model model,
                               @RequestParam(value = "q", required = false) String q,
                               @RequestParam(value = "verify", required = false) String verify,
                               @RequestParam(value = "userStatus", required = false) String userStatus,
                               @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                               @RequestParam(value = "size", required = false, defaultValue = "10") int size) {

        int pageIndex = Math.max(page - 1, 0);
        int pageSize = Math.min(Math.max(size, 5), 50);

        fpt.group3.swp.common.VerifyStatus vStatus = null;
        if (verify != null && !verify.isBlank()) {
            try { vStatus = fpt.group3.swp.common.VerifyStatus.valueOf(verify.trim().toUpperCase()); } catch (Exception ignored) {}
        }
        fpt.group3.swp.common.Status uStatus = null;
        if (userStatus != null && !userStatus.isBlank()) {
            try { uStatus = fpt.group3.swp.common.Status.valueOf(userStatus.trim().toUpperCase()); } catch (Exception ignored) {}
        }

        org.springframework.data.domain.Pageable pageable = org.springframework.data.domain.PageRequest.of(pageIndex, pageSize,
                org.springframework.data.domain.Sort.by(org.springframework.data.domain.Sort.Direction.DESC, "id"));

        org.springframework.data.jpa.domain.Specification<Shop> spec = org.springframework.data.jpa.domain.Specification.where(
                fpt.group3.swp.reposirory.spec.ShopSpecifications.search(q)
        );
        if (vStatus != null) spec = spec.and(fpt.group3.swp.reposirory.spec.ShopSpecifications.verifyStatus(vStatus));
        if (uStatus != null) spec = spec.and(fpt.group3.swp.reposirory.spec.ShopSpecifications.userStatus(uStatus));

        org.springframework.data.domain.Page<Shop> shopPage = shopRepo.findAll(spec, pageable);

        model.addAttribute("shops", shopPage.getContent());
        model.addAttribute("page", shopPage);
        model.addAttribute("currentPage", shopPage.getNumber() + 1);
        model.addAttribute("pageSize", shopPage.getSize());
        model.addAttribute("totalPages", shopPage.getTotalPages());
        model.addAttribute("totalElements", shopPage.getTotalElements());

        model.addAttribute("q", q);
        model.addAttribute("filterVerify", vStatus);
        model.addAttribute("filterUserStatus", uStatus);
        model.addAttribute("verifyStatuses", fpt.group3.swp.common.VerifyStatus.values());
        model.addAttribute("userStatuses", fpt.group3.swp.common.Status.values());

        model.addAttribute("pageTitle", "Danh sách Shop");
        model.addAttribute("pageDescription", "Quản lý các shop và trạng thái");
        model.addAttribute("contentPage", "/WEB-INF/view/admin/seller/seller-list-content.jsp");
        return "admin/seller/seller-list";
    }

    @PostMapping("/admin/seller/{shopId}/lock")
    public String lockShop(@PathVariable Long shopId,
                           @RequestParam(value = "reason", required = false) String reason,
                           RedirectAttributes ra) {
        try {
            sellerService.lockShop(shopId, reason);
            ra.addFlashAttribute("success", "Đã khóa shop #" + shopId + ".");
        } catch (Exception e) {
            ra.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/admin/seller/list";
    }

    @PostMapping("/admin/seller/{shopId}/unlock")
    public String unlockShop(@PathVariable Long shopId, RedirectAttributes ra) {
        try {
            sellerService.unlockShop(shopId);
            ra.addFlashAttribute("success", "Đã mở khóa shop #" + shopId + ".");
        } catch (Exception e) {
            ra.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/admin/seller/list";
    }
}
