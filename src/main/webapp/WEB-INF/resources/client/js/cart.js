/**
 * CART PAGE - SHOPEE STYLE JAVASCRIPT
 * Handles cart interactions, quantity updates, calculations
 */

(function () {
  "use strict";

  // Wait for DOM to be ready
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    setTimeout(init, 0);
  }

  function init() {
    initQuantityControls();
    initCheckboxHandlers();
    initVariantToggles();
    initDeleteHandlers();
    recalculateTotals();
  }

  /**
   * Initialize quantity increase/decrease controls
   */
  function initQuantityControls() {
    document.querySelectorAll(".quantity-control").forEach((control) => {
      const decreaseBtn = control.querySelector(
        '.qty-btn[data-action="decrease"]'
      );
      const increaseBtn = control.querySelector(
        '.qty-btn[data-action="increase"]'
      );
      const input = control.querySelector(".qty-input");
      const form = control.closest("form");

      if (!input || !form) return;

      // Decrease quantity
      if (decreaseBtn) {
        decreaseBtn.addEventListener("click", (e) => {
          e.preventDefault();
          const currentValue = parseInt(input.value) || 1;
          const newValue = Math.max(1, currentValue - 1);

          if (newValue !== currentValue) {
            input.value = newValue;
            updateQuantityWithDelay(form, newValue);
          }
        });
      }

      // Increase quantity
      if (increaseBtn) {
        increaseBtn.addEventListener("click", (e) => {
          e.preventDefault();
          const currentValue = parseInt(input.value) || 1;
          const newValue = currentValue + 1;

          input.value = newValue;
          updateQuantityWithDelay(form, newValue);
        });
      }

      // Direct input change
      input.addEventListener("change", () => {
        let value = parseInt(input.value) || 1;
        value = Math.max(1, value);
        input.value = value;
        updateQuantityWithDelay(form, value);
      });
    });
  }

  /**
   * Update quantity with debounce to avoid too many requests
   */
  let quantityUpdateTimeout;
  function updateQuantityWithDelay(form, newValue) {
    clearTimeout(quantityUpdateTimeout);

    quantityUpdateTimeout = setTimeout(() => {
      // Update the data attribute for calculation
      const cartItem = form.closest(".cart-item");
      if (cartItem) {
        cartItem.dataset.qty = newValue;
        recalculateTotals();
      }

      // Submit form to update on server
      showLoading();
      form.submit();
    }, 500);
  }

  /**
   * Initialize checkbox handlers for select all/individual items
   */
  function initCheckboxHandlers() {
    const selectAllCheckbox = document.getElementById("select-all-checkbox");
    const headerSelectAll = document.getElementById("header-select-all");
    const shopCheckboxes = document.querySelectorAll(".shop-checkbox");
    const itemCheckboxes = document.querySelectorAll(
      ".item-checkbox:not(:disabled)"
    );

    // Select all handler for footer checkbox
    if (selectAllCheckbox) {
      selectAllCheckbox.addEventListener("change", (e) => {
        const isChecked = e.target.checked;

        itemCheckboxes.forEach((checkbox) => {
          checkbox.checked = isChecked;
        });

        shopCheckboxes.forEach((checkbox) => {
          checkbox.checked = isChecked;
        });

        // Sync header checkbox
        if (headerSelectAll) {
          headerSelectAll.checked = isChecked;
        }

        recalculateTotals();
      });
    }

    // Select all handler for header checkbox
    if (headerSelectAll) {
      headerSelectAll.addEventListener("change", (e) => {
        const isChecked = e.target.checked;

        itemCheckboxes.forEach((checkbox) => {
          checkbox.checked = isChecked;
        });

        shopCheckboxes.forEach((checkbox) => {
          checkbox.checked = isChecked;
        });

        // Sync footer checkbox
        if (selectAllCheckbox) {
          selectAllCheckbox.checked = isChecked;
        }

        recalculateTotals();
      });
    }

    // Shop checkbox handlers (exclude the header select-all)
    shopCheckboxes.forEach((shopCheckbox) => {
      // Skip if this is the header select-all checkbox
      if (shopCheckbox.id === 'header-select-all') return;
      
      shopCheckbox.addEventListener("change", (e) => {
        const shopGroup = e.target.closest(".shop-group");
        if (!shopGroup) return;
        
        const itemsInShop = shopGroup.querySelectorAll(
          ".item-checkbox:not(:disabled)"
        );

        itemsInShop.forEach((checkbox) => {
          checkbox.checked = e.target.checked;
        });

        updateSelectAllState();
        recalculateTotals();
      });
    });

    // Individual item checkbox handlers
    itemCheckboxes.forEach((itemCheckbox) => {
      itemCheckbox.addEventListener("change", () => {
        // Update shop checkbox state
        const shopGroup = itemCheckbox.closest(".shop-group");
        const shopCheckbox = shopGroup?.querySelector(".shop-checkbox");

        if (shopCheckbox) {
          const itemsInShop = shopGroup.querySelectorAll(
            ".item-checkbox:not(:disabled)"
          );
          const checkedItems = shopGroup.querySelectorAll(
            ".item-checkbox:not(:disabled):checked"
          );
          shopCheckbox.checked = itemsInShop.length === checkedItems.length;
        }

        updateSelectAllState();
        recalculateTotals();
      });
    });
  }

  /**
   * Update "Select All" checkbox state based on individual items
   */
  function updateSelectAllState() {
    const selectAllCheckbox = document.getElementById("select-all-checkbox");
    const headerSelectAll = document.getElementById("header-select-all");
    const itemCheckboxes = document.querySelectorAll(
      ".item-checkbox:not(:disabled)"
    );
    const checkedItems = document.querySelectorAll(
      ".item-checkbox:not(:disabled):checked"
    );

    const allSelected = itemCheckboxes.length === checkedItems.length && itemCheckboxes.length > 0;

    if (selectAllCheckbox) {
      selectAllCheckbox.checked = allSelected;
    }
    
    if (headerSelectAll) {
      headerSelectAll.checked = allSelected;
    }
  }

  /**
   * Recalculate shop totals and grand total
   */
  function recalculateTotals() {
    let grandTotal = 0;
    let selectedCount = 0;

    // Calculate each shop total
    document.querySelectorAll(".shop-group").forEach((shopGroup) => {
      let shopTotal = 0;

      const items = shopGroup.querySelectorAll(".cart-item");
      items.forEach((item) => {
        const checkbox = item.querySelector(".item-checkbox");

        if (checkbox && checkbox.checked && !checkbox.disabled) {
          const price = parseFloat(item.dataset.unit) || 0;
          const quantity = parseInt(item.dataset.qty) || 0;
          const itemTotal = price * quantity;

          shopTotal += itemTotal;
          selectedCount += quantity;

          // Update item total display
          const itemTotalEl = item.querySelector(".item-total");
          if (itemTotalEl) {
            itemTotalEl.textContent = formatCurrency(itemTotal);
          }
        }
      });

      // Update shop total display
      const shopTotalEl = shopGroup.querySelector(".shop-total-amount");
      if (shopTotalEl) {
        shopTotalEl.textContent = formatCurrency(shopTotal);
      }

      grandTotal += shopTotal;
    });

    // Update grand total and count
    const grandTotalEl = document.getElementById("grand-total");
    const selectedCountEl = document.getElementById("selected-count");

    if (grandTotalEl) {
      grandTotalEl.textContent = formatCurrency(grandTotal);
    }

    if (selectedCountEl) {
      selectedCountEl.textContent = selectedCount;
    }

    // Enable/disable checkout button
    const checkoutBtn = document.querySelector(".checkout-btn");
    if (checkoutBtn) {
      checkoutBtn.disabled = selectedCount === 0;
    }

    // Update cart badge in header
    updateCartBadge();
  }

  /**
   * Format number as Vietnamese currency
   */
  function formatCurrency(amount) {
    return new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
    }).format(amount);
  }

  /**
   * Initialize variant toggle buttons
   */
  function initVariantToggles() {
    document.querySelectorAll(".variant-change-btn").forEach((btn) => {
      btn.addEventListener("click", (e) => {
        e.preventDefault();
        const cartDetailId = btn.dataset.cartDetailId;
        const panel = document.getElementById(`variant-panel-${cartDetailId}`);

        if (panel) {
          // Close all other panels
          document.querySelectorAll(".variant-panel").forEach((p) => {
            if (p !== panel) {
              p.classList.remove("active");
            }
          });

          // Toggle current panel
          panel.classList.toggle("active");
        }
      });
    });

    // Auto-submit variant select on change
    document.querySelectorAll(".variant-select").forEach((select) => {
      select.addEventListener("change", function () {
        const form = this.closest("form");
        if (form) {
          showLoading();
          form.submit();
        }
      });
    });
  }

  /**
   * Initialize delete handlers
   */
  function initDeleteHandlers() {
    // Individual delete buttons
    document.querySelectorAll(".delete-btn").forEach((btn) => {
      btn.addEventListener("click", (e) => {
        e.preventDefault();

        if (confirm("Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?")) {
          const form = btn.closest("form");
          if (form) {
            showLoading();
            form.submit();
          }
        }
      });
    });

    // Delete selected button
    const deleteSelectedBtn = document.querySelector(".delete-selected-btn");
    if (deleteSelectedBtn) {
      deleteSelectedBtn.addEventListener("click", async () => {
        const checkedItems = document.querySelectorAll(
          ".item-checkbox:checked:not(:disabled)"
        );

        if (checkedItems.length === 0) {
          showToast("Vui lòng chọn sản phẩm để xóa", "error");
          return;
        }

        if (
          confirm(
            `Bạn có chắc muốn xóa ${checkedItems.length} sản phẩm đã chọn?`
          )
        ) {
          showLoading();

          try {
            await deleteSelectedItems(checkedItems);
            showToast(
              `Đã xóa ${checkedItems.length} sản phẩm khỏi giỏ hàng`,
              "success"
            );

            // Reload page after 1 second
            setTimeout(() => {
              window.location.reload();
            }, 1000);
          } catch (error) {
            hideLoading();
            showToast("Có lỗi xảy ra khi xóa sản phẩm", "error");
            console.error("Delete error:", error);
          }
        }
      });
    }
  }

  /**
   * Delete selected items using form submissions
   */
  async function deleteSelectedItems(checkedItems) {
    const deletePromises = [];

    // Get CSRF token from first form (if exists)
    const firstForm = document.querySelector(
      'form[action*="delete-cart-product"]'
    );
    const csrfTokenInput = firstForm?.querySelector('input[name^="_csrf"]');
    const csrfParam = csrfTokenInput?.name;
    const csrfToken = csrfTokenInput?.value;

    checkedItems.forEach((checkbox) => {
      const cartItem = checkbox.closest(".cart-item");
      const deleteForm = cartItem?.querySelector(
        'form[action*="delete-cart-product"]'
      );

      if (deleteForm) {
        const cartDetailId = deleteForm.querySelector(
          'input[name="cartDetailId"]'
        )?.value;

        if (cartDetailId) {
          // Add deleting animation class
          cartItem.classList.add("deleting");

          // Create FormData
          const formData = new FormData();
          formData.append("cartDetailId", cartDetailId);

          // Add CSRF token if exists
          if (csrfToken && csrfParam) {
            formData.append(csrfParam, csrfToken);
          }

          // Create promise for each delete request
          const promise = fetch(deleteForm.action, {
            method: "POST",
            body: formData,
            credentials: "same-origin",
            redirect: "manual", // Prevent automatic redirect
          }).catch((error) => {
            console.error(
              "Delete failed for cartDetailId:",
              cartDetailId,
              error
            );
            // Remove animation class on error
            cartItem.classList.remove("deleting");
          });

          deletePromises.push(promise);
        }
      }
    });

    // Wait for all delete requests to complete
    const results = await Promise.allSettled(deletePromises);

    // Check if any request failed
    const hasErrors = results.some((result) => result.status === "rejected");
    if (hasErrors) {
      throw new Error("Some delete requests failed");
    }
  }

  /**
   * Validate checkout form before submit
   */
  const checkoutForm = document.getElementById("checkout-form");
  if (checkoutForm) {
    checkoutForm.addEventListener("submit", (e) => {
      const checkedItems = document.querySelectorAll(
        ".item-checkbox:checked:not(:disabled)"
      );

      if (checkedItems.length === 0) {
        e.preventDefault();
        showToast("Vui lòng chọn ít nhất 1 sản phẩm để thanh toán", "error");
        return false;
      }

      showLoading();
    });
  }

  /**
   * Show loading overlay
   */
  function showLoading() {
    let overlay = document.querySelector(".loading-overlay");

    if (!overlay) {
      overlay = document.createElement("div");
      overlay.className = "loading-overlay";
      overlay.innerHTML = '<div class="loading-spinner"></div>';
      document.body.appendChild(overlay);
    }

    overlay.classList.add("active");
  }

  /**
   * Hide loading overlay
   */
  function hideLoading() {
    const overlay = document.querySelector(".loading-overlay");
    if (overlay) {
      overlay.classList.remove("active");
    }
  }

  /**
   * Show toast notification
   */
  function showToast(message, type = "success") {
    const toast = document.createElement("div");
    toast.className = `toast ${type}`;

    const icon =
      type === "success"
        ? '<i class="fas fa-check-circle toast-icon"></i>'
        : '<i class="fas fa-exclamation-circle toast-icon"></i>';

    toast.innerHTML = `
            ${icon}
            <div class="toast-message">${message}</div>
        `;

    document.body.appendChild(toast);

    setTimeout(() => {
      toast.style.animation = "slideInRight 0.3s ease-out reverse";
      setTimeout(() => toast.remove(), 300);
    }, 3000);
  }

  /**
   * Update cart count badge in header
   */
  function updateCartBadge() {
    // Count number of cart items (not total quantity)
    // Example: 10 shirts type 1 + 2 shirts type 2 = show 2 (not 12)
    const totalItems = document.querySelectorAll(".cart-item").length;

    // Update all cart badges in header
    document.querySelectorAll(".cart-count").forEach((badge) => {
      badge.textContent = totalItems;

      // Show/hide badge based on count
      if (totalItems > 0) {
        badge.style.display = "flex";
      } else {
        badge.style.display = "none";
      }
    });
  }

  // Expose utilities to global scope if needed
  window.cartUtils = {
    showToast,
    showLoading,
    hideLoading,
    recalculateTotals,
    updateCartBadge,
  };
})();
