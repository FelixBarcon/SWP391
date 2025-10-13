package fpt.group3.swp.config;

import fpt.group3.swp.common.VerifyStatus;
import fpt.group3.swp.reposirory.ShopRepository;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class AuthoritiesRefreshFilter extends OncePerRequestFilter {

    private final ShopRepository shopRepo;
    private final UserDetailsService userDetailsService;

    public AuthoritiesRefreshFilter(ShopRepository shopRepo, UserDetailsService userDetailsService) {
        this.shopRepo = shopRepo;
        this.userDetailsService = userDetailsService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getPrincipal())) {

            String username;
            if (auth.getPrincipal() instanceof org.springframework.security.core.userdetails.UserDetails ud) {
                username = ud.getUsername();
            } else {
                username = auth.getName();
            }

            // Lấy userId từ session (theo cách bạn đang làm)
            HttpSession session = request.getSession(false);
            Long userId = null;
            if (session != null) {
                Object id = session.getAttribute("id");
                if (id != null) userId = Long.valueOf(id.toString());
            }

            if (userId != null) {
                boolean alreadySellerRole = auth.getAuthorities().stream()
                        .anyMatch(ga -> ga.getAuthority().equals("ROLE_SELLER"));

                boolean approved = shopRepo.findByUser_Id(userId)
                        .map(s -> s.getVerifyStatus() == VerifyStatus.APPROVED)
                        .orElse(false);

                if (approved && !alreadySellerRole) {
                    var userDetails = userDetailsService.loadUserByUsername(username);
                    var newAuth = new UsernamePasswordAuthenticationToken(
                            userDetails,
                            auth.getCredentials(),
                            userDetails.getAuthorities()
                    );
                    newAuth.setDetails(auth.getDetails());
                    SecurityContextHolder.getContext().setAuthentication(newAuth);
                }
            }
        }

        filterChain.doFilter(request, response);
    }
}
