// Product Detail Page JavaScript - Shopee Style
console.log("📦 product-detail.js file loaded");

// Sử dụng function này để đảm bảo chạy dù DOMContentLoaded đã fired hay chưa
function initProductDetail() {
  console.log("🚀 Initializing Product Detail Page...");
  console.log("Document ready state:", document.readyState);
  console.log("Timestamp:", new Date().toISOString());

  initImageCarousel();
  initQuantityControl();
  initVariantSelection();
  initAddToCart();

  console.log("✅ Product Detail Page Initialized Successfully");
}

// Kiểm tra nếu DOM đã ready thì chạy ngay, nếu không thì đợi DOMContentLoaded
console.log("Checking document state:", document.readyState);

if (document.readyState === "loading") {
  // DOM chưa ready, đợi event
  console.log("⏳ Waiting for DOMContentLoaded...");
  document.addEventListener("DOMContentLoaded", initProductDetail);
} else {
  // DOM đã ready, nhưng chờ thêm 50ms để đảm bảo tất cả đã render
  console.log("✅ DOM already ready, initializing after short delay...");
  setTimeout(initProductDetail, 50);
}

// ========== IMAGE CAROUSEL ==========
function initImageCarousel() {
  console.log("📸 Initializing Image Carousel...");
  const carousel = document.getElementById("imageCarousel");
  if (!carousel) {
    console.warn("⚠️ Carousel element not found");
    return;
  }

  const track = carousel.querySelector(".carousel-track");
  const slides = carousel.querySelectorAll(".carousel-slide");
  const prevBtn = carousel.querySelector(".carousel-nav.prev");
  const nextBtn = carousel.querySelector(".carousel-nav.next");
  const thumbnails = document.querySelectorAll(".thumbnail");

  let currentIndex = 0;
  const totalSlides = slides.length;

  // Tìm index của ảnh đại diện (ảnh có data-is-main="true")
  const mainImageIndex = Array.from(slides).findIndex(
    (slide) => slide.dataset.isMain === "true"
  );

  // Nếu tìm thấy ảnh đại diện, set làm currentIndex ban đầu
  if (mainImageIndex !== -1) {
    currentIndex = mainImageIndex;
  }

  // Go to specific slide
  function goToSlide(index) {
    if (index < 0 || index >= totalSlides) return;

    currentIndex = index;
    const offset = -currentIndex * 100;
    track.style.transform = `translateX(${offset}%)`;

    // Update navigation buttons
    prevBtn.disabled = currentIndex === 0;
    nextBtn.disabled = currentIndex === totalSlides - 1;

    // Update active thumbnail
    thumbnails.forEach((thumb, i) => {
      thumb.classList.toggle("active", i === currentIndex);
    });
  }

  // Initialize: Go to main image or first slide
  goToSlide(currentIndex);

  // Previous slide
  prevBtn.addEventListener("click", () => {
    goToSlide(currentIndex - 1);
  });

  // Next slide
  nextBtn.addEventListener("click", () => {
    goToSlide(currentIndex + 1);
  });

  // Thumbnail click
  thumbnails.forEach((thumb, index) => {
    thumb.addEventListener("click", () => {
      goToSlide(index);
    });
  });

  // Keyboard navigation
  document.addEventListener("keydown", (e) => {
    if (e.key === "ArrowLeft") goToSlide(currentIndex - 1);
    if (e.key === "ArrowRight") goToSlide(currentIndex + 1);
  });

  // Touch/Swipe support
  let touchStartX = 0;
  let touchEndX = 0;

  carousel.addEventListener(
    "touchstart",
    (e) => {
      touchStartX = e.touches[0].clientX;
    },
    { passive: true }
  );

  carousel.addEventListener(
    "touchmove",
    (e) => {
      touchEndX = e.touches[0].clientX;
    },
    { passive: true }
  );

  carousel.addEventListener("touchend", () => {
    const diff = touchStartX - touchEndX;
    if (Math.abs(diff) > 50) {
      // Minimum swipe distance
      if (diff > 0) {
        goToSlide(currentIndex + 1); // Swipe left
      } else {
        goToSlide(currentIndex - 1); // Swipe right
      }
    }
  });

  // Initialize
  goToSlide(0);
}

// ========== QUANTITY CONTROL ==========
function initQuantityControl() {
  console.log("🔢 Initializing Quantity Control...");
  const minusBtn = document.getElementById("qtyMinus");
  const plusBtn = document.getElementById("qtyPlus");
  const input = document.getElementById("quantity");

  console.log("Quantity elements:", { minusBtn, plusBtn, input });

  if (!minusBtn || !plusBtn || !input) {
    console.warn("⚠️ Quantity control elements not found");
    return;
  }

  const min = parseInt(input.min) || 1;
  const max = parseInt(input.max) || 999;

  function updateQuantity(newValue) {
    newValue = Math.max(min, Math.min(max, newValue));
    input.value = newValue;

    minusBtn.disabled = newValue <= min;
    plusBtn.disabled = newValue >= max;
  }

  minusBtn.addEventListener("click", () => {
    updateQuantity(parseInt(input.value) - 1);
  });

  plusBtn.addEventListener("click", () => {
    updateQuantity(parseInt(input.value) + 1);
  });

  input.addEventListener("change", () => {
    updateQuantity(parseInt(input.value) || min);
  });

  input.addEventListener("input", () => {
    // Remove non-numeric characters
    input.value = input.value.replace(/[^0-9]/g, "");
  });

  // Initialize
  updateQuantity(parseInt(input.value) || min);
}

// ========== VARIANT SELECTION ==========
function initVariantSelection() {
  console.log("🎨 Initializing Variant Selection...");
  const variantInputs = document.querySelectorAll('input[name="variantId"]');
  console.log(`Found ${variantInputs.length} variant inputs`);

  variantInputs.forEach((input) => {
    input.addEventListener("change", function () {
      // Update price if variant has different price
      const label = this.nextElementSibling;
      const priceElement = label.querySelector(".variant-price");

      if (priceElement) {
        const price = priceElement.textContent;
        const currentPriceElement = document.querySelector(".current-price");
        if (currentPriceElement) {
          // Add animation
          currentPriceElement.style.transform = "scale(1.1)";
          setTimeout(() => {
            currentPriceElement.style.transform = "scale(1)";
          }, 200);
        }
      }

      // Update image if variant has image
      const variantImageUrl = this.dataset.image;
      if (variantImageUrl) {
        updateCarouselToVariantImage(variantImageUrl);
      }
    });
  });
}

function updateCarouselToVariantImage(imageUrl) {
  const slides = document.querySelectorAll(".carousel-slide");
  const thumbnails = document.querySelectorAll(".thumbnail");

  slides.forEach((slide, index) => {
    const img = slide.querySelector("img");
    if (img && img.src.includes(imageUrl)) {
      // Found the slide with this image
      const carousel = document.getElementById("imageCarousel");
      const track = carousel.querySelector(".carousel-track");
      const offset = -index * 100;
      track.style.transform = `translateX(${offset}%)`;

      // Update thumbnails
      thumbnails.forEach((thumb, i) => {
        thumb.classList.toggle("active", i === index);
      });
    }
  });
}

// ========== ADD TO CART ==========
function initAddToCart() {
  console.log("🛒 Initializing Add to Cart...");
  const addToCartBtn = document.getElementById("addToCartBtn");
  const buyNowBtn = document.getElementById("buyNowBtn");
  const productForm = document.getElementById("productForm");

  console.log("Cart elements:", { addToCartBtn, buyNowBtn, productForm });

  if (addToCartBtn && productForm) {
    console.log("✅ Add to Cart button found, attaching click event...");
    addToCartBtn.addEventListener("click", function (e) {
      console.log("🖱️ Add to Cart button clicked!");
      e.preventDefault();

      if (!validateSelection()) {
        return false;
      }

      // Show loading
      showLoading();

      // Submit form via AJAX
      const formData = new FormData(productForm);

      fetch(productForm.action, {
        method: "POST",
        body: formData,
      })
        .then((response) => {
          // Remove loading
          const loadingOverlay = document.querySelector(".loading-overlay");
          if (loadingOverlay) loadingOverlay.remove();

          if (response.ok) {
            // Show success notification
            showNotification("✓ Đã thêm sản phẩm vào giỏ hàng!", "success");

            // Add animation to button
            this.style.transform = "scale(0.95)";
            setTimeout(() => {
              this.style.transform = "scale(1)";
            }, 100);

            // Optional: Update cart count in header if exists
            updateCartCount();
          } else {
            showNotification("Có lỗi xảy ra. Vui lòng thử lại!", "warning");
          }
        })
        .catch((error) => {
          const loadingOverlay = document.querySelector(".loading-overlay");
          if (loadingOverlay) loadingOverlay.remove();
          showNotification("Có lỗi xảy ra. Vui lòng thử lại!", "warning");
          console.error("Error:", error);
        });
    });
  }

  if (buyNowBtn) {
    buyNowBtn.addEventListener("click", function (e) {
      if (!validateSelection()) {
        e.preventDefault();
        return false;
      }

      showLoading();

      // For buy now, submit form normally
      if (productForm) {
        productForm.submit();
      }
    });
  }
}

// Update cart count in header (fetch from server for accurate count)
function updateCartCount() {
  // Use global function from header.jsp if available
  if (typeof window.updateCartBadge === "function") {
    window.updateCartBadge();
  } else {
    // Fallback: simple increment (may be inaccurate for duplicate products)
    const cartCountElement = document.querySelector(".cart-count, .badge-cart");
    if (cartCountElement) {
      const currentCount = parseInt(cartCountElement.textContent) || 0;
      cartCountElement.textContent = currentCount + 1;

      // Add pulse animation
      cartCountElement.style.animation = "pulse 0.3s ease";
      setTimeout(() => {
        cartCountElement.style.animation = "";
      }, 300);
    }
  }
}

function validateSelection() {
  const variantInputs = document.querySelectorAll('input[name="variantId"]');

  if (variantInputs.length > 0) {
    const selected = document.querySelector('input[name="variantId"]:checked');
    if (!selected) {
      showNotification("Vui lòng chọn phân loại sản phẩm", "warning");
      highlightVariantSection();
      return false;
    }
  }

  const quantity = document.getElementById("quantity");
  if (quantity && (parseInt(quantity.value) < 1 || isNaN(quantity.value))) {
    showNotification("Vui lòng chọn số lượng hợp lệ", "warning");
    quantity.focus();
    return false;
  }

  return true;
}

function highlightVariantSection() {
  const variantSection = document.querySelector(".variant-options");
  if (variantSection) {
    variantSection.style.animation = "shake 0.5s";
    setTimeout(() => {
      variantSection.style.animation = "";
    }, 500);
  }
}

// ========== UTILITIES ==========
function showNotification(message, type = "info") {
  // Remove existing notifications
  const existing = document.querySelector(".notification-toast");
  if (existing) existing.remove();

  const toast = document.createElement("div");
  toast.className = `notification-toast notification-${type}`;

  // Different icons for different types
  const icons = {
    success: "check-circle",
    warning: "exclamation-triangle",
    info: "info-circle",
    error: "times-circle",
  };

  toast.innerHTML = `
        <i class="fas fa-${icons[type] || icons.info}"></i>
        <span>${message}</span>
        <button class="toast-close" onclick="this.parentElement.remove()" title="Đóng">
            <i class="fas fa-times"></i>
        </button>
    `;

  document.body.appendChild(toast);

  // Show with animation
  setTimeout(() => toast.classList.add("show"), 10);

  // Play subtle sound for success (optional - can be removed)
  if (type === "success") {
    playNotificationSound();
  }

  // Auto hide after duration (success = 3.5s, warning = 3s)
  const duration = type === "success" ? 3500 : 3000;
  setTimeout(() => {
    toast.classList.remove("show");
    setTimeout(() => toast.remove(), 400);
  }, duration);
}

function playNotificationSound() {
  // Create a subtle beep sound using Web Audio API (optional)
  try {
    const audioContext = new (window.AudioContext ||
      window.webkitAudioContext)();
    const oscillator = audioContext.createOscillator();
    const gainNode = audioContext.createGain();

    oscillator.connect(gainNode);
    gainNode.connect(audioContext.destination);

    oscillator.frequency.value = 800;
    oscillator.type = "sine";

    gainNode.gain.setValueAtTime(0.1, audioContext.currentTime);
    gainNode.gain.exponentialRampToValueAtTime(
      0.01,
      audioContext.currentTime + 0.1
    );

    oscillator.start(audioContext.currentTime);
    oscillator.stop(audioContext.currentTime + 0.1);
  } catch (e) {
    // Ignore if audio not supported
  }
}

function showLoading() {
  const overlay = document.createElement("div");
  overlay.className = "loading-overlay";
  overlay.innerHTML = '<div class="spinner"></div>';
  document.body.appendChild(overlay);
}

// Add notification toast styles dynamically (wrap in IIFE to avoid conflicts)
(function () {
  // Check if styles already added
  if (document.getElementById("product-detail-toast-styles")) {
    return;
  }

  const toastStyle = document.createElement("style");
  toastStyle.id = "product-detail-toast-styles";
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

    .notification-toast i {
        font-size: 22px;
        flex-shrink: 0;
    }

    .notification-toast span {
        font-size: 15px;
        font-weight: 500;
        color: #333;
        flex: 1;
    }

    .toast-close {
        background: none;
        border: none;
        color: #999;
        cursor: pointer;
        padding: 4px;
        display: flex;
        align-items: center;
        justify-content: center;
        width: 24px;
        height: 24px;
        border-radius: 4px;
        transition: all 0.2s ease;
        flex-shrink: 0;
    }

    .toast-close:hover {
        background: rgba(0, 0, 0, 0.05);
        color: #333;
    }

    .toast-close i {
        font-size: 14px;
    }

    .notification-success {
        border-left-color: #00c853;
        background: linear-gradient(135deg, #ffffff 0%, #f1f8f4 100%);
    }

    .notification-success i {
        color: #00c853;
    }

    .notification-warning {
        border-left-color: #ff9800;
        background: linear-gradient(135deg, #ffffff 0%, #fff8f0 100%);
    }

    .notification-warning i {
        color: #ff9800;
    }

    .notification-info {
        border-left-color: #2196f3;
        background: linear-gradient(135deg, #ffffff 0%, #f0f7ff 100%);
    }

    .notification-info i {
        color: #2196f3;
    }

    @keyframes shake {
        0%, 100% { transform: translateX(0); }
        10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
        20%, 40%, 60%, 80% { transform: translateX(5px); }
    }

    @keyframes pulse {
        0%, 100% { transform: scale(1); }
        50% { transform: scale(1.2); }
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
})(); // End IIFE
