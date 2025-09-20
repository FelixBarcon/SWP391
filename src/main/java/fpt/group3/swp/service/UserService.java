package fpt.group3.swp.service;

import fpt.group3.swp.domain.User;
import fpt.group3.swp.reposirory.UserRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {
    private final UserRepository userRepository;
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }
    public List<User> getAllUser() {
        return this.userRepository.findAll();
    }

    public User getUserById(long id) {
        return this.userRepository.findById(id);
    }

    public List<User> getAllUserByEmail(String email) {
        return this.userRepository.findByEmail(email);
    }

    public User handleSaveUser(User user) {
        return this.userRepository.save(user);
    }

    public boolean checkEmailExist(String email) {
        List<User> users = this.userRepository.findByEmail(email);
        return !users.isEmpty();
    }

    public void deleteAUser(long id) {
        this.userRepository.deleteById(id);
    }
}
