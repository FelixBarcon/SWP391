/**
 * JavaScript cho trang chủ - Marketplace
 * Xử lý tương tác người dùng và chức năng động
 */

document.addEventListener("DOMContentLoaded", function () {
  // Khởi tạo các chức năng
  initializeSearch();
  initializeProductCards();
  initializeNewsletterForm();
  initializeSmoothScrolling();
  initializeAnimations();

  // Xử lý tìm kiếm
  function initializeSearch() {
    const searchForm = document.getElementById("searchForm");
    const searchInput = document.getElementById("searchInput");
    const trendingKeywords = document.querySelectorAll(".trending-keyword");

    // Xử lý form tìm kiếm
    if (searchForm) {
      searchForm.addEventListener("submit", function (e) {
        e.preventDefault();
        const searchTerm = searchInput.value.trim();

        if (searchTerm) {
          performSearch(searchTerm);
        } else {
          showSearchError("Vui lòng nhập từ khóa tìm kiếm");
        }
      });
    }

    // Xử lý từ khóa trending
    trendingKeywords.forEach((keyword) => {
      keyword.addEventListener("click", function (e) {
        e.preventDefault();
        const searchTerm = this.textContent.trim();
        searchInput.value = searchTerm;
        performSearch(searchTerm);
      });
    });

    // Auto-complete cho tìm kiếm
    if (searchInput) {
      searchInput.addEventListener("input", function () {
        const value = this.value.trim();
        if (value.length >= 2) {
          // Có thể thêm auto-complete ở đây
          console.log("Searching for:", value);
        }
      });
    }
  }

  // Thực hiện tìm kiếm
  function performSearch(searchTerm) {
    console.log("Performing search for:", searchTerm);

    // Hiển thị loading
    showSearchLoading();

    // Simulate search API call
    setTimeout(() => {
      hideSearchLoading();
      // Redirect to search results page
      window.location.href = `/search?q=${encodeURIComponent(searchTerm)}`;
    }, 500);
  }

  // Hiển thị loading cho search
  function showSearchLoading() {
    const searchBtn = document.querySelector("#searchForm .btn");
    if (searchBtn) {
      searchBtn.innerHTML =
        '<i class="fas fa-spinner fa-spin"></i> Đang tìm...';
      searchBtn.disabled = true;
    }
  }

  // Ẩn loading cho search
  function hideSearchLoading() {
    const searchBtn = document.querySelector("#searchForm .btn");
    if (searchBtn) {
      searchBtn.innerHTML = '<i class="fas fa-search"></i>';
      searchBtn.disabled = false;
    }
  }

  // Hiển thị lỗi search
  function showSearchError(message) {
    const searchContainer = document.querySelector(".search-container");
    if (searchContainer) {
      // Remove existing error
      const existingError = searchContainer.querySelector(".search-error");
      if (existingError) {
        existingError.remove();
      }

      // Add new error
      const errorDiv = document.createElement("div");
      errorDiv.className = "search-error alert alert-danger mt-2";
      errorDiv.textContent = message;
      searchContainer.appendChild(errorDiv);

      // Auto remove after 3 seconds
      setTimeout(() => {
        errorDiv.remove();
      }, 3000);
    }
  }

  // Khởi tạo tương tác với product cards
  function initializeProductCards() {
    const productCards = document.querySelectorAll(".product-card");
    const addToCartBtns = document.querySelectorAll(".add-to-cart");

    // Xử lý click vào product card
    productCards.forEach((card) => {
      card.addEventListener("click", function (e) {
        // Không xử lý nếu click vào button
        if (
          e.target.classList.contains("add-to-cart") ||
          e.target.closest(".add-to-cart")
        ) {
          return;
        }

        // // Redirect to product detail page
        // const productId = this.dataset.productId;
        // if (productId) {
        //   window.location.href = `/product/${productId}`;
        // } else {
        //   console.log("Product clicked:", this);
        //   // Temporary - show alert for demo
        //   alert("Chức năng xem chi tiết sản phẩm đang được phát triển");
        // }
      });
    });

    // Xử lý nút thêm vào giỏ hàng
    addToCartBtns.forEach((btn) => {
      btn.addEventListener("click", function (e) {
        e.stopPropagation();
        e.preventDefault();

        const productCard = this.closest(".product-card");
        const productName =
          productCard.querySelector(".product-name").textContent;

        addToCart(productCard, productName);
      });
    });
  }

  // Thêm sản phẩm vào giỏ hàng
  function addToCart(productCard, productName) {
    const btn = productCard.querySelector(".add-to-cart");
    const originalText = btn.innerHTML;

    // Hiển thị loading
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang thêm...';
    btn.disabled = true;

    // Simulate API call
    setTimeout(() => {
      // Success animation
      btn.innerHTML = '<i class="fas fa-check"></i> Đã thêm!';
      btn.classList.add("btn-success");
      btn.classList.remove("btn-primary");

      // Show success message
      showAddToCartSuccess(productName);

      // Reset button after 2 seconds
      setTimeout(() => {
        btn.innerHTML = originalText;
        btn.classList.remove("btn-success");
        btn.classList.add("btn-primary");
        btn.disabled = false;
      }, 2000);
    }, 800);
  }

  // Hiển thị thông báo thêm giỏ hàng thành công
  function showAddToCartSuccess(productName) {
    // Create toast notification
    const toast = document.createElement("div");
    toast.className = "position-fixed top-0 end-0 p-3";
    toast.style.zIndex = "9999";
    toast.innerHTML = `
            <div class="toast show" role="alert">
                <div class="toast-header bg-success text-white">
                    <i class="fas fa-check-circle me-2"></i>
                    <strong class="me-auto">Thành công</strong>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"></button>
                </div>
                <div class="toast-body">
                    Đã thêm "${productName}" vào giỏ hàng
                </div>
            </div>
        `;

    document.body.appendChild(toast);

    // Auto remove after 4 seconds
    setTimeout(() => {
      toast.remove();
    }, 4000);

    // Handle close button
    const closeBtn = toast.querySelector(".btn-close");
    if (closeBtn) {
      closeBtn.addEventListener("click", () => {
        toast.remove();
      });
    }
  }

  // Khởi tạo newsletter form
  function initializeNewsletterForm() {
    const newsletterForm = document.getElementById("newsletterForm");
    const emailInput = document.getElementById("emailInput");

    if (newsletterForm) {
      newsletterForm.addEventListener("submit", function (e) {
        e.preventDefault();

        const email = emailInput.value.trim();

        if (validateEmail(email)) {
          subscribeNewsletter(email);
        } else {
          showNewsletterError("Vui lòng nhập email hợp lệ");
        }
      });
    }
  }

  // Validate email
  function validateEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  // Đăng ký newsletter
  function subscribeNewsletter(email) {
    const btn = document.querySelector("#newsletterForm .btn");
    const originalText = btn.innerHTML;

    // Show loading
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
    btn.disabled = true;

    // Simulate API call
    setTimeout(() => {
      // Success
      btn.innerHTML = '<i class="fas fa-check"></i> Đã đăng ký!';
      btn.classList.add("btn-success");

      showNewsletterSuccess("Cảm ơn bạn đã đăng ký nhận tin tức!");

      // Reset form
      document.getElementById("emailInput").value = "";

      // Reset button after 3 seconds
      setTimeout(() => {
        btn.innerHTML = originalText;
        btn.classList.remove("btn-success");
        btn.disabled = false;
      }, 3000);
    }, 1000);
  }

  // Hiển thị lỗi newsletter
  function showNewsletterError(message) {
    showNewsletterMessage(message, "danger");
  }

  // Hiển thị thành công newsletter
  function showNewsletterSuccess(message) {
    showNewsletterMessage(message, "success");
  }

  // Hiển thị thông báo newsletter
  function showNewsletterMessage(message, type) {
    const newsletterSection = document.querySelector(".newsletter-section");
    if (newsletterSection) {
      // Remove existing message
      const existingMessage = newsletterSection.querySelector(
        ".newsletter-message"
      );
      if (existingMessage) {
        existingMessage.remove();
      }

      // Add new message
      const messageDiv = document.createElement("div");
      messageDiv.className = `newsletter-message alert alert-${type} mt-3 mx-auto`;
      messageDiv.style.maxWidth = "400px";
      messageDiv.textContent = message;

      const container = newsletterSection.querySelector(".container");
      container.appendChild(messageDiv);

      // Auto remove after 4 seconds
      setTimeout(() => {
        messageDiv.remove();
      }, 4000);
    }
  }

  // Khởi tạo smooth scrolling
  function initializeSmoothScrolling() {
    const anchors = document.querySelectorAll('a[href^="#"]');

    anchors.forEach((anchor) => {
      anchor.addEventListener("click", function (e) {
        e.preventDefault();

        const targetId = this.getAttribute("href").substring(1);
        const targetElement = document.getElementById(targetId);

        if (targetElement) {
          targetElement.scrollIntoView({
            behavior: "smooth",
            block: "start",
          });
        }
      });
    });
  }

  // Khởi tạo animations khi scroll
  function initializeAnimations() {
    const observerOptions = {
      threshold: 0.1,
      rootMargin: "0px 0px -50px 0px",
    };

    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add("animate-in");
        }
      });
    }, observerOptions);

    // Observe elements for animation
    const animateElements = document.querySelectorAll(
      ".category-card, .product-card, .feature-card"
    );
    animateElements.forEach((el) => {
      observer.observe(el);
    });
  }

  // Xử lý category clicks
  const categoryCards = document.querySelectorAll(".category-card");
  categoryCards.forEach((card) => {
    card.addEventListener("click", function () {
      const categoryName = this.querySelector(".category-name").textContent;
      console.log("Category clicked:", categoryName);

      // Redirect to category page
      const categorySlug = categoryName.toLowerCase().replace(/\s+/g, "-");
      // window.location.href = `/category/${categorySlug}`;

      // Temporary - show alert for demo
      alert(`Chức năng danh mục "${categoryName}" đang được phát triển`);
    });
  });

  // Thêm CSS animations
  const style = document.createElement("style");
  style.textContent = `
        .animate-in {
            animation: fadeInUp 0.6s ease forwards;
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .category-card, .product-card, .feature-card {
            opacity: 0;
            transform: translateY(30px);
            transition: all 0.6s ease;
        }
        
        .category-card.animate-in, 
        .product-card.animate-in, 
        .feature-card.animate-in {
            opacity: 1;
            transform: translateY(0);
        }
    `;
  document.head.appendChild(style);
});

// Utility functions
function formatPrice(price) {
  return new Intl.NumberFormat("vi-VN", {
    style: "currency",
    currency: "VND",
  }).format(price);
}

function formatNumber(number) {
  return new Intl.NumberFormat("vi-VN").format(number);
}

// Export functions for external use
window.HomepageUtils = {
  formatPrice,
  formatNumber,
};

// ========== PRODUCT CARD INTERACTIONS ==========
// Xử lý nút yêu thích
document.addEventListener("DOMContentLoaded", function () {
  const favoriteButtons = document.querySelectorAll(
    '.action-btn[title="Yêu thích"]'
  );

  favoriteButtons.forEach((button) => {
    button.addEventListener("click", function (e) {
      e.preventDefault();
      e.stopPropagation();

      const icon = this.querySelector("i");
      const isFavorited = icon.classList.contains("fas");

      if (isFavorited) {
        // Bỏ yêu thích
        icon.classList.remove("fas");
        icon.classList.add("far");
        showNotification("Đã bỏ khỏi danh sách yêu thích", "info");
      } else {
        // Thêm yêu thích
        icon.classList.remove("far");
        icon.classList.add("fas");
        this.style.animation = "heartBeat 0.5s ease";
        setTimeout(() => {
          this.style.animation = "";
        }, 500);
        showNotification("Đã thêm vào danh sách yêu thích", "success");
      }
    });
  });
});

// Hàm hiển thị thông báo
function showNotification(message, type = "info") {
  const existing = document.querySelector(".homepage-notification");
  if (existing) existing.remove();

  const notification = document.createElement("div");
  notification.className = `homepage-notification notification-${type}`;

  const icons = {
    success: "check-circle",
    info: "info-circle",
    warning: "exclamation-triangle",
  };

  notification.innerHTML = `
    <i class="fas fa-${icons[type] || icons.info}"></i>
    <span>${message}</span>
  `;

  document.body.appendChild(notification);

  setTimeout(() => notification.classList.add("show"), 10);

  setTimeout(() => {
    notification.classList.remove("show");
    setTimeout(() => notification.remove(), 300);
  }, 2500);
}

// Thêm CSS cho thông báo và animation
const notificationStyle = document.createElement("style");
notificationStyle.textContent = `
  .homepage-notification {
    position: fixed;
    top: 80px;
    right: -300px;
    background: white;
    padding: 14px 18px;
    border-radius: 8px;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
    display: flex;
    align-items: center;
    gap: 10px;
    z-index: 10000;
    transition: right 0.3s ease;
    min-width: 250px;
    border-left: 4px solid;
  }
  
  .homepage-notification.show {
    right: 20px;
  }
  
  .homepage-notification i {
    font-size: 18px;
  }
  
  .notification-success {
    border-left-color: #00c853;
  }
  
  .notification-success i {
    color: #00c853;
  }
  
  .notification-info {
    border-left-color: #2196f3;
  }
  
  .notification-info i {
    color: #2196f3;
  }
  
  .notification-warning {
    border-left-color: #ff9800;
  }
  
  .notification-warning i {
    color: #ff9800;
  }
  
  .homepage-notification span {
    font-size: 14px;
    font-weight: 500;
    color: #333;
  }
  
  @keyframes heartBeat {
    0%, 100% {
      transform: scale(1);
    }
    25% {
      transform: scale(1.2);
    }
    50% {
      transform: scale(1);
    }
    75% {
      transform: scale(1.15);
    }
  }
  
  @media (max-width: 768px) {
    .homepage-notification {
      right: -100%;
      min-width: auto;
      max-width: calc(100% - 40px);
    }
    
    .homepage-notification.show {
      right: 20px;
    }
  }
`;
document.head.appendChild(notificationStyle);
