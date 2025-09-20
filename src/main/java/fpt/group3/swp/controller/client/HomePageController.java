package fpt.group3.swp.controller.client;

import fpt.group3.swp.domain.User;
import fpt.group3.swp.domain.dto.RegisterDTO;
import fpt.group3.swp.service.UserService;
import jakarta.validation.Valid;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

@Controller
public class HomePageController {
    private final UserService userService;
    private final PasswordEncoder passwordEncoder;

    public HomePageController(UserService userService, PasswordEncoder passwordEncoder) {
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
    }
    @GetMapping("/")
    public String getHomePage(Model model) {
        return "client/homepage/homepage";
    }

    @GetMapping("/register")
    public String gerRegisterPageString(Model model) {
        model.addAttribute("newUser", new RegisterDTO());
        return "client/auth/register";
    }

    @GetMapping("/login")
    public String getLoginPage(Model model) {
        return "client/auth/login";
    }

    @PostMapping("/register")
    public String handleRegister(
            @ModelAttribute("newUser") @Valid RegisterDTO registerDTO,
            BindingResult bindingResult,
            Model model) {
        if (bindingResult.hasErrors()) {
            return "client/auth/register";
        }
        User user = this.userService.registerDTOtoUser(registerDTO);
        String hashPassword = this.passwordEncoder.encode(user.getPassword());

        user.setPassword(hashPassword);
        user.setRole(this.userService.getRoleByName("USER"));

        this.userService.handleSaveUser(user);

        return "redirect:/login";
    }

    @RequestMapping(value = "/access-deny", method = {RequestMethod.GET, RequestMethod.POST})
    public String denyPage(Model model) {
        return "client/user/hello";
    }
}