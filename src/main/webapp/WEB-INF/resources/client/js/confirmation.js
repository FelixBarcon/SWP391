/**
 * ===================================
 * CONFIRMATION PAGE SCRIPT
 * - Order tracking animation
 * - Copy order ID
 * - Print order
 * ===================================
 */

(function () {
  "use strict";

  // Wait for DOM to be ready
  document.addEventListener("DOMContentLoaded", function () {
    initConfirmationPage();
  });

  /**
   * Initialize confirmation page
   */
  function initConfirmationPage() {
    animateTimelineSteps();
    initCopyOrderId();
    initPrintOrder();
    showSuccessAnimation();
  }

  /**
   * Animate timeline steps sequentially
   */
  function animateTimelineSteps() {
    const steps = document.querySelectorAll(".timeline-step");

    steps.forEach((step, index) => {
      setTimeout(() => {
        step.style.opacity = "0";
        step.style.transform = "translateX(-20px)";

        setTimeout(() => {
          step.style.transition = "all 0.5s ease-out";
          step.style.opacity = "1";
          step.style.transform = "translateX(0)";
        }, 50);
      }, index * 150);
    });
  }

  /**
   * Copy order ID to clipboard
   */
  function initCopyOrderId() {
    const orderIdElement = document.querySelector("[data-order-id]");

    if (!orderIdElement) return;

    orderIdElement.style.cursor = "pointer";
    orderIdElement.title = "Click để sao chép mã đơn hàng";

    orderIdElement.addEventListener("click", function () {
      const orderId = this.getAttribute("data-order-id");

      // Copy to clipboard
      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard
          .writeText(orderId)
          .then(() => {
            showToast("Đã sao chép mã đơn hàng: " + orderId, "success");
          })
          .catch(() => {
            fallbackCopyTextToClipboard(orderId);
          });
      } else {
        fallbackCopyTextToClipboard(orderId);
      }
    });
  }

  /**
   * Fallback copy method for older browsers
   */
  function fallbackCopyTextToClipboard(text) {
    const textArea = document.createElement("textarea");
    textArea.value = text;
    textArea.style.position = "fixed";
    textArea.style.top = "-9999px";
    textArea.style.left = "-9999px";
    document.body.appendChild(textArea);
    textArea.focus();
    textArea.select();

    try {
      const successful = document.execCommand("copy");
      if (successful) {
        showToast("Đã sao chép mã đơn hàng: " + text, "success");
      } else {
        showToast("Không thể sao chép", "error");
      }
    } catch (err) {
      showToast("Không thể sao chép", "error");
    }

    document.body.removeChild(textArea);
  }

  /**
   * Initialize print order functionality
   */
  function initPrintOrder() {
    const printBtn = document.querySelector("[data-print-order]");

    if (!printBtn) return;

    printBtn.addEventListener("click", function (e) {
      e.preventDefault();
      window.print();
    });
  }

  /**
   * Show success animation on page load
   */
  function showSuccessAnimation() {
    const banner = document.querySelector(".success-banner");

    if (!banner) return;

    // Add extra animation class
    banner.style.animation =
      "slideDown 0.5s ease-out, pulse 1s ease-in-out 0.5s";
  }

  /**
   * Show toast notification
   */
  function showToast(message, type = "info") {
    // Remove existing toast
    const existingToast = document.querySelector(".toast-notification");
    if (existingToast) {
      existingToast.remove();
    }

    // Create toast element
    const toast = document.createElement("div");
    toast.className = `toast-notification toast-${type}`;

    const icon =
      type === "success"
        ? "fa-check-circle"
        : type === "error"
        ? "fa-exclamation-circle"
        : "fa-info-circle";

    toast.innerHTML = `
            <i class="fas ${icon}"></i>
            <span>${message}</span>
        `;

    // Add styles
    Object.assign(toast.style, {
      position: "fixed",
      top: "24px",
      right: "24px",
      background:
        type === "success"
          ? "#52c41a"
          : type === "error"
          ? "#ff4d4f"
          : "#1890ff",
      color: "white",
      padding: "16px 24px",
      borderRadius: "8px",
      boxShadow: "0 4px 12px rgba(0, 0, 0, 0.15)",
      display: "flex",
      alignItems: "center",
      gap: "12px",
      fontSize: "14px",
      fontWeight: "500",
      zIndex: "9999",
      animation: "slideDown 0.3s ease-out",
      maxWidth: "400px",
    });

    document.body.appendChild(toast);

    // Auto remove after 3 seconds
    setTimeout(() => {
      toast.style.animation = "fadeOut 0.3s ease-out";
      setTimeout(() => {
        toast.remove();
      }, 300);
    }, 3000);
  }

  /**
   * Add print styles dynamically
   */
  const printStyles = document.createElement("style");
  printStyles.textContent = `
        @media print {
            body * {
                visibility: hidden;
            }
            .confirmation-container,
            .confirmation-container * {
                visibility: visible;
            }
            .confirmation-container {
                position: absolute;
                left: 0;
                top: 0;
                width: 100%;
            }
            .action-buttons,
            .qr-code-card,
            header,
            footer,
            .success-banner-icon {
                display: none !important;
            }
            .confirmation-layout {
                grid-template-columns: 1fr !important;
            }
            .sidebar-sticky {
                page-break-before: always;
            }
        }

        @keyframes fadeOut {
            from {
                opacity: 1;
                transform: translateY(0);
            }
            to {
                opacity: 0;
                transform: translateY(-20px);
            }
        }
    `;
  document.head.appendChild(printStyles);
})();
