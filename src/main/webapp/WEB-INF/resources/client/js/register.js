/**
 * JavaScript cho trang đăng ký - Marketplace
 * Xử lý validation form và tương tác người dùng
 */

document.addEventListener("DOMContentLoaded", function () {
  // Các phần tử DOM
  const form = document.getElementById("registerForm");
  const firstName = document.getElementById("firstName");
  const lastName = document.getElementById("lastName");
  const email = document.getElementById("email");
  const password = document.getElementById("password");
  const confirmPassword = document.getElementById("confirmPassword");
  const termsCheck = document.getElementById("termsCheck");
  const submitBtn = document.getElementById("submitBtn");

  // Khởi tạo password toggle
  initPasswordToggle();

  // Khởi tạo validation
  initValidation();

  /**
   * Khởi tạo password toggle functionality
   */
  function initPasswordToggle() {
    const togglePassword = document.getElementById("togglePassword");
    const toggleConfirmPassword = document.getElementById(
      "toggleConfirmPassword"
    );

    if (togglePassword) {
      togglePassword.addEventListener("click", function () {
        togglePasswordVisibility(password, this);
      });
    }

    if (toggleConfirmPassword) {
      toggleConfirmPassword.addEventListener("click", function () {
        togglePasswordVisibility(confirmPassword, this);
      });
    }
  }

  /**
   * Toggle password visibility
   */
  function togglePasswordVisibility(passwordField, toggleBtn) {
    const icon = toggleBtn.querySelector("i");

    if (passwordField.type === "password") {
      passwordField.type = "text";
      icon.classList.remove("fa-eye");
      icon.classList.add("fa-eye-slash");
    } else {
      passwordField.type = "password";
      icon.classList.remove("fa-eye-slash");
      icon.classList.add("fa-eye");
    }
  }

  /**
   * Khởi tạo validation
   */
  function initValidation() {
    // Password strength check
    if (password) {
      password.addEventListener("input", function () {
        checkPasswordStrength(this.value);
      });

      password.addEventListener("blur", function () {
        validatePassword();
      });
    }

    // Confirm password validation
    if (confirmPassword) {
      confirmPassword.addEventListener("input", function () {
        validateConfirmPassword();
      });

      confirmPassword.addEventListener("blur", function () {
        validateConfirmPassword();
      });
    }

    // Email validation
    if (email) {
      email.addEventListener("blur", function () {
        validateEmail();
      });
    }

    // Name validation
    if (firstName) {
      firstName.addEventListener("blur", function () {
        validateName(this, "firstNameError", "Họ");
      });
    }

    if (lastName) {
      lastName.addEventListener("blur", function () {
        validateName(this, "lastNameError", "Tên");
      });
    }

    // Form submission - chỉ validate, không ngăn submit
    if (form) {
      form.addEventListener("submit", function (e) {
        if (!validateForm()) {
          e.preventDefault(); // Chỉ ngăn submit khi validation fail
          return false;
        }
        // Cho phép form submit bình thường đến controller
      });
    }
  }

  /**
   * Hiển thị thông báo thành công
   */
  function showSuccess(message) {
    hideAllAlerts();
    const alertHtml = `
      <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fas fa-check-circle me-2"></i>
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    `;
    form.insertAdjacentHTML("afterbegin", alertHtml);
  }

  /**
   * Hiển thị thông báo lỗi
   */
  function showError(message) {
    hideAllAlerts();
    const alertHtml = `
      <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="fas fa-exclamation-circle me-2"></i>
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    `;
    form.insertAdjacentHTML("afterbegin", alertHtml);
  }

  /**
   * Ẩn tất cả alert messages
   */
  function hideAllAlerts() {
    const alerts = form.querySelectorAll(".alert");
    alerts.forEach((alert) => alert.remove());
  }

  /**
   * Check password strength
   */
  function checkPasswordStrength(passwordValue) {
    const strengthBar = document.getElementById("passwordStrength");
    const passwordError = document.getElementById("passwordError");

    if (!strengthBar) return;

    let strength = 0;
    let feedback = "";

    // Reset classes
    strengthBar.className = "password-strength";

    if (passwordValue.length === 0) {
      passwordError.textContent = "";
      passwordError.style.display = "none";
      return;
    }

    // Kiểm tra độ dài
    if (passwordValue.length >= 8) {
      strength++;
    } else {
      feedback = "Mật khẩu phải có ít nhất 8 ký tự";
    }

    // Kiểm tra chữ hoa
    if (/[A-Z]/.test(passwordValue)) {
      strength++;
    } else if (passwordValue.length >= 8) {
      feedback = "Thêm chữ hoa để tăng độ bảo mật";
    }

    // Kiểm tra chữ thường
    if (/[a-z]/.test(passwordValue)) {
      strength++;
    }

    // Kiểm tra số
    if (/[0-9]/.test(passwordValue)) {
      strength++;
    } else if (passwordValue.length >= 8 && strength >= 2) {
      feedback = "Thêm số để tăng độ bảo mật";
    }

    // Kiểm tra ký tự đặc biệt
    if (/[^A-Za-z0-9]/.test(passwordValue)) {
      strength++;
    } else if (passwordValue.length >= 8 && strength >= 3) {
      feedback = "Thêm ký tự đặc biệt để tăng độ bảo mật";
    }

    // Cập nhật thanh độ mạnh
    if (strength < 3) {
      strengthBar.classList.add("weak");
      if (!feedback) feedback = "Mật khẩu yếu";
    } else if (strength < 4) {
      strengthBar.classList.add("medium");
      if (!feedback) feedback = "Mật khẩu trung bình";
    } else {
      strengthBar.classList.add("strong");
      feedback = "Mật khẩu mạnh";
    }

    // Hiển thị feedback
    if (passwordError) {
      if (strength >= 3 || passwordValue.length === 0) {
        passwordError.textContent = "";
        passwordError.style.display = "none";
      } else {
        passwordError.textContent = feedback;
        passwordError.style.display = "block";
      }
    }
  }

  /**
   * Validate password
   */
  function validatePassword() {
    const passwordError = document.getElementById("passwordError");

    if (!password || !passwordError) return;

    if (password.value.length === 0) {
      showFieldError(passwordError, "");
      password.classList.remove("is-valid", "is-invalid");
      return;
    }

    if (password.value.length < 8) {
      showFieldError(passwordError, "Mật khẩu phải có ít nhất 8 ký tự");
      password.classList.add("is-invalid");
      password.classList.remove("is-valid");
    } else {
      hideError(passwordError);
      password.classList.add("is-valid");
      password.classList.remove("is-invalid");
    }
  }

  /**
   * Validate confirm password
   */
  function validateConfirmPassword() {
    const confirmPasswordError = document.getElementById(
      "confirmPasswordError"
    );

    if (!confirmPassword || !password || !confirmPasswordError) return;

    if (confirmPassword.value === "") {
      hideError(confirmPasswordError);
      confirmPassword.classList.remove("is-valid", "is-invalid");
      return;
    }

    if (confirmPassword.value !== password.value) {
      showFieldError(confirmPasswordError, "Mật khẩu xác nhận không khớp");
      confirmPassword.classList.add("is-invalid");
      confirmPassword.classList.remove("is-valid");
    } else {
      hideError(confirmPasswordError);
      confirmPassword.classList.add("is-valid");
      confirmPassword.classList.remove("is-invalid");
    }
  }

  /**
   * Validate email
   */
  function validateEmail() {
    const emailError = document.getElementById("emailError");

    if (!email || !emailError) return;

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (email.value === "") {
      hideError(emailError);
      email.classList.remove("is-valid", "is-invalid");
      return;
    }

    if (!emailRegex.test(email.value)) {
      showFieldError(emailError, "Vui lòng nhập email hợp lệ");
      email.classList.add("is-invalid");
      email.classList.remove("is-valid");
    } else {
      hideError(emailError);
      email.classList.add("is-valid");
      email.classList.remove("is-invalid");
    }
  }

  /**
   * Validate name fields
   */
  function validateName(nameField, errorId, fieldName) {
    const errorElement = document.getElementById(errorId);

    if (!nameField || !errorElement) return;

    if (nameField.value.trim() === "") {
      hideError(errorElement);
      nameField.classList.remove("is-valid", "is-invalid");
      return;
    }

    if (nameField.value.trim().length < 2) {
      showFieldError(errorElement, fieldName + " phải có ít nhất 2 ký tự");
      nameField.classList.add("is-invalid");
      nameField.classList.remove("is-valid");
    } else {
      hideError(errorElement);
      nameField.classList.add("is-valid");
      nameField.classList.remove("is-invalid");
    }
  }

  /**
   * Validate entire form
   */
  function validateForm() {
    let isValid = true;

    // Validate required fields
    const requiredFields = [
      { field: firstName, errorId: "firstNameError", name: "Họ" },
      { field: lastName, errorId: "lastNameError", name: "Tên" },
      { field: email, errorId: "emailError", name: "Email" },
      { field: password, errorId: "passwordError", name: "Mật khẩu" },
      {
        field: confirmPassword,
        errorId: "confirmPasswordError",
        name: "Xác nhận mật khẩu",
      },
    ];

    requiredFields.forEach(({ field, errorId, name }) => {
      if (field && field.value.trim() === "") {
        showFieldError(
          document.getElementById(errorId),
          name + " không được để trống"
        );
        field.classList.add("is-invalid");
        isValid = false;
      }
    });

    // Validate email format
    if (
      email &&
      email.value &&
      !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value)
    ) {
      showFieldError(
        document.getElementById("emailError"),
        "Vui lòng nhập email hợp lệ"
      );
      email.classList.add("is-invalid");
      isValid = false;
    }

    // Validate password strength
    if (password && password.value && password.value.length < 8) {
      showFieldError(
        document.getElementById("passwordError"),
        "Mật khẩu phải có ít nhất 8 ký tự"
      );
      password.classList.add("is-invalid");
      isValid = false;
    }

    // Validate password confirmation
    if (
      confirmPassword &&
      password &&
      confirmPassword.value !== password.value
    ) {
      showFieldError(
        document.getElementById("confirmPasswordError"),
        "Mật khẩu xác nhận không khớp"
      );
      confirmPassword.classList.add("is-invalid");
      isValid = false;
    }

    // Validate terms checkbox
    if (termsCheck && !termsCheck.checked) {
      showFieldError(
        document.getElementById("termsError"),
        "Bạn phải đồng ý với điều khoản sử dụng"
      );
      isValid = false;
    }

    return isValid;
  }

  /**
   * Show field validation error message
   */
  function showFieldError(errorElement, message) {
    if (errorElement) {
      errorElement.textContent = message;
      errorElement.style.display = "block";
    }
  }

  /**
   * Hide error message
   */
  function hideError(errorElement) {
    if (errorElement) {
      errorElement.textContent = "";
      errorElement.style.display = "none";
    }
  }
});
