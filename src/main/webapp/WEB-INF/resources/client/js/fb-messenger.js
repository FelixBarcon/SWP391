/**
 * ===================================
 * FACEBOOK MESSENGER CONFIGURATION
 * - Page ID settings
 * - Button behavior
 * ===================================
 */

// Facebook Messenger configuration
const FB_MESSENGER_CONFIG = {
  pageId: "123", // Facebook Page ID
  displayName: "Hỗ trợ 24/7",
  message: "Xin chào! Tôi cần hỗ trợ.",
  showNotificationDot: true,
};

/**
 * Get Facebook Messenger URL
 */
function getFacebookMessengerUrl() {
  // Facebook Messenger URL format
  const url = `https://m.me/${FB_MESSENGER_CONFIG.pageId}`;

  // Add pre-filled message if available (optional, may not work on all devices)
  if (FB_MESSENGER_CONFIG.message) {
    return `${url}?text=${encodeURIComponent(FB_MESSENGER_CONFIG.message)}`;
  }

  return url;
}

/**
 * Initialize Facebook Messenger button
 */
function initFacebookMessengerButton() {
  const fbButton = document.querySelector(".fb-messenger-button");

  if (!fbButton) return;

  // Update href with config
  fbButton.href = getFacebookMessengerUrl();

  // Add click tracking (if using Google Analytics)
  fbButton.addEventListener("click", function () {
    // Track click event
    if (typeof gtag !== "undefined") {
      gtag("event", "click", {
        event_category: "Social",
        event_label: "Facebook Messenger",
        value: FB_MESSENGER_CONFIG.pageId,
      });
    }

    // Hide notification dot after first click
    const notificationDot = this.querySelector(
      ".fb-messenger-notification-dot"
    );
    if (notificationDot) {
      setTimeout(() => {
        notificationDot.style.display = "none";
      }, 300);
    }
  });

  // Mobile tooltip handling
  if (window.innerWidth <= 768) {
    fbButton.addEventListener("touchstart", function (e) {
      if (!this.classList.contains("touched")) {
        e.preventDefault();
        this.classList.add("touched");
        showMobileTooltipFB(this);

        setTimeout(() => {
          this.classList.remove("touched");
        }, 2000);
      }
    });
  }
}

/**
 * Show tooltip on mobile devices
 */
function showMobileTooltipFB(button) {
  const tooltip = button.querySelector(".fb-messenger-tooltip");
  if (tooltip) {
    tooltip.style.opacity = "1";
    setTimeout(() => {
      tooltip.style.opacity = "0";
    }, 2000);
  }
}

/**
 * Update Facebook Page ID dynamically
 */
function updateFacebookPageId(newPageId) {
  FB_MESSENGER_CONFIG.pageId = newPageId;
  const fbButton = document.querySelector(".fb-messenger-button");
  if (fbButton) {
    fbButton.href = getFacebookMessengerUrl();
  }
}

// Initialize when DOM is ready
if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initFacebookMessengerButton);
} else {
  initFacebookMessengerButton();
}

// Export for external use
window.FacebookMessenger = {
  updatePageId: updateFacebookPageId,
  getUrl: getFacebookMessengerUrl,
  config: FB_MESSENGER_CONFIG,
};
