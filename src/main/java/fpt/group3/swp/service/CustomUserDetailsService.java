package fpt.group3.swp.service;

import java.util.Collections;

import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

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
            // Fix user with missing role
            user.setRole(this.userService.getRoleByName("USER"));
            this.userService.handleSaveUser(user);
            System.out.println("Fixed user " + username + " with missing role");
        }

        return new User(
                user.getEmail(),
                user.getPassword(),
                Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + roleName)));

    }

}