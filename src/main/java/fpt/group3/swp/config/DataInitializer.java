package fpt.group3.swp.config;

import fpt.group3.swp.domain.*;
import fpt.group3.swp.common.VerifyStatus;
import fpt.group3.swp.common.Status;
import fpt.group3.swp.reposirory.*;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Random;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ShopRepository shopRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ProductVariantRepository productVariantRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    private final Random random = new Random();

    @Override
    public void run(String... args) throws Exception {
        // Initialize Roles
        if (roleRepository.count() == 0) {
            Role adminRole = new Role();
            adminRole.setName("ADMIN");
            adminRole.setDescription("Administrator role with full access");
            roleRepository.save(adminRole);

            Role sellerRole = new Role();
            sellerRole.setName("SELLER");
            sellerRole.setDescription("Seller role for shop owners");
            roleRepository.save(sellerRole);

            Role userRole = new Role();
            userRole.setName("USER");
            userRole.setDescription("Standard user role for customers");
            roleRepository.save(userRole);
        }

        // Initialize Admin User
        if (userRepository.findByEmail("admin@example.com") == null) {
            Role adminRole = roleRepository.findByName("ADMIN").orElseThrow();
            User admin = new User();
            admin.setEmail("admin@example.com");
            admin.setPassword(passwordEncoder.encode("123456"));
            admin.setFirstName("Admin");
            admin.setLastName("User");
            admin.setFullName("Admin User");
            admin.setAddress("123 Admin Street");
            admin.setPhone("0123456789");
            admin.setAvatar("admin_avatar.jpg");
            admin.setRole(adminRole);
            userRepository.save(admin);
        }

        Role sellerRole = roleRepository.findByName("SELLER").orElseThrow();
        for (int i = 1; i <= 3; i++) {
            String sellerEmail = "seller" + i + "@example.com";
            if (userRepository.findByEmail(sellerEmail) == null) {
                User seller = new User();
                seller.setEmail(sellerEmail);
                seller.setPassword(passwordEncoder.encode("123456"));
                seller.setFirstName("Seller" + i);
                seller.setLastName("Shop");
                seller.setFullName("Seller " + i + " Shop");
                seller.setAddress("456 Seller Avenue " + i);
                seller.setPhone("098765432" + i);
                seller.setAvatar("seller_avatar_" + i + ".jpg");
                seller.setRole(sellerRole);
                userRepository.save(seller);

                Shop shop = new Shop();
                shop.setUser(seller);
                shop.setDisplayName("Shop " + i);
                shop.setDescription("A sample shop " + i + " for demonstration");
                shop.setVerifyStatus(VerifyStatus.APPROVED);
                shop.setVerifiedAt(LocalDateTime.now());
                shop.setVerifyBy(1L); // Assuming admin ID
                shop.setPickupAddress("Pickup at 456 Seller Avenue " + i);
                shop.setReturnAddress("Return to 456 Seller Avenue " + i);
                shop.setContactPhone("098765432" + i);
                shop.setBankCode("BANK00" + i);
                shop.setBankAccountNo("123456789" + i);
                shop.setBankAccountName("Seller " + i + " Shop");
                shop.setRatingAvg(Math.min(4.0 + (i * 0.3), 5.0));
                shop.setCreatedAt(LocalDate.now());
                shopRepository.save(shop);
            }
        }

        List<Shop> shops = shopRepository.findAll();
        for (Shop shop : shops) {
            List<Product> existingProducts = productRepository.findAllByShop_IdAndDeletedFalseOrderByUpdatedAtDesc(shop.getId());
            if (existingProducts.size() < 5) {
                for (int j = existingProducts.size() + 1; j <= 5; j++) {
                    Product product = new Product();
                    product.setShop(shop);
                    product.setName("Product " + j + " from " + shop.getDisplayName());
                    product.setDescription("Description for product " + j + " in " + shop.getDisplayName() + ". This is a detailed description.");
                    product.setPrice(50.0 + (j * 10.0));
                    product.setPriceMin(product.getPrice() - 10.0);
                    product.setPriceMax(product.getPrice() + 20.0);
                    product.setImageUrl("products/1/0ac95bd4-8e11-4d1d-b558-16bf3172a04e.webp");
                    List<String> imageUrls = new ArrayList<>();
                    imageUrls.add("products/1/0ac95bd4-8e11-4d1d-b558-16bf3172a04e.webp");
                    imageUrls.add("products/1/9b180d9c-cb0a-4e3f-a8fe-8de3c5348e3a.webp");
                    imageUrls.add("products/1/37d585b6-67fb-4e8a-b64a-377c0b16a62e.webp");
                    product.setImageUrls(imageUrls);
                    product.setStatus(Status.ACTIVE);
                    product.setDeleted(false);
                    product.setHasVariants(true);
                    product.setCreatedAt(LocalDateTime.now());
                    product.setUpdatedAt(LocalDateTime.now());
                    product.setCategories(new HashSet<>());

                    List<ProductVariant> variants = new ArrayList<>();
                    int numVariants = random.nextInt(3) + 2;
                    for (int k = 1; k <= numVariants; k++) {
                        ProductVariant variant = new ProductVariant();
                        variant.setProduct(product);
                        variant.setName("Variant " + k + " (e.g., Color/Size " + k + ")");
                        variant.setPrice(product.getPrice() + (k * 5.0));
                        variant.setImageUrl("products/1/62d3f33b-68b3-4978-b3e2-481931074ba7.webp");
                        variants.add(variant);
                    }
                    product.setVariants(variants);

                    productRepository.save(product);
                }
            }
        }
    }
}