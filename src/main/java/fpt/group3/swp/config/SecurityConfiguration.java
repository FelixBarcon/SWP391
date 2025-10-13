package fpt.group3.swp.config;

import fpt.group3.swp.service.CustomUserDetailsService;
import fpt.group3.swp.service.UserService;
import jakarta.servlet.DispatcherType;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.session.security.web.authentication.SpringSessionRememberMeServices;

@Configuration
@EnableMethodSecurity(securedEnabled = true)
public class SecurityConfiguration {

        @Bean
        public PasswordEncoder passwordEncoder() {
                return new BCryptPasswordEncoder();
        }

        @Bean
        public UserDetailsService userDetailsService(UserService userService) {
                return new CustomUserDetailsService(userService);
        }

        @Bean
        public AuthenticationSuccessHandler customSuccessHandler() {
                return new SuccessHandler();
        }

        @Bean
        public DaoAuthenticationProvider authProvider(
                        PasswordEncoder passwordEncoder,
                        UserDetailsService userDetailsService) {
                DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
                authProvider.setUserDetailsService(userDetailsService);
                authProvider.setPasswordEncoder(passwordEncoder);
                return authProvider;
        }

        @Bean
        public SpringSessionRememberMeServices rememberMeServices() {
                SpringSessionRememberMeServices rememberMeServices = new SpringSessionRememberMeServices();
                rememberMeServices.setAlwaysRemember(true);
                return rememberMeServices;
        }

        @Bean
        SecurityFilterChain filterChain(HttpSecurity http,
                        AuthoritiesRefreshFilter authoritiesRefreshFilter) throws Exception {
                http
                                .authorizeHttpRequests(auth -> auth
                                                .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.INCLUDE)
                                                .permitAll()
                                                .requestMatchers("/", "/login", "/register", "/register/**",
                                                                "/css/**", "/js/**", "/images/**", "/resources/**")
                                                .permitAll()
                                                .requestMatchers(HttpMethod.GET, "/products", "/product/**").permitAll()
                                                .requestMatchers("/forgot-password", "/reset-password").permitAll()
                                                .requestMatchers(HttpMethod.GET, "/seller/register").authenticated()
                                                .requestMatchers(HttpMethod.POST, "/seller/register").authenticated()
                                                .requestMatchers(HttpMethod.POST, "/cart/**").authenticated()
                                                .requestMatchers(HttpMethod.POST, "/seller/register/save-draft")
                                                .permitAll()
                                                .requestMatchers(HttpMethod.GET, "/payment/vnp-return",
                                                                "/payment/vnpay-return")
                                                .permitAll()
                                                .requestMatchers(HttpMethod.GET, "/payment/vnp-ipn").permitAll()
                                                .requestMatchers(HttpMethod.GET, "/shipping/ghn/provinces",
                                                                "/shipping/ghn/districts",
                                                                "/shipping/ghn/wards")
                                                .permitAll()
                                                .requestMatchers(HttpMethod.POST, "/shipping/ghn/fee").permitAll()
                                                .requestMatchers("/seller/**").hasRole("SELLER")
                                                .requestMatchers("/admin/**").hasRole("ADMIN")
                                                .anyRequest().authenticated())
                                .sessionManagement(s -> s
                                                .sessionCreationPolicy(SessionCreationPolicy.ALWAYS)
                                                .invalidSessionUrl("/logout?expired")
                                                .maximumSessions(1)
                                                .maxSessionsPreventsLogin(false))
                                .logout(l -> l
                                                .logoutUrl("/logout")
                                                .logoutSuccessUrl("/login?logout")
                                                .deleteCookies("JSESSIONID")
                                                .invalidateHttpSession(true))
                                .csrf(csrf -> csrf.disable())
                                .rememberMe(r -> r.rememberMeServices(rememberMeServices()))
                                .formLogin(f -> f
                                                .loginPage("/login")
                                                .failureUrl("/login?error")
                                                .successHandler(customSuccessHandler())
                                                .permitAll())
                                .addFilterAfter(authoritiesRefreshFilter, UsernamePasswordAuthenticationFilter.class)

                                .exceptionHandling(ex -> ex.accessDeniedPage("/access-deny"));

                return http.build();
        }
}
