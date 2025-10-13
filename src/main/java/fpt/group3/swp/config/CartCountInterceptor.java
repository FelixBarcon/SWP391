package fpt.group3.swp.config;

import fpt.group3.swp.domain.User;
import fpt.group3.swp.service.CartService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * Interceptor to update cart count in session for header badge display
 */
@Component
public class CartCountInterceptor implements HandlerInterceptor {

    private final CartService cartService;

    public CartCountInterceptor(CartService cartService) {
        this.cartService = cartService;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        HttpSession session = request.getSession(false);
        
        // Only update if user is logged in
        if (session != null && session.getAttribute("id") != null) {
            try {
                Long userId = (Long) session.getAttribute("id");
                User user = new User();
                user.setId(userId);
                
                // Get total cart items count
                int cartCount = cartService.getTotalCartItemsCount(user);
                
                // Update session attribute
                session.setAttribute("cartCount", cartCount);
            } catch (Exception e) {
                // If error, set count to 0
                session.setAttribute("cartCount", 0);
            }
        } else {
            // No user logged in, set count to 0
            if (session != null) {
                session.setAttribute("cartCount", 0);
            }
        }
        
        return true;
    }
}
