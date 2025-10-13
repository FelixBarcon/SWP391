// Product List Page JavaScript
console.log("📦 product-list.js loaded");

// Initialize when DOM is ready
function initProductList() {
  console.log("🚀 Initializing Product List Page...");

  initQuickAddToCart();
  initCardAnimations();
  initLazyLoading();

  console.log("✅ Product List Page Initialized");
}

// Check DOM ready state
if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initProductList);
} else {
  setTimeout(initProductList, 50);
}

// ========== QUICK ADD TO CART ==========
function initQuickAddToCart() {
  const addToCartForms = document.querySelectorAll(".quick-add-cart-form");

  addToCartForms.forEach((form) => {
    form.addEventListener("submit", function (e) {
      e.preventDefault();
      e.stopPropagation();

      const submitBtn = this.querySelector('button[type="submit"]');
      const originalText = submitBtn.innerHTML;

      // Show loading
      submitBtn.disabled = true;
      submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';

      // Submit via AJAX
      fetch(this.action, {
        method: "POST",
        body: new FormData(this),
      })
        .then((response) => {
          if (response.ok) {
            showNotification("✓ Đã thêm vào giỏ hàng!", "success");
            updateCartCount();

            // Animate button
            submitBtn.innerHTML = '<i class="fas fa-check"></i>';
            setTimeout(() => {
              submitBtn.innerHTML = originalText;
              submitBtn.disabled = false;
            }, 1500);
          } else {
            showNotification("Có lỗi xảy ra. Vui lòng thử lại!", "error");
            submitBtn.innerHTML = originalText;
            submitBtn.disabled = false;
          }
        })
        .catch((error) => {
          console.error("Error:", error);
          showNotification("Có lỗi xảy ra. Vui lòng thử lại!", "error");
          submitBtn.innerHTML = originalText;
          submitBtn.disabled = false;
        });
    });
  });
}

// ========== CARD ANIMATIONS ==========
function initCardAnimations() {
  const cards = document.querySelectorAll(".product-card");

  // Intersection Observer for fade-in animation
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry, index) => {
        if (entry.isIntersecting) {
          setTimeout(() => {
            entry.target.style.opacity = "1";
            entry.target.style.transform = "translateY(0)";
          }, index * 50); // Stagger animation
          observer.unobserve(entry.target);
        }
      });
    },
    {
      threshold: 0.1,
    }
  );

  cards.forEach((card) => {
    card.style.opacity = "0";
    card.style.transform = "translateY(20px)";
    card.style.transition = "opacity 0.4s, transform 0.4s";
    observer.observe(card);
  });
}

// ========== LAZY LOADING IMAGES ==========
function initLazyLoading() {
  const images = document.querySelectorAll("img[data-src]");

  const imageObserver = new IntersectionObserver((entries, observer) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        const img = entry.target;
        img.src = img.dataset.src;
        img.removeAttribute("data-src");
        observer.unobserve(img);
      }
    });
  });

  images.forEach((img) => imageObserver.observe(img));
}

// ========== NOTIFICATION ==========
function showNotification(message, type = "success") {
  // Remove existing notification
  const existing = document.querySelector(".notification-toast");
  if (existing) existing.remove();

  const toast = document.createElement("div");
  toast.className = `notification-toast ${type}`;

  const icon = type === "success" ? "✓" : type === "warning" ? "⚠" : "✗";
  toast.innerHTML = `
    <div class="toast-icon">${icon}</div>
    <div class="toast-message">${message}</div>
  `;

  document.body.appendChild(toast);

  setTimeout(() => toast.classList.add("show"), 100);

  setTimeout(() => {
    toast.classList.remove("show");
    setTimeout(() => toast.remove(), 400);
  }, 3000);
}

// ========== UPDATE CART COUNT ==========
function updateCartCount() {
  // Use global function from header.jsp if available (accurate count from server)
  if (typeof window.updateCartBadge === "function") {
    window.updateCartBadge();
  } else {
    // Fallback: simple increment
    const cartCount = document.querySelector(".cart-count");
    if (cartCount) {
      const current = parseInt(cartCount.textContent) || 0;
      cartCount.textContent = current + 1;

      // Animate cart icon
      const cartIcon = document.querySelector(".cart-icon");
      if (cartIcon) {
        cartIcon.style.transform = "scale(1.2)";
        setTimeout(() => {
          cartIcon.style.transform = "scale(1)";
        }, 300);
      }
    }
  }
}

// Add notification styles dynamically
(function () {
  if (document.getElementById("product-list-toast-styles")) return;

  const toastStyle = document.createElement("style");
  toastStyle.id = "product-list-toast-styles";
  toastStyle.textContent = `
    .notification-toast {
      position: fixed;
      top: 80px;
      right: -350px;
      background: white;
      padding: 16px 20px;
      border-radius: 8px;
      box-shadow: 0 4px 16px rgba(0, 0, 0, 0.2);
      display: flex;
      align-items: center;
      gap: 12px;
      z-index: 10000;
      transition: right 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
      max-width: 320px;
      min-width: 280px;
      border-left: 4px solid;
    }

    .notification-toast.show {
      right: 20px;
    }

    .notification-toast.success {
      border-left-color: #4caf50;
    }

    .notification-toast.error {
      border-left-color: #f44336;
    }

    .notification-toast.warning {
      border-left-color: #ff9800;
    }

    .toast-icon {
      width: 32px;
      height: 32px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 18px;
      font-weight: bold;
      flex-shrink: 0;
    }

    .notification-toast.success .toast-icon {
      background: #4caf50;
      color: white;
    }

    .notification-toast.error .toast-icon {
      background: #f44336;
      color: white;
    }

    .notification-toast.warning .toast-icon {
      background: #ff9800;
      color: white;
    }

    .toast-message {
      flex: 1;
      font-size: 14px;
      color: #333;
      font-weight: 500;
    }

    @media (max-width: 768px) {
      .notification-toast {
        top: 60px;
        right: -100%;
        max-width: calc(100% - 40px);
        min-width: auto;
      }
      
      .notification-toast.show {
        right: 20px;
      }
    }
  `;
  document.head.appendChild(toastStyle);
})();
