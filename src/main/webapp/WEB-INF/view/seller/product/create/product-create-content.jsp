<%@ page contentType="text/html; charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <div class="product-create-container">
            <!-- Page Header -->
            <div class="page-header-card">
                <div class="page-header-content">
                    <h1 class="page-title">
                        <i class="fas fa-plus-circle" style="color: rgba(255,255,255,0.9);"></i>
                        Tạo sản phẩm mới
                    </h1>
                    <p class="page-description">
                        Thêm sản phẩm mới vào cửa hàng của bạn một cách dễ dàng và chuyên nghiệp
                    </p>
                </div>

                <!-- Progress Steps -->
                <div class="progress-steps">
                    <div class="step active">
                        <div class="step-circle">
                            <i class="fas fa-info-circle"></i>
                        </div>
                        <span class="step-label">Thông tin cơ bản</span>
                    </div>
                    <div class="step-line"></div>
                    <div class="step">
                        <div class="step-circle">
                            <i class="fas fa-check"></i>
                        </div>
                        <span class="step-label">Hoàn thành</span>
                    </div>
                </div>
            </div>

            <!-- Success Message -->
            <c:if test="${param.createdId != null}">
                <div class="alert-modern alert-success">
                    <i class="fas fa-check-circle" style="font-size: 1.5rem; margin-top: 2px;"></i>
                    <div class="alert-content">
                        <strong>Tạo sản phẩm thành công!</strong>
                        Sản phẩm với ID <span class="highlight">${param.createdId}</span> đã được thêm vào cửa hàng của
                        bạn.
                    </div>
                </div>
            </c:if>

            <!-- Main Form -->
            <form method="post" enctype="multipart/form-data"
                action="${pageContext.request.contextPath}/seller/products" class="product-form" id="productForm">

                <c:if test="${_csrf != null}">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                </c:if>
                <input type="hidden" name="shopId" value="${form.shopId}" />

                <!-- Basic Information Card -->
                <div class="form-card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-info-circle"></i>
                            Thông tin cơ bản
                        </h2>
                    </div>
                    <div class="card-body">
                        <div class="form-grid">
                            <!-- Product Name -->
                            <div class="form-group full-width">
                                <label class="form-label required">
                                    <i class="fas fa-tag"></i>
                                    Tên sản phẩm
                                </label>
                                <div class="input-group">
                                    <input type="text" name="name" value="${form.name}" class="form-input"
                                        placeholder="Nhập tên sản phẩm của bạn..." maxlength="200" required />
                                    <div class="input-helper">
                                        <span class="char-count">
                                            <span id="nameCount">0</span>/200
                                        </span>
                                    </div>
                                </div>
                                <div class="form-hint">
                                    Tên sản phẩm nên rõ ràng, súc tích và dễ tìm kiếm
                                </div>
                            </div>

                            <!-- Description -->
                            <div class="form-group full-width">
                                <label class="form-label">
                                    <i class="fas fa-align-left"></i>
                                    Mô tả sản phẩm
                                </label>
                                <div class="input-group">
                                    <textarea name="description" rows="4" class="form-textarea"
                                        placeholder="Mô tả chi tiết về sản phẩm, tính năng, công dụng..."
                                        maxlength="2000">${form.description}</textarea>
                                    <div class="input-helper">
                                        <span class="char-count">
                                            <span id="descCount">0</span>/2000
                                        </span>
                                    </div>
                                </div>
                                <div class="form-hint">
                                    Mô tả chi tiết giúp khách hàng hiểu rõ hơn về sản phẩm
                                </div>
                            </div>
                        </div>
                    </div>
                </div>


                <!-- Product Images Card -->
                <div class="form-card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-images"></i>
                            Hình ảnh sản phẩm
                        </h2>
                    </div>
                    <div class="card-body">
                        <div class="image-upload-section">
                            <input type="file" name="images" multiple accept="image/*" class="file-input"
                                id="imageInput" style="display: none;" />
                            <div class="upload-area" id="uploadArea">
                                <div class="upload-content">
                                    <i class="fas fa-cloud-upload-alt"></i>
                                    <h3>Thêm hình ảnh sản phẩm</h3>
                                    <p>Kéo thả hoặc nhấp để chọn nhiều ảnh</p>
                                </div>
                            </div>
                            <div class="upload-preview" id="imagePreview"></div>
                            <div class="form-hint">
                                <br>Định dạng hỗ trợ: JPG, PNG, GIF. Kích thước tối đa: 5MB mỗi ảnh.
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Product Variants Card -->
                <div class="form-card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-layer-group"></i>
                            Thiết lập biến thể
                        </h2>
                        <div class="card-actions">
                            <label class="toggle-switch">
                                <input type="checkbox" name="hasVariants" value="true" id="hasVariants" <c:if
                                    test="${form.hasVariants}">checked</c:if> />
                                <span class="toggle-slider"></span>
                                <span class="toggle-label">Sản phẩm có biến thể</span>
                            </label>
                        </div>
                    </div>
                    <div class="card-body">
                        <!-- No Variants Block -->
                        <div id="noVariantBlock" class="variant-section">
                            <div class="form-group">
                                <label class="form-label required">
                                    <i class="fas fa-dollar-sign"></i>
                                    Giá sản phẩm
                                </label>
                                <div class="input-group">
                                    <input type="number" step="1000" min="0" name="price" value="${form.price}"
                                        class="form-input price-input" placeholder="Nhập giá sản phẩm..." />
                                    <span class="input-suffix">VNĐ</span>
                                </div>
                                <div class="price-validation-msg" id="priceError" style="display: none;"></div>
                                <div class="form-hint">
                                    Giá bán lẻ của sản phẩm cho khách hàng
                                </div>
                            </div>
                        </div>

                        <!-- Variants Block -->
                        <div id="variantBlock" class="variant-section" style="display: none;">
                            <div class="variant-explanation">
                                <div class="info-card">
                                    <i class="fas fa-lightbulb"></i>
                                    <div>
                                        <strong>Biến thể sản phẩm</strong>
                                        <p>Tạo các phiên bản khác nhau của sản phẩm như màu sắc, kích thước, dung
                                            lượng...</p>
                                    </div>
                                </div>
                            </div>

                            <div class="variant-table-container">
                                <table class="variant-table">
                                    <thead>
                                        <tr>
                                            <th style="width: 40%;">
                                                <i class="fas fa-tag"></i>
                                                Tên biến thể
                                            </th>
                                            <th style="width: 35% !important;">
                                                <i class="fas fa-dollar-sign"></i>
                                                Giá (tuỳ chọn)
                                            </th>
                                            <th style="width: 15% !important; ">
                                                <i class="fas fa-image"></i>
                                                Ảnh (tuỳ chọn)
                                            </th>
                                            <th style="width: 10%;">
                                                <i class="fas fa-times"></i>
                                                Xoá
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody id="variantTbody">
                                        <!-- Variant rows will be added dynamically -->
                                    </tbody>
                                </table>
                            </div>

                            <div class="variant-actions">
                                <button type="button" class="btn-add-variant" onclick="addVariantRow()">
                                    <i class="fas fa-plus"></i>
                                    Thêm biến thể
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <button type="button" class="btn btn-outline" onclick="history.back()">
                        <i class="fas fa-arrow-left"></i>
                        Quay lại
                    </button>
                    <button type="submit" class="btn-primary" id="submitBtn">
                        <i class="fas fa-save"></i>
                        Tạo sản phẩm
                        <div class="btn-loading" id="btnLoading" style="display: none;">
                            <i class="fas fa-spinner fa-spin"></i>
                        </div>
                    </button>
                </div>
            </form>
        </div>