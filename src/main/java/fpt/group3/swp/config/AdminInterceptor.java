package fpt.group3.swp.config;

import fpt.group3.swp.common.VerifyStatus;
import fpt.group3.swp.reposirory.ShopRepository;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.lang.NonNull;
import org.springframework.lang.Nullable;

@Component
@RequiredArgsConstructor
public class AdminInterceptor implements HandlerInterceptor {

    private final ShopRepository shopRepository;

    @Override
    public void postHandle(@NonNull HttpServletRequest request, @NonNull HttpServletResponse response, 
                          @NonNull Object handler, @Nullable ModelAndView modelAndView) {
        if (modelAndView != null && request.getRequestURI().startsWith("/admin")) {
            // Add pending seller requests count
            modelAndView.addObject("pending", shopRepository.findAllByVerifyStatus(VerifyStatus.PENDING));
        }
    }
}