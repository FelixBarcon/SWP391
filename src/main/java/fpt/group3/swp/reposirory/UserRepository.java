package fpt.group3.swp.reposirory;

import java.util.List;

import fpt.group3.swp.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    User findById(long id);

    boolean existsByEmail(String email);

    User findByEmail(String email);

    User findByResetToken(String resetToken);
}