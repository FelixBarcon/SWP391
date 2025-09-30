document.addEventListener("DOMContentLoaded", function () {
  // Initialize all functions when page loads
  initVariantToggle();
  initFormValidation();
  initImagePreview();
  initTooltips();
});

// Toggle hiển thị khối giá base khi có biến thể
function initVariantToggle() {
  const hasVariantsEl = document.getElementById("hasVariants");
  const noVariant = document.getElementById("noVariantBlock");
  const basePriceBlock = document.getElementById("basePriceBlock");

  function toggleVariantBlocks() {
    if (!hasVariantsEl) return;

    if (hasVariantsEl.checked) {
      if (noVariant) noVariant.style.display = "none";
      if (basePriceBlock) basePriceBlock.style.display = "block";
    } else {
      if (noVariant) noVariant.style.display = "block";
      if (basePriceBlock) basePriceBlock.style.display = "none";
    }
  }

  if (hasVariantsEl) {
    hasVariantsEl.addEventListener("change", toggleVariantBlocks);
    toggleVariantBlocks(); // Initialize on page load
  }
}

// Thêm dòng biến thể mới
function addVariantRow() {
  const tbody = document.getElementById("variantTbody");
  if (!tbody) return;

  const tr = document.createElement("tr");
  tr.innerHTML = `
        <td>
            <span class="new-variant-badge">Mới</span>
        </td>
        <td>
            <input type="text" name="variantName" placeholder="VD: Màu Đỏ / 128GB" 
                   style="width:95%;" required class="form-control"/>
        </td>
        <td>
            <input type="number" step="0.01" name="variantPrice" 
                   placeholder="Để trống = dùng giá cơ bản" 
                   style="width:95%;" class="form-control"/>
        </td>
        <td class="text-muted">(chưa có ảnh)</td>
        <td>
            <select name="variantImageFromGallery" class="form-control">
                <option value="">-- không chọn --</option>
            </select>
        </td>
        <td>
            <input type="file" name="variantImage" accept="image/*" class="form-control"/>
        </td>
        <td style="text-align:center;">
            <button type="button" onclick="removeVariantRow(this)" class="btn btn-danger">
                <i class="fa fa-trash"></i> Xóa
            </button>
        </td>
    `;

  // Populate gallery images in select dropdown
  const select = tr.querySelector('select[name="variantImageFromGallery"]');
  const galleryImages = document.querySelectorAll(
    'input[name="removeImageUrl"]'
  );

  galleryImages.forEach((cb) => {
    const opt = document.createElement("option");
    opt.value = cb.value;
    opt.textContent = cb.value;
    select.appendChild(opt);
  });

  tbody.appendChild(tr);

  // Add animation
  tr.style.opacity = "0";
  setTimeout(() => {
    tr.style.opacity = "1";
    tr.style.transition = "opacity 0.3s ease";
  }, 10);

  // Show success message
  showNotification("Đã thêm biến thể mới", "success");
}

// Xóa dòng biến thể
function removeVariantRow(button) {
  const row = button.closest("tr");
  if (row) {
    // Add fade out animation
    row.style.transition = "opacity 0.3s ease";
    row.style.opacity = "0";

    setTimeout(() => {
      row.remove();
      showNotification("Đã xóa biến thể", "warning");
    }, 300);
  }
}

// Form validation
function initFormValidation() {
  const forms = document.querySelectorAll("form");

  forms.forEach((form) => {
    form.addEventListener("submit", function (e) {
      const requiredFields = form.querySelectorAll("[required]");
      let hasError = false;

      requiredFields.forEach((field) => {
        if (!field.value.trim()) {
          showFieldError(field, "Trường này là bắt buộc");
          hasError = true;
        } else {
          clearFieldError(field);
        }
      });

      // Validate price fields
      const priceFields = form.querySelectorAll('input[type="number"]');
      priceFields.forEach((field) => {
        if (field.value && parseFloat(field.value) < 0) {
          showFieldError(field, "Giá không được âm");
          hasError = true;
        }
      });

      if (hasError) {
        e.preventDefault();
        showNotification("Vui lòng kiểm tra lại thông tin", "error");
      } else {
        // Show loading state
        const submitBtn = form.querySelector('button[type="submit"]');
        if (submitBtn) {
          submitBtn.disabled = true;
          submitBtn.innerHTML =
            '<i class="fa fa-spinner fa-spin"></i> Đang xử lý...';
        }
      }
    });
  });
}

// Show field error
function showFieldError(field, message) {
  field.classList.add("error");

  // Remove existing error message
  const existingError = field.parentNode.querySelector(".error-message");
  if (existingError) {
    existingError.remove();
  }

  // Add new error message
  const errorDiv = document.createElement("div");
  errorDiv.className = "error-message";
  errorDiv.textContent = message;
  field.parentNode.appendChild(errorDiv);
}

// Clear field error
function clearFieldError(field) {
  field.classList.remove("error");
  const errorMsg = field.parentNode.querySelector(".error-message");
  if (errorMsg) {
    errorMsg.remove();
  }
}

// Image preview functionality
function initImagePreview() {
  const fileInputs = document.querySelectorAll('input[type="file"]');

  fileInputs.forEach((input) => {
    input.addEventListener("change", function (e) {
      const files = e.target.files;
      if (files.length > 0) {
        // Create preview container if it doesn't exist
        let previewContainer = input.parentNode.querySelector(".image-preview");
        if (!previewContainer) {
          previewContainer = document.createElement("div");
          previewContainer.className = "image-preview";
          input.parentNode.appendChild(previewContainer);
        }

        // Clear existing previews
        previewContainer.innerHTML = "";

        // Show previews for selected files
        Array.from(files).forEach((file) => {
          if (file.type.startsWith("image/")) {
            const reader = new FileReader();
            reader.onload = function (e) {
              const img = document.createElement("img");
              img.src = e.target.result;
              img.style.maxWidth = "100px";
              img.style.maxHeight = "100px";
              img.style.margin = "5px";
              img.style.border = "1px solid #ddd";
              img.style.borderRadius = "4px";
              previewContainer.appendChild(img);
            };
            reader.readAsDataURL(file);
          }
        });
      }
    });
  });
}

// Show notification
function showNotification(message, type = "info") {
  // Remove existing notifications
  const existingNotifications = document.querySelectorAll(".notification");
  existingNotifications.forEach((n) => n.remove());

  const notification = document.createElement("div");
  notification.className = `notification notification-${type}`;
  notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: ${
          type === "success"
            ? "#52c41a"
            : type === "error"
            ? "#ff4d4f"
            : type === "warning"
            ? "#faad14"
            : "#1890ff"
        };
        color: white;
        padding: 12px 20px;
        border-radius: 4px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        z-index: 9999;
        font-size: 14px;
        font-weight: 500;
        min-width: 250px;
        animation: slideInRight 0.3s ease;
    `;
  notification.textContent = message;

  // Add close button
  const closeBtn = document.createElement("span");
  closeBtn.innerHTML = "&times;";
  closeBtn.style.cssText = `
        margin-left: 10px;
        cursor: pointer;
        font-size: 18px;
        font-weight: bold;
    `;
  closeBtn.onclick = () => notification.remove();
  notification.appendChild(closeBtn);

  document.body.appendChild(notification);

  // Auto remove after 3 seconds
  setTimeout(() => {
    if (notification.parentNode) {
      notification.style.animation = "slideOutRight 0.3s ease";
      setTimeout(() => notification.remove(), 300);
    }
  }, 3000);
}

// Initialize tooltips
function initTooltips() {
  const elementsWithTooltip = document.querySelectorAll("[data-tooltip]");

  elementsWithTooltip.forEach((element) => {
    element.addEventListener("mouseenter", function () {
      showTooltip(this, this.getAttribute("data-tooltip"));
    });

    element.addEventListener("mouseleave", function () {
      hideTooltip();
    });
  });
}

// Show tooltip
function showTooltip(element, text) {
  const tooltip = document.createElement("div");
  tooltip.className = "tooltip";
  tooltip.textContent = text;
  tooltip.style.cssText = `
        position: absolute;
        background: #333;
        color: white;
        padding: 6px 10px;
        border-radius: 4px;
        font-size: 12px;
        z-index: 10000;
        white-space: nowrap;
        box-shadow: 0 2px 8px rgba(0,0,0,0.15);
    `;

  document.body.appendChild(tooltip);

  const rect = element.getBoundingClientRect();
  tooltip.style.left =
    rect.left + rect.width / 2 - tooltip.offsetWidth / 2 + "px";
  tooltip.style.top = rect.top - tooltip.offsetHeight - 8 + "px";
}

// Hide tooltip
function hideTooltip() {
  const tooltip = document.querySelector(".tooltip");
  if (tooltip) {
    tooltip.remove();
  }
}

// Format price display
function formatPrice(price) {
  return new Intl.NumberFormat("vi-VN", {
    style: "currency",
    currency: "VND",
  }).format(price);
}

// Validate file size
function validateFileSize(input, maxSizeMB = 5) {
  const files = input.files;
  let hasError = false;

  Array.from(files).forEach((file) => {
    if (file.size > maxSizeMB * 1024 * 1024) {
      showNotification(
        `File ${file.name} quá lớn. Kích thước tối đa: ${maxSizeMB}MB`,
        "error"
      );
      hasError = true;
    }
  });

  if (hasError) {
    input.value = "";
    return false;
  }
  return true;
}

// Add CSS animations
const style = document.createElement("style");
style.textContent = `
    @keyframes slideInRight {
        from { transform: translateX(100%); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }
    
    @keyframes slideOutRight {
        from { transform: translateX(0); opacity: 1; }
        to { transform: translateX(100%); opacity: 0; }
    }
    
    .new-variant-badge {
        background: #52c41a;
        color: white;
        padding: 2px 8px;
        border-radius: 12px;
        font-size: 11px;
        font-weight: 500;
    }
`;
document.head.appendChild(style);
