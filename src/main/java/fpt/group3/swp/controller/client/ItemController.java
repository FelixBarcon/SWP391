package fpt.group3.swp.controller.client;

import java.util.List;

import fpt.group3.swp.domain.Product;
import fpt.group3.swp.domain.ProductVariant;
import fpt.group3.swp.domain.User;
import fpt.group3.swp.reposirory.ProductRepository;
import fpt.group3.swp.reposirory.ProductVariantRepository;
import fpt.group3.swp.service.CartService;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class ItemController {

    private final ProductRepository productRepo;
    private final ProductVariantRepository variantRepo;
    private final CartService cartService;

    public ItemController(ProductRepository productRepo, ProductVariantRepository variantRepo, CartService cartService) {
        this.productRepo = productRepo;
        this.variantRepo = variantRepo;
        this.cartService = cartService;
    }

    @GetMapping("/products")
    public String getProductPage(Model model,
                                 @RequestParam(value="page", defaultValue="1") int page,
                                 @RequestParam(value="sort", required=false) String sort) {
        Pageable pageable = PageRequest.of(Math.max(0, page-1), 12);
        if ("gia-tang-dan".equalsIgnoreCase(sort)) {
            pageable = PageRequest.of(Math.max(0, page-1), 12, Sort.by("price").ascending());
        } else if ("gia-giam-dan".equalsIgnoreCase(sort)) {
            pageable = PageRequest.of(Math.max(0, page-1), 12, Sort.by("price").descending());
        }
        Page<Product> prs = productRepo.findAll(pageable);
        model.addAttribute("products", prs.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", prs.getTotalPages());
        model.addAttribute("sort", sort);
        return "client/product/list";
    }

    @GetMapping("/product/{id}")
    public String getProductDetail(Model model, @PathVariable Long id) {
        Product p = productRepo.findById(id).orElseThrow();
        List<ProductVariant> variants = variantRepo.findByProduct_Id(id);
        model.addAttribute("product", p);
        model.addAttribute("variants", variants);
        return "client/product/detail";
    }

    // Thêm từ list: không có variant, qty=1
    @PostMapping("/add-product-to-cart/{id}")
    public String addFromList(@PathVariable Long id, HttpServletRequest request) {
        User user = requireLogin(request.getSession(false));
        cartService.addProduct(user, id, null, 1);
        return "redirect:/cart";
    }

    // Thêm từ trang chi tiết (có thể chọn variant + qty)
    @PostMapping("/add-product-from-view-detail")
    public String addFromDetail(@RequestParam("id") Long id,
                                @RequestParam(value = "variantId", required = false) Long variantId,
                                @RequestParam("quantity") int quantity,
                                HttpServletRequest request) {
        User user = requireLogin(request.getSession(false));
        cartService.addProduct(user, id, variantId, quantity);
        return "redirect:/product/" + id;
    }

    private User requireLogin(HttpSession session) {
        if (session == null || session.getAttribute("id") == null) {
            throw new RuntimeException("Vui lòng đăng nhập trước khi thêm giỏ hàng.");
        }
        User u = new User();
        u.setId((long) session.getAttribute("id"));
        return u;
    }
}
