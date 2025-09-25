let currentStep = 1;
const totalSteps = 3;

// Validation rules for each step
const stepValidation = {
  1: function () {
    const displayName = document
      .querySelector('[name="displayName"]')
      .value.trim();
    const description = document
      .querySelector('[name="description"]')
      .value.trim();

    if (!displayName) {
      showError("Vui lòng nhập tên hiển thị của cửa hàng");
      return false;
    }
    return true;
  },
  2: function () {
    const phone = document.querySelector('[name="contactPhone"]').value.trim();
    const pickupAddress = document
      .querySelector('[name="pickupAddress"]')
      .value.trim();
    const returnAddress = document
      .querySelector('[name="returnAddress"]')
      .value.trim();

    if (!phone) {
      showError("Vui lòng nhập số điện thoại liên hệ");
      return false;
    }
    if (!pickupAddress) {
      showError("Vui lòng nhập địa chỉ lấy hàng");
      return false;
    }
    if (!returnAddress) {
      showError("Vui lòng nhập địa chỉ trả hàng");
      return false;
    }

    // Validate phone number format
    if (!/^[0-9]{10}$/.test(phone)) {
      showError("Số điện thoại không hợp lệ (phải có 10 chữ số)");
      return false;
    }

    return true;
  },
  3: function () {
    const bankCode = document.querySelector('[name="bankCode"]').value.trim();
    const bankAccountNo = document
      .querySelector('[name="bankAccountNo"]')
      .value.trim();
    const bankAccountName = document
      .querySelector('[name="bankAccountName"]')
      .value.trim();

    if (!bankCode) {
      showError("Vui lòng nhập mã ngân hàng");
      return false;
    }
    if (!bankAccountNo) {
      showError("Vui lòng nhập số tài khoản");
      return false;
    }
    if (!bankAccountName) {
      showError("Vui lòng nhập tên chủ tài khoản");
      return false;
    }

    // Validate bank account number format
    if (!/^[0-9]{8,20}$/.test(bankAccountNo)) {
      showError("Số tài khoản không hợp lệ (phải có 8-20 chữ số)");
      return false;
    }

    return true;
  },
};

function showError(message) {
  // Remove existing error message if any
  const existingError = document.querySelector(".error-feedback");
  if (existingError) {
    existingError.remove();
  }

  // Create and show new error message
  const error = document.createElement("div");
  error.className = "error-feedback";
  error.innerHTML = `<i class="fas fa-exclamation-circle"></i> ${message}`;

  const currentSection = document.querySelector(".form-section.active");
  currentSection.appendChild(error);

  // Add show class after a small delay for animation
  setTimeout(() => error.classList.add("show"), 10);

  // Remove error after 3 seconds
  setTimeout(() => {
    error.classList.remove("show");
    setTimeout(() => error.remove(), 500);
  }, 3000);
}

function updateSteps() {
  // Update steps UI with smooth transitions
  document.querySelectorAll(".step").forEach((step, index) => {
    if (index + 1 < currentStep) {
      step.classList.add("completed");
      step.classList.remove("active");
    } else if (index + 1 === currentStep) {
      step.classList.add("active");
      step.classList.remove("completed");
    } else {
      step.classList.remove("active", "completed");
    }
  });

  // Show/hide form sections with animation
  document.querySelectorAll(".form-section").forEach((section, index) => {
    if (index + 1 === currentStep) {
      section.classList.add("active");
    } else {
      section.classList.remove("active");
    }
  });

  // Update navigation buttons
  const navButtons = document.querySelector(".form-navigation");
  if (currentStep === totalSteps) {
    navButtons.innerHTML =
      '<button type="button" class="nav-button prev-button" onclick="prevStep()">' +
      '<i class="fas fa-arrow-left"></i> Quay lại</button>' +
      '<button type="submit" class="nav-button submit-button">' +
      '<i class="fas fa-paper-plane"></i> Gửi đăng ký</button>';
  } else {
    var html = "";
    if (currentStep > 1) {
      html +=
        '<button type="button" class="nav-button prev-button" onclick="prevStep()">' +
        '<i class="fas fa-arrow-left"></i> Quay lại</button>';
    }
    html +=
      '<button type="button" class="nav-button next-button" onclick="nextStep()">' +
      '<i class="fas fa-arrow-right"></i> Tiếp theo</button>';
    navButtons.innerHTML = html;
  }
}

function nextStep() {
  // Validate current step before proceeding
  if (stepValidation[currentStep]()) {
    if (currentStep < totalSteps) {
      currentStep++;
      updateSteps();
    }
  }
}

function prevStep() {
  if (currentStep > 1) {
    currentStep--;
    updateSteps();
  }
}

// Initialize steps
document.addEventListener("DOMContentLoaded", function () {
  updateSteps();

  // Add input event listeners for real-time validation
  document.querySelectorAll("input, textarea").forEach((input) => {
    input.addEventListener("input", function () {
      this.classList.remove("error");
      const feedback = this.parentElement.querySelector(".error-feedback");
      if (feedback) {
        feedback.remove();
      }
    });
  });
});
