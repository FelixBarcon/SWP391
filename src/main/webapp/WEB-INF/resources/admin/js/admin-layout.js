/**
 * JavaScript cho Admin Layout - Marketplace
 * Xử lý sidebar toggle, dropdown menus, mobile responsive
 */

document.addEventListener("DOMContentLoaded", function () {
  // Khởi tạo các chức năng admin
  initializeSidebar();
  initializeHeader();
  initializeDropdowns();
  initializeMobileMenu();
  initializeSearch();
  initializeSubmenu();

  // ===== SIDEBAR FUNCTIONALITY =====
  function initializeSidebar() {
    // Active menu highlighting
    highlightActiveMenu();
  }

  // ===== HEADER FUNCTIONALITY =====
  function initializeHeader() {
    // Settings button animation
    const settingsBtn = document.getElementById("settingsBtn");
    if (settingsBtn) {
      settingsBtn.addEventListener("click", function () {
        // Add rotation animation or open settings modal
        console.log("Settings clicked");
      });
    }

    // Notifications
    const notificationBtn = document.getElementById("notificationBtn");
    if (notificationBtn) {
      notificationBtn.addEventListener("click", function () {
        // Handle notifications dropdown
        console.log("Notifications clicked");
      });
    }
  }

  // ===== DROPDOWN FUNCTIONALITY =====
  function initializeDropdowns() {
    const userDropdown = document.getElementById("userDropdown");
    const userBtn = document.getElementById("userBtn");
    const userDropdownMenu = document.getElementById("userDropdownMenu");

    if (userBtn && userDropdownMenu && userDropdown) {
      // Toggle user dropdown
      userBtn.addEventListener("click", function (e) {
        e.stopPropagation();
        userDropdown.classList.toggle("show");
        userDropdownMenu.classList.toggle("show");
      });

      // Close dropdown when clicking outside
      document.addEventListener("click", function (e) {
        if (!userDropdown.contains(e.target)) {
          userDropdown.classList.remove("show");
          userDropdownMenu.classList.remove("show");
        }
      });

      // Prevent dropdown from closing when clicking inside
      userDropdownMenu.addEventListener("click", function (e) {
        e.stopPropagation();
      });
    }
  }

  // ===== MOBILE MENU FUNCTIONALITY =====
  function initializeMobileMenu() {
    const mobileMenuBtn = document.getElementById("mobileMenuBtn");
    const sidebar = document.getElementById("adminSidebar");
    const mobileOverlay = document.getElementById("mobileMenuOverlay");

    if (mobileMenuBtn && sidebar && mobileOverlay) {
      // Open mobile menu
      mobileMenuBtn.addEventListener("click", function () {
        sidebar.classList.add("mobile-open");
        mobileOverlay.classList.add("show");
        document.body.style.overflow = "hidden";
      });

      // Close mobile menu
      mobileOverlay.addEventListener("click", function () {
        closeMobileMenu();
      });

      // Close on escape key
      document.addEventListener("keydown", function (e) {
        if (e.key === "Escape") {
          closeMobileMenu();
        }
      });
    }

    function closeMobileMenu() {
      if (sidebar && mobileOverlay) {
        sidebar.classList.remove("mobile-open");
        mobileOverlay.classList.remove("show");
        document.body.style.overflow = "";
      }
    }
  }

  // ===== SEARCH FUNCTIONALITY =====
  function initializeSearch() {
    const searchInput = document.getElementById("adminSearch");
    const searchBtn = document.querySelector(".search-btn");

    if (searchInput) {
      // Handle search on enter key
      searchInput.addEventListener("keypress", function (e) {
        if (e.key === "Enter") {
          performSearch(this.value);
        }
      });

      // Handle search input changes
      searchInput.addEventListener("input", function () {
        // Real-time search suggestions could go here
        debounce(handleSearchInput, 300)(this.value);
      });
    }

    if (searchBtn) {
      searchBtn.addEventListener("click", function () {
        const query = searchInput.value.trim();
        if (query) {
          performSearch(query);
        }
      });
    }

    function performSearch(query) {
      console.log("Searching for:", query);
      // Implement actual search functionality
      // Could redirect to search results page or show dropdown results
    }

    function handleSearchInput(value) {
      if (value.length >= 2) {
        // Show search suggestions
        console.log("Search suggestions for:", value);
      }
    }
  }

  // ===== SUBMENU FUNCTIONALITY =====
  function initializeSubmenu() {
    const submenuLinks = document.querySelectorAll("[data-submenu]");

    submenuLinks.forEach(function (link) {
      link.addEventListener("click", function (e) {
        e.preventDefault();

        const submenuId = "submenu-" + this.getAttribute("data-submenu");
        const submenu = document.getElementById(submenuId);
        const toggle = this.querySelector(".nav-submenu-toggle");

        if (submenu && toggle) {
          // Toggle submenu
          submenu.classList.toggle("show");
          toggle.classList.toggle("rotated");

          // Close other submenus
          submenuLinks.forEach(function (otherLink) {
            if (otherLink !== link) {
              const otherSubmenuId =
                "submenu-" + otherLink.getAttribute("data-submenu");
              const otherSubmenu = document.getElementById(otherSubmenuId);
              const otherToggle = otherLink.querySelector(
                ".nav-submenu-toggle"
              );

              if (otherSubmenu && otherToggle) {
                otherSubmenu.classList.remove("show");
                otherToggle.classList.remove("rotated");
              }
            }
          });
        }
      });
    });
  }

  // ===== ACTIVE MENU HIGHLIGHTING =====
  function highlightActiveMenu() {
    const currentPath = window.location.pathname;
    const navLinks = document.querySelectorAll(".nav-link");

    // Xóa active class từ tất cả các links trước
    navLinks.forEach((link) => link.classList.remove("active"));

    // Tìm link phù hợp nhất với current path
    let bestMatch = null;
    let bestMatchLength = 0;

    navLinks.forEach(function (link) {
      const href = link.getAttribute("href");
      if (!href || href === "#") return;

      // Chuẩn hóa href (bỏ contextPath nếu có)
      let cleanHref = href;
      if (cleanHref.startsWith("/")) {
        cleanHref = cleanHref.substring(1);
      }
      if (cleanHref.includes(";")) {
        cleanHref = cleanHref.split(";")[0];
      }

      // So sánh với current path
      if (
        currentPath.includes(cleanHref) &&
        cleanHref.length > bestMatchLength
      ) {
        bestMatch = link;
        bestMatchLength = cleanHref.length;
      }
    });

    // Đánh dấu link phù hợp nhất là active
    if (bestMatch) {
      bestMatch.classList.add("active");

      // Nếu link nằm trong submenu, mở submenu đó
      const submenuItem = bestMatch.closest(".nav-submenu");
      if (submenuItem) {
        const parentSubmenu = submenuItem.previousElementSibling;
        if (parentSubmenu && parentSubmenu.hasAttribute("data-submenu")) {
          const submenuId =
            "submenu-" + parentSubmenu.getAttribute("data-submenu");
          const submenu = document.getElementById(submenuId);
          const toggle = parentSubmenu.querySelector(".nav-submenu-toggle");

          if (submenu && toggle) {
            submenu.classList.add("show");
            toggle.classList.add("rotated");
          }
        }
      }
    }
  }

  // ===== UTILITY FUNCTIONS =====
  function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
      const later = () => {
        clearTimeout(timeout);
        func(...args);
      };
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
    };
  }

  // ===== WINDOW RESIZE HANDLER =====
  window.addEventListener("resize", function () {
    const sidebar = document.getElementById("adminSidebar");
    const mobileOverlay = document.getElementById("mobileMenuOverlay");

    // Close mobile menu on resize to desktop
    if (window.innerWidth > 768) {
      if (sidebar) sidebar.classList.remove("mobile-open");
      if (mobileOverlay) mobileOverlay.classList.remove("show");
      document.body.style.overflow = "";
    }
  });

  // ===== KEYBOARD SHORTCUTS =====
  document.addEventListener("keydown", function (e) {
    // Ctrl/Cmd + K for search focus
    if ((e.ctrlKey || e.metaKey) && e.key === "k") {
      e.preventDefault();
      const searchInput = document.getElementById("adminSearch");
      if (searchInput) {
        searchInput.focus();
        searchInput.select();
      }
    }

    // Ctrl/Cmd + B for sidebar toggle
    if ((e.ctrlKey || e.metaKey) && e.key === "b") {
      e.preventDefault();
      const sidebarToggle = document.getElementById("sidebarToggle");
      if (sidebarToggle) {
        sidebarToggle.click();
      }
    }
  });

  // ===== TOOLTIPS (Optional enhancement) =====
  function initializeTooltips() {
    const tooltipElements = document.querySelectorAll("[title]");

    tooltipElements.forEach(function (element) {
      element.addEventListener("mouseenter", function () {
        // Show tooltip
      });

      element.addEventListener("mouseleave", function () {
        // Hide tooltip
      });
    });
  }

  // Initialize tooltips
  initializeTooltips();

  console.log("Admin layout initialized successfully!");
});
