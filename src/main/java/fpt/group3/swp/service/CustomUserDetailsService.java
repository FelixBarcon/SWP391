package fpt.group3.swp.service;

import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.security.authentication.DisabledException;

import java.util.Collections;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserService userService;

    public CustomUserDetailsService(UserService userService) {
        this.userService = userService;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        fpt.group3.swp.domain.User user = this.userService.getUserByEmail(username);
        if (user == null) {
            throw new UsernameNotFoundException("user not found");
        }

        // Handle null role case - assign default role if role is null
        String roleName = "USER"; // default role
        if (user.getRole() != null) {
            roleName = user.getRole().getName();
        } else {
            // Fix user with missing role (save safely)
            user.setRole(this.userService.getRoleByName("USER"));
            this.userService.updateUser(user);
            System.out.println("Fixed user " + username + " with missing role");
        }

        boolean disabled = (user.getStatus() != null && user.getStatus().name().equals("INACTIVE"));

        return User.withUsername(user.getEmail())
                .password(user.getPassword())
                .authorities("ROLE_" + roleName)
                .accountExpired(false)
                .accountLocked(false)
                .credentialsExpired(false)
                .disabled(disabled)
                .build();

    }

}
