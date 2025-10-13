/**
 * ORDER CHECKOUT - SHOPEE STYLE JAVASCRIPT
 * Handles address selection, shipping fee calculation, form validation
 */

(function () {
  "use strict";

  // Configuration
  const config = {
    contextPath: "",
    csrfToken: null,
    csrfHeader: "X-CSRF-TOKEN",
  };

  // State
  const state = {
    cartDetailIds: [],
    itemsTotal: 0,
    shippingTotal: 0,
    shopFees: [],
  };

  // Wait for DOM to be ready
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    setTimeout(init, 0);
  }

  function init() {
    initConfig();
    initAddressSelects();
    initPaymentMethods();
    initFormValidation();
    loadProvinces();
  }

  /**
   * Initialize configuration from page
   */
  function initConfig() {
    // Get context path
    const metaContext = document.querySelector('meta[name="context-path"]');
    if (metaContext) {
      config.contextPath = metaContext.getAttribute("content");
    }

    // Get CSRF token
    const metaCsrf = document.querySelector('meta[name="_csrf"]');
    const metaCsrfHeader = document.querySelector('meta[name="_csrf_header"]');
    if (metaCsrf) {
      config.csrfToken = metaCsrf.getAttribute("content");
    }
    if (metaCsrfHeader) {
      config.csrfHeader = metaCsrfHeader.getAttribute("content");
    }

    // Get cart detail IDs from hidden input or data attribute
    const idsInput = document.getElementById("cart-detail-ids");
    if (idsInput) {
      const idsValue = idsInput.value;
      if (idsValue) {
        state.cartDetailIds = idsValue
          .split(",")
          .map((id) => parseInt(id.trim(), 10))
          .filter((id) => !isNaN(id));
      }
    }

    // Get items total
    const itemsTotalInput = document.getElementById("items-total-value");
    if (itemsTotalInput) {
      state.itemsTotal = parseFloat(itemsTotalInput.value) || 0;
    }
  }

  /**
   * Initialize address select dropdowns
   */
  function initAddressSelects() {
    const provinceSelect = document.getElementById("province");
    const districtSelect = document.getElementById("district");
    const wardSelect = document.getElementById("ward");

    if (provinceSelect) {
      provinceSelect.addEventListener("change", handleProvinceChange);
    }

    if (districtSelect) {
      districtSelect.addEventListener("change", handleDistrictChange);
    }

    if (wardSelect) {
      wardSelect.addEventListener("change", handleWardChange);
    }
  }

  /**
   * Handle province selection change
   */
  function handleProvinceChange(event) {
    const select = event.target;
    const selectedOption = select.options[select.selectedIndex];
    const provinceName = selectedOption.dataset.name || selectedOption.text;
    const provinceId = select.value;

    // Update hidden input
    document.getElementById("receiver-province").value = provinceName;

    // Reset district and ward
    resetSelect("district", "-- Chọn Quận/Huyện --", true);
    resetSelect("ward", "-- Chọn Phường/Xã --", true);
    document.getElementById("receiver-district").value = "";
    document.getElementById("receiver-ward").value = "";
    document.getElementById("to-district-id").value = "";
    document.getElementById("to-ward-code").value = "";

    // Reset shipping
    updateShippingDisplay(0, []);

    // Load districts if province selected
    if (provinceId) {
      loadDistricts(provinceId);
    }
  }

  /**
   * Handle district selection change
   */
  function handleDistrictChange(event) {
    const select = event.target;
    const selectedOption = select.options[select.selectedIndex];
    const districtName = selectedOption.dataset.name || selectedOption.text;
    const districtId = select.value;

    // Update hidden inputs
    document.getElementById("receiver-district").value = districtName;
    document.getElementById("to-district-id").value = districtId;

    // Reset ward
    resetSelect("ward", "-- Chọn Phường/Xã --", true);
    document.getElementById("receiver-ward").value = "";
    document.getElementById("to-ward-code").value = "";

    // Reset shipping
    updateShippingDisplay(0, []);

    // Load wards if district selected
    if (districtId) {
      loadWards(districtId);
    }
  }

  /**
   * Handle ward selection change
   */
  function handleWardChange(event) {
    const select = event.target;
    const selectedOption = select.options[select.selectedIndex];
    const wardName = selectedOption.dataset.name || selectedOption.text;
    const wardCode = select.value;

    // Update hidden inputs
    document.getElementById("receiver-ward").value = wardName;
    document.getElementById("to-ward-code").value = wardCode;

    // Calculate shipping fee
    if (wardCode) {
      calculateShippingFee();
    } else {
      updateShippingDisplay(0, []);
    }
  }

  /**
   * Load provinces from API
   */
  async function loadProvinces() {
    try {
      showLoading("Đang tải danh sách tỉnh/thành phố...");

      const url = `${config.contextPath}/shipping/ghn/provinces`;
      const response = await fetch(url);

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }

      const data = await response.json();
      populateSelect("province", data, {
        valueKey: "ProvinceID",
        textKey: "ProvinceName",
        nameKey: "ProvinceName",
        defaultText: "-- Chọn Tỉnh/TP --",
      });

      hideLoading();
    } catch (error) {
      console.error("Load provinces error:", error);
      hideLoading();
      showNotification("Không thể tải danh sách tỉnh/thành phố", "error");
    }
  }

  /**
   * Load districts from API
   */
  async function loadDistricts(provinceId) {
    try {
      showLoading("Đang tải danh sách quận/huyện...");

      const url = `${config.contextPath}/shipping/ghn/districts?provinceId=${provinceId}`;
      const response = await fetch(url);

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }

      const data = await response.json();
      populateSelect("district", data, {
        valueKey: "DistrictID",
        textKey: "DistrictName",
        nameKey: "DistrictName",
        defaultText: "-- Chọn Quận/Huyện --",
        disabled: false,
      });

      hideLoading();
    } catch (error) {
      console.error("Load districts error:", error);
      hideLoading();
      showNotification("Không thể tải danh sách quận/huyện", "error");
    }
  }

  /**
   * Load wards from API
   */
  async function loadWards(districtId) {
    try {
      showLoading("Đang tải danh sách phường/xã...");

      const url = `${config.contextPath}/shipping/ghn/wards?districtId=${districtId}`;
      const response = await fetch(url);

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }

      const data = await response.json();
      populateSelect("ward", data, {
        valueKey: "WardCode",
        textKey: "WardName",
        nameKey: "WardName",
        defaultText: "-- Chọn Phường/Xã --",
        disabled: false,
      });

      hideLoading();
    } catch (error) {
      console.error("Load wards error:", error);
      hideLoading();
      showNotification("Không thể tải danh sách phường/xã", "error");
    }
  }

  /**
   * Calculate shipping fee via API
   */
  async function calculateShippingFee() {
    const toDistrictId = document.getElementById("to-district-id").value;
    const toWardCode = document.getElementById("to-ward-code").value;

    if (!toDistrictId || !toWardCode || state.cartDetailIds.length === 0) {
      updateShippingDisplay(0, []);
      return;
    }

    try {
      showLoading("Đang tính phí vận chuyển...");

      const url = `${config.contextPath}/shipping/ghn/fee`;
      const headers = {
        "Content-Type": "application/json",
      };

      if (config.csrfToken) {
        headers[config.csrfHeader] = config.csrfToken;
      }

      const payload = {
        cartDetailIds: state.cartDetailIds,
        toDistrictId: parseInt(toDistrictId, 10),
        toWardCode: toWardCode,
      };

      const response = await fetch(url, {
        method: "POST",
        headers: headers,
        body: JSON.stringify(payload),
      });

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }

      const data = await response.json();
      const totalFee = parseFloat(data.totalFee) || 0;
      const shopFees = data.shops || [];

      updateShippingDisplay(totalFee, shopFees);
      hideLoading();
    } catch (error) {
      console.error("Calculate shipping fee error:", error);
      hideLoading();
      updateShippingDisplay(0, []);
      showNotification(
        "Không thể tính phí vận chuyển. Vui lòng thử lại.",
        "error"
      );
    }
  }

  /**
   * Update shipping fee display
   */
  function updateShippingDisplay(totalFee, shopFees) {
    state.shippingTotal = totalFee;
    state.shopFees = shopFees;

    // Update shipping total
    const shippingTotalEl = document.getElementById("shipping-total");
    if (shippingTotalEl) {
      shippingTotalEl.textContent = formatCurrency(totalFee);
    }

    // Update hidden input
    const shippingInput = document.getElementById("client-ship-total");
    if (shippingInput) {
      shippingInput.value = totalFee;
    }

    // Update shop fees
    document.querySelectorAll(".shop-shipping-amount").forEach((el) => {
      const shopId = parseInt(el.dataset.shopId, 10);
      const shopFee = shopFees.find((s) => parseInt(s.shopId, 10) === shopId);
      const fee = shopFee ? shopFee.fee || 0 : 0;
      el.textContent = formatCurrency(fee);
    });

    // Update grand total
    updateGrandTotal();
  }

  /**
   * Update grand total
   */
  function updateGrandTotal() {
    const grandTotal = state.itemsTotal + state.shippingTotal;
    const grandTotalEl = document.getElementById("grand-total");
    if (grandTotalEl) {
      grandTotalEl.textContent = formatCurrency(grandTotal);
    }
  }

  /**
   * Populate select element with options
   */
  function populateSelect(selectId, data, options) {
    const select = document.getElementById(selectId);
    if (!select) return;

    // Clear existing options
    select.innerHTML = "";

    // Add default option
    const defaultOption = document.createElement("option");
    defaultOption.value = "";
    defaultOption.textContent = options.defaultText || "-- Chọn --";
    select.appendChild(defaultOption);

    // Add data options
    if (Array.isArray(data)) {
      data.forEach((item) => {
        const option = document.createElement("option");
        option.value = item[options.valueKey];
        option.textContent =
          item[options.textKey] || String(item[options.valueKey]);

        if (options.nameKey) {
          option.dataset.name = item[options.nameKey] || "";
        }

        select.appendChild(option);
      });
    }

    // Enable/disable select
    if (options.disabled !== undefined) {
      select.disabled = options.disabled;
    }
  }

  /**
   * Reset select element
   */
  function resetSelect(selectId, defaultText, disabled) {
    const select = document.getElementById(selectId);
    if (!select) return;

    select.innerHTML = "";
    const option = document.createElement("option");
    option.value = "";
    option.textContent = defaultText;
    select.appendChild(option);
    select.disabled = disabled;
  }

  /**
   * Initialize payment method selection
   */
  function initPaymentMethods() {
    document.querySelectorAll(".payment-option").forEach((option) => {
      option.addEventListener("click", function () {
        // Remove active from all
        document.querySelectorAll(".payment-option").forEach((opt) => {
          opt.classList.remove("active");
        });

        // Add active to clicked
        this.classList.add("active");

        // Check the radio
        const radio = this.querySelector(".payment-radio");
        if (radio) {
          radio.checked = true;
        }
      });
    });
  }

  /**
   * Initialize form validation
   */
  function initFormValidation() {
    const form = document.getElementById("checkout-form");
    if (!form) return;

    form.addEventListener("submit", function (event) {
      const toDistrictId = document.getElementById("to-district-id").value;
      const toWardCode = document.getElementById("to-ward-code").value;

      if (!toDistrictId || !toWardCode) {
        event.preventDefault();
        showNotification(
          "Vui lòng chọn đầy đủ địa chỉ nhận hàng (Tỉnh/TP, Quận/Huyện, Phường/Xã)",
          "error"
        );

        // Scroll to address section
        const addressSection = document.querySelector(".section-card");
        if (addressSection) {
          addressSection.scrollIntoView({ behavior: "smooth", block: "start" });
        }

        return false;
      }

      showLoading("Đang xử lý đơn hàng...");
    });
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
   * Show loading overlay
   */
  function showLoading(message = "Đang xử lý...") {
    let overlay = document.querySelector(".loading-overlay");

    if (!overlay) {
      overlay = document.createElement("div");
      overlay.className = "loading-overlay";
      overlay.innerHTML = `
                <div class="loading-content">
                    <div class="loading-spinner"></div>
                    <div class="loading-text">${message}</div>
                </div>
            `;
      document.body.appendChild(overlay);
    } else {
      const textEl = overlay.querySelector(".loading-text");
      if (textEl) {
        textEl.textContent = message;
      }
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
   * Show notification toast
   */
  function showNotification(message, type = "success") {
    const toast = document.createElement("div");
    toast.className = `alert alert-${type === "error" ? "danger" : type}`;
    toast.style.cssText =
      "position: fixed; top: 80px; right: 20px; z-index: 10000; min-width: 300px; animation: slideInRight 0.3s ease-out;";

    const icon =
      type === "success"
        ? '<i class="fas fa-check-circle"></i>'
        : '<i class="fas fa-exclamation-circle"></i>';

    toast.innerHTML = `${icon} ${message}`;

    document.body.appendChild(toast);

    setTimeout(() => {
      toast.style.animation = "slideInRight 0.3s ease-out reverse";
      setTimeout(() => toast.remove(), 300);
    }, 3000);
  }

  // Expose utilities to global scope
  window.orderCheckout = {
    showLoading,
    hideLoading,
    showNotification,
    calculateShippingFee,
  };
})();
