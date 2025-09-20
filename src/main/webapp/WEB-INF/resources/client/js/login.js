/**
 * JavaScript cho trang đăng nhập - Marketplace
 * Xử lý validation và tương tác form
 */

document.addEventListener("DOMContentLoaded", function () {
  // Khởi tạo các elements
  const loginForm = document.getElementById("loginForm");
  const emailInput = document.getElementById("email");
  const passwordInput = document.getElementById("password");
  const rememberMeCheckbox = document.getElementById("rememberMe");
  const loginButton = document.getElementById("submitBtn");

  // Biến state cho validation
  let isFormValid = false;

  /**
   * Kiểm tra email hợp lệ
   */
  function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  /**
   * Hiển thị thông báo lỗi cho input
   */
  function showError(input, message) {
    input.classList.add("is-invalid");
    input.classList.remove("is-valid");

    let errorElement = input.parentNode.querySelector(".invalid-feedback");
    if (!errorElement) {
      errorElement = document.createElement("div");
      errorElement.className = "invalid-feedback";
      input.parentNode.appendChild(errorElement);
    }
    errorElement.textContent = message;
    errorElement.style.display = "block";
  }

  /**
   * Hiển thị thông báo thành công cho input
   */
  function showSuccess(input) {
    input.classList.add("is-valid");
    input.classList.remove("is-invalid");

    const errorElement = input.parentNode.querySelector(".invalid-feedback");
    if (errorElement) {
      errorElement.textContent = "";
      errorElement.style.display = "none";
    }
  }

  /**
   * Xóa tất cả validation messages
   */
  function clearValidation(input) {
    input.classList.remove("is-valid", "is-invalid");
    const errorElement = input.parentNode.querySelector(".invalid-feedback");
    if (errorElement) {
      errorElement.textContent = "";
      errorElement.style.display = "none";
    }
  }

  /**
   * Ẩn error message cho input
   */
  function hideError(input) {
    input.classList.remove("is-invalid");
    const errorElement = input.parentNode.querySelector(".invalid-feedback");
    if (errorElement) {
      errorElement.textContent = "";
      errorElement.style.display = "none";
    }
  }

  /**
   * Validate email field
   */
  function validateEmail() {
    const email = emailInput.value.trim();

    if (email === "") {
      showError(emailInput, "Vui lòng nhập email");
      return false;
    }

    if (!isValidEmail(email)) {
      showError(emailInput, "Email không hợp lệ");
      return false;
    }

    hideError(emailInput);
    return true;
  }

  /**
   * Validate password field
   */
  function validatePassword() {
    const password = passwordInput.value;

    if (password === "") {
      showError(passwordInput, "Vui lòng nhập mật khẩu");
      return false;
    }

    if (password.length < 6) {
      showError(passwordInput, "Mật khẩu phải có ít nhất 6 ký tự");
      return false;
    }

    hideError(passwordInput);
    return true;
  }

  /**
   * Validate toàn bộ form
   */
  function validateForm() {
    const isEmailValid = validateEmail();
    const isPasswordValid = validatePassword();

    isFormValid = isEmailValid && isPasswordValid;

    // Enable/disable login button
    if (loginButton) {
      loginButton.disabled = !isFormValid;
    }

    return isFormValid;
  }

  /**
   * Xử lý submit form
   */
  function handleFormSubmit(event) {
    event.preventDefault();

    // Validate form trước khi submit
    if (!validateForm()) {
      return false;
    }

    // Hiển thị loading state
    loginButton.classList.add("loading");
    loginButton.disabled = true;

    // Tạo FormData để submit
    const formData = new FormData(loginForm);
    console.log("🚀 ~ handleFormSubmit ~ formData:", formData);

    // Gửi request đến server
    fetch("/login", {
      method: "POST",
      body: formData,
      headers: {
        "X-Requested-With": "XMLHttpRequest",
      },
    })
      .then((response) => {
        if (response.ok) {
          return response.json();
        }
        throw new Error("Network response was not ok");
      })
      .then((data) => {
        if (data.success) {
          // Đăng nhập thành công
          showLoginSuccess("Đăng nhập thành công!");

          // Chuyển hướng sau 1 giây
          setTimeout(() => {
            window.location.href = data.redirectUrl || "/";
          }, 1000);
        } else {
          // Đăng nhập thất bại
          showLoginError(data.message || "Email hoặc mật khẩu không đúng");
        }
      })
      .catch((error) => {
        console.error("Login error:", error);
        showLoginError("Có lỗi xảy ra. Vui lòng thử lại sau.");
      })
      .finally(() => {
        // Ẩn loading state
        loginButton.classList.remove("loading");
        loginButton.disabled = false;
      });

    return false;
  }

  /**
   * Hiển thị thông báo thành công
   */
  function showLoginSuccess(message) {
    hideAllAlerts();
    const alertHtml = `
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        `;
    loginForm.insertAdjacentHTML("afterbegin", alertHtml);
  }

  /**
   * Hiển thị thông báo lỗi
   */
  function showLoginError(message) {
    hideAllAlerts();
    const alertHtml = `
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        `;
    loginForm.insertAdjacentHTML("afterbegin", alertHtml);
  }

  /**
   * Ẩn tất cả alert messages
   */
  function hideAllAlerts() {
    const alerts = loginForm.querySelectorAll(".alert");
    alerts.forEach((alert) => alert.remove());
  }

  /**
   * Lưu/xóa thông tin "Remember Me"
   */
  function handleRememberMe() {
    if (rememberMeCheckbox.checked) {
      localStorage.setItem("rememberEmail", emailInput.value);
    } else {
      localStorage.removeItem("rememberEmail");
    }
  }

  /**
   * Khôi phục email đã lưu
   */
  function restoreSavedEmail() {
    const savedEmail = localStorage.getItem("rememberEmail");
    if (savedEmail) {
      emailInput.value = savedEmail;
      rememberMeCheckbox.checked = true;
    }
  }

  // Event Listeners
  if (emailInput) {
    emailInput.addEventListener("blur", validateEmail);
  }

  if (passwordInput) {
    passwordInput.addEventListener("blur", validatePassword);
  }

  if (loginForm) {
    loginForm.addEventListener("submit", handleFormSubmit);
  }

  if (rememberMeCheckbox) {
    rememberMeCheckbox.addEventListener("change", handleRememberMe);
  }

  // Enter key để submit form
  document.addEventListener("keypress", function (event) {
    if (
      event.key === "Enter" &&
      document.activeElement &&
      (document.activeElement === emailInput ||
        document.activeElement === passwordInput)
    ) {
      event.preventDefault();
      if (isFormValid) {
        loginForm.dispatchEvent(new Event("submit"));
      }
    }
  });

  // Khôi phục email đã lưu khi trang load
  restoreSavedEmail();

  // Auto-focus vào email input
  if (emailInput && !emailInput.value) {
    emailInput.focus();
  } else if (passwordInput && emailInput.value) {
    passwordInput.focus();
  }

  // Tự động ẩn alerts sau 5 giây
  setTimeout(() => {
    const alerts = document.querySelectorAll(".alert:not(.alert-permanent)");
    alerts.forEach((alert) => {
      if (alert.classList.contains("show")) {
        alert.classList.remove("show");
        setTimeout(() => alert.remove(), 150);
      }
    });
  }, 5000);
});

/**
 * Utility functions for external use
 */
window.LoginPage = {
  /**
   * Programmatically trigger login
   */
  login: function (email, password, remember = false) {
    const emailInput = document.getElementById("email");
    const passwordInput = document.getElementById("password");
    const rememberCheckbox = document.getElementById("rememberMe");
    const loginForm = document.getElementById("loginForm");

    if (emailInput) emailInput.value = email;
    if (passwordInput) passwordInput.value = password;
    if (rememberCheckbox) rememberCheckbox.checked = remember;

    if (loginForm) {
      loginForm.dispatchEvent(new Event("submit"));
    }
  },

  /**
   * Clear all form data
   */
  clearForm: function () {
    const loginForm = document.getElementById("loginForm");
    if (loginForm) {
      loginForm.reset();
      const inputs = loginForm.querySelectorAll(".form-control");
      inputs.forEach((input) => {
        input.classList.remove("is-valid", "is-invalid");
      });
    }
  },

  /**
   * Focus on email input
   */
  focusEmail: function () {
    const emailInput = document.getElementById("email");
    if (emailInput) {
      emailInput.focus();
    }
  },
};
