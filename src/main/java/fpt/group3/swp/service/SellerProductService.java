// src/main/java/fpt/group3/swp/service/SellerProductService.java
package fpt.group3.swp.service;

import fpt.group3.swp.common.Status;
import fpt.group3.swp.domain.*;
import fpt.group3.swp.reposirory.*;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SellerProductService {

    private final UploadService uploadService;
    private final CategoryRepository categoryRepo;
    private final ShopRepository shopRepo;
    private final ProductRepository productRepo;
    private final ProductVariantRepository variantRepo;

    // ===== Helper: dữ liệu cho trang CREATE =====
    @Transactional(readOnly = true)
    public CreateProductForm prepareCreateForm(Long shopId) {
        CreateProductForm form = new CreateProductForm();
        form.setShopId(shopId);
        return form;
    }

    @Transactional(readOnly = true)
    public List<Category> findAllCategories() {
        return categoryRepo.findAll();
    }

    @Transactional(readOnly = true)
    public Shop findShopById(Long shopId) {
        return shopRepo.findById(shopId).orElse(null);
    }

    // ===== CREATE =====
    @Transactional
    public Long createProduct(CreateProductForm form,
                              MultipartFile[] images,
                              List<String> variantNames,
                              List<String> variantPrices,
                              MultipartFile[] variantImages) {

        Shop shop = shopRepo.findById(form.getShopId())
                .orElseThrow(() -> new IllegalArgumentException("Shop not found"));

        Product p = new Product();
        p.setShop(shop);
        p.setName(form.getName());
        p.setDescription(form.getDescription() == null ? "" : form.getDescription());
        p.setHasVariants(Boolean.TRUE.equals(form.getHasVariants()));
        p.setStatus(Status.ACTIVE);

        // Categories (tuỳ chọn)
        Set<Category> cats = form.getCategoryIds() == null ? new HashSet<>() :
                new HashSet<>(categoryRepo.findAllById(form.getCategoryIds()));
        p.setCategories(cats);

        // Ảnh sản phẩm
        if (images != null && images.length > 0) {
            String folder = "products/" + shop.getId();
            List<String> saved = uploadService.handleSaveUploadFiles(images, folder)
                    .stream().map(fn -> folder + "/" + fn).toList();
            p.getImageUrls().addAll(saved);
            if (p.getImageUrl() == null && !saved.isEmpty()) p.setImageUrl(saved.get(0));
        }

        // Giá
        if (!p.getHasVariants()) {
            double base = form.getPrice() == null ? 0d : form.getPrice();
            p.setPrice(base); p.setPriceMin(base); p.setPriceMax(base);
        } else {
            p.setPrice(form.getPrice()); // giá base (fallback)
        }

        // Lưu trước để có id
        p = productRepo.save(p);

        // Biến thể đơn giản
        if (Boolean.TRUE.equals(p.getHasVariants()) && variantNames != null && !variantNames.isEmpty()) {
            String folder = "products/" + shop.getId();
            for (int i = 0; i < variantNames.size(); i++) {
                String name = variantNames.get(i);
                if (!StringUtils.hasText(name)) continue;

                ProductVariant v = new ProductVariant();
                v.setProduct(p);
                v.setName(name.trim());

                // Giá
                Double price = null;
                if (variantPrices != null && i < variantPrices.size()) {
                    try { price = Double.parseDouble(variantPrices.get(i)); } catch (Exception ignored) {}
                }
                v.setPrice(price);

                // Ảnh biến thể
                if (variantImages != null && i < variantImages.length && variantImages[i] != null && !variantImages[i].isEmpty()) {
                    List<String> saved = uploadService.handleSaveUploadFiles(new MultipartFile[]{variantImages[i]}, folder);
                    if (!saved.isEmpty()) v.setImageUrl(folder + "/" + saved.get(0));
                }

                variantRepo.save(v);
                p.getVariants().add(v);
            }
            recalcPriceRange(p);
            if ((p.getImageUrl() == null || p.getImageUrl().isBlank()) && !p.getImageUrls().isEmpty()) {
                p.setImageUrl(p.getImageUrls().get(0));
            }
            productRepo.save(p);
        }

        return p.getId();
    }

    // ===== LIST =====
    @Transactional(readOnly = true)
    public List<Product> fetchProducts(Long shopId, boolean showDeleted) {
        return showDeleted
                ? productRepo.findAllByShop_IdOrderByUpdatedAtDesc(shopId)
                : productRepo.findAllByShop_IdAndDeletedFalseOrderByUpdatedAtDesc(shopId);
    }

    // ===== TOGGLE =====
    @Transactional
    public void toggleDelete(Long id, Long shopId) {
        Product p = productRepo.findById(id).orElseThrow(() -> new IllegalArgumentException("Product not found"));
        assertOwner(p, shopId);
        boolean newDeletedState = !p.isDeleted();
        p.setDeleted(newDeletedState);
        // Update status based on delete state: deleted products are inactive, restored products are active
        p.setStatus(newDeletedState ? Status.INACTIVE : Status.ACTIVE);
        productRepo.save(p);
    }

    @Transactional
    public void toggleStatus(Long id, Long shopId) {
        Product p = productRepo.findById(id).orElseThrow(() -> new IllegalArgumentException("Product not found"));
        assertOwner(p, shopId);
        if (p.isDeleted()) p.setStatus(Status.INACTIVE);
        else p.setStatus(p.getStatus() == Status.ACTIVE ? Status.INACTIVE : Status.ACTIVE);
        productRepo.save(p);
    }

    // ===== EDIT PAGE DATA =====
    @Transactional(readOnly = true)
    public EditPageData getEditPageData(Long productId, Long shopId) {
        Product p = productRepo.findById(productId).orElseThrow(() -> new IllegalArgumentException("Product not found"));
        assertOwner(p, shopId);
        List<ProductVariant> variants = variantRepo.findAllByProduct_Id(productId);
        List<Category> categories = categoryRepo.findAll();

        EditPageData data = new EditPageData();
        data.setProduct(p);
        data.setVariants(variants);
        data.setCategories(categories);
        return data;
    }

    // ===== UPDATE BASIC =====
    @Transactional
    public void updateBasicOwned(Long id, Long shopId, String name, String description,
                                 List<Long> categoryIds, boolean hasVariants,
                                 Double price,
                                 MultipartFile[] addImages, List<String> removeImageUrl,
                                 String coverImage, MultipartFile coverUpload) {
        Product p = productRepo.findById(id).orElseThrow(() -> new IllegalArgumentException("Product not found"));
        assertOwner(p, shopId);

        p.setName(name);
        p.setDescription(description == null ? "" : description);
        p.setHasVariants(hasVariants);

        // Categories
        Set<Category> newCats = categoryIds == null ? new HashSet<>() :
                new HashSet<>(categoryRepo.findAllById(categoryIds));
        p.setCategories(newCats);

        // Xóa ảnh
        if (removeImageUrl != null && !removeImageUrl.isEmpty()) {
            p.getImageUrls().removeIf(removeImageUrl::contains);
            if (p.getImageUrl() != null && removeImageUrl.contains(p.getImageUrl())) {
                p.setImageUrl(null);
            }
        }

        // Thêm ảnh
        if (addImages != null && addImages.length > 0) {
            String folder = "products/" + p.getShop().getId();
            List<String> saved = uploadService.handleSaveUploadFiles(addImages, folder)
                    .stream().map(fn -> folder + "/" + fn).toList();
            p.getImageUrls().addAll(saved);
        }

        // Cover
        if (coverUpload != null && !coverUpload.isEmpty()) {
            String folder = "products/" + p.getShop().getId();
            List<String> saved = uploadService.handleSaveUploadFiles(new MultipartFile[]{coverUpload}, folder);
            if (!saved.isEmpty()) {
                String url = folder + "/" + saved.get(0);
                p.setImageUrl(url);
                if (!p.getImageUrls().contains(url)) p.getImageUrls().add(0, url);
            }
        } else if (coverImage != null && !coverImage.isBlank()) {
            p.setImageUrl(coverImage);
            if (!p.getImageUrls().contains(coverImage)) p.getImageUrls().add(0, coverImage);
        } else if ((p.getImageUrl() == null || p.getImageUrl().isBlank()) && !p.getImageUrls().isEmpty()) {
            p.setImageUrl(p.getImageUrls().get(0));
        }

        // Giá
        if (!hasVariants) {
            double base = price == null ? 0d : price;
            p.setPrice(base); p.setPriceMin(base); p.setPriceMax(base);
        } else {
            p.setPrice(price);
            recalcPriceRange(p);
        }

        productRepo.save(p);
    }

    // ===== UPSERT VARIANTS =====
    @Transactional
    public void upsertVariantsOwned(Long productId, Long shopId,
                                    List<Long> variantIds, List<String> variantNames, List<String> variantPrices,
                                    MultipartFile[] variantImages, List<String> variantImageFromGallery,
                                    List<Long> deleteVariantIds) {
        Product p = productRepo.findById(productId).orElseThrow(() -> new IllegalArgumentException("Product not found"));
        assertOwner(p, shopId);

        String folder = "products/" + p.getShop().getId();

        Map<Long, ProductVariant> map = new HashMap<>();
        if (variantIds != null && !variantIds.isEmpty()) {
            map = variantRepo.findAllById(variantIds).stream()
                    .collect(Collectors.toMap(ProductVariant::getId, v -> v));
        }

        int n = (variantNames == null ? 0 : variantNames.size());
        for (int i = 0; i < n; i++) {
            String name = variantNames.get(i);
            if (!StringUtils.hasText(name)) continue;

            Long vid = (variantIds != null && i < variantIds.size()) ? variantIds.get(i) : null;
            ProductVariant v = (vid != null ? map.get(vid) : null);
            if (v == null) v = new ProductVariant();

            v.setProduct(p);
            v.setName(name.trim());

            Double price = null;
            if (variantPrices != null && i < variantPrices.size()) {
                try { price = Double.parseDouble(variantPrices.get(i)); } catch (Exception ignored) {}
            }
            v.setPrice(price);

            if (variantImages != null && i < variantImages.length && variantImages[i] != null && !variantImages[i].isEmpty()) {
                List<String> saved = uploadService.handleSaveUploadFiles(new MultipartFile[]{variantImages[i]}, folder);
                if (!saved.isEmpty()) v.setImageUrl(folder + "/" + saved.get(0));
            } else if (variantImageFromGallery != null && i < variantImageFromGallery.size()) {
                String pick = variantImageFromGallery.get(i);
                if (StringUtils.hasText(pick)) v.setImageUrl(pick);
            }

            variantRepo.save(v);
        }

        if (deleteVariantIds != null && !deleteVariantIds.isEmpty()) {
            for (Long delId : deleteVariantIds) {
                variantRepo.deleteById(delId);
            }
        }

        recalcPriceRange(p);
        if ((p.getImageUrl() == null || p.getImageUrl().isBlank()) && !p.getImageUrls().isEmpty()) {
            p.setImageUrl(p.getImageUrls().get(0));
        }
        productRepo.save(p);
    }

    // ===== DELETE VARIANT =====
    @Transactional
    public void deleteVariantOwned(Long productId, Long shopId, Long variantId) {
        Product p = productRepo.findById(productId).orElseThrow();
        assertOwner(p, shopId);
        variantRepo.deleteById(variantId);
        recalcPriceRange(p);
        productRepo.save(p);
    }

    // ===== Utils =====
    private void assertOwner(Product p, Long shopId) {
        if (p.getShop() == null || !Objects.equals(p.getShop().getId(), shopId)) {
            throw new IllegalArgumentException("Bạn không có quyền thao tác sản phẩm này");
        }
    }

    private void recalcPriceRange(Product p) {
        List<ProductVariant> remain = variantRepo.findAllByProduct_Id(p.getId());
        double base = p.getPrice() == null ? 0d : p.getPrice();
        double min = Double.MAX_VALUE, max = 0d;
        for (ProductVariant v : remain) {
            double pr = v.getPrice() != null ? v.getPrice() : base;
            min = Math.min(min, pr); max = Math.max(max, pr);
        }
        if (min == Double.MAX_VALUE) { min = base; max = base; }
        p.setPriceMin(min); p.setPriceMax(max);
    }

    // ===== DTOs =====
    @Data
    public static class CreateProductForm {
        private Long shopId;
        private String name;
        private String description;
        private List<Long> categoryIds;
        private Boolean hasVariants;
        private Double price;
    }

    @Data
    public static class EditPageData {
        private Product product;
        private List<ProductVariant> variants;
        private List<Category> categories;
    }
}
