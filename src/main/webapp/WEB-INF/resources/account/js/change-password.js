// Change Password Page JavaScript Functions

// Toggle password visibility
function togglePassword(fieldId) {
  const field = document.getElementById(fieldId);
  const button = field.nextElementSibling;
  const icon = button.querySelector("i");

  if (field.type === "password") {
    field.type = "text";
    icon.classList.remove("fa-eye");
    icon.classList.add("fa-eye-slash");
  } else {
    field.type = "password";
    icon.classList.remove("fa-eye-slash");
    icon.classList.add("fa-eye");
  }
}

// Password strength checker
function checkPasswordStrength(password) {
  let strength = 0;
  const requirements = {
    "req-length": password.length >= 8,
    "req-uppercase": /[A-Z]/.test(password),
    "req-lowercase": /[a-z]/.test(password),
    "req-number": /\d/.test(password),
  };

  // Update requirement indicators
  Object.keys(requirements).forEach((reqId) => {
    const element = document.getElementById(reqId);
    if (requirements[reqId]) {
      element.classList.add("valid");
      element.classList.remove("invalid");
      element.querySelector("i").classList.remove("fa-circle");
      element.querySelector("i").classList.add("fa-check-circle");
      strength++;
    } else {
      element.classList.add("invalid");
      element.classList.remove("valid");
      element.querySelector("i").classList.remove("fa-check-circle");
      element.querySelector("i").classList.add("fa-circle");
    }
  });

  // Update strength bar
  const strengthFill = document.getElementById("strengthFill");
  const strengthText = document.getElementById("strengthText");

  const percentage = (strength / 4) * 100;
  strengthFill.style.width = percentage + "%";

  if (strength === 0) {
    strengthFill.style.background = "#e2e8f0";
    strengthText.textContent = "Độ mạnh mật khẩu";
    strengthText.style.color = "#718096";
  } else if (strength === 1) {
    strengthFill.style.background = "#e53e3e";
    strengthText.textContent = "Yếu";
    strengthText.style.color = "#e53e3e";
  } else if (strength === 2) {
    strengthFill.style.background = "#fd7f12";
    strengthText.textContent = "Trung bình";
    strengthText.style.color = "#fd7f12";
  } else if (strength === 3) {
    strengthFill.style.background = "#38a169";
    strengthText.textContent = "Mạnh";
    strengthText.style.color = "#38a169";
  } else {
    strengthFill.style.background = "#00d084";
    strengthText.textContent = "Rất mạnh";
    strengthText.style.color = "#00d084";
  }

  return strength;
}

// Check password match
function checkPasswordMatch() {
  const newPassword = document.getElementById("newPassword").value;
  const confirmPassword = document.getElementById("confirmPassword").value;
  const matchElement = document.getElementById("confirmMatch");

  if (confirmPassword && newPassword !== confirmPassword) {
    matchElement.style.display = "flex";
    return false;
  } else {
    matchElement.style.display = "none";
    return true;
  }
}

// Initialize page functionality
document.addEventListener("DOMContentLoaded", function () {
  // Form submission with loading state
  document
    .getElementById("changePasswordForm")
    .addEventListener("submit", function (e) {
      const submitBtn = document.getElementById("submitBtn");
      const spinner = document.getElementById("loadingSpinner");

      // Check password match before submission
      if (!checkPasswordMatch()) {
        e.preventDefault();
        return;
      }

      // Show loading state
      submitBtn.disabled = true;
      spinner.style.display = "block";
      submitBtn.innerHTML =
        '<div class="loading-spinner"></div>Đang cập nhật...';

      // Re-enable button after 5 seconds (in case of error)
      setTimeout(() => {
        submitBtn.disabled = false;
        spinner.style.display = "none";
        submitBtn.innerHTML =
          '<i class="fas fa-save me-2"></i>Cập nhật mật khẩu';
      }, 5000);
    });

  // Event listeners for password validation
  document.getElementById("newPassword").addEventListener("input", function () {
    checkPasswordStrength(this.value);
  });

  document
    .getElementById("confirmPassword")
    .addEventListener("input", function () {
      checkPasswordMatch();
    });

  // Auto-hide alerts after 5 seconds
  setTimeout(function () {
    const alerts = document.querySelectorAll(".alert-modern");
    alerts.forEach((alert) => {
      alert.style.transition = "opacity 0.5s ease";
      alert.style.opacity = "0";
      setTimeout(() => alert.remove(), 500);
    });
  }, 5000);

  // Add subtle animations on focus
  document.querySelectorAll(".form-control-modern").forEach((input) => {
    input.addEventListener("focus", function () {
      this.parentElement.style.transform = "scale(1.02)";
    });

    input.addEventListener("blur", function () {
      this.parentElement.style.transform = "scale(1)";
    });
  });
});
