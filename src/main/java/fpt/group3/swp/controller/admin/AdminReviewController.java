package fpt.group3.swp.controller.admin;

import fpt.group3.swp.domain.ProductReview;
import fpt.group3.swp.service.AdminReviewService;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class AdminReviewController {

    private final AdminReviewService adminReviewService;

    public AdminReviewController(AdminReviewService adminReviewService) {
        this.adminReviewService = adminReviewService;
    }

    @GetMapping("/admin/reviews/products")
    public String listProductReviews(@RequestParam(value = "productId", required = false) Long productId,
                                     @RequestParam(value = "visible", required = false) Boolean visible,
                                     @RequestParam(value = "q", required = false) String q,
                                     @RequestParam(value = "page", defaultValue = "1") int page,
                                     @RequestParam(value = "size", defaultValue = "10") int size,
                                     Model model) {
        int pageIndex = Math.max(0, page - 1);
        Page<ProductReview> result = adminReviewService.search(productId, visible, q, pageIndex, size);
        model.addAttribute("reviews", result.getContent());
        model.addAttribute("totalPages", result.getTotalPages());
        model.addAttribute("totalElements", result.getTotalElements());
        model.addAttribute("currentPage", page);
        model.addAttribute("size", size);
        model.addAttribute("productId", productId);
        model.addAttribute("visible", visible);
        model.addAttribute("q", q);
        model.addAttribute("pageTitle", "Quản lý đánh giá");
        model.addAttribute("pageDescription", "Danh sách đánh giá sản phẩm và trạng thái hiển thị");
        model.addAttribute("contentPage", "/WEB-INF/view/admin/review/product-reviews-content.jsp");
        return "admin/review/product-reviews";
    }

    @PostMapping("/admin/reviews/{id}/hide")
    public String hide(@PathVariable Long id,
                       @RequestParam(value = "productId", required = false) Long productId,
                       @RequestParam(value = "visible", required = false) Boolean visible,
                       @RequestParam(value = "q", required = false) String q,
                       @RequestParam(value = "page", required = false) Integer page,
                       @RequestParam(value = "size", required = false) Integer size,
                       RedirectAttributes ra) {
        adminReviewService.hideReview(id);
        if (productId != null) ra.addAttribute("productId", productId);
        if (visible != null) ra.addAttribute("visible", visible);
        if (q != null && !q.isBlank()) ra.addAttribute("q", q);
        if (page != null) ra.addAttribute("page", page);
        if (size != null) ra.addAttribute("size", size);
        return "redirect:/admin/reviews/products";
    }

    @PostMapping("/admin/reviews/{id}/unhide")
    public String unhide(@PathVariable Long id,
                         @RequestParam(value = "productId", required = false) Long productId,
                         @RequestParam(value = "visible", required = false) Boolean visible,
                         @RequestParam(value = "q", required = false) String q,
                         @RequestParam(value = "page", required = false) Integer page,
                         @RequestParam(value = "size", required = false) Integer size,
                         RedirectAttributes ra) {
        adminReviewService.unhideReview(id);
        if (productId != null) ra.addAttribute("productId", productId);
        if (visible != null) ra.addAttribute("visible", visible);
        if (q != null && !q.isBlank()) ra.addAttribute("q", q);
        if (page != null) ra.addAttribute("page", page);
        if (size != null) ra.addAttribute("size", size);
        return "redirect:/admin/reviews/products";
    }
}
