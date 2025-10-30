<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="context-path" content="${pageContext.request.contextPath}">
    <title>Thanh toán - SWP Shop</title>

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Order CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/client/css/order.css">

    <!-- CSRF Meta Tags -->
    <c:if test="${not empty _csrf}">
        <meta name="_csrf" content="${_csrf.token}"/>
        <meta name="_csrf_header" content="${_csrf.headerName}"/>
    </c:if>
</head>

<body>
    <!-- Include Header -->
    <jsp:include page="../layout/header.jsp" />

    <!-- Checkout Container -->
    <div class="checkout-container">
        <!-- Header -->
        <div class="checkout-header">
            <h1 class="checkout-title">
                <i class="fas fa-shopping-cart"></i>
                Thanh toán
            </h1>
            <div class="checkout-steps">
                <div class="step">
                    <i class="fas fa-check-circle"></i>
                    <span>Giỏ hàng</span>
                </div>
                <i class="fas fa-chevron-right" style="color: #ddd;"></i>
                <div class="step active">
                    <i class="fas fa-credit-card"></i>
                    <span>Thanh toán</span>
                </div>
                <i class="fas fa-chevron-right" style="color: #ddd;"></i>
                <div class="step">
                    <i class="fas fa-check-double"></i>
                    <span>Hoàn thành</span>
                </div>
            </div>
        </div>

        <!-- Main Layout -->
<%--        <form id="checkout-form" method="post" action="${pageContext.request.contextPath}/order/place">--%>
        <form id="checkout-form" method="post" action="${pageContext.request.contextPath}${formAction}">
        <div class="checkout-layout">
                <!-- Left Column -->
                <div class="checkout-left">
                    <!-- Address Section -->
                    <div class="section-card">
                        <div class="section-header">
                            <h2 class="section-title">
                                <i class="fas fa-map-marker-alt"></i>
                                Địa chỉ nhận hàng
                            </h2>
                        </div>
                        <div class="section-body">
                            <!-- Name & Phone -->
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">
                                        Họ và tên <span class="required">*</span>
                                    </label>
                                    <input type="text"
                                           name="receiverName"
                                           class="form-input"
                                           placeholder="Nhập họ và tên người nhận"
                                           required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">
                                        Số điện thoại <span class="required">*</span>
                                    </label>
                                    <input type="tel"
                                           name="receiverPhone"
                                           class="form-input"
                                           placeholder="Nhập số điện thoại"
                                           pattern="[0-9]{10,11}"
                                           required>
                                </div>
                            </div>

                            <!-- Address -->
                            <div class="form-row full">
                                <div class="form-group">
                                    <label class="form-label">
                                        Địa chỉ chi tiết <span class="required">*</span>
                                    </label>
                                    <div class="input-with-action">
                                        <input type="text"
                                               name="receiverAddress"
                                               class="form-input"
                                               placeholder="Số nhà, tên đường..."
                                               required>
                                        <button type="button" id="btn-fill-profile-address" class="input-action" title="Dùng địa chỉ từ hồ sơ">
                                            <i class="fas fa-address-card"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <!-- Province, District, Ward -->
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">
                                        Tỉnh/Thành phố <span class="required">*</span>
                                    </label>
                                    <select id="province" class="form-select" required>
                                        <option value="">-- Đang tải... --</option>
                                    </select>
                                    <input type="hidden" name="receiverProvince" id="receiver-province">
                                </div>

                                <div class="form-group">
                                    <label class="form-label">
                                        Quận/Huyện <span class="required">*</span>
                                    </label>
                                    <select id="district" class="form-select" required disabled>
                                        <option value="">-- Chọn Quận/Huyện --</option>
                                    </select>
                                    <input type="hidden" name="receiverDistrict" id="receiver-district">
                                    <input type="hidden" name="toDistrictId" id="to-district-id">
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">
                                        Phường/Xã <span class="required">*</span>
                                    </label>
                                    <select id="ward" class="form-select" required disabled>
                                        <option value="">-- Chọn Phường/Xã --</option>
                                    </select>
                                    <input type="hidden" name="receiverWard" id="receiver-ward">
                                    <input type="hidden" name="toWardCode" id="to-ward-code">
                                </div>
                                <div></div>
                            </div>
                        </div>
                    </div>

                    <!-- Products Section -->
                    <c:set var="itemsTotal" value="0" scope="page"/>
                    <c:forEach var="g" items="${groups}">
                        <div class="shop-block" data-shop-id="${g.shop.id}">
                            <!-- Shop Header -->
                            <div class="shop-header-info">
                                <div class="shop-name-badge">
                                    <span class="shop-name-text">
                                        <i class="fas fa-store"></i>
                                        ${g.shop.displayName}
                                    </span>
                                    <span class="shop-badge">OFFICIAL</span>
                                </div>
                                <span class="shop-id">ID: ${g.shop.id}</span>
                            </div>

                            <!-- Products Table -->
                            <table class="product-table">
                                <thead>
                                    <tr>
                                        <th style="width: 45%;">Sản phẩm</th>
                                        <th style="width: 20%;">Đơn giá</th>
                                        <th style="width: 15%; text-align: center;">Số lượng</th>
                                        <th style="width: 20%; text-align: right;">Tạm tính</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="cd" items="${g.items}">
                                        <tr>
                                            <td>
                                                <div class="product-info">
                                                    <c:choose>
                                                        <c:when test="${not empty cd.product.imageUrl}">
                                                            <img src="${pageContext.request.contextPath}/images/${cd.product.imageUrl}"
                                                                 alt="${cd.product.name}"
                                                                 class="product-image">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="https://via.placeholder.com/60x60?text=No+Image"
                                                                 alt="${cd.product.name}"
                                                                 class="product-image">
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <div class="product-details">
                                                        <div class="product-name">${cd.product.name}</div>
                                                        <c:if test="${cd.variant != null}">
                                                            <div class="product-variant">
                                                                <i class="fas fa-tag"></i> ${cd.variant.name}
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="product-price">
                                                <fmt:formatNumber value="${cd.price}" type="currency"/>
                                            </td>
                                            <td class="product-quantity">
                                                x${cd.quantity}
                                            </td>
                                            <td class="product-subtotal">
                                                <fmt:formatNumber value="${cd.price * cd.quantity}" type="currency"/>
                                            </td>
                                        </tr>
                                        <c:set var="itemsTotal" value="${itemsTotal + (cd.price * cd.quantity)}"/>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <!-- Shop Shipping -->
                            <div class="shop-shipping">
                                <span class="shop-shipping-label">
                                    <i class="fas fa-shipping-fast"></i> Phí vận chuyển:
                                </span>
                                <span class="shop-shipping-amount" data-shop-id="${g.shop.id}">0 ₫</span>
                            </div>
                        </div>
                    </c:forEach>

                    <!-- Payment Method -->
                    <div class="section-card">
                        <div class="section-header">
                            <h2 class="section-title">
                                <i class="fas fa-credit-card"></i>
                                Phương thức thanh toán
                            </h2>
                        </div>
                        <div class="section-body">
                            <div class="payment-options">
                                <!-- COD -->
                                <label class="payment-option active">
                                    <input type="radio"
                                           name="paymentMethod"
                                           value="COD"
                                           class="payment-radio"
                                           checked>
                                    <div class="payment-info">
                                        <div class="payment-name">Thanh toán khi nhận hàng (COD)</div>
                                        <div class="payment-description">
                                            Thanh toán bằng tiền mặt khi nhận hàng
                                        </div>
                                    </div>
                                    <div class="payment-icon cod">
                                        <i class="fas fa-money-bill-wave"></i>
                                    </div>
                                </label>

                                <!-- VNPay -->
                                <label class="payment-option">
                                    <input type="radio"
                                           name="paymentMethod"
                                           value="VNPAY"
                                           class="payment-radio">
                                    <div class="payment-info">
                                        <div class="payment-name">Thanh toán VNPay</div>
                                        <div class="payment-description">
                                            Thanh toán qua cổng VNPay (ATM, Visa, MasterCard...)
                                        </div>
                                    </div>
                                    <div class="payment-icon vnpay">
                                        <i class="fas fa-university"></i>
                                    </div>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Column - Summary -->
                <div class="summary-sidebar">
                    <div class="summary-card">
                        <div class="summary-header">
                            <i class="fas fa-receipt"></i>
                            Tóm tắt đơn hàng
                        </div>
                        <div class="summary-body">
                            <div class="summary-row">
                                <span class="summary-label">Tổng tiền hàng:</span>
                                <span class="summary-value" id="items-total">
                                    <fmt:formatNumber value="${itemsTotal}" type="currency"/>
                                </span>
                            </div>

                            <div class="summary-row">
                                <span class="summary-label">Phí vận chuyển:</span>
                                <span class="summary-value" id="shipping-total">0 ₫</span>
                            </div>

                            <div class="summary-row summary-total">
                                <span class="summary-label">Tổng thanh toán:</span>
                                <span class="summary-value" id="grand-total">
                                    <fmt:formatNumber value="${itemsTotal}" type="currency"/>
                                </span>
                            </div>

                            <button type="submit" class="checkout-button">
                                <i class="fas fa-check-circle"></i>
                                Đặt hàng ngay
                            </button>

                            <div style="margin-top: 16px; padding: 12px; background: var(--shopee-orange-light); border-radius: 6px; font-size: 13px; color: var(--text-secondary);">
                                <i class="fas fa-shield-alt" style="color: var(--shopee-primary);"></i>
                                Đơn hàng của bạn được bảo vệ bởi SWP Shop
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Hidden Inputs -->
            <input type="hidden" name="clientShipTotal" id="client-ship-total" value="0">
            <input type="hidden" id="items-total-value" value="${itemsTotal}">
            <input type="hidden" id="cart-detail-ids" value="<c:forEach var='g' items='${groups}'><c:forEach var='cd' items='${g.items}'>${cd.id},</c:forEach></c:forEach>">

            <!-- CSRF Token -->
            <c:if test="${not empty _csrf}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
            </c:if>
        </form>
    </div>

    <!-- Include Footer -->
    <jsp:include page="../layout/footer.jsp" />

    <!-- Order JavaScript -->
    <script src="${pageContext.request.contextPath}/resources/client/js/order.js?v=<%= System.currentTimeMillis() %>"></script>
</body>

</html>
