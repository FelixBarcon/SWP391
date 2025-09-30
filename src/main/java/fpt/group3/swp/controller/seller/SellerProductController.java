// src/main/java/fpt/group3/swp/controller/seller/SellerProductController.java
package fpt.group3.swp.controller.seller;

import fpt.group3.swp.domain.Shop;
import fpt.group3.swp.domain.Category;
import fpt.group3.swp.domain.Product;
import fpt.group3.swp.domain.ProductVariant;
import fpt.group3.swp.reposirory.ShopRepository;
import fpt.group3.swp.service.SellerProductService;
import fpt.group3.swp.service.SellerProductService.CreateProductForm;
import fpt.group3.swp.service.SellerProductService.EditPageData;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Controller
@RequestMapping("/seller/products")
@RequiredArgsConstructor
public class SellerProductController {

    private final SellerProductService productService;
    private final ShopRepository shopRepo;

    private long shopIdFromSession(HttpSession session) {
        if (session == null)
            throw new IllegalStateException("Phiên làm việc hết hạn. Vui lòng đăng nhập lại.");
        Long userId = (Long) session.getAttribute("id");
        if (userId == null)
            throw new IllegalStateException("Không tìm thấy user trong session.");
        Shop shop = shopRepo.findByUser_Id(userId)
                .orElseThrow(() -> new IllegalStateException("Bạn chưa có shop. Vui lòng đăng ký shop trước."));
        return shop.getId();
    }

    // ===== CREATE (GET) =====
    @GetMapping("/create")
    public String showCreateForm(Model model, HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        long shopId = shopIdFromSession(session);

        CreateProductForm form = productService.prepareCreateForm(shopId);
        List<Category> categories = productService.findAllCategories();

        model.addAttribute("form", form);
        model.addAttribute("categories", categories);
        return "seller/product/create/product-create";
    }

    // ===== CREATE (POST) =====
    @PostMapping
    public String create(@ModelAttribute CreateProductForm form,
            @RequestParam(name = "images", required = false) MultipartFile[] images,
            @RequestParam(name = "variantName", required = false) List<String> variantNames,
            @RequestParam(name = "variantPrice", required = false) List<String> variantPrices,
            @RequestParam(name = "variantImage", required = false) MultipartFile[] variantImages,
            HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        long shopId = shopIdFromSession(session);
        form.setShopId(shopId);

        Long productId = productService.createProduct(form, images, variantNames, variantPrices, variantImages);
        return "redirect:/seller/products/create?createdId=" + productId;
    }

    // ===== EDIT (GET) =====
    @GetMapping("/{id}/edit")
    public String editPage(@PathVariable Long id, Model model, HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        long shopId = shopIdFromSession(session);

        EditPageData data = productService.getEditPageData(id, shopId);
        model.addAttribute("p", data.getProduct());
        model.addAttribute("categories", data.getCategories());
        model.addAttribute("variants", data.getVariants());
        return "seller/product/edit/product-edit";
    }

    // ===== EDIT: BASIC (POST) =====
    @PostMapping("/{id}")
    public String updateBasic(@PathVariable Long id,
            @RequestParam String name,
            @RequestParam(required = false) String description,
            @RequestParam(required = false) List<Long> categoryIds,
            @RequestParam(required = false, defaultValue = "false") boolean hasVariants,
            @RequestParam(required = false) Double price,
            @RequestParam(name = "addImages", required = false) MultipartFile[] addImages,
            @RequestParam(name = "removeImageUrl", required = false) List<String> removeImageUrl,
            @RequestParam(name = "coverImage", required = false) String coverImage,
            @RequestParam(name = "coverUpload", required = false) MultipartFile coverUpload,
            HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        long shopId = shopIdFromSession(session);

        productService.updateBasicOwned(id, shopId, name, description, categoryIds, hasVariants,
                price, addImages, removeImageUrl, coverImage, coverUpload);

        return "redirect:/seller/products/" + id + "/edit?updated=variants";
    }

    // ===== EDIT: VARIANTS (POST) =====
    @PostMapping("/{id}/variants")
    public String upsertVariants(@PathVariable Long id,
            @RequestParam(name = "variantId", required = false) List<Long> variantIds,
            @RequestParam(name = "variantName", required = false) List<String> variantNames,
            @RequestParam(name = "variantPrice", required = false) List<String> variantPrices,
            @RequestParam(name = "variantImage", required = false) MultipartFile[] variantImages,
            @RequestParam(name = "variantImageFromGallery", required = false) List<String> variantImageFromGallery,
            @RequestParam(name = "deleteVariant", required = false) List<Long> deleteVariantIds,
            HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        long shopId = shopIdFromSession(session);

        productService.upsertVariantsOwned(id, shopId, variantIds, variantNames, variantPrices,
                variantImages, variantImageFromGallery, deleteVariantIds);

        return "redirect:/seller/products/" + id + "/edit?updated=variants";
    }
}
