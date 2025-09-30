// Product List Shopee-Inspired Interactive Features

document.addEventListener("DOMContentLoaded", function () {
  // Initialize all features
  initializeViewToggle();
  initializeProductCardAnimations();
  initializeLoadingStates();
  initializeTooltips();
});

function initializeViewToggle() {
  const gridBtn = document.getElementById("gridViewBtn");
  const tableBtn = document.getElementById("tableViewBtn");

  if (gridBtn && tableBtn) {
    // Save user preference to localStorage
    const savedView = localStorage.getItem("preferredView") || "grid";
    toggleView(savedView);
  }
}

function toggleView(viewType) {
  const gridView = document.getElementById("gridView");
  const tableView = document.getElementById("tableView");
  const gridBtn = document.getElementById("gridViewBtn");
  const tableBtn = document.getElementById("tableViewBtn");

  if (!gridView || !tableView || !gridBtn || !tableBtn) return;

  if (viewType === "grid") {
    gridView.classList.remove("d-none");
    tableView.classList.add("d-none");
    gridBtn.classList.add("active");
    tableBtn.classList.remove("active");

    // Animate cards entrance
    animateCardsEntrance();
  } else {
    gridView.classList.add("d-none");
    tableView.classList.remove("d-none");
    tableBtn.classList.add("active");
    gridBtn.classList.remove("active");

    // Animate table entrance
    animateTableEntrance();
  }

  // Save preference
  localStorage.setItem("preferredView", viewType);
}

function animateCardsEntrance() {
  const cards = document.querySelectorAll(".product-card");
  cards.forEach((card, index) => {
    card.style.opacity = "0";
    card.style.transform = "translateY(20px)";

    setTimeout(() => {
      card.style.transition = "all 0.3s ease";
      card.style.opacity = "1";
      card.style.transform = "translateY(0)";
    }, index * 50);
  });
}

function animateTableEntrance() {
  const rows = document.querySelectorAll(".product-table tbody tr");
  rows.forEach((row, index) => {
    row.style.opacity = "0";
    row.style.transform = "translateX(-20px)";

    setTimeout(() => {
      row.style.transition = "all 0.3s ease";
      row.style.opacity = "1";
      row.style.transform = "translateX(0)";
    }, index * 30);
  });
}

function initializeProductCardAnimations() {
  const cards = document.querySelectorAll(".product-card");

  cards.forEach((card) => {
    // Hover effect for better interaction feedback
    card.addEventListener("mouseenter", function () {
      this.style.transform = "translateY(-4px) scale(1.02)";
    });

    card.addEventListener("mouseleave", function () {
      this.style.transform = "translateY(0) scale(1)";
    });

    // Add ripple effect to action buttons
    const actionBtns = card.querySelectorAll(".btn-action");
    actionBtns.forEach((btn) => {
      btn.addEventListener("click", createRippleEffect);
    });
  });
}

function createRippleEffect(e) {
  const button = e.currentTarget;
  const ripple = document.createElement("span");
  const rect = button.getBoundingClientRect();
  const size = Math.max(rect.width, rect.height);
  const x = e.clientX - rect.left - size / 2;
  const y = e.clientY - rect.top - size / 2;

  ripple.style.width = ripple.style.height = size + "px";
  ripple.style.left = x + "px";
  ripple.style.top = y + "px";
  ripple.classList.add("ripple");

  button.appendChild(ripple);

  setTimeout(() => {
    ripple.remove();
  }, 600);
}

function initializeLoadingStates() {
  // Add loading states to forms
  const forms = document.querySelectorAll("form");

  forms.forEach((form) => {
    form.addEventListener("submit", function () {
      const submitBtn = this.querySelector('button[type="submit"]');
      if (submitBtn) {
        submitBtn.disabled = true;
        submitBtn.innerHTML =
          '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';

        // Add loading class
        submitBtn.classList.add("loading");
      }
    });
  });
}

function initializeTooltips() {
  // Initialize Bootstrap tooltips if available
  if (typeof bootstrap !== "undefined") {
    const tooltipTriggerList = [].slice.call(
      document.querySelectorAll('[data-bs-toggle="tooltip"]')
    );
    tooltipTriggerList.map(function (tooltipTriggerEl) {
      return new bootstrap.Tooltip(tooltipTriggerEl);
    });
  }
}

// Utility functions
function showNotification(message, type = "success") {
  const notification = document.createElement("div");
  notification.className = `notification notification-${type}`;
  notification.innerHTML = `
        <i class="fas fa-${
          type === "success" ? "check-circle" : "exclamation-circle"
        }"></i>
        <span>${message}</span>
        <button onclick="this.parentElement.remove()" class="notification-close">
            <i class="fas fa-times"></i>
        </button>
    `;

  document.body.appendChild(notification);

  // Auto remove after 5 seconds
  setTimeout(() => {
    if (notification.parentElement) {
      notification.remove();
    }
  }, 5000);
}

// Search functionality (if search input exists)
function initializeSearch() {
  const searchInput = document.getElementById("productSearch");
  if (searchInput) {
    let searchTimeout;

    searchInput.addEventListener("input", function () {
      clearTimeout(searchTimeout);
      const query = this.value.toLowerCase();

      searchTimeout = setTimeout(() => {
        filterProducts(query);
      }, 300);
    });
  }
}

function filterProducts(query) {
  const cards = document.querySelectorAll(".product-card");
  const rows = document.querySelectorAll(".product-table tbody tr");

  // Filter grid view
  cards.forEach((card) => {
    const productName =
      card.querySelector(".product-name")?.textContent.toLowerCase() || "";
    const shouldShow = productName.includes(query);

    card.style.display = shouldShow ? "block" : "none";
  });

  // Filter table view
  rows.forEach((row) => {
    const productName = row.cells[2]?.textContent.toLowerCase() || "";
    const shouldShow = productName.includes(query);

    row.style.display = shouldShow ? "table-row" : "none";
  });
}
