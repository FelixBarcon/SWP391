<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <fmt:setLocale value="vi_VN" />
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Chi tiết đơn hàng #${order.id} - SWP Shop</title>

                <!-- Font Awesome -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

                <!-- Confirmation CSS -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/client/css/confirmation.css">
            </head>

            <body>
                <!-- Confirmation Wrapper -->
                <div class="confirmation-wrapper">
                    <div class="confirmation-container">
                        <!-- Error Alert -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">
                                <i class="fas fa-exclamation-circle"></i>
                                ${error}
                            </div>
                        </c:if>

                        <!-- Success Banner -->
                        <div class="success-banner">
                            <div class="success-banner-icon">
                                <i class="fas fa-check-circle"></i>
                            </div>
                            <h2 class="success-banner-title">Đặt hàng thành công!</h2>
                            <p class="success-banner-subtitle">Cảm ơn bạn đã tin tưởng mua sắm tại SWP Shop</p>
                        </div>

                        <!-- Main Layout -->
                        <div class="confirmation-layout">
                            <!-- Left Column - Order Details -->
                            <div>
                                <!-- Order Info Card -->
                                <div class="confirmation-card">
                                    <div class="confirmation-header">
                                        <h1 class="confirmation-title">
                                            <i class="fas fa-file-invoice"></i>
                                            Thông tin đơn hàng
                                        </h1>
                                    </div>

                                    <div class="confirmation-body">
                                        <!-- Order Info Grid -->
                                        <div class="info-grid">
                                            <div class="info-item">
                                                <div class="info-label">
                                                    <i class="fas fa-hashtag"></i> Mã đơn hàng
                                                </div>
                                                <div class="info-value"
                                                    style="color: var(--shopee-primary); cursor: pointer;"
                                                    data-order-id="${order.id}" title="Click để sao chép">
                                                    #${order.id}
                                                </div>
                                            </div>

                                            <div class="info-item">
                                                <div class="info-label">
                                                    <i class="fas fa-clock"></i> Thời gian đặt
                                                </div>
                                                <div class="info-value">
                                                    ${order.createdAt}
                                                </div>
                                            </div>

                                            <div class="info-item">
                                                <div class="info-label">
                                                    <i class="fas fa-info-circle"></i> Trạng thái
                                                </div>
                                                <div class="info-value">
                                                    <c:choose>
                                                        <c:when test="${order.orderStatus.name() == 'PENDING_CONFIRM'}">
                                                            <span class="status-badge pending">
                                                                <i class="fas fa-hourglass-half"></i> Chờ xác nhận
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.orderStatus.name() == 'PENDING_PAYMENT'}">
                                                            <span class="status-badge warning">
                                                                <i class="fas fa-credit-card"></i> Chờ thanh toán
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.orderStatus.name() == 'PAID'}">
                                                            <span class="status-badge success">
                                                                <i class="fas fa-check-circle"></i> Đã thanh toán
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.orderStatus.name() == 'CANCELED'}">
                                                            <span class="status-badge danger">
                                                                <i class="fas fa-times-circle"></i> Đã hủy
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge">
                                                                ${order.orderStatus}
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>

                                            <div class="info-item">
                                                <div class="info-label">
                                                    <i class="fas fa-credit-card"></i> Thanh toán
                                                </div>
                                                <div class="info-value">
                                                    <c:choose>
                                                        <c:when test="${order.paymentMethod.name() == 'COD'}">
                                                            <i class="fas fa-money-bill-wave"
                                                                style="color: var(--success);"></i>
                                                            Thanh toán khi nhận
                                                        </c:when>
                                                        <c:when test="${order.paymentMethod.name() == 'VNPAY'}">
                                                            <i class="fas fa-university"
                                                                style="color: var(--blue);"></i>
                                                            VNPay
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${order.paymentMethod}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="divider"></div>

                                        <!-- Receiver Address -->
                                        <div class="address-section">
                                            <h3 class="section-title">
                                                <i class="fas fa-map-marker-alt"></i>
                                                Địa chỉ nhận hàng
                                            </h3>
                                            <div class="address-card">
                                                <div class="address-name">
                                                    <i class="fas fa-user"></i> ${order.receiverName}
                                                </div>
                                                <div class="address-phone">
                                                    <i class="fas fa-phone"></i> ${order.receiverPhone}
                                                </div>
                                                <div class="address-detail">
                                                    <i class="fas fa-home"></i>
                                                    <span>
                                                        ${order.receiverAddress}, ${order.receiverWard},
                                                        ${order.receiverDistrict}, ${order.receiverProvince}
                                                    </span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="divider"></div>

                                        <!-- Order Timeline -->
                                        <div class="timeline-section">
                                            <h3 class="section-title">
                                                <i class="fas fa-shipping-fast"></i>
                                                Tiến trình đơn hàng
                                            </h3>
                                            <div class="order-timeline">
                                                <div class="timeline-step active">
                                                    <div class="timeline-icon">
                                                        <i class="fas fa-check"></i>
                                                    </div>
                                                    <div class="timeline-content">
                                                        <div class="timeline-title">Đơn hàng đã đặt</div>
                                                        <div class="timeline-time">
                                                            ${order.createdAt}
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="timeline-step pending">
                                                    <div class="timeline-icon">
                                                        <i class="fas fa-box"></i>
                                                    </div>
                                                    <div class="timeline-content">
                                                        <div class="timeline-title">Đang chuẩn bị hàng</div>
                                                        <div class="timeline-time">Đang chờ shop xác nhận</div>
                                                    </div>
                                                </div>

                                                <div class="timeline-step pending">
                                                    <div class="timeline-icon">
                                                        <i class="fas fa-truck"></i>
                                                    </div>
                                                    <div class="timeline-content">
                                                        <div class="timeline-title">Đang giao hàng</div>
                                                        <div class="timeline-time">Chưa giao</div>
                                                    </div>
                                                </div>

                                                <div class="timeline-step pending">
                                                    <div class="timeline-icon">
                                                        <i class="fas fa-check-double"></i>
                                                    </div>
                                                    <div class="timeline-content">
                                                        <div class="timeline-title">Đã nhận hàng</div>
                                                        <div class="timeline-time">Chưa hoàn thành</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Right Column - Summary -->
                            <div class="sidebar-sticky">
                                <!-- Order Summary -->
                                <div class="summary-card">
                                    <div class="summary-header">
                                        <i class="fas fa-receipt"></i>
                                        Chi tiết thanh toán
                                    </div>
                                    <div class="summary-body">
                                        <div class="summary-row">
                                            <div class="summary-label">
                                                <i class="fas fa-shopping-bag"></i> Tổng tiền hàng:
                                            </div>
                                            <div class="summary-value">
                                                <fmt:formatNumber value="${order.itemsTotal}" type="currency" />
                                            </div>
                                        </div>

                                        <div class="summary-row">
                                            <div class="summary-label">
                                                <i class="fas fa-shipping-fast"></i> Phí vận chuyển:
                                            </div>
                                            <div class="summary-value">
                                                <fmt:formatNumber value="${order.shippingFee}" type="currency" />
                                            </div>
                                        </div>

                                        <div class="summary-row summary-total">
                                            <div class="summary-label">
                                                <i class="fas fa-money-check-alt"></i> Tổng thanh toán:
                                            </div>
                                            <div class="summary-value">
                                                <fmt:formatNumber value="${order.totalAmount}" type="currency" />
                                            </div>
                                        </div>

                                        <div class="security-badge">
                                            <div class="security-text">
                                                <i class="fas fa-shield-alt"></i>
                                                <strong>Thanh toán an toàn</strong>
                                                Được bảo vệ bởi SWP Shop
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Action Buttons -->
                                <div class="action-buttons">
                                    <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                                        <i class="fas fa-shopping-bag"></i>
                                        Tiếp tục mua sắm
                                    </a>
                                    <a href="#" class="btn btn-secondary" data-print-order>
                                        <i class="fas fa-print"></i>
                                        In đơn hàng
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Important Info Boxes -->
                        <div class="info-boxes">
                            <h3 class="info-boxes-title">
                                <i class="fas fa-info-circle"></i>
                                Thông tin quan trọng
                            </h3>
                            <div class="info-boxes-grid">
                                <div class="info-box">
                                    <div class="info-box-title">
                                        <i class="fas fa-clock"></i> Thời gian xử lý
                                    </div>
                                    <div class="info-box-content">
                                        Đơn hàng sẽ được shop xác nhận trong vòng 24 giờ làm việc
                                    </div>
                                </div>

                                <div class="info-box">
                                    <div class="info-box-title">
                                        <i class="fas fa-bell"></i> Thông báo
                                    </div>
                                    <div class="info-box-content">
                                        Bạn sẽ nhận thông báo qua Email/SMS khi đơn hàng được vận chuyển
                                    </div>
                                </div>

                                <div class="info-box">
                                    <div class="info-box-title">
                                        <i class="fas fa-box-open"></i> Kiểm tra hàng
                                    </div>
                                    <div class="info-box-content">
                                        Vui lòng kiểm tra kỹ sản phẩm trước khi thanh toán với shipper
                                    </div>
                                </div>

                                <div class="info-box">
                                    <div class="info-box-title">
                                        <i class="fas fa-headset"></i> Hỗ trợ 24/7
                                    </div>
                                    <div class="info-box-content">
                                        Liên hệ <strong>1900-xxxx</strong> nếu cần hỗ trợ
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Confirmation JS -->
                <script src="${pageContext.request.contextPath}/resources/client/js/confirmation.js"></script>
            </body>

            </html>