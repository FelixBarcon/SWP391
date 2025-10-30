package fpt.group3.swp.service;

import fpt.group3.swp.common.VerifyStatus;
import fpt.group3.swp.domain.Role;
import fpt.group3.swp.domain.Shop;
import fpt.group3.swp.domain.User;
import fpt.group3.swp.domain.dto.SellerRegistrationDTO;
import fpt.group3.swp.reposirory.RoleRepository;
import fpt.group3.swp.reposirory.ShopRepository;
import fpt.group3.swp.reposirory.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class SellerService {

    private final ShopRepository shopRepo;
    private final UserRepository userRepo;
    private final RoleRepository roleRepo;
    private final fpt.group3.swp.reposirory.ProductRepository productRepo;
    private final UserService userService;
    private final MailService mailService;

    /** Tạo/cập nhật bản nháp (DRAFT). Cho phép gọi nhiều lần khi user đi qua các bước */
    @Transactional
    public Shop saveDraft(Long userId, SellerRegistrationDTO dto) {
        Shop shop = shopRepo.findByUser_Id(userId).orElseGet(() -> {
            User u = userRepo.findById(userId)
                    .orElseThrow(() -> new EntityNotFoundException("User not found: " + userId));
            Shop s = new Shop();
            s.setUser(u);
            s.setCreatedAt(LocalDate.now());
            s.setVerifyStatus(VerifyStatus.DRAFT);
            return s;
        });

        // Không cho sửa nếu đã APPROVED
        if (shop.getVerifyStatus() == VerifyStatus.APPROVED) {
            throw new IllegalStateException("Tài khoản đã là người bán.");
        }
        // Không cho sửa khi đang chờ duyệt
        if (shop.getVerifyStatus() == VerifyStatus.PENDING) {
            throw new IllegalStateException("Hồ sơ đang chờ duyệt, không thể chỉnh sửa.");
        }

        applyForm(shop, dto);
        shop.setVerifyStatus(VerifyStatus.DRAFT);
        shop.setVerifiedAt(null);
        shop.setVerifyBy(null);
        return shopRepo.save(shop);
    }

    /** Nộp xét duyệt (chuyển PENDING). Validate những trường bắt buộc */
    @Transactional
    public Shop submit(Long userId, SellerRegistrationDTO dto) {
        Shop shop = shopRepo.findByUser_Id(userId)
                .orElseGet(() -> saveDraft(userId, dto)); // nếu chưa có thì tạo draft trước

        if (shop.getVerifyStatus() == VerifyStatus.APPROVED) {
            throw new IllegalStateException("Tài khoản đã là người bán.");
        }
        if (shop.getVerifyStatus() == VerifyStatus.PENDING) {
            return shop; // đã nộp rồi
        }

        // Validate cơ bản
        if (isBlank(dto.getDisplayName())) {
            throw new IllegalStateException("Tên hiển thị là bắt buộc.");
        }
        // Tên shop phải duy nhất (tránh đụng unique index)
        boolean nameTaken = shopRepo.existsByDisplayNameIgnoreCase(dto.getDisplayName())
                && (shop.getDisplayName() == null
                || !shop.getDisplayName().equalsIgnoreCase(dto.getDisplayName()));
        if (nameTaken) {
            throw new IllegalStateException("Tên hiển thị đã tồn tại.");
        }

        applyForm(shop, dto);
        shop.setVerifyStatus(VerifyStatus.PENDING);
        shop.setVerifiedAt(null);
        shop.setVerifyBy(null);
        return shop;
    }

    /** ADMIN: approve */
    @Transactional
    public void approve(Long shopId, Long adminId) {
        Shop shop = shopRepo.findById(shopId)
                .orElseThrow(() -> new EntityNotFoundException("Shop not found: " + shopId));
        shop.setVerifyStatus(VerifyStatus.APPROVED);
        shop.setVerifiedAt(LocalDateTime.now());
        shop.setVerifyBy(adminId);

        // đổi role user -> SELLER
        Role sellerRole = roleRepo.findByName("SELLER")
                .orElseThrow(() -> new EntityNotFoundException("Role SELLER không tồn tại"));
        shop.getUser().setRole(sellerRole);
    }

    /** ADMIN: reject */
    @Transactional
    public void reject(Long shopId, Long adminId) {
        Shop shop = shopRepo.findById(shopId)
                .orElseThrow(() -> new EntityNotFoundException("Shop not found: " + shopId));
        shop.setVerifyStatus(VerifyStatus.REJECTED);
        shop.setVerifiedAt(LocalDateTime.now());
        shop.setVerifyBy(adminId);
    }

    /**
     * ADMIN: Lock a shop -> deactivate seller account and set all products of this shop to INACTIVE.
     */
    @Transactional
    public void lockShop(Long shopId, String reason) {
        Shop shop = shopRepo.findById(shopId)
                .orElseThrow(() -> new EntityNotFoundException("Shop not found: " + shopId));

        if (shop.getUser() == null) {
            throw new IllegalStateException("Shop has no owner account");
        }

        // Deactivate seller account (also invalidates sessions)
        userService.deactivateUser(shop.getUser().getId(), reason);

        // Send deactivation email like account deactivation
        try {
            String email = shop.getUser().getEmail();
            if (email != null && !email.isBlank()) {
                mailService.sendAccountDeactivationEmail(email, reason);
            }
        } catch (Exception ignored) {
            // Avoid failing business flow due to mail errors
        }

        // Set products that are currently ACTIVE to INACTIVE and mark lockedByShop
        var products = productRepo.findAllByShop_IdOrderByUpdatedAtDesc(shop.getId());
        if (products != null) {
            boolean changed = false;
            for (var p : products) {
                if (!p.isDeleted() && p.getStatus() == fpt.group3.swp.common.Status.ACTIVE) {
                    p.setStatus(fpt.group3.swp.common.Status.INACTIVE);
                    p.setLockedByShop(true);
                    changed = true;
                }
            }
            if (changed) productRepo.saveAll(products);
        }
    }

    /**
     * ADMIN: Unlock a shop -> reactivate seller account and set all products of this shop to ACTIVE.
     */
    @Transactional
    public void unlockShop(Long shopId) {
        Shop shop = shopRepo.findById(shopId)
                .orElseThrow(() -> new EntityNotFoundException("Shop not found: " + shopId));

        if (shop.getUser() == null) {
            throw new IllegalStateException("Shop has no owner account");
        }

        // Reactivate seller account
        userService.restoreUser(shop.getUser().getId());

        // Restore only products that were deactivated due to shop lock
        var products = productRepo.findAllByShop_IdOrderByUpdatedAtDesc(shop.getId());
        if (products != null) {
            boolean changed = false;
            for (var p : products) {
                if (p.isLockedByShop()) {
                    p.setStatus(fpt.group3.swp.common.Status.ACTIVE);
                    p.setLockedByShop(false);
                    changed = true;
                }
            }
            if (changed) productRepo.saveAll(products);
        }
    }

    /** Cho phép user “sửa lại sau khi bị từ chối”: đưa về DRAFT */
    @Transactional
    public Shop reopenAfterReject(Long userId) {
        Shop shop = shopRepo.findByUser_Id(userId)
                .orElseThrow(() -> new EntityNotFoundException("Chưa có hồ sơ shop"));
        if (shop.getVerifyStatus() != VerifyStatus.REJECTED) {
            throw new IllegalStateException("Chỉ có thể mở lại khi ở trạng thái REJECTED.");
        }
        shop.setVerifyStatus(VerifyStatus.DRAFT);
        shop.setVerifiedAt(null);
        shop.setVerifyBy(null);
        return shop;
    }

    // --- helpers ---
    private void applyForm(Shop s, SellerRegistrationDTO dto) {
        s.setDisplayName(dto.getDisplayName());
        s.setDescription(dto.getDescription());
        s.setPickupAddress(dto.getPickupAddress());
        s.setReturnAddress(dto.getReturnAddress());
        s.setContactPhone(dto.getContactPhone());
        s.setBankCode(dto.getBankCode());
        s.setBankAccountNo(dto.getBankAccountNo());
        s.setBankAccountName(dto.getBankAccountName());
    }

    private boolean isBlank(String s) { return s == null || s.trim().isEmpty(); }
}
