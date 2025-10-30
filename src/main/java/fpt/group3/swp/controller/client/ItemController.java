package fpt.group3.swp.controller.client;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import fpt.group3.swp.domain.Product;
import fpt.group3.swp.domain.ProductReview;
import fpt.group3.swp.domain.ProductVariant;
import fpt.group3.swp.domain.User;
import fpt.group3.swp.reposirory.ProductRepository;
import fpt.group3.swp.reposirory.ProductVariantRepository;
import fpt.group3.swp.service.CartService;
import fpt.group3.swp.service.ProductReviewService;
import fpt.group3.swp.service.ProductService;
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
    private final ProductReviewService productReviewService;
    private final ProductService productService;
    private final fpt.group3.swp.reposirory.CategoryRepository categoryRepo;
    private final fpt.group3.swp.reposirory.ProductReviewRepository productReviewRepo;
    private final fpt.group3.swp.reposirory.OrderItemRepository orderItemRepo;

    public ItemController(ProductRepository productRepo,
                          ProductVariantRepository variantRepo,
                          CartService cartService,
                          ProductReviewService productReviewService,
                          ProductService productService,
                          fpt.group3.swp.reposirory.CategoryRepository categoryRepo,
                          fpt.group3.swp.reposirory.ProductReviewRepository productReviewRepo,
                          fpt.group3.swp.reposirory.OrderItemRepository orderItemRepo) {
        this.productRepo = productRepo;
        this.variantRepo = variantRepo;
        this.cartService = cartService;
        this.productReviewService = productReviewService;
        this.productService = productService;
        this.categoryRepo = categoryRepo;
        this.productReviewRepo = productReviewRepo;
        this.orderItemRepo = orderItemRepo;
    }

    @GetMapping("/products")
    public String getProductPage(Model model,
                                 @RequestParam(value = "page", defaultValue = "1") int page,
                                 @RequestParam(value = "size", defaultValue = "12") int size,
                                 @RequestParam(value = "sort", required = false) String sort,
                                 @RequestParam(value = "q", required = false) String q,
                                 @RequestParam(value = "category", required = false) List<Long> categoryIds,
                                 @RequestParam(value = "minPrice", required = false) Double minPrice,
                                 @RequestParam(value = "maxPrice", required = false) Double maxPrice,
                                 @RequestParam(value = "rating", required = false) String ratingParam,
                                 @RequestParam(value = "includeUnrated", required = false) Boolean includeUnrated
                                 ) {
        // Robust parsing of rating parameter: accept values like "5", "4.0" or "0.0".
        // Treat any value < 1 (0, 0.0) as no filter (null) to avoid binding/type errors that break pagination.
        Integer rating = null;
        if (ratingParam != null && !ratingParam.isBlank()) {
            try {
                double d = Double.parseDouble(ratingParam);
                if (d >= 1.0) {
                    // floor to integer rating levels (e.g., 4.8 -> 4)
                    rating = (int) Math.floor(d);
                } else {
                    // values like 0 or 0.0 => treat as no rating filter
                    rating = null;
                }
            } catch (NumberFormatException ex) {
                // Invalid input (e.g., non-numeric) -> ignore rating filter
                rating = null;
            }
        }

        // Xử lý includeUnrated: nếu không có rating filter thì mặc định là true (hiện tất cả)
        // Nếu có rating filter mà không check includeUnrated thì là false
        boolean finalIncludeUnrated = (includeUnrated != null) ? includeUnrated : (rating == null || rating <= 0);
        
        // Build search via Specification
        Page<Product> prs = productService.search(
                q,
                categoryIds,
                minPrice,
                maxPrice,
                rating,
                Math.max(0, page-1),
                Math.max(1, size),
                sort,
                finalIncludeUnrated
        );

        // Tính rating, review count và số lượng đã bán cho mỗi product
        Map<Long, Double> productRatings = new HashMap<>();
        Map<Long, Long> productReviewCounts = new HashMap<>();
        Map<Long, Long> productSoldCounts = new HashMap<>();
        
        for (Product p : prs.getContent()) {
            Double avgRating = productReviewRepo.averageRatingByProduct(p.getId());
            Long reviewCount = productReviewRepo.countByProduct_IdAndIsDeletedFalseAndIsVisibleTrue(p.getId());
            Long soldCount = orderItemRepo.countSoldByProduct(p.getId());
            productRatings.put(p.getId(), avgRating != null ? avgRating : 0.0);
            productReviewCounts.put(p.getId(), reviewCount != null ? reviewCount : 0L);
            productSoldCounts.put(p.getId(), soldCount != null ? soldCount : 0L);
            
            // Debug log for rating filter
            if (rating != null && rating > 0) {
                System.out.println("Product: " + p.getName() + 
                                 " | Avg Rating: " + (avgRating != null ? avgRating : "NULL") + 
                                 " | Review Count: " + reviewCount);
            }
        }

        model.addAttribute("products", prs.getContent());
        model.addAttribute("productRatings", productRatings);
        model.addAttribute("productReviewCounts", productReviewCounts);
        model.addAttribute("productSoldCounts", productSoldCounts);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", prs.getTotalPages());
        model.addAttribute("totalProducts", prs.getTotalElements());
        model.addAttribute("sort", sort);

        // filters
        model.addAttribute("q", q);
        model.addAttribute("selectedCategories", categoryIds);
        model.addAttribute("minPrice", minPrice);
        model.addAttribute("maxPrice", maxPrice);
        model.addAttribute("rating", rating);
        model.addAttribute("includeUnrated", finalIncludeUnrated);

        // category list for sidebar
        model.addAttribute("categories", categoryRepo.findAll());
        return "client/product/list";
    }

    @GetMapping("/product/{id}")
    public String getProductDetail(Model model,
                                   @PathVariable Long id,
                                   HttpServletRequest request,
                                   @RequestParam(value = "reviewPage", defaultValue = "1") int reviewPage,
                                   @RequestParam(value = "reviewSize", defaultValue = "5") int reviewSize) {
        Product p = productRepo.findById(id).orElseThrow();
        List<ProductVariant> variants = variantRepo.findByProduct_Id(id);
        model.addAttribute("product", p);
        model.addAttribute("variants", variants);
        int safeReviewPage = Math.max(reviewPage, 1);
        int safeReviewSize = Math.max(reviewSize, 1);
        Page<ProductReview> reviewPageData = productReviewService
                .getVisibleByProduct(id, safeReviewPage - 1, safeReviewSize);
        Double avgRating = productReviewService.getAverageRating(id);
        
        // Tính số lượng đã bán
        Long soldCount = orderItemRepo.countSoldByProduct(id);
        
        model.addAttribute("reviews", reviewPageData.getContent());
        model.addAttribute("reviewCount", reviewPageData.getTotalElements());
        model.addAttribute("reviewCurrentPage", reviewPageData.getTotalPages() == 0 ? 1 : reviewPageData.getNumber() + 1);
        model.addAttribute("reviewTotalPages", reviewPageData.getTotalPages());
        model.addAttribute("reviewPageSize", reviewPageData.getSize());
        model.addAttribute("avgRating", avgRating);
        model.addAttribute("soldCount", soldCount != null ? soldCount : 0L);
        return "client/product/detail";
    }

    @PostMapping("/product/{id}/reviews")
    public String createProductReview(@PathVariable Long id,
                                      @RequestParam("rating") int rating,
                                      @RequestParam(value = "title", required = false) String title,
                                      @RequestParam(value = "comment", required = false) String comment,
                                      @RequestParam(value = "orderItemId", required = false) Long orderItemId,
                                      HttpServletRequest request) {
        User user = requireLogin(request.getSession(false));
        productReviewService.createReview(id, user.getId(), orderItemId, rating, title, comment);
        return "redirect:/product/" + id + "?reviewed=1";
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
        Long idValue = getSessionUserId(session);
        if (idValue == null) {
            throw new RuntimeException("Không xác định được người dùng.");
        }
        u.setId(idValue);
        return u;
    }

    private Long getSessionUserId(HttpSession session) {
        if (session == null) {
            return null;
        }
        Object raw = session.getAttribute("id");
        if (raw == null) {
            return null;
        }
        if (raw instanceof Long l) {
            return l;
        }
        if (raw instanceof Integer i) {
            return i.longValue();
        }
        try {
            return Long.parseLong(String.valueOf(raw));
        } catch (NumberFormatException ex) {
            return null;
        }
    }
}

