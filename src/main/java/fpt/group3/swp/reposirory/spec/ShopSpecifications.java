package fpt.group3.swp.reposirory.spec;

import fpt.group3.swp.common.Status;
import fpt.group3.swp.common.VerifyStatus;
import fpt.group3.swp.domain.Shop;
import fpt.group3.swp.domain.User;
import jakarta.persistence.criteria.Join;
import jakarta.persistence.criteria.JoinType;
import org.springframework.data.jpa.domain.Specification;

public class ShopSpecifications {

    public static Specification<Shop> search(String q) {
        if (q == null || q.trim().isEmpty()) return null;
        final String like = "%" + q.trim() + "%";
        return (root, query, cb) -> {
            Join<Shop, User> user = root.join("user", JoinType.LEFT);
            return cb.or(
                    cb.like(cb.lower(cb.coalesce(root.get("displayName"), "")), like.toLowerCase()),
                    cb.like(cb.lower(cb.coalesce(user.get("email"), "")), like.toLowerCase()),
                    cb.like(cb.lower(cb.coalesce(user.get("fullName"), "")), like.toLowerCase())
            );
        };
    }

    public static Specification<Shop> verifyStatus(VerifyStatus status) {
        if (status == null) return null;
        return (root, query, cb) -> cb.equal(root.get("verifyStatus"), status);
    }

    public static Specification<Shop> userStatus(Status st) {
        if (st == null) return null;
        return (root, query, cb) -> cb.equal(root.join("user", JoinType.INNER).get("status"), st);
    }
}

