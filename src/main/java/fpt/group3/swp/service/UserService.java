package fpt.group3.swp.service;

import fpt.group3.swp.domain.Role;
import fpt.group3.swp.domain.User;
import fpt.group3.swp.domain.dto.RegisterDTO;
import fpt.group3.swp.reposirory.RoleRepository;
import fpt.group3.swp.reposirory.UserRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
public class UserService {
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;

    public UserService(UserRepository userRepository, RoleRepository roleRepository) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
    }

    public List<User> getAllUser() {
        return this.userRepository.findAll();
    }

    public User getUserById(long id) {
        return this.userRepository.findById(id);
    }

    public User handleSaveUser(User user) {
        return this.userRepository.save(user);
    }

    public void deleteAUser(long id) {
        this.userRepository.deleteById(id);
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
        Role role = this.roleRepository.findByName(name);
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
}