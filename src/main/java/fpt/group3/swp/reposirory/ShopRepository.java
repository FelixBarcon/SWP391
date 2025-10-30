package fpt.group3.swp.reposirory;

import fpt.group3.swp.common.VerifyStatus;
import fpt.group3.swp.domain.Shop;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface ShopRepository extends JpaRepository<Shop, Long>, JpaSpecificationExecutor<Shop> {
    Optional<Shop> findByUser_Id(Long userId);
    boolean existsByUser_Id(Long userId);
    boolean existsByDisplayNameIgnoreCase(String displayName);
    List<Shop> findAllByVerifyStatus(VerifyStatus status);
    Optional<Shop> findByUser_EmailIgnoreCase(String email);
    Optional<Shop> findByDisplayName(String exampleShop);
    
    // Lấy top shops đã verify, rating >= 4 sao, sắp xếp theo rating
    @Query("SELECT s FROM Shop s WHERE s.verifyStatus = 'VERIFIED' AND s.ratingAvg >= 4.0 ORDER BY s.ratingAvg DESC, s.id DESC")
    List<Shop> findTopShops(Pageable pageable);
    
    // Lấy tất cả shops có rating >= 4 sao (để test)
    @Query("SELECT s FROM Shop s WHERE s.ratingAvg >= 4.0 ORDER BY s.ratingAvg DESC, s.id DESC")
    List<Shop> findAllShopsSortedByRating(Pageable pageable);
}
