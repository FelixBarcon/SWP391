// src/main/java/fpt/group3/swp/service/AccountService.java
package fpt.group3.swp.service;

import fpt.group3.swp.domain.User;
import fpt.group3.swp.reposirory.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.security.Principal;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AccountService {

    private final UserRepository userRepo;
    private final UploadService uploadService;
    private final Optional<PasswordEncoder> passwordEncoder; // optional cho DEV, prod thì luôn có

    // ---------- Lấy user từ Principal ----------
    @Transactional(readOnly = true)
    public User getCurrentUser(Principal principal) {
        if (principal == null || !StringUtils.hasText(principal.getName())) {
            throw new IllegalStateException("Bạn cần đăng nhập.");
        }
        User u = userRepo.findByEmail(principal.getName());
        if (u == null) throw new IllegalArgumentException("Không tìm thấy user theo principal.");
        return u;
    }

    // ---------- Xem hồ sơ ----------
    @Transactional(readOnly = true)
    public User viewProfile(Principal principal) {
        return getCurrentUser(principal);
    }

    // ---------- Cập nhật hồ sơ ----------
    @Transactional
    public void updateProfile(Principal principal, UpdateProfileReq req, MultipartFile avatarFile) {
        User u = getCurrentUser(principal);

        // Email duy nhất
        if (StringUtils.hasText(req.getEmail()) && !req.getEmail().equalsIgnoreCase(u.getEmail())) {
            if (userRepo.existsByEmailIgnoreCaseAndIdNot(req.getEmail().trim(), u.getId())) {
                throw new BusinessException("email_exists", "Email đã tồn tại.");
            }
            u.setEmail(req.getEmail().trim());
        }

        if (StringUtils.hasText(req.getFullName())) u.setFullName(req.getFullName().trim());
        u.setFirstName(req.getFirstName() == null ? null : req.getFirstName().trim());
        u.setLastName(req.getLastName() == null ? null : req.getLastName().trim());
        u.setPhone(req.getPhone() == null ? null : req.getPhone().trim());
        u.setAddress(req.getAddress() == null ? null : req.getAddress().trim());

        // Avatar
        if (req.isRemoveAvatar()) {
            u.setAvatar(null);
        }
        if (avatarFile != null && !avatarFile.isEmpty()) {
            String folder = "avatars/" + u.getId();
            List<String> saved = uploadService.handleSaveUploadFiles(new MultipartFile[]{avatarFile}, folder);
            if (!saved.isEmpty()) {
                u.setAvatar(folder + "/" + saved.get(0));
            }
        }

        userRepo.save(u);
    }

    // ---------- Đổi mật khẩu ----------
    @Transactional
    public void changePassword(Principal principal, String currentPassword, String newPassword, String confirmPassword) {
        User u = getCurrentUser(principal);

        if (!Objects.equals(newPassword, confirmPassword)) {
            throw new BusinessException("pw_confirm", "Mật khẩu xác nhận không khớp.");
        }
        if (newPassword == null || newPassword.trim().length() < 8) {
            throw new BusinessException("pw_short", "Mật khẩu mới phải có ít nhất 8 ký tự.");
        }

        if (passwordEncoder.isPresent()) {
            if (!passwordEncoder.get().matches(currentPassword, u.getPassword())) {
                throw new BusinessException("pw_current", "Mật khẩu hiện tại không đúng.");
            }
            u.setPassword(passwordEncoder.get().encode(newPassword));
        } else {
            // DEV ONLY nếu chưa cấu hình encoder
            if (!Objects.equals(currentPassword, u.getPassword())) {
                throw new BusinessException("pw_current", "Mật khẩu hiện tại không đúng (DEV).");
            }
            u.setPassword(newPassword);
        }

        userRepo.save(u);
    }

    // ---------- DTO ----------
    @Value
    public static class UpdateProfileReq {
        String fullName;
        String firstName;
        String lastName;
        String email;
        String phone;
        String address;
        boolean removeAvatar;
    }

    // ---------- Business exception ----------
    @Value
    public static class BusinessException extends RuntimeException {
        String code;
        String message;
        public BusinessException(String code, String message) {
            super(message);
            this.code = code;
            this.message = message;
        }
    }
}
