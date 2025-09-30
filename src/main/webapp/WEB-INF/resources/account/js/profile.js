/**
 * Profile Page JavaScript
 * Enhanced interactive functionality for account profile management
 */

document.addEventListener("DOMContentLoaded", function () {
  // Initialize profile manager
  const profileManager = new ProfileManager();
});

class ProfileManager {
  constructor() {
    this.init();
    this.bindEvents();
  }

  init() {
    // Cache DOM elements
    this.elements = {
      avatarFile: document.getElementById("avatarFile"),
      avatarPreview: document.getElementById("avatarPreview"),
      profileForm: document.getElementById("profileForm"),
      saveBtn: document.getElementById("saveBtn"),
      alerts: document.querySelectorAll(".alert-modern"),
      formInputs: document.querySelectorAll(".form-input"),
      avatarUpload: document.querySelector(".avatar-upload"),
    };

    // Configuration
    this.config = {
      maxFileSize: 5 * 1024 * 1024, // 5MB
      allowedTypes: [
        "image/jpeg",
        "image/jpg",
        "image/png",
        "image/gif",
        "image/webp",
      ],
      alertTimeout: 5000,
    };

    this.setupValidation();
    this.setupAutoHideAlerts();
  }

  bindEvents() {
    // Avatar upload functionality
    if (this.elements.avatarFile) {
      this.elements.avatarFile.addEventListener("change", (e) =>
        this.handleAvatarChange(e)
      );
    }

    // Form submission with loading state
    if (this.elements.profileForm && this.elements.saveBtn) {
      this.elements.profileForm.addEventListener("submit", (e) =>
        this.handleFormSubmit(e)
      );
    }

    // Enhanced form validation
    this.elements.formInputs.forEach((input) => {
      input.addEventListener("blur", () => this.validateField(input));
      input.addEventListener("input", () => this.clearFieldError(input));
    });

    // Drag and drop for avatar upload
    this.setupDragAndDrop();

    // Keyboard shortcuts
    document.addEventListener("keydown", (e) =>
      this.handleKeyboardShortcuts(e)
    );
  }

  handleAvatarChange(e) {
    const file = e.target.files[0];
    if (!file) return;

    // Validate file
    const validation = this.validateFile(file);
    if (!validation.isValid) {
      this.showNotification(validation.message, "error");
      e.target.value = "";
      return;
    }

    // Preview the image
    this.previewAvatar(file);
  }

  validateFile(file) {
    // Check file size
    if (file.size > this.config.maxFileSize) {
      return {
        isValid: false,
        message: `Kích thước file quá lớn. Vui lòng chọn file nhỏ hơn ${
          this.config.maxFileSize / (1024 * 1024)
        }MB.`,
      };
    }

    // Check file type
    if (!this.config.allowedTypes.includes(file.type)) {
      return {
        isValid: false,
        message:
          "Định dạng file không được hỗ trợ. Vui lòng chọn file JPG, PNG, GIF hoặc WebP.",
      };
    }

    return { isValid: true };
  }

  previewAvatar(file) {
    const reader = new FileReader();

    reader.onload = (e) => {
      const result = e.target.result;

      if (this.elements.avatarPreview) {
        // Update existing image with smooth transition
        this.elements.avatarPreview.style.opacity = "0.5";
        setTimeout(() => {
          this.elements.avatarPreview.src = result;
          this.elements.avatarPreview.style.opacity = "1";
        }, 150);
      } else {
        // Replace placeholder with image
        const placeholder = document.querySelector(".avatar-placeholder");
        if (placeholder) {
          const img = document.createElement("img");
          img.src = result;
          img.className = "avatar-image";
          img.id = "avatarPreview";
          img.alt = "Avatar Preview";

          // Smooth transition
          placeholder.style.opacity = "0";
          setTimeout(() => {
            placeholder.parentNode.replaceChild(img, placeholder);
            this.elements.avatarPreview = img;
            img.style.opacity = "0";
            setTimeout(() => (img.style.opacity = "1"), 50);
          }, 300);
        }
      }

      this.showNotification("Ảnh đã được chọn thành công!", "success");
    };

    reader.onerror = () => {
      this.showNotification("Không thể đọc file ảnh.", "error");
    };

    reader.readAsDataURL(file);
  }

  setupDragAndDrop() {
    if (!this.elements.avatarUpload) return;

    const uploadArea = this.elements.avatarUpload;

    // Prevent default drag behaviors
    ["dragenter", "dragover", "dragleave", "drop"].forEach((eventName) => {
      uploadArea.addEventListener(eventName, this.preventDefaults, false);
      document.body.addEventListener(eventName, this.preventDefaults, false);
    });

    // Highlight drop area when item is dragged over it
    ["dragenter", "dragover"].forEach((eventName) => {
      uploadArea.addEventListener(
        eventName,
        () => this.highlight(uploadArea),
        false
      );
    });

    ["dragleave", "drop"].forEach((eventName) => {
      uploadArea.addEventListener(
        eventName,
        () => this.unhighlight(uploadArea),
        false
      );
    });

    // Handle dropped files
    uploadArea.addEventListener("drop", (e) => this.handleDrop(e), false);
  }

  preventDefaults(e) {
    e.preventDefault();
    e.stopPropagation();
  }

  highlight(element) {
    element.classList.add("drag-highlight");
  }

  unhighlight(element) {
    element.classList.remove("drag-highlight");
  }

  handleDrop(e) {
    const dt = e.dataTransfer;
    const files = dt.files;

    if (files.length > 0) {
      const file = files[0];

      // Update file input
      if (this.elements.avatarFile) {
        const dataTransfer = new DataTransfer();
        dataTransfer.items.add(file);
        this.elements.avatarFile.files = dataTransfer.files;

        // Trigger change event
        this.handleAvatarChange({ target: { files: [file] } });
      }
    }
  }

  setupValidation() {
    this.validationRules = {
      email: {
        required: true,
        pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
        message: "Vui lòng nhập email hợp lệ",
      },
      phone: {
        pattern: /^[0-9]{10,11}$/,
        message: "Số điện thoại phải có 10-11 chữ số",
      },
      fullName: {
        required: true,
        minLength: 2,
        message: "Họ tên phải có ít nhất 2 ký tự",
      },
    };
  }

  validateField(field) {
    const fieldName = field.name;
    const value = field.value.trim();
    const rules = this.validationRules[fieldName];

    if (!rules) return true;

    // Clear previous errors
    this.clearFieldError(field);

    // Required validation
    if (rules.required && !value) {
      this.showFieldError(field, "Trường này là bắt buộc");
      return false;
    }

    // Pattern validation
    if (value && rules.pattern && !rules.pattern.test(value)) {
      this.showFieldError(field, rules.message);
      return false;
    }

    // Min length validation
    if (value && rules.minLength && value.length < rules.minLength) {
      this.showFieldError(field, rules.message);
      return false;
    }

    // Mark as valid
    field.classList.add("is-valid");
    return true;
  }

  showFieldError(field, message) {
    field.classList.add("is-invalid");
    field.classList.remove("is-valid");

    // Create error element if it doesn't exist
    let errorElement = field.parentNode.querySelector(".invalid-feedback");
    if (!errorElement) {
      errorElement = document.createElement("div");
      errorElement.className = "invalid-feedback";
      field.parentNode.appendChild(errorElement);
    }

    errorElement.textContent = message;
    errorElement.style.display = "block";
  }

  clearFieldError(field) {
    field.classList.remove("is-invalid");
    const errorElement = field.parentNode.querySelector(".invalid-feedback");
    if (errorElement) {
      errorElement.style.display = "none";
    }
  }

  handleFormSubmit(e) {
    // Validate all fields before submission
    let isValid = true;
    this.elements.formInputs.forEach((input) => {
      if (!this.validateField(input)) {
        isValid = false;
      }
    });

    if (!isValid) {
      e.preventDefault();
      this.showNotification("Vui lòng kiểm tra lại thông tin đã nhập", "error");
      return;
    }

    // Show loading state
    this.setLoadingState(true);

    // Form will submit normally
    // Loading state will be cleared when page reloads
  }

  setLoadingState(loading) {
    if (this.elements.saveBtn) {
      if (loading) {
        this.elements.saveBtn.classList.add("loading");
        this.elements.saveBtn.disabled = true;
      } else {
        this.elements.saveBtn.classList.remove("loading");
        this.elements.saveBtn.disabled = false;
      }
    }
  }

  setupAutoHideAlerts() {
    this.elements.alerts.forEach((alert) => {
      setTimeout(() => {
        this.hideAlert(alert);
      }, this.config.alertTimeout);
    });
  }

  hideAlert(alert) {
    alert.style.opacity = "0";
    alert.style.transform = "translateY(-10px)";
    setTimeout(() => {
      if (alert.parentNode) {
        alert.remove();
      }
    }, 300);
  }

  handleKeyboardShortcuts(e) {
    // Ctrl/Cmd + S to save
    if ((e.ctrlKey || e.metaKey) && e.key === "s") {
      e.preventDefault();
      if (this.elements.profileForm) {
        this.elements.profileForm.dispatchEvent(
          new Event("submit", { bubbles: true })
        );
      }
    }
  }

  showNotification(message, type = "info") {
    // Create notification element
    const notification = document.createElement("div");
    notification.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
    notification.style.cssText = `
            top: 20px;
            right: 20px;
            z-index: 1050;
            min-width: 300px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        `;

    const iconMap = {
      success: "fas fa-check-circle",
      error: "fas fa-exclamation-circle",
      warning: "fas fa-exclamation-triangle",
      info: "fas fa-info-circle",
    };

    notification.innerHTML = `
            <i class="${iconMap[type] || iconMap.info}"></i>
            <span class="ms-2">${message}</span>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;

    document.body.appendChild(notification);

    // Auto remove after 4 seconds
    setTimeout(() => {
      if (notification.parentNode) {
        notification.classList.remove("show");
        setTimeout(() => notification.remove(), 150);
      }
    }, 4000);
  }
}

// Add additional CSS for enhanced functionality
const additionalStyles = document.createElement("style");
additionalStyles.textContent = `
    .drag-highlight {
        border-color: var(--shopee-orange) !important;
        background-color: rgba(238, 77, 45, 0.05) !important;
        transform: scale(1.02);
    }

    .form-input.is-valid {
        border-color: #28a745;
        box-shadow: 0 0 0 2px rgba(40, 167, 69, 0.1);
    }

    .form-input.is-invalid {
        border-color: #dc3545;
        box-shadow: 0 0 0 2px rgba(220, 53, 69, 0.1);
    }

    .invalid-feedback {
        display: none;
        width: 100%;
        margin-top: 0.25rem;
        font-size: 0.875em;
        color: #dc3545;
    }

    .avatar-image {
        transition: opacity 0.3s ease;
    }

    .btn-primary.loading .btn-text {
        display: none;
    }

    .btn-primary.loading .loading-spinner {
        display: inline-block;
    }

    .notification-enter {
        transform: translateX(100%);
        opacity: 0;
    }

    .notification-enter-active {
        transform: translateX(0);
        opacity: 1;
        transition: all 0.3s ease;
    }

    .notification-exit {
        transform: translateX(0);
        opacity: 1;
    }

    .notification-exit-active {
        transform: translateX(100%);
        opacity: 0;
        transition: all 0.3s ease;
    }
`;

document.head.appendChild(additionalStyles);
