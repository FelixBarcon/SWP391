package fpt.group3.swp.service;

import fpt.group3.swp.domain.Role;
import fpt.group3.swp.domain.User;
import fpt.group3.swp.domain.dto.RegisterDTO;
import fpt.group3.swp.reposirory.RoleRepository;
import fpt.group3.swp.reposirory.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private RoleRepository roleRepository;

    @InjectMocks
    private UserService userService;

    private User user;

    @BeforeEach
    void init() {
        user = new User();
        user.setId(1L);
        user.setEmail("test@example.com");
        user.setFullName("Test User");
        user.setPassword("password");
    }

    @Test
    void getAllUser_shouldReturnList_whenUsersExist() {
        when(userRepository.findAll()).thenReturn(Collections.singletonList(user));

        List<User> users = userService.getAllUser();

        assertEquals(1, users.size());
        verify(userRepository).findAll();
    }

    @Test
    void getUserById_shouldReturnUser_whenIdExists() {
        when(userRepository.findById(1L)).thenReturn(user);

        User found = userService.getUserById(1L);

        assertEquals("test@example.com", found.getEmail());
    }

    @Test
    void handleSaveUser_shouldSaveUser_whenEmailNotExists() {
        when(userRepository.existsByEmail(user.getEmail())).thenReturn(false);
        when(userRepository.save(user)).thenReturn(user);

        User saved = userService.handleSaveUser(user);

        assertEquals(user.getEmail(), saved.getEmail());
        verify(userRepository).save(user);
    }

    @Test
    void handleSaveUser_shouldThrowException_whenEmailExists() {
        when(userRepository.existsByEmail(user.getEmail())).thenReturn(true);

        assertThrows(IllegalArgumentException.class,
                () -> userService.handleSaveUser(user));
    }

    @Test
    void deleteAUser_shouldDelete_whenUserExists() {
        when(userRepository.existsById(1L)).thenReturn(true);

        userService.deleteAUser(1L);

        verify(userRepository).deleteById(1L);
    }

    @Test
    void deleteAUser_shouldThrowException_whenUserNotExists() {
        when(userRepository.existsById(1L)).thenReturn(false);

        assertThrows(IllegalArgumentException.class,
                () -> userService.deleteAUser(1L));
    }

    @Test
    void registerDTOtoUser_shouldMapFields_whenDTOProvided() {
        RegisterDTO dto = new RegisterDTO("John", "Doe", "john@example.com", "secret", "secret");

        User newUser = userService.registerDTOtoUser(dto);

        assertEquals("John Doe", newUser.getFullName());
        assertEquals("john@example.com", newUser.getEmail());
    }

    @Test
    void checkEmailExist_shouldReturnTrue_whenEmailExists() {
        when(userRepository.existsByEmail("test@example.com")).thenReturn(true);

        assertTrue(userService.checkEmailExist("test@example.com"));
    }

    @Test
    void getRoleByName_shouldReturnRole_whenRoleExists() {
        Role role = new Role();
        role.setName("USER");
        when(roleRepository.findByName("USER")).thenReturn(Optional.of(role));

        Role found = userService.getRoleByName("USER");

        assertEquals("USER", found.getName());
    }

    @Test
    void createPasswordResetToken_shouldGenerateToken_whenUserProvided() {
        when(userRepository.save(user)).thenReturn(user);

        String token = userService.createPasswordResetToken(user);

        assertNotNull(token);
        assertEquals(token, user.getResetToken());
        assertTrue(user.getResetTokenExpiry().isAfter(LocalDateTime.now()));
    }

    @Test
    void isValidPasswordResetToken_shouldReturnTrue_whenTokenValid() {
        user.setResetToken("valid-token");
        user.setResetTokenExpiry(LocalDateTime.now().plusMinutes(10));
        when(userRepository.findByResetToken("valid-token")).thenReturn(user);

        assertTrue(userService.isValidPasswordResetToken("valid-token"));
    }

    @Test
    void isValidPasswordResetToken_shouldReturnFalse_whenTokenInvalid() {
        when(userRepository.findByResetToken("invalid")).thenReturn(null);

        assertFalse(userService.isValidPasswordResetToken("invalid"));
    }

    @Test
    void getUserByPasswordResetToken_shouldReturnUser_whenTokenValid() {
        user.setResetToken("token123");
        user.setResetTokenExpiry(LocalDateTime.now().plusMinutes(20));
        when(userRepository.findByResetToken("token123")).thenReturn(user);

        User result = userService.getUserByPasswordResetToken("token123");

        assertNotNull(result);
    }

    @Test
    void getUserByPasswordResetToken_shouldReturnNull_whenTokenExpired() {
        user.setResetToken("token123");
        user.setResetTokenExpiry(LocalDateTime.now().minusMinutes(5));
        when(userRepository.findByResetToken("token123")).thenReturn(user);

        User result = userService.getUserByPasswordResetToken("token123");

        assertNull(result);
    }

    @Test
    void clearResetToken_shouldClearToken_whenUserProvided() {
        user.setResetToken("abc");
        user.setResetTokenExpiry(LocalDateTime.now().plusMinutes(5));
        when(userRepository.save(user)).thenReturn(user);

        userService.clearResetToken(user);

        assertNull(user.getResetToken());
        assertNull(user.getResetTokenExpiry());
        verify(userRepository).save(user);
    }

    @Test
    void updateUser_shouldSaveUser_whenUserProvided() {
        when(userRepository.save(user)).thenReturn(user);

        userService.updateUser(user);

        verify(userRepository).save(user);
    }
}
