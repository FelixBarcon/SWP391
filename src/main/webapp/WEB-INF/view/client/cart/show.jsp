<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <fmt:setLocale value="vi_VN" />
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Giỏ hàng của bạn - SWP Shop</title>

                <!-- Font Awesome -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

                <!-- Cart CSS -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/client/css/cart.css">
            </head>

            <body>
                <!-- Include Header -->
                <jsp:include page="../layout/header.jsp" />

                <!-- Cart Container -->
                <div class="cart-container">
                    <!-- Page Header -->
                    <div class="cart-page-header">
                        <h1 class="cart-page-title">
                            <i class="fas fa-shopping-cart"></i>
                            Giỏ hàng của bạn
                        </h1>
                        <div class="cart-breadcrumb">
                            <a href="${pageContext.request.contextPath}/">
                                <i class="fas fa-home"></i> Trang chủ
                            </a>
                            <i class="fas fa-chevron-right" style="font-size: 10px; margin: 0 8px;"></i>
                            <span>Giỏ hàng</span>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${not empty shopGroups}">
                            <!-- Cart Header (Grid labels) -->
                            <div class="cart-header">
                                <div class="cart-header-item">
                                    <input type="checkbox" id="header-select-all" class="shop-checkbox" checked>
                                </div>
                                <div class="cart-header-item">Sản phẩm</div>
                                <div class="cart-header-item">Đơn giá</div>
                                <div class="cart-header-item">Số lượng</div>
                                <div class="cart-header-item">Số tiền</div>
                                <div class="cart-header-item">Thao tác</div>
                            </div>

                            <!-- Shop Groups -->
                            <c:forEach var="group" items="${shopGroups}">
                                <div class="shop-group">
                                    <!-- Shop Header -->
                                    <div class="shop-header">
                                        <input type="checkbox" class="shop-checkbox" checked>
                                        <div class="shop-name">
                                            <i class="fas fa-store"></i>
                                            ${group.shop.displayName}
                                            <span class="shop-badge">Official</span>
                                        </div>
                                    </div>

                                    <!-- Promo Banner -->
                                    <div class="promo-banner">
                                        <span class="promo-badge">
                                            <i class="fas fa-gift"></i> KHUYẾN MÃI
                                        </span>
                                        Mua thêm sản phẩm để được giảm giá thêm!
                                    </div>

                                    <!-- Cart Items -->
                                    <c:forEach var="cd" items="${group.items}">
                                        <c:set var="disabled"
                                            value="${cd.product.status ne 'ACTIVE' or cd.product.deleted}" />

                                        <div class="cart-item ${disabled ? 'disabled' : ''}" data-unit="${cd.price}"
                                            data-qty="${cd.quantity}">

                                            <!-- Checkbox Column -->
                                            <div class="item-checkbox-col">
                                                <input type="checkbox" class="item-checkbox" name="ids" value="${cd.id}"
                                                    form="checkout-form" ${disabled ? 'disabled' : 'checked' }>
                                            </div>

                                            <!-- Product Info -->
                                            <div class="item-product-info">
                                                <c:choose>
                                                    <c:when test="${not empty cd.product.imageUrl}">
                                                        <img src="${pageContext.request.contextPath}/images/${cd.product.imageUrl}"
                                                            alt="${cd.product.name}" class="item-image">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="https://via.placeholder.com/80x80?text=No+Image"
                                                            alt="${cd.product.name}" class="item-image">
                                                    </c:otherwise>
                                                </c:choose>

                                                <div class="item-details">
                                                    <div class="item-name">${cd.product.name}</div>

                                                    <!-- Variant Section -->
                                                    <c:if test="${not empty variantsMap[cd.product.id] && !disabled}">
                                                        <button type="button" class="variant-change-btn"
                                                            data-cart-detail-id="${cd.id}">
                                                            <i class="fas fa-sync-alt"></i>
                                                            <c:choose>
                                                                <c:when test="${cd.variant != null}">Đổi phân loại
                                                                </c:when>
                                                                <c:otherwise>Chọn phân loại</c:otherwise>
                                                            </c:choose>
                                                        </button>

                                                        <!-- Variant Panel -->
                                                        <div class="variant-panel" id="variant-panel-${cd.id}">
                                                            <form method="post"
                                                                action="${pageContext.request.contextPath}/cart/change-variant">
                                                                <input type="hidden" name="cartDetailId"
                                                                    value="${cd.id}">

                                                                <select name="variantId" class="variant-select">
                                                                    <option value="" ${cd.variant==null ? 'selected'
                                                                        : '' }>
                                                                        Không chọn phân loại
                                                                    </option>
                                                                    <c:forEach var="v"
                                                                        items="${variantsMap[cd.product.id]}">
                                                                        <option value="${v.id}" ${cd.variant !=null &&
                                                                            cd.variant.id==v.id ? 'selected' : '' }>
                                                                            ${v.name}
                                                                            <c:if test="${v.price != null}">
                                                                                -
                                                                                <fmt:formatNumber value="${v.price}"
                                                                                    type="currency" />
                                                                            </c:if>
                                                                        </option>
                                                                    </c:forEach>
                                                                </select>

                                                                <c:if test="${not empty _csrf}">
                                                                    <input type="hidden" name="${_csrf.parameterName}"
                                                                        value="${_csrf.token}">
                                                                </c:if>
                                                            </form>
                                                        </div>
                                                    </c:if>

                                                    <!-- Current Variant Display -->
                                                    <c:if test="${cd.variant != null}">
                                                        <div class="item-variant">
                                                            <i class="fas fa-tag"></i> Phân loại: ${cd.variant.name}
                                                        </div>
                                                    </c:if>

                                                    <!-- Disabled Status -->
                                                    <c:if test="${disabled}">
                                                        <div class="item-status">
                                                            <i class="fas fa-exclamation-triangle"></i>
                                                            Sản phẩm đã ngưng bán
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <!-- Price Column -->
                                            <div class="item-price">
                                                <fmt:formatNumber value="${cd.price}" type="currency" />
                                            </div>

                                            <!-- Quantity Column -->
                                            <div class="item-quantity">
                                                <c:choose>
                                                    <c:when test="${disabled}">
                                                        <span class="qty-disabled">${cd.quantity}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <form method="post"
                                                            action="${pageContext.request.contextPath}/cart/update"
                                                            class="quantity-form">
                                                            <input type="hidden" name="cartDetailId" value="${cd.id}">

                                                            <div class="quantity-control">
                                                                <button type="button" class="qty-btn"
                                                                    data-action="decrease">
                                                                    <i class="fas fa-minus"></i>
                                                                </button>

                                                                <input type="number" name="qty" value="${cd.quantity}"
                                                                    min="1" class="qty-input" readonly>

                                                                <button type="button" class="qty-btn"
                                                                    data-action="increase">
                                                                    <i class="fas fa-plus"></i>
                                                                </button>
                                                            </div>

                                                            <c:if test="${not empty _csrf}">
                                                                <input type="hidden" name="${_csrf.parameterName}"
                                                                    value="${_csrf.token}">
                                                            </c:if>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <!-- Total Column -->
                                            <div class="item-total">
                                                <fmt:formatNumber value="${cd.price * cd.quantity}" type="currency" />
                                            </div>

                                            <!-- Delete Column -->
                                            <div class="item-delete">
                                                <form method="post"
                                                    action="${pageContext.request.contextPath}/delete-cart-product"
                                                    style="display: inline;">
                                                    <input type="hidden" name="cartDetailId" value="${cd.id}">

                                                    <c:if test="${!disabled}">
                                                        <button type="submit" class="delete-btn">
                                                            <i class="fas fa-trash-alt"></i> Xóa
                                                        </button>
                                                    </c:if>

                                                    <c:if test="${not empty _csrf}">
                                                        <input type="hidden" name="${_csrf.parameterName}"
                                                            value="${_csrf.token}">
                                                    </c:if>
                                                </form>
                                            </div>
                                        </div>
                                    </c:forEach>

                                    <!-- Shop Total -->
                                    <div class="shop-total-row">
                                        <span class="shop-total-label">
                                            <i class="fas fa-calculator"></i> Tổng đơn hàng (${group.shop.displayName}):
                                        </span>
                                        <span class="shop-total-amount" data-total="${group.shopTotal}">
                                            <fmt:formatNumber value="${group.shopTotal}" type="currency" />
                                        </span>
                                    </div>
                                </div>
                            </c:forEach>

                            <!-- Checkout Footer -->
                            <div class="checkout-footer">
                                <div class="footer-left">
                                    <label class="select-all-wrapper">
                                        <input type="checkbox" id="select-all-checkbox" class="select-all-checkbox"
                                            checked>
                                        <span class="select-all-label">Chọn tất cả</span>
                                    </label>

                                    <button type="button" class="delete-selected-btn">
                                        <i class="fas fa-trash"></i> Xóa sản phẩm đã chọn
                                    </button>
                                </div>

                                <div class="footer-right">
                                    <div class="total-summary">
                                        <div class="total-summary-label">
                                            Tổng thanh toán (<span class="selected-count" id="selected-count">0</span>
                                            sản phẩm):
                                        </div>
                                        <div class="total-summary-amount" id="grand-total">
                                            <fmt:formatNumber value="${grandTotal}" type="currency" />
                                        </div>
                                    </div>

                                    <form id="checkout-form" method="post"
                                        action="${pageContext.request.contextPath}/cart/checkout">

                                        <c:if test="${not empty _csrf}">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                        </c:if>

                                        <button type="submit" class="checkout-btn">
                                            <i class="fas fa-credit-card"></i> Mua hàng
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Empty Cart -->
                            <div class="empty-cart">
                                <div class="empty-cart-icon">
                                    <i class="fas fa-shopping-cart"></i>
                                </div>
                                <h3 class="empty-cart-title">Giỏ hàng của bạn đang trống</h3>
                                <p class="empty-cart-text">
                                    Hãy khám phá và thêm những sản phẩm yêu thích vào giỏ hàng nhé!
                                </p>
                                <a href="${pageContext.request.contextPath}/products" class="back-to-shop-btn">
                                    <i class="fas fa-shopping-bag"></i>
                                    Mua sắm ngay
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Include Footer -->
                <jsp:include page="../layout/footer.jsp" />

                <!-- Cart JavaScript -->
                <script
                    src="${pageContext.request.contextPath}/resources/client/js/cart.js?v=<%= System.currentTimeMillis() %>"></script>
            </body>

            </html>