/**
 * Seller Sidebar Navigation
 * Handles submenu toggle functionality and mobile menu
 */

document.addEventListener("DOMContentLoaded", function () {
  initializeSubmenuToggle();
  setActiveMenu();
  initializeMobileMenu();
});

/**
 * Initialize mobile menu functionality
 */
function initializeMobileMenu() {
  const mobileToggle = document.getElementById("mobileMenuToggle");
  const sidebar = document.querySelector(".seller-sidebar");
  const mobileOverlay = document.getElementById("mobileOverlay");

  if (mobileToggle && sidebar) {
    mobileToggle.addEventListener("click", function () {
      sidebar.classList.toggle("show");
      document.body.classList.toggle("sidebar-open");

      // Create overlay if it doesn't exist
      if (!mobileOverlay) {
        const overlay = document.createElement("div");
        overlay.className = "mobile-overlay";
        overlay.id = "mobileOverlay";
        document.body.appendChild(overlay);

        overlay.addEventListener("click", function () {
          closeMobileMenu();
        });
      }
    });
  }

  // Close menu when clicking outside
  document.addEventListener("click", function (e) {
    if (window.innerWidth <= 768) {
      const isClickInsideSidebar = sidebar && sidebar.contains(e.target);
      const isClickOnToggle = mobileToggle && mobileToggle.contains(e.target);

      if (
        !isClickInsideSidebar &&
        !isClickOnToggle &&
        sidebar &&
        sidebar.classList.contains("show")
      ) {
        closeMobileMenu();
      }
    }
  });

  // Handle window resize
  window.addEventListener("resize", function () {
    if (window.innerWidth > 768) {
      closeMobileMenu();
    }
  });
}

/**
 * Close mobile menu
 */
function closeMobileMenu() {
  const sidebar = document.querySelector(".seller-sidebar");
  const overlay = document.getElementById("mobileOverlay");

  if (sidebar) {
    sidebar.classList.remove("show");
  }

  document.body.classList.remove("sidebar-open");

  if (overlay) {
    overlay.remove();
  }
}

/**
 * Initialize submenu toggle functionality
 */
function initializeSubmenuToggle() {
  const submenuToggles = document.querySelectorAll(".submenu-toggle");

  submenuToggles.forEach((toggle) => {
    toggle.addEventListener("click", function (e) {
      e.preventDefault();

      const navItem = this.closest(".nav-item.has-submenu");
      const submenu = navItem.querySelector(".submenu");

      // Toggle active class
      navItem.classList.toggle("active");

      // Close other submenus
      document.querySelectorAll(".nav-item.has-submenu").forEach((item) => {
        if (item !== navItem) {
          item.classList.remove("active");
        }
      });
    });
  });
}

/**
 * Set active menu based on current page
 */
function setActiveMenu() {
  const currentPath = window.location.pathname;

  // Remove all active classes first
  document.querySelectorAll(".nav-link.active").forEach((link) => {
    link.classList.remove("active");
  });

  document.querySelectorAll(".submenu-link.active").forEach((link) => {
    link.classList.remove("active");
  });

  document.querySelectorAll(".nav-item.has-submenu.active").forEach((item) => {
    item.classList.remove("active");
  });

  // Check if we're on a products page
  if (currentPath.includes("/seller/products")) {
    const productNavItem = document.querySelector(".nav-item.has-submenu");
    if (productNavItem) {
      productNavItem.classList.add("active");

      // Set active submenu item
      const submenuLinks = productNavItem.querySelectorAll(".submenu-link");
      submenuLinks.forEach((link) => {
        const href = link.getAttribute("href");
        if (href) {
          // More precise matching for product pages
          if (
            (currentPath.includes("/products/create") &&
              href.includes("/products/create")) ||
            (currentPath.includes("/products/list") &&
              href.includes("/products/list")) ||
            (currentPath.includes("/products") &&
              !currentPath.includes("/products/create") &&
              !currentPath.includes("/products/list") &&
              href.includes("/products") &&
              !href.includes("/products/create"))
          ) {
            link.classList.add("active");
          }
        }
      });
    }
  } else if (
    currentPath === "/seller" ||
    currentPath.includes("/seller/dashboard")
  ) {
    // Dashboard page - this should only be active on dashboard
    const dashboardLink = document.querySelector(".nav-link[href*='/seller']");
    if (dashboardLink && !dashboardLink.closest(".submenu")) {
      dashboardLink.classList.add("active");
    }
  }
}

/**
 * Mobile menu toggle (if needed)
 */
function toggleMobileMenu() {
  const sidebar = document.getElementById("sellerSidebar");
  const overlay = document.getElementById("mobileMenuOverlay");

  if (sidebar && overlay) {
    sidebar.classList.toggle("show");
    overlay.classList.toggle("show");
  }
}

// Export functions for external use
window.SellerSidebar = {
  toggleMobileMenu: toggleMobileMenu,
};
