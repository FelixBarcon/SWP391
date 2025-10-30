/**
 * ORDER CHECKOUT - SHOPEE STYLE JAVASCRIPT
 * Handles address selection, shipping fee calculation (GHN), form validation
 * Version: shopIds-based (works for both CART & BUY-NOW flows)
 */

(function () {
  "use strict";

  // ===== Config =====
  const config = {
    contextPath: "",
    csrfToken: null,
    csrfHeader: "X-CSRF-TOKEN",
  };

  // ===== State =====
  const state = {
    // Giữ lại để tương thích nơi khác nếu có dùng, KHÔNG dùng cho tính phí nữa
    cartDetailIds: [],
    itemsTotal: 0,
    shippingTotal: 0,
    shopFees: [],
  };

  // ===== Boot =====
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
    initProfileAddressButton();

    // Nếu địa chỉ đã có sẵn (user quay lại), tính phí ngay
    const toDist = document.getElementById("to-district-id")?.value;
    const toWard = document.getElementById("to-ward-code")?.value;
    if (toDist && toWard) {
      calculateShippingFee();
    } else {
      // Chưa có -> load master data GHN
      loadProvinces();
    }
  }

  // ======================================
  // Config & Helpers
  // ======================================

  function initConfig() {
    // context path
    const metaContext = document.querySelector('meta[name="context-path"]');
    if (metaContext) config.contextPath = metaContext.getAttribute("content") || "";

    // CSRF
    const metaCsrf = document.querySelector('meta[name="_csrf"]');
    const metaCsrfHeader = document.querySelector('meta[name="_csrf_header"]');
    if (metaCsrf) config.csrfToken = metaCsrf.getAttribute("content");
    if (metaCsrfHeader) config.csrfHeader = metaCsrfHeader.getAttribute("content") || "X-CSRF-TOKEN";

    // Giữ tương thích cũ (không dùng để tính phí)
    const idsInput = document.getElementById("cart-detail-ids");
    if (idsInput && idsInput.value) {
      state.cartDetailIds = idsInput.value
          .split(",")
          .map((id) => parseInt(id.trim(), 10))
          .filter((id) => !isNaN(id));
    }

    // Tổng tiền hàng
    const itemsTotalInput = document.getElementById("items-total-value");
    if (itemsTotalInput) state.itemsTotal = parseFloat(itemsTotalInput.value) || 0;
  }

  // Lấy danh sách shopId đang hiển thị (áp dụng cho cả CART & BUY-NOW)
  function getShopIdsFromDOM() {
    return Array.from(document.querySelectorAll('.shop-block[data-shop-id]'))
        .map((el) => Number(el.getAttribute('data-shop-id')))
        .filter(Boolean);
  }

  // ======================================
  // Address selects (province/district/ward)
  // ======================================

  function initAddressSelects() {
    const provinceSelect = document.getElementById("province");
    const districtSelect = document.getElementById("district");
    const wardSelect = document.getElementById("ward");

    provinceSelect?.addEventListener("change", handleProvinceChange);
    districtSelect?.addEventListener("change", handleDistrictChange);
    wardSelect?.addEventListener("change", handleWardChange);
  }

  function handleProvinceChange(event) {
    const select = event.target;
    const selectedOption = select.options[select.selectedIndex];
    const provinceName = selectedOption?.dataset?.name || selectedOption?.text || "";
    const provinceId = select.value;

    // Update hidden input
    const hp = document.getElementById("receiver-province");
    if (hp) hp.value = provinceName;

    // Reset district & ward & GHN keys
    resetSelect("district", "-- Chọn Quận/Huyện --", true);
    resetSelect("ward", "-- Chọn Phường/Xã --", true);
    setValueIfExists("receiver-district", "");
    setValueIfExists("receiver-ward", "");
    setValueIfExists("to-district-id", "");
    setValueIfExists("to-ward-code", "");

    // Reset shipping UI
    updateShippingDisplay(0, []);

    // Load districts
    if (provinceId) loadDistricts(provinceId);
  }

  function handleDistrictChange(event) {
    const select = event.target;
    const selectedOption = select.options[select.selectedIndex];
    const districtName = selectedOption?.dataset?.name || selectedOption?.text || "";
    const districtId = select.value;

    setValueIfExists("receiver-district", districtName);
    setValueIfExists("to-district-id", districtId);

    // Reset ward & GHN ward code
    resetSelect("ward", "-- Chọn Phường/Xã --", true);
    setValueIfExists("receiver-ward", "");
    setValueIfExists("to-ward-code", "");

    // Reset shipping UI
    updateShippingDisplay(0, []);

    // Load wards
    if (districtId) loadWards(districtId);
  }

  function handleWardChange(event) {
    const select = event.target;
    const selectedOption = select.options[select.selectedIndex];
    const wardName = selectedOption?.dataset?.name || selectedOption?.text || "";
    const wardCode = select.value;

    setValueIfExists("receiver-ward", wardName);
    setValueIfExists("to-ward-code", wardCode);

    if (wardCode) calculateShippingFee();
    else updateShippingDisplay(0, []);
  }

  function setValueIfExists(id, val) {
    const el = document.getElementById(id);
    if (el) el.value = val;
  }

  // ======================================
  // Fill address from profile
  // ======================================

  function initProfileAddressButton() {
    const btn = document.getElementById("btn-fill-profile-address");
    if (!btn) return;

    btn.addEventListener("click", async () => {
      try {
        btn.disabled = true;
        showLoading("Đang lấy địa chỉ từ hồ sơ...");
        const url = `${config.contextPath}/account/profile/address`;
        const res = await fetch(url, { headers: { "Accept": "application/json" } });
        if (!res.ok) throw new Error(`HTTP ${res.status}`);
        const data = await res.json();

        if (data && data.hasAddress && data.address) {
          const input = document.querySelector('input[name="receiverAddress"]');
          if (input) {
            input.value = data.address;
            input.classList.add("just-filled");
            setTimeout(() => input.classList.remove("just-filled"), 600);
          }
          showNotification("Đã điền địa chỉ từ hồ sơ", "success");
        } else {
          showNotification("Bạn chưa lưu địa chỉ trong hồ sơ. Vui lòng cập nhật tại Trang hồ sơ.", "error");
        }
      } catch (e) {
        console.error("Fetch profile address error:", e);
        showNotification("Không thể lấy địa chỉ hồ sơ. Vui lòng thử lại.", "error");
      } finally {
        hideLoading();
        btn.disabled = false;
      }
    });
  }

  // ======================================
  // Load GHN master data
  // ======================================

  async function loadProvinces() {
    try {
      showLoading("Đang tải danh sách tỉnh/thành phố...");
      const url = `${config.contextPath}/shipping/ghn/provinces`;
      const res = await fetch(url);
      if (!res.ok) throw new Error(`HTTP ${res.status}`);
      const data = await res.json();

      populateSelect("province", data, {
        valueKey: "ProvinceID",
        textKey: "ProvinceName",
        nameKey: "ProvinceName",
        defaultText: "-- Chọn Tỉnh/TP --",
      });
    } catch (e) {
      console.error("Load provinces error:", e);
      showNotification("Không thể tải danh sách tỉnh/thành phố", "error");
    } finally {
      hideLoading();
    }
  }

  async function loadDistricts(provinceId) {
    try {
      showLoading("Đang tải danh sách quận/huyện...");
      const url = `${config.contextPath}/shipping/ghn/districts?provinceId=${encodeURIComponent(provinceId)}`;
      const res = await fetch(url);
      if (!res.ok) throw new Error(`HTTP ${res.status}`);
      const data = await res.json();

      populateSelect("district", data, {
        valueKey: "DistrictID",
        textKey: "DistrictName",
        nameKey: "DistrictName",
        defaultText: "-- Chọn Quận/Huyện --",
        disabled: false,
      });
    } catch (e) {
      console.error("Load districts error:", e);
      showNotification("Không thể tải danh sách quận/huyện", "error");
    } finally {
      hideLoading();
    }
  }

  async function loadWards(districtId) {
    try {
      showLoading("Đang tải danh sách phường/xã...");
      const url = `${config.contextPath}/shipping/ghn/wards?districtId=${encodeURIComponent(districtId)}`;
      const res = await fetch(url);
      if (!res.ok) throw new Error(`HTTP ${res.status}`);
      const data = await res.json();

      populateSelect("ward", data, {
        valueKey: "WardCode",
        textKey: "WardName",
        nameKey: "WardName",
        defaultText: "-- Chọn Phường/Xã --",
        disabled: false,
      });
    } catch (e) {
      console.error("Load wards error:", e);
      showNotification("Không thể tải danh sách phường/xã", "error");
    } finally {
      hideLoading();
    }
  }

  // ======================================
  // GHN Fee Calculation (shopIds-based)
  // ======================================

  async function calculateShippingFee() {
    const toDistrictId = document.getElementById("to-district-id")?.value;
    const toWardCode = document.getElementById("to-ward-code")?.value;

    const shopIds = getShopIdsFromDOM(); // Áp dụng cho cả CART & BUY-NOW

    if (!toDistrictId || !toWardCode || shopIds.length === 0) {
      updateShippingDisplay(0, []);
      return;
    }

    try {
      showLoading("Đang tính phí vận chuyển...");

      const url = `${config.contextPath}/shipping/ghn/fee`;
      const headers = { "Content-Type": "application/json" };
      if (config.csrfToken) headers[config.csrfHeader] = config.csrfToken;

      const payload = {
        shopIds: shopIds,
        toDistrictId: parseInt(toDistrictId, 10),
        toWardCode: toWardCode,
      };

      const res = await fetch(url, {
        method: "POST",
        headers,
        body: JSON.stringify(payload),
      });
      if (!res.ok) throw new Error(`HTTP ${res.status}`);

      const data = await res.json(); // { totalFee, shops: [{shopId, fee, ...}] }
      const totalFee = Number(data.totalFee) || 0;
      const shopFees = Array.isArray(data.shops) ? data.shops : [];

      updateShippingDisplay(totalFee, shopFees);
    } catch (e) {
      console.error("Calculate shipping fee error:", e);
      updateShippingDisplay(0, []);
      showNotification("Không thể tính phí vận chuyển. Vui lòng thử lại.", "error");
    } finally {
      hideLoading();
    }
  }

  // ======================================
  // UI updates
  // ======================================

  function updateShippingDisplay(totalFee, shopFees) {
    state.shippingTotal = totalFee;
    state.shopFees = shopFees;

    // Tổng phí ship
    const elShipTotal = document.getElementById("shipping-total");
    if (elShipTotal) elShipTotal.textContent = formatCurrency(totalFee);

    // Hidden input để submit về server
    const shippingInput = document.getElementById("client-ship-total");
    if (shippingInput) shippingInput.value = totalFee;

    // Phí từng shop
    document.querySelectorAll(".shop-shipping-amount").forEach((el) => {
      const shopId = parseInt(el.dataset.shopId, 10);
      const sf = shopFees.find((s) => parseInt(s.shopId, 10) === shopId);
      el.textContent = formatCurrency(sf ? (sf.fee || 0) : 0);
    });

    updateGrandTotal();
  }

  function updateGrandTotal() {
    const grand = (state.itemsTotal || 0) + (state.shippingTotal || 0);
    const elGrand = document.getElementById("grand-total");
    if (elGrand) elGrand.textContent = formatCurrency(grand);
  }

  // ======================================
  // Select utils
  // ======================================

  function populateSelect(selectId, data, options) {
    const select = document.getElementById(selectId);
    if (!select) return;

    // Clear
    select.innerHTML = "";

    // Default option
    const def = document.createElement("option");
    def.value = "";
    def.textContent = options.defaultText || "-- Chọn --";
    select.appendChild(def);

    // Data options
    if (Array.isArray(data)) {
      data.forEach((item) => {
        const opt = document.createElement("option");
        opt.value = item[options.valueKey];
        opt.textContent = item[options.textKey] || String(item[options.valueKey]);
        if (options.nameKey) opt.dataset.name = item[options.nameKey] || "";
        select.appendChild(opt);
      });
    }

    // Enable/disable
    if (typeof options.disabled !== "undefined") {
      select.disabled = options.disabled;
    }
  }

  function resetSelect(selectId, defaultText, disabled) {
    const select = document.getElementById(selectId);
    if (!select) return;

    select.innerHTML = "";
    const opt = document.createElement("option");
    opt.value = "";
    opt.textContent = defaultText || "-- Chọn --";
    select.appendChild(opt);
    select.disabled = !!disabled;
  }

  // ======================================
  // Payment UI
  // ======================================

  function initPaymentMethods() {
    document.querySelectorAll(".payment-option").forEach((option) => {
      option.addEventListener("click", function () {
        document.querySelectorAll(".payment-option").forEach((opt) => opt.classList.remove("active"));
        this.classList.add("active");
        const radio = this.querySelector(".payment-radio");
        if (radio) radio.checked = true;
      });
    });
  }

  // ======================================
  // Form validation
  // ======================================

  function initFormValidation() {
    const form = document.getElementById("checkout-form");
    if (!form) return;

    form.addEventListener("submit", function (event) {
      const toDistrictId = document.getElementById("to-district-id")?.value;
      const toWardCode = document.getElementById("to-ward-code")?.value;

      if (!toDistrictId || !toWardCode) {
        event.preventDefault();
        showNotification("Vui lòng chọn đầy đủ địa chỉ nhận hàng (Tỉnh/TP, Quận/Huyện, Phường/Xã)", "error");
        const addressSection = document.querySelector(".section-card");
        addressSection?.scrollIntoView({ behavior: "smooth", block: "start" });
        return false;
      }

      showLoading("Đang xử lý đơn hàng...");
    });
  }

  // ======================================
  // UX helpers
  // ======================================

  function formatCurrency(amount) {
    try {
      return new Intl.NumberFormat("vi-VN", { style: "currency", currency: "VND" }).format(amount || 0);
    } catch {
      return (amount || 0).toLocaleString("vi-VN") + " ₫";
    }
  }

  function showLoading(message = "Đang xử lý...") {
    let overlay = document.querySelector(".loading-overlay");

    if (!overlay) {
      overlay = document.createElement("div");
      overlay.className = "loading-overlay";
      overlay.innerHTML = `
        <div class="loading-content">
          <div class="loading-spinner"></div>
          <div class="loading-text">${message}</div>
        </div>`;
      document.body.appendChild(overlay);
    } else {
      const textEl = overlay.querySelector(".loading-text");
      if (textEl) textEl.textContent = message;
    }

    overlay.classList.add("active");
  }

  function hideLoading() {
    const overlay = document.querySelector(".loading-overlay");
    if (overlay) overlay.classList.remove("active");
  }

  function showNotification(message, type = "success") {
    const toast = document.createElement("div");
    toast.className = `alert alert-${type === "error" ? "danger" : type}`;
    toast.style.cssText = "position: fixed; top: 80px; right: 20px; z-index: 10000; min-width: 300px; animation: slideInRight 0.3s ease-out;";

    const icon = type === "success"
        ? '<i class="fas fa-check-circle"></i>'
        : '<i class="fas fa-exclamation-circle"></i>';

    toast.innerHTML = `${icon} ${message}`;
    document.body.appendChild(toast);

    setTimeout(() => {
      toast.style.animation = "slideInRight 0.3s ease-out reverse";
      setTimeout(() => toast.remove(), 300);
    }, 3000);
  }

  // Expose minimal API for debugging
  window.orderCheckout = {
    calculateShippingFee,
    showLoading,
    hideLoading,
    showNotification,
  };
})();
