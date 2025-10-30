package fpt.group3.swp.controller.client;

import fpt.group3.swp.common.Status;
import fpt.group3.swp.domain.Product;
import fpt.group3.swp.domain.Shop;
import fpt.group3.swp.domain.User;
import fpt.group3.swp.domain.dto.RegisterDTO;
import fpt.group3.swp.reposirory.ProductRepository;
import fpt.group3.swp.reposirory.ProductReviewRepository;
import fpt.group3.swp.reposirory.ShopRepository;
import fpt.group3.swp.service.ProductService;
import fpt.group3.swp.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class HomePageController {
    private final UserService userService;
    private final PasswordEncoder passwordEncoder;
    private final ProductRepository productRepository;
    private final ShopRepository shopRepository;
    private final ProductReviewRepository productReviewRepository;

    public HomePageController(UserService userService, PasswordEncoder passwordEncoder,
            ProductRepository productRepository, ShopRepository shopRepository,
            ProductReviewRepository productReviewRepository) {
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
        this.productRepository = productRepository;
        this.shopRepository = shopRepository;
        this.productReviewRepository = productReviewRepository;
    }

    @GetMapping("/")
    public String getHomePage(Model model,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "8") int size) {

        // Lấy sản phẩm ACTIVE và chưa bị xóa
        Page<Product> products = productRepository.findByStatusAndDeleted(
                Status.ACTIVE, false, PageRequest.of(page, size));

        // Tính rating và review count cho mỗi product
        Map<Long, Double> productRatings = new HashMap<>();
        Map<Long, Long> productReviewCounts = new HashMap<>();
        
        for (Product p : products.getContent()) {
            Double avgRating = productReviewRepository.averageRatingByProduct(p.getId());
            Long reviewCount = productReviewRepository.countByProduct_IdAndIsDeletedFalseAndIsVisibleTrue(p.getId());
            productRatings.put(p.getId(), avgRating != null ? avgRating : 0.0);
            productReviewCounts.put(p.getId(), reviewCount != null ? reviewCount : 0L);
        }

        // Lấy top 6 shops nổi bật
        // Thử lấy shops VERIFIED trước
        List<Shop> topShops = shopRepository.findTopShops(PageRequest.of(0, 6));
        
        // Nếu không có shop VERIFIED nào, lấy tất cả shops
        if (topShops.isEmpty()) {
            System.out.println("No VERIFIED shops found, getting all shops instead");
            topShops = shopRepository.findAllShopsSortedByRating(PageRequest.of(0, 6));
        }
        
        // Debug: In ra số lượng shops
        System.out.println("Number of top shops: " + topShops.size());
        if (!topShops.isEmpty()) {
            System.out.println("First shop: " + topShops.get(0).getDisplayName() + " - Status: " + topShops.get(0).getVerifyStatus());
        }

        model.addAttribute("products", products.getContent());
        model.addAttribute("productRatings", productRatings);
        model.addAttribute("productReviewCounts", productReviewCounts);
        model.addAttribute("topShops", topShops);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", products.getTotalPages());

        return "client/homepage/homepage";
    }

    @GetMapping("/register")
    public String gerRegisterPageString(Model model) {
        model.addAttribute("newUser", new RegisterDTO());
        return "client/auth/register";
    }

    @GetMapping("/login")
    public String getLoginPage(Model model) {
        return "client/auth/login";
    }

    // Backward-compatible search endpoint -> redirect to /products
    @GetMapping("/search")
    public String redirectSearch(@RequestParam(value = "q", required = false) String q) {
        String qs = (q == null) ? "" : URLEncoder.encode(q, StandardCharsets.UTF_8);
        return "redirect:/products" + (qs.isEmpty() ? "" : ("?q=" + qs));
    }

    @PostMapping("/register")
    public String handleRegister(
            @ModelAttribute("newUser") @Valid RegisterDTO registerDTO,
            BindingResult bindingResult,
            Model model) {
        if (bindingResult.hasErrors()) {
            return "client/auth/register";
        }
        User user = this.userService.registerDTOtoUser(registerDTO);
        String hashPassword = this.passwordEncoder.encode(user.getPassword());

        user.setPassword(hashPassword);
        user.setRole(this.userService.getRoleByName("USER"));

        this.userService.handleSaveUser(user);

        return "redirect:/login";
    }

    @RequestMapping(value = "/access-deny", method = { RequestMethod.GET, RequestMethod.POST })
    public String denyPage(Model model) {
        return "client/access-deny";
    }
}
