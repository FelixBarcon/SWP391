/**
 * Authentication Utilities
 * Helper functions to handle login redirects and authentication checks
 */

/**
 * Enhanced fetch wrapper that handles authentication redirects
 * @param {string} url - The URL to fetch
 * @param {object} options - Fetch options
 * @returns {Promise} - Promise that resolves with response or rejects with auth error
 */
window.authFetch = function (url, options = {}) {
  // Don't set redirect to manual - let it follow redirects
  // We'll check the final URL to determine if it's a login redirect

  return fetch(url, options).then((response) => {
    // Check if we got redirected to login page
    const finalUrl = response.url || window.location.href;

    if (finalUrl.includes("/login")) {
      throw new Error("AUTHENTICATION_REQUIRED");
    }

    return response;
  });
};

/**
 * Handle authentication required error
 * Redirects to login immediately without notification
 * @param {string} message - Custom message to show (optional, won't be used)
 */
window.handleAuthRequired = function (message = "") {
  // Redirect to login page immediately
  const currentUrl = encodeURIComponent(window.location.href);
  window.location.href = `/login?redirect=${currentUrl}`;
};

/**
 * Check if user is logged in by checking session/local storage or making a quick API call
 * @returns {boolean} - True if logged in, false otherwise
 */
window.isUserLoggedIn = function () {
  // Check if there's user data in session/local storage
  // This is a simple check - you might want to verify with server
  return (
    document.querySelector("[data-user-logged-in]") !== null ||
    localStorage.getItem("userLoggedIn") === "true" ||
    sessionStorage.getItem("userLoggedIn") === "true"
  );
};

/**
 * Safe add to cart function that checks authentication first
 * @param {string} url - Add to cart URL
 * @param {FormData|object} data - Form data to send
 * @param {object} options - Additional options
 * @returns {Promise} - Promise that resolves with response
 */
window.safeAddToCart = function (url, data, options = {}) {
  return window
    .authFetch(url, {
      method: "POST",
      body: data,
      ...options,
    })
    .catch((error) => {
      if (error.message === "AUTHENTICATION_REQUIRED") {
        window.handleAuthRequired(
          "⚠️ Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng!"
        );
        throw error;
      }
      throw error;
    });
};
