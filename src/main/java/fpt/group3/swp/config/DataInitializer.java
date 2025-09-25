package fpt.group3.swp.config;

import fpt.group3.swp.domain.Role;
import fpt.group3.swp.reposirory.RoleRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer implements CommandLineRunner {
    
    private final RoleRepository roleRepository;
    
    public DataInitializer(RoleRepository roleRepository) {
        this.roleRepository = roleRepository;
    }
    
    @Override
    public void run(String... args) throws Exception {
        // Create default roles if they don't exist
        createRoleIfNotExists("USER");
        createRoleIfNotExists("ADMIN");
        createRoleIfNotExists("SELLER");
    }
    
    private void createRoleIfNotExists(String roleName) {
        Role existingRole = roleRepository.findByName(roleName).orElse(null);
        if (existingRole == null) {
            Role role = new Role();
            role.setName(roleName);
            role.setDescription("Default " + roleName + " role");
            roleRepository.save(role);
            System.out.println("Created role: " + roleName);
        }
    }
}