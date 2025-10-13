package fpt.group3.swp.controller.client;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import fpt.group3.swp.domain.ProductVariant;
import fpt.group3.swp.reposirory.ProductVariantRepository;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import fpt.group3.swp.domain.User;
import fpt.group3.swp.domain.dto.ShopCartDto;
import fpt.group3.swp.service.CartService;

@Controller
public class CartController {
    private final CartService cartService;
    private final ProductVariantRepository variantRepo;

    public CartController(CartService cartService, ProductVariantRepository variantRepo) {
        this.cartService = cartService;
        this.variantRepo = variantRepo;
    }

    @GetMapping("/cart")
    public String getCartPage(Model model,
            @RequestParam(value = "page", defaultValue = "1") int page,
            HttpServletRequest request) {
        User user = requireLogin(request.getSession(false));

        int size = 10; // mỗi trang 10 dòng giỏ hàng
        CartService.PagedCartView pv = cartService.getPagedGroups(user, page, size);

        model.addAttribute("shopGroups", pv.groups);
        model.addAttribute("currentPage", pv.currentPage);
        model.addAttribute("totalPages", pv.totalPages);

        Map<Long, java.util.List<ProductVariant>> variantsMap = new HashMap<>();
        pv.groups.forEach(g -> g.getItems().forEach(cd -> {
            Long pid = cd.getProduct().getId();
            variantsMap.computeIfAbsent(pid, variantRepo::findByProduct_Id);
        }));
        model.addAttribute("variantsMap", variantsMap);

        model.addAttribute("grandTotal", cartService.calcGrandTotal(user));

        return "client/cart/show";
    }

    @PostMapping("/cart/update")
    public String update(@RequestParam Long cartDetailId, @RequestParam int qty, HttpServletRequest request) {
        User user = requireLogin(request.getSession(false));
        cartService.updateQty(user, cartDetailId, qty);
        return "redirect:/cart";
    }

    @PostMapping("/delete-cart-product")
    public String delete(@RequestParam Long cartDetailId, HttpServletRequest request) {
        User user = requireLogin(request.getSession(false));
        cartService.removeDetail(user, cartDetailId);
        return "redirect:/cart";
    }

    @PostMapping("/cart/change-variant")
    public String changeVariant(@RequestParam Long cartDetailId,
            @RequestParam(value = "variantId", required = false) String variantIdRaw,
            HttpServletRequest request) {
        User user = requireLogin(request.getSession(false));
        Long variantId = (variantIdRaw == null || variantIdRaw.isBlank())
                ? null
                : Long.valueOf(variantIdRaw);
        cartService.changeVariant(user, cartDetailId, variantId);
        return "redirect:/cart";
    }

    private User requireLogin(HttpSession session) {
        if (session == null || session.getAttribute("id") == null) {
            throw new RuntimeException("Vui lòng đăng nhập để xem giỏ hàng.");
        }
        User u = new User();
        u.setId((long) session.getAttribute("id"));
        return u;
    }

}
