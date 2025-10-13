package fpt.group3.swp.controller.client;

import fpt.group3.swp.common.Status;
import fpt.group3.swp.domain.Product;
import fpt.group3.swp.domain.User;
import fpt.group3.swp.domain.dto.RegisterDTO;
import fpt.group3.swp.reposirory.ProductRepository;
import fpt.group3.swp.service.ProductService;
import fpt.group3.swp.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

@Controller
public class HomePageController {
    private final UserService userService;
    private final PasswordEncoder passwordEncoder;
    private final ProductRepository productRepository;

    public HomePageController(UserService userService, PasswordEncoder passwordEncoder,
            ProductRepository productRepository) {
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
        this.productRepository = productRepository;
    }

    @GetMapping("/")
    public String getHomePage(Model model,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "8") int size) {

        // Lấy sản phẩm ACTIVE và chưa bị xóa
        Page<Product> products = productRepository.findByStatusAndDeleted(
                Status.ACTIVE, false, PageRequest.of(page, size));

        model.addAttribute("products", products.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", products.getTotalPages());

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

    @RequestMapping(value = "/access-deny", method = { RequestMethod.GET, RequestMethod.POST })
    public String denyPage(Model model) {
        return "client/access-deny";
    }
}