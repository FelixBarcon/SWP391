package fpt.group3.swp.service;

import fpt.group3.swp.domain.Role;
import fpt.group3.swp.domain.User;
import fpt.group3.swp.domain.dto.RegisterDTO;
import fpt.group3.swp.reposirory.RoleRepository;
import fpt.group3.swp.reposirory.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.session.FindByIndexNameSessionRepository;
import org.springframework.session.Session;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import fpt.group3.swp.common.Status;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

@Service
public class UserService {
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final FindByIndexNameSessionRepository<? extends Session> sessionRepository;

    public UserService(UserRepository userRepository,
                       RoleRepository roleRepository,
                       FindByIndexNameSessionRepository<? extends Session> sessionRepository) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.sessionRepository = sessionRepository;
    }

    public List<User> getAllUser() {
        return this.userRepository.findAll();
    }

    public User getUserById(long id) {
        return this.userRepository.findById(id);
    }

    public User handleSaveUser(User user) {
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new IllegalArgumentException("Email already exists");
        }
        return userRepository.save(user);
    }


    public void deleteAUser(long id) {
        if(!userRepository.existsById(id)) {
            throw new IllegalArgumentException("User does not exist");
        }
        this.userRepository.deleteById(id);
    }

    public void deactivateUser(long id, String reason) {
        User user = userRepository.findById(id);
        if (user == null) {
            throw new IllegalArgumentException("User does not exist");
        }
        if (user.getRole() != null) {
            String rn = user.getRole().getName();
            if ("ADMIN".equalsIgnoreCase(rn) || "SUPER_ADMIN".equalsIgnoreCase(rn)) {
                throw new IllegalArgumentException("Không thể khóa tài khoản quản trị.");
            }
        }
        user.setStatus(Status.INACTIVE);
        user.setDeactivationReason(reason);
        user.setDeactivatedAt(LocalDateTime.now());
        userRepository.save(user);
        // Invalidate all active sessions for this user (kick out)
        try {
            if (user.getEmail() != null) {
                var sessions = sessionRepository.findByPrincipalName(user.getEmail());
                sessions.values().forEach(s -> sessionRepository.deleteById(s.getId()));
            }
        } catch (Exception ignored) {
            // Avoid breaking flow if session repository not available
        }
    }

    public void restoreUser(long id) {
        User user = userRepository.findById(id);
        if (user == null) {
            throw new IllegalArgumentException("User does not exist");
        }
        if (user.getRole() != null) {
            String rn = user.getRole().getName();
            if ("ADMIN".equalsIgnoreCase(rn) || "SUPER_ADMIN".equalsIgnoreCase(rn)) {
                throw new IllegalArgumentException("Không thể thay đổi trạng thái tài khoản quản trị.");
            }
        }
        user.setStatus(Status.ACTIVE);
        user.setDeactivationReason(null);
        user.setDeactivatedAt(null);
        userRepository.save(user);
    }

    public User registerDTOtoUser(RegisterDTO registerDTO) {
        User user = new User();
        user.setFullName(registerDTO.getFirstName() + " " + registerDTO.getLastName());
        user.setEmail(registerDTO.getEmail());
        user.setPassword(registerDTO.getPassword());
        return user;
    }

    public boolean checkEmailExist(String email) {
        return this.userRepository.existsByEmail(email);
    }

    public User getUserByEmail(String email) {
        return this.userRepository.findByEmail(email);
    }

    public Role getRoleByName(String name) {
        Role role = this.roleRepository.findByName(name).orElse(null);
        if (role == null) {
            // Create default role if it doesn't exist
            role = new Role();
            role.setName(name);
            role.setDescription("Default " + name + " role");
            role = this.roleRepository.save(role);
            System.out.println("Created missing role: " + name);
        }
        return role;
    }

    public String createPasswordResetToken(User user) {
        String token = UUID.randomUUID().toString();
        user.setResetToken(token);
        user.setResetTokenExpiry(LocalDateTime.now().plusMinutes(30));
        userRepository.save(user);
        return token;
    }

    public boolean isValidPasswordResetToken(String token) {
        User user = userRepository.findByResetToken(token);
        return user != null && user.getResetTokenExpiry().isAfter(LocalDateTime.now());
    }

    public User getUserByPasswordResetToken(String token) {
        User user = userRepository.findByResetToken(token);
        if (user == null || user.getResetTokenExpiry().isBefore(LocalDateTime.now())) {
            return null;
        }
        return user;
    }

    public void clearResetToken(User user) {
        user.setResetToken(null);
        user.setResetTokenExpiry(null);
        userRepository.save(user);
    }

    public void updateUser(User user) {
        userRepository.save(user);
    }

    public Page<User> searchUsers(String q, Status status, String roleName, int page, int size) {
        String term = (q != null && !q.isBlank()) ? q.trim() : null;
        Status st = status; // may be null for all
        String role = (roleName != null && !roleName.isBlank()) ? roleName.trim() : null;

        int p = Math.max(page, 0);
        int s = Math.min(Math.max(size, 5), 50);
        Pageable pageable = PageRequest.of(p, s, Sort.by(Sort.Direction.DESC, "id"));
        return userRepository.search(term, st, role, pageable);
    }
}
