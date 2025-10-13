/**
 * ===================================
 * ZALO CHAT CONFIGURATION
 * - Phone number settings
 * - Button behavior
 * ===================================
 */

// Zalo phone number (admin)
const ZALO_CONFIG = {
  phoneNumber: "0353707544",
  displayName: "Hỗ trợ 24/7",
  message: "Xin chào! Tôi cần hỗ trợ.",
  showNotificationDot: true,
};

/**
 * Get Zalo chat URL
 */
function getZaloChatUrl() {
  const url = `https://zalo.me/${ZALO_CONFIG.phoneNumber}`;

  // Add pre-filled message if available
  if (ZALO_CONFIG.message) {
    return `${url}?text=${encodeURIComponent(ZALO_CONFIG.message)}`;
  }

  return url;
}

/**
 * Initialize Zalo chat button
 */
function initZaloChatButton() {
  const zaloButton = document.querySelector(".zalo-chat-button");

  if (!zaloButton) return;

  // Update href with config
  zaloButton.href = getZaloChatUrl();

  // Add click tracking
  zaloButton.addEventListener("click", function (e) {
    // Track analytics (Google Analytics, Facebook Pixel, etc.)
    if (typeof gtag !== "undefined") {
      gtag("event", "zalo_chat_click", {
        event_category: "Contact",
        event_label: "Zalo Chat Button",
        phone_number: ZALO_CONFIG.phoneNumber,
      });
    }

    // Show tooltip on click (mobile)
    if (window.innerWidth <= 768) {
      showMobileTooltip();
    }
  });
}

/**
 * Show tooltip on mobile
 */
function showMobileTooltip() {
  const tooltip = document.querySelector(".zalo-tooltip");
  if (tooltip) {
    tooltip.style.opacity = "1";
    setTimeout(() => {
      tooltip.style.opacity = "0";
    }, 2000);
  }
}

/**
 * Update phone number dynamically
 */
function updateZaloPhoneNumber(newPhoneNumber) {
  ZALO_CONFIG.phoneNumber = newPhoneNumber;
  const zaloButton = document.querySelector(".zalo-chat-button");
  if (zaloButton) {
    zaloButton.href = getZaloChatUrl();
  }
}

// Initialize when DOM is ready
if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initZaloChatButton);
} else {
  initZaloChatButton();
}

// Export for external use
window.ZaloChat = {
  updatePhoneNumber: updateZaloPhoneNumber,
  getUrl: getZaloChatUrl,
  config: ZALO_CONFIG,
};
