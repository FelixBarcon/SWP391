// Product Creation Form JavaScript
document.addEventListener("DOMContentLoaded", function () {
  setupVariantToggle();
  setupCharacterCounters();
  setupPriceValidation();
  setupImageUpload();
});

function setupVariantToggle() {
  const hasVariants = document.getElementById("hasVariants");
  const noVariantBlock = document.getElementById("noVariantBlock");
  const variantBlock = document.getElementById("variantBlock");

  if (hasVariants) {
    hasVariants.addEventListener("change", function () {
      if (this.checked) {
        noVariantBlock.style.display = "none";
        variantBlock.style.display = "block";
        const tbody = document.getElementById("variantTbody");
        if (tbody && tbody.children.length === 0) {
          addVariantRow();
        }
      } else {
        noVariantBlock.style.display = "block";
        variantBlock.style.display = "none";
      }
    });

    // Initial state
    if (hasVariants.checked) {
      noVariantBlock.style.display = "none";
      variantBlock.style.display = "block";
    }
  }
}

function setupCharacterCounters() {
  const nameInput = document.querySelector('input[name="name"]');
  const nameCount = document.getElementById("nameCount");

  if (nameInput && nameCount) {
    nameInput.addEventListener("input", function () {
      nameCount.textContent = this.value.length;
    });
    nameCount.textContent = nameInput.value.length;
  }

  const descTextarea = document.querySelector('textarea[name="description"]');
  const descCount = document.getElementById("descCount");

  if (descTextarea && descCount) {
    descTextarea.addEventListener("input", function () {
      descCount.textContent = this.value.length;
    });
    descCount.textContent = descTextarea.value.length;
  }
}

function setupPriceValidation() {
  const priceInput = document.querySelector('input[name="price"]');
  const priceError = document.getElementById("priceError");

  if (priceInput && priceError) {
    priceInput.addEventListener("blur", function () {
      validatePriceInput(this, priceError);
    });

    priceInput.addEventListener("input", function () {
      priceError.style.display = "none";
    });
  }
}

function validatePriceInput(input, errorElement) {
  const value = parseFloat(input.value);

  if (isNaN(value) || value <= 0) {
    showError(errorElement, "Vui lòng nhập giá hợp lệ");
    return false;
  }

  if (value < 1000) {
    showError(errorElement, "Giá tối thiểu là 1,000 VNĐ");
    return false;
  }

  if (value > 1000000000) {
    showError(errorElement, "Giá tối đa là 1,000,000,000 VNĐ");
    return false;
  }

  errorElement.style.display = "none";
  return true;
}

function showError(element, message) {
  element.textContent = message;
  element.style.display = "block";
  element.style.color = "#dc3545";
}

function setupImageUpload() {
  const uploadArea = document.getElementById("uploadArea");
  const imageInput = document.getElementById("imageInput");

  if (uploadArea && imageInput) {
    console.log("Setting up image upload for:", uploadArea, imageInput);

    // Remove any existing event listeners by cloning the element
    const newUploadArea = uploadArea.cloneNode(true);
    uploadArea.parentNode.replaceChild(newUploadArea, uploadArea);

    // Handle click on upload area only
    newUploadArea.addEventListener("click", function (e) {
      e.preventDefault();
      e.stopPropagation();
      console.log("Upload area clicked, triggering file input");
      imageInput.click();
    });

    // Handle file selection
    imageInput.addEventListener("change", function (e) {
      console.log("Files selected:", this.files.length);
      displayImagePreview(this.files);
    });

    // Handle drag and drop
    newUploadArea.addEventListener("dragover", function (e) {
      e.preventDefault();
      e.stopPropagation();
      newUploadArea.classList.add("drag-over");
    });

    newUploadArea.addEventListener("dragleave", function (e) {
      e.preventDefault();
      e.stopPropagation();
      newUploadArea.classList.remove("drag-over");
    });

    newUploadArea.addEventListener("drop", function (e) {
      e.preventDefault();
      e.stopPropagation();
      newUploadArea.classList.remove("drag-over");

      const files = e.dataTransfer.files;
      if (files.length > 0) {
        console.log("Files dropped:", files.length);
        // Assign files to input and trigger preview
        imageInput.files = files;
        displayImagePreview(files);
      }
    });
  }
}

function displayImagePreview(files) {
  const preview = document.getElementById("imagePreview");
  if (!preview) return;

  preview.innerHTML = "";
  if (files.length === 0) return;

  preview.style.display = "grid";

  for (let i = 0; i < files.length; i++) {
    const file = files[i];
    if (file.type.startsWith("image/")) {
      const div = document.createElement("div");
      div.className = "preview-item";

      const img = document.createElement("img");
      const reader = new FileReader();
      reader.onload = function (e) {
        img.src = e.target.result;
      };
      reader.readAsDataURL(file);

      const name = document.createElement("span");
      name.className = "file-name";
      name.textContent = file.name;

      div.appendChild(img);
      div.appendChild(name);
      preview.appendChild(div);
    }
  }
}

function addVariantRow() {
  const tbody = document.getElementById("variantTbody");
  if (!tbody) return;

  const tr = document.createElement("tr");
  tr.innerHTML = [
    "<td>",
    '<input type="text" name="variantName" placeholder="VD: Màu Đỏ, Size M..." class="variant-input" required/>',
    "</td>",
    "<td>",
    '<input type="number" name="variantPrice" placeholder="Để trống = giá cơ bản" class="variant-input"/>',
    "</td>",
    "<td>",
    '<input type="file" name="variantImage" accept="image/*"/>',
    "</td>",
    "<td>",
    '<button type="button" onclick="removeVariantRow(this)" class="btn-remove-variant">Xóa</button>',
    "</td>",
  ].join("");

  tbody.appendChild(tr);
}

function removeVariantRow(button) {
  const row = button.closest("tr");
  if (row) {
    row.remove();
  }
}
