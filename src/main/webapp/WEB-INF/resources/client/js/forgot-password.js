/**
 * JavaScript cho trang Forgot Password - Marketplace
 * Xử lý validation form và user experience
 */

document.addEventListener("DOMContentLoaded", function () {
  // Khởi tạo các chức năng
  initializeForgotPasswordForm();
  initializeValidation();
  initializeResendButton();
  initializeAnimations();

  // Khởi tạo form forgot password
  function initializeForgotPasswordForm() {
    const form = document.getElementById("forgotPasswordForm");
    const emailInput = document.getElementById("email");
    const submitBtn = document.getElementById("submitBtn");

    if (form) {
      form.addEventListener("submit", function (e) {
        const email = emailInput.value.trim();

        if (!validateEmail(email)) {
          e.preventDefault(); // Chỉ ngăn submit khi validation fail
          showEmailError("Vui lòng nhập email hợp lệ");
          return false;
        }
        // Cho phép form submit bình thường khi validation pass
      });
    }

    // Auto clear errors khi người dùng nhập lại
    if (emailInput) {
      emailInput.addEventListener("input", function () {
        clearEmailError();
        if (this.value.trim()) {
          this.classList.remove("is-invalid");
        }
      });
    }
  }

  // Validate email
  function validateEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return email && emailRegex.test(email);
  }

  // Hiển thị step thành công (không dùng nữa vì form submit redirect)
  function showSuccessStep(email) {
    const step1 = document.getElementById("step1");
    const step2 = document.getElementById("step2");
    const emailSent = document.getElementById("emailSent");

    if (step1 && step2) {
      step1.classList.remove("active");
      step2.classList.add("active");

      if (emailSent) {
        emailSent.textContent = email;
      }

      // Auto scroll to top
      window.scrollTo({ top: 0, behavior: "smooth" });
    }
  }

  // Hiển thị lỗi email
  function showEmailError(message) {
    const emailInput = document.getElementById("email");
    const emailError = document.getElementById("emailError");

    if (emailInput && emailError) {
      emailInput.classList.add("is-invalid");
      emailError.textContent = message;
    }
  }

  // Xóa lỗi email
  function clearEmailError() {
    const emailInput = document.getElementById("email");
    const emailError = document.getElementById("emailError");

    if (emailInput && emailError) {
      emailInput.classList.remove("is-invalid");
      emailError.textContent = "";
    }
  }

  // Khởi tạo validation realtime
  function initializeValidation() {
    const emailInput = document.getElementById("email");

    if (emailInput) {
      emailInput.addEventListener("blur", function () {
        const email = this.value.trim();
        if (email && !validateEmail(email)) {
          showEmailError("Định dạng email không hợp lệ");
        } else if (email) {
          clearEmailError();
        }
      });

      // Show validation status
      emailInput.addEventListener("input", function () {
        const email = this.value.trim();
        if (email && validateEmail(email)) {
          this.classList.add("is-valid");
          this.classList.remove("is-invalid");
        } else {
          this.classList.remove("is-valid");
        }
      });
    }
  }

  // Khởi tạo nút gửi lại
  function initializeResendButton() {
    const resendBtn = document.getElementById("resendBtn");

    if (resendBtn) {
      resendBtn.addEventListener("click", function () {
        const email = document.getElementById("emailSent").textContent;

        // Disable button temporarily
        this.disabled = true;
        this.innerHTML =
          '<i class="fas fa-spinner fa-spin me-2"></i>Đang gửi...';

        // Simulate resend
        setTimeout(() => {
          this.disabled = false;
          this.innerHTML = '<i class="fas fa-redo me-2"></i>Gửi lại';

          // Show success message
          showResendSuccess();
        }, 2000);
      });
    }
  }

  // Hiển thị thông báo gửi lại thành công
  function showResendSuccess() {
    // Create temporary success message
    const resendSection = document.querySelector(".resend-section");
    const existingMessage = resendSection.querySelector(".resend-success");

    if (existingMessage) {
      existingMessage.remove();
    }

    const successMessage = document.createElement("div");
    successMessage.className = "resend-success alert alert-success mt-2";
    successMessage.innerHTML =
      '<i class="fas fa-check-circle me-2"></i>Email đã được gửi lại!';

    resendSection.appendChild(successMessage);

    // Auto remove after 3 seconds
    setTimeout(() => {
      successMessage.remove();
    }, 3000);
  }

  // Khởi tạo animations
  function initializeAnimations() {
    // Animate form elements on load
    const formElements = document.querySelectorAll(
      ".forgot-form-container > *"
    );
    formElements.forEach((element, index) => {
      element.style.opacity = "0";
      element.style.transform = "translateY(20px)";

      setTimeout(() => {
        element.style.transition = "all 0.5s ease";
        element.style.opacity = "1";
        element.style.transform = "translateY(0)";
      }, index * 100);
    });

    // Add hover effects to interactive elements
    const interactiveElements = document.querySelectorAll(
      ".btn-back, .help-link, .form-footer a"
    );
    interactiveElements.forEach((element) => {
      element.addEventListener("mouseenter", function () {
        this.style.transform = "translateX(3px)";
      });

      element.addEventListener("mouseleave", function () {
        this.style.transform = "translateX(0)";
      });
    });
  }

  // Auto dismiss alerts
  const alerts = document.querySelectorAll(".alert");
  alerts.forEach((alert) => {
    if (alert.classList.contains("alert-success")) {
      setTimeout(() => {
        alert.style.transition = "opacity 0.5s ease";
        alert.style.opacity = "0";
        setTimeout(() => {
          alert.remove();
        }, 500);
      }, 5000);
    }
  });

  // Handle back to login
  const backLink = document.querySelector(".btn-back");
  if (backLink) {
    backLink.addEventListener("click", function (e) {
      e.preventDefault();

      // Add loading effect
      this.innerHTML =
        '<i class="fas fa-spinner fa-spin me-2"></i>Đang chuyển...';

      setTimeout(() => {
        window.location.href = this.href;
      }, 500);
    });
  }
});

// Utility functions
function isValidEmail(email) {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

// Export for external use
window.ForgotPasswordUtils = {
  isValidEmail,
};
