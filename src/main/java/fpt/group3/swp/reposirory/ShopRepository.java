package fpt.group3.swp.reposirory;

import fpt.group3.swp.common.VerifyStatus;
import fpt.group3.swp.domain.Shop;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ShopRepository extends JpaRepository<Shop, Long> {
    Optional<Shop> findByUser_Id(Long userId);
    boolean existsByUser_Id(Long userId);
    boolean existsByDisplayNameIgnoreCase(String displayName);
    List<Shop> findAllByVerifyStatus(VerifyStatus status);
}