package fpt.group3.swp.reposirory;

import fpt.group3.swp.domain.Category;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CategoryRepository extends JpaRepository<Category, Long> {}