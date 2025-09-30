<%@ page contentType="text/html; charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- Link to Shopee Orange Theme CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/seller/css/product-edit-shopee.css">

        <div class="product-edit-container">
            <div class="page-header">
                <h1 class="page-title">Chỉnh sửa sản phẩm</h1>
            </div>

            <c:if test="${param.updated != null}">
                <div class="alert alert-success">
                    <strong>Thành công!</strong> Đã cập nhật: ${param.updated}
                </div>
            </c:if>
            <c:if test="${param.deleted != null}">
                <div class="alert alert-success">
                    <strong>Thành công!</strong> Đã xoá: ${param.deleted}
                </div>
            </c:if>

            <!-- ====== FORM 1: THÔNG TIN CƠ BẢN ====== -->
            <div class="form-section">
                <h2 class="section-title">Thông tin cơ bản</h2>
                <form method="post" enctype="multipart/form-data"
                    action="${pageContext.request.contextPath}/seller/products/${p.id}">
                    <c:if test="${_csrf != null}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    </c:if>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label required">Tên sản phẩm</label>
                                <input type="text" name="name" value="${p.name}" required class="form-control"
                                    placeholder="Nhập tên sản phẩm..." />
                            </div>

                            <div class="form-group">
                                <label class="form-label">Mô tả sản phẩm</label>
                                <textarea name="description" rows="4" class="form-control textarea"
                                    placeholder="Nhập mô tả chi tiết về sản phẩm...">${p.description}</textarea>
                                <div class="help-text">Mô tả chi tiết sẽ giúp khách hàng hiểu rõ hơn về sản phẩm</div>
                            </div>


                        </div>

                        <div class="col-md-6">
                            <div class="toggle-section">
                                <div class="form-group">
                                    <label class="checkbox-item">
                                        <input id="hasVariants" type="checkbox" name="hasVariants" value="true" <c:if
                                            test="${p.hasVariants}">checked</c:if> />
                                        <span><strong>Sản phẩm có biến thể</strong></span>
                                    </label>
                                    <div class="help-text">Bật tùy chọn này nếu sản phẩm có nhiều phiên bản (màu sắc,
                                        kích thước...)</div>
                                </div>
                            </div>

                            <div id="noVariantBlock" class="form-group">
                                <c:if test="${!p.hasVariants}">
                                    <label class="form-label required">Giá sản phẩm (VNĐ)</label>
                                    <input type="number" step="0.01" name="price" value="${p.price}"
                                        class="form-control" placeholder="0" min="0" />
                                    <div class="help-text">Giá khi sản phẩm không có biến thể</div>
                                </c:if>
                            </div>

                            <div id="basePriceBlock" class="form-group" style="display:none;">
                                <c:if test="${p.hasVariants}">
                                    <label class="form-label">Giá cơ bản (VNĐ)</label>
                                    <input type="number" step="0.01" name="price" value="${p.price}"
                                        class="form-control" placeholder="0" min="0" />
                                    <div class="help-text">Giá mặc định cho các biến thể không có giá riêng</div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <h3 class="section-title">Quản lý hình ảnh</h3>



                        <div class="image-gallery">
                            <h4><strong>Thư viện ảnh hiện tại:</strong></h4>
                            <c:if test="${empty p.imageUrls}">
                                <div
                                    style="text-align: center; padding: 40px; color: #8c8c8c; background: #f8f9fa; border-radius: 8px;">
                                    <p style="font-size: 16px; margin: 0;">Chưa có ảnh nào trong thư viện</p>
                                    <p style="font-size: 14px; margin: 8px 0 0 0;">Thêm ảnh để thu hút khách hàng</p>
                                </div>
                            </c:if>
                            <c:if test="${not empty p.imageUrls}">
                                <table class="gallery-table">
                                    <thead>
                                        <tr>
                                            <th style="width: 40%;">Hình ảnh</th>
                                            <th style="width: 30%;">Đặt làm đại diện</th>
                                            <th style="width: 30%;">Xóa khỏi thư viện</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${p.imageUrls}" var="img">
                                            <tr>
                                                <td>
                                                    <div style="display: flex; align-items: center; gap: 12px;">
                                                        <img src="${pageContext.request.contextPath}/images/${img}"
                                                            width="80" height="80" style="object-fit: cover;" />
                                                        <span
                                                            style="font-size: 12px; color: #666; font-family: monospace;">${img}</span>
                                                    </div>
                                                </td>
                                                <td style="text-align:center;">
                                                    <input type="radio" name="coverImage" value="${img}" <c:if
                                                        test="${img == p.imageUrl}">checked
                            </c:if> />
                            <c:if test="${img == p.imageUrl}">
                                <br><small style="color: #10ac84; font-weight: 600;">✓ Ảnh đại diện</small>
                            </c:if>
                            </td>
                            <td style="text-align:center;">
                                <input type="checkbox" name="removeImageUrl" value="${img}" />
                            </td>
                            </tr>
                            </c:forEach>
                            </tbody>
                            </table>
                            </c:if>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="file-input-group">
                                    <h4>Thêm ảnh vào thư viện</h4>
                                    <input type="file" name="addImages" multiple accept="image/*"
                                        class="form-control" />
                                    <div class="help-text">
                                        Định dạng: JPG, PNG, GIF | Kích thước tối đa: 5MB/ảnh
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="file-input-group">
                                    <h4>Tải ảnh đại diện mới</h4>
                                    <input type="file" name="coverUpload" accept="image/*" class="form-control" />
                                    <div class="help-text">
                                        Ảnh này sẽ tự động trở thành ảnh đại diện và được thêm vào thư viện
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div style="text-align: center; margin-top: 24px;">
                            <button type="submit" class="btn btn-primary">
                                Lưu thông tin cơ bản
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- ========== FORM 2: BIẾN THỂ (Shopee Style) ========== -->
            <c:if test="${p.hasVariants}">
                <div class="variant-section">
                    <h2 class="section-title">
                        Quản lý biến thể sản phẩm
                    </h2>

                    <div class="price-range">
                        Khoảng giá hiện tại: <strong>${p.priceMin} - ${p.priceMax} VNĐ</strong>
                    </div>

                    <form method="post" enctype="multipart/form-data"
                        action="${pageContext.request.contextPath}/seller/products/${p.id}/variants">
                        <c:if test="${_csrf != null}">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        </c:if>

                        <table class="variant-table">
                            <thead>
                                <tr>
                                    <th style="width:8%;">ID</th>
                                    <th style="width:25%;">Tên biến thể</th>
                                    <th style="width:12%;">Giá (VNĐ)</th>
                                    <th style="width:15%;">Ảnh hiện tại</th>
                                    <th style="width:15%;">Chọn từ thư viện</th>
                                    <th style="width:15%;">Tải ảnh mới</th>
                                    <th style="width:10%;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody id="variantTbody">
                                <c:forEach items="${variants}" var="v" varStatus="st">
                                    <tr>
                                        <td>
                                            <span style="font-weight: 500; color: #666;">${v.id}</span>
                                            <input type="hidden" name="variantId" value="${v.id}" />
                                        </td>
                                        <td>
                                            <input type="text" name="variantName" value="${v.name}"
                                                placeholder="VD: Màu Đỏ, Size L..." required />
                                        </td>
                                        <td>
                                            <input type="number" step="0.01" name="variantPrice"
                                                value="<c:out value='${v.price}'/>"
                                                placeholder="Để trống = dùng giá cơ bản" min="0" />
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty v.imageUrl}">
                                                    <div style="text-align: center;">
                                                        <img src="${pageContext.request.contextPath}/images/${v.imageUrl}"
                                                            width="60" height="60"
                                                            style="object-fit: cover; border-radius: 4px;" />
                                                        <br><small style="color: #666;">${v.imageUrl}</small>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div style="text-align: center; color: #ccc;">
                                                        <span style="font-size: 24px;">📷</span><br><small>Chưa có
                                                            ảnh</small>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <select name="variantImageFromGallery">
                                                <option value="">-- giữ nguyên --</option>
                                                <c:forEach items="${p.imageUrls}" var="img">
                                                    <option value="${img}">${img}</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td>
                                            <input type="file" name="variantImage" accept="image/*" />
                                        </td>
                                        <td style="text-align:center;">
                                            <input type="checkbox" name="deleteVariant" value="${v.id}" />
                                            <br><small style="color: #ee4d2d; font-weight: 500;">Xóa</small>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <div style="text-align: center; margin: 20px 0;">
                            <button type="button" onclick="addVariantRow()" class="btn btn-add">
                                Thêm biến thể mới
                            </button>
                        </div>

                        <div style="text-align: center;">
                            <button type="submit" class="btn btn-primary">
                                Lưu tất cả biến thể
                            </button>
                        </div>
                    </form>
                </div>
            </c:if>
        </div>

        <!-- Link to external JavaScript file -->
        <script src="${pageContext.request.contextPath}/resources/seller/js/product-edit.js"></script>