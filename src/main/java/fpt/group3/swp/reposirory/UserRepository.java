package fpt.group3.swp.reposirory;

import fpt.group3.swp.common.Status;
import fpt.group3.swp.domain.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    User findById(long id);

    boolean existsByEmail(String email);

    boolean existsById(long id);

    User findByEmail(String email);

    User findByResetToken(String resetToken);

    boolean existsByEmailIgnoreCaseAndIdNot(String email, long id);

    Page<User> findAllByStatus(Status status, Pageable pageable);

    @Query("SELECT u FROM User u WHERE (:status IS NULL OR u.status = :status) " +
            "AND (:roleName IS NULL OR (u.role IS NOT NULL AND u.role.name = :roleName)) " +
            "AND ((:q IS NULL) OR (" +
            "     LOWER(COALESCE(u.fullName, '')) LIKE LOWER(CONCAT('%',:q,'%')) OR " +
            "     LOWER(COALESCE(u.email, '')) LIKE LOWER(CONCAT('%',:q,'%')) OR " +
            "     LOWER(COALESCE(u.phone, '')) LIKE LOWER(CONCAT('%',:q,'%')) " +
            ")) " +
            "AND (u.role IS NULL OR u.role.name NOT IN ('ADMIN','SUPER_ADMIN'))")
    Page<User> search(@Param("q") String q,
                      @Param("status") Status status,
                      @Param("roleName") String roleName,
                      Pageable pageable);
}
