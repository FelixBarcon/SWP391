package fpt.group3.swp.controller.admin;

import fpt.group3.swp.common.VerifyStatus;
import fpt.group3.swp.domain.Shop;
import fpt.group3.swp.domain.dto.SellerRegistrationDTO;
import fpt.group3.swp.reposirory.ShopRepository;
import fpt.group3.swp.service.SellerService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
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
        model.addAttribute("pending", pending);
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
}
