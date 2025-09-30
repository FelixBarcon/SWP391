<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- Product List Content -->
        <div class="seller-product-list">
            <!-- Page Header -->
            <div class="seller-page-header">
                <div class="container-fluid">
                    <div class="row align-items-center">
                        <div class="col">
                            <h1 class="page-title">
                                <i class="fas fa-box me-3"></i>
                                Danh sách sản phẩm
                            </h1>
                            <p class="page-subtitle">
                                Cửa hàng:
                                <c:choose>
                                    <c:when test="${shop != null}">
                                        <strong>${shop.displayName}</strong> (ID: ${shop.id})
                                    </c:when>
                                    <c:otherwise>
                                        <strong>ID: ${shopId}</strong>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <div class="col-auto">
                            <a href="<c:url value='/seller/products/create?shopId=${shopId}'/>" class="btn-add-product">
                                <i class="fas fa-plus"></i>
                                Thêm sản phẩm mới
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Actions Bar -->
            <div class="product-actions-bar">
                <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                    <!-- Filters -->
                    <form method="get" action="${pageContext.request.contextPath}/seller/products"
                        class="action-filters">
                        <input type="hidden" name="shopId" value="${shopId}" />
                        <label class="filter-checkbox">
                            <input type="checkbox" name="showDeleted" value="true" <c:if test="${showDeleted}">checked
                            </c:if> />
                            <span>Hiển thị sản phẩm đã xóa</span>
                        </label>
                        <button type="submit" class="btn-apply">
                            <i class="fas fa-filter"></i>
                            Áp dụng
                        </button>
                    </form>

                    <!-- View Toggle -->
                    <div class="view-toggle">
                        <button type="button" class="toggle-btn active" onclick="toggleView('grid')" id="gridViewBtn">
                            <i class="fas fa-th-large"></i>
                            Grid
                        </button>
                        <button type="button" class="toggle-btn" onclick="toggleView('table')" id="tableViewBtn">
                            <i class="fas fa-list"></i>
                            Table
                        </button>
                    </div>
                </div>
            </div>

            <!-- Products Content -->
            <c:choose>
                <c:when test="${empty products}">
                    <!-- Empty State -->
                    <div class="empty-state">
                        <div class="empty-icon">
                            <i class="fas fa-box-open"></i>
                        </div>
                        <h3 class="empty-title">Chưa có sản phẩm nào</h3>
                        <p class="empty-description">
                            Bắt đầu bán hàng bằng cách thêm sản phẩm đầu tiên của bạn
                        </p>
                        <a href="<c:url value='/seller/products/create?shopId=${shopId}'/>" class="btn-add-product">
                            <i class="fas fa-plus"></i>
                            Thêm sản phẩm đầu tiên
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Grid View -->
                    <div class="products-grid" id="gridView">
                        <c:forEach items="${products}" var="p">
                            <div class="product-card">
                                <!-- Product Image -->
                                <div class="product-image">
                                    <c:choose>
                                        <c:when test="${not empty p.imageUrl}">
                                            <img src="${pageContext.request.contextPath}/images/${p.imageUrl}"
                                                alt="${p.name}" />
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-image"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- Product Info -->
                                <div class="product-info">
                                    <h5 class="product-name">${p.name}</h5>

                                    <div class="product-price">
                                        <c:choose>
                                            <c:when test="${p.hasVariants}">
                                                ${p.priceMin}₫ - ${p.priceMax}₫
                                            </c:when>
                                            <c:otherwise>
                                                ${p.price}₫
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="product-meta">
                                        <div class="meta-item">
                                            <i class="fas fa-tag"></i>
                                            <span>ID: ${p.id}</span>
                                        </div>
                                        <div class="meta-item">
                                            <i class="fas fa-layer-group"></i>
                                            <span>${p.hasVariants ? 'Có biến thể' : 'Đơn giản'}</span>
                                        </div>
                                    </div>

                                    <!-- Status Badge -->
                                    <div class="product-status 
                                        <c:choose>
                                            <c:when test=" ${p.deleted}">status-deleted</c:when>
                                        <c:when test="${p.status == 'ACTIVE'}">status-active</c:when>
                                        <c:otherwise>status-inactive</c:otherwise>
            </c:choose>">
            <c:choose>
                <c:when test="${p.deleted}">
                    <i class="fas fa-trash"></i>
                    Đã xóa
                </c:when>
                <c:when test="${p.status == 'ACTIVE'}">
                    <i class="fas fa-check-circle"></i>
                    Đang bán
                </c:when>
                <c:otherwise>
                    <i class="fas fa-pause-circle"></i>
                    Tạm dừng
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Actions -->
        <div class="product-actions">
            <!-- Edit Button -->
            <a href="${pageContext.request.contextPath}/seller/products/${p.id}/edit" class="btn-action btn-edit">
                <i class="fas fa-edit"></i>
                Sửa
            </a>

            <!-- Toggle Status -->
            <form method="post" action="${pageContext.request.contextPath}/seller/products/${p.id}/toggle-status"
                style="display:inline;">
                <c:if test="${_csrf != null}">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                </c:if>
                <input type="hidden" name="shopId" value="${shopId}" />
                <input type="hidden" name="showDeleted" value="${showDeleted}" />
                <button type="submit" class="btn-action btn-toggle">
                    <c:choose>
                        <c:when test="${p.status == 'ACTIVE'}">
                            <i class="fas fa-pause"></i>
                            Tắt bán
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-play"></i>
                            Bật bán
                        </c:otherwise>
                    </c:choose>
                </button>
            </form>

            <!-- Delete/Restore -->
            <c:if test="${!p.deleted}">
                <form method="post" action="${pageContext.request.contextPath}/seller/products/${p.id}/toggle-delete"
                    style="display:inline;" onsubmit="return confirm('Bạn có chắc muốn xóa sản phẩm này?');">
                    <c:if test="${_csrf != null}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    </c:if>
                    <input type="hidden" name="shopId" value="${shopId}" />
                    <input type="hidden" name="showDeleted" value="${showDeleted}" />
                    <button type="submit" class="btn-action btn-delete">
                        <i class="fas fa-trash"></i>
                        Xóa
                    </button>
                </form>
            </c:if>

            <c:if test="${p.deleted}">
                <form method="post" action="${pageContext.request.contextPath}/seller/products/${p.id}/toggle-delete"
                    style="display:inline;" onsubmit="return confirm('Bạn có chắc muốn khôi phục sản phẩm này?');">
                    <c:if test="${_csrf != null}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    </c:if>
                    <input type="hidden" name="shopId" value="${shopId}" />
                    <input type="hidden" name="showDeleted" value="${showDeleted}" />
                    <button type="submit" class="btn-action btn-restore">
                        <i class="fas fa-undo"></i>
                        Khôi phục
                    </button>
                </form>
            </c:if>
        </div>
        </div>
        </div>
        </c:forEach>
        </div>

        <!-- Table View -->
        <div class="product-table d-none" id="tableView">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Ảnh</th>
                        <th>Tên sản phẩm</th>
                        <th>Giá</th>
                        <th>Biến thể</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${products}" var="p">
                        <tr>
                            <td><strong>#${p.id}</strong></td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty p.imageUrl}">
                                        <img src="${pageContext.request.contextPath}/images/${p.imageUrl}"
                                            alt="${p.name}" class="table-product-image" />
                                    </c:when>
                                    <c:otherwise>
                                        <div
                                            class="table-product-image d-flex align-items-center justify-content-center bg-light">
                                            <i class="fas fa-image text-muted"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <strong>${p.name}</strong>
                                <c:if test="${p.deleted}">
                                    <span class="badge bg-secondary ms-2">Đã xóa</span>
                                </c:if>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.hasVariants}">
                                        <span class="text-primary fw-bold">${p.priceMin}₫ - ${p.priceMax}₫</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-primary fw-bold">${p.price}₫</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <span class="badge ${p.hasVariants ? 'bg-info' : 'bg-secondary'}">
                                    ${p.hasVariants ? 'Có' : 'Không'}
                                </span>
                            </td>
                            <td>
                                <span class="badge 
                                                <c:choose>
                                                    <c:when test=" ${p.deleted}">bg-dark</c:when>
                                    <c:when test="${p.status == 'ACTIVE'}">bg-success</c:when>
                                    <c:otherwise>bg-warning</c:otherwise>
                                    </c:choose>">
                                    <c:choose>
                                        <c:when test="${p.deleted}">Đã xóa</c:when>
                                        <c:when test="${p.status == 'ACTIVE'}">Đang bán</c:when>
                                        <c:otherwise>Tạm dừng</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td>
                                <div class="d-flex gap-1">
                                    <a href="${pageContext.request.contextPath}/seller/products/${p.id}/edit"
                                        class="btn btn-sm btn-outline-primary">
                                        <i class="fas fa-edit"></i>
                                    </a>

                                    <form method="post"
                                        action="${pageContext.request.contextPath}/seller/products/${p.id}/toggle-status"
                                        style="display:inline;">
                                        <c:if test="${_csrf != null}">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        </c:if>
                                        <input type="hidden" name="shopId" value="${shopId}" />
                                        <input type="hidden" name="showDeleted" value="${showDeleted}" />
                                        <button type="submit" class="btn btn-sm btn-outline-warning">
                                            <i class="fas fa-${p.status == 'ACTIVE' ? 'pause' : 'play'}"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        </c:otherwise>
        </c:choose>
        </div>

        <script>
            function toggleView(viewType) {
                const gridView = document.getElementById('gridView');
                const tableView = document.getElementById('tableView');
                const gridBtn = document.getElementById('gridViewBtn');
                const tableBtn = document.getElementById('tableViewBtn');

                if (viewType === 'grid') {
                    gridView.classList.remove('d-none');
                    tableView.classList.add('d-none');
                    gridBtn.classList.add('active');
                    tableBtn.classList.remove('active');
                } else {
                    gridView.classList.add('d-none');
                    tableView.classList.remove('d-none');
                    tableBtn.classList.add('active');
                    gridBtn.classList.remove('active');
                }
            }
        </script>

        <!-- Shopee-inspired JavaScript for enhanced interactions -->
        <script src="<c:url value='/resources/seller/js/seller-product-list.js'/>"></script>