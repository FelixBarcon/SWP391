<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Đặt hàng thất bại - SWP Shop</title>

            <!-- Font Awesome -->
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

            <!-- Order CSS -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/client/css/order.css">
        </head>

        <body>
            <!-- Include Header -->
            <jsp:include page="../layout/header.jsp" />

            <!-- Result Container -->
            <div class="result-container">
                <div class="result-card">
                    <!-- Failed Icon -->
                    <div class="result-icon failed">
                        <i class="fas fa-times-circle"></i>
                    </div>

                    <!-- Title -->
                    <h1 class="result-title failed">
                        Đặt hàng thất bại!
                    </h1>

                    <!-- Message -->
                    <p class="result-message">
                        <c:choose>
                            <c:when test="${not empty message}">
                                ${message}
                            </c:when>
                            <c:otherwise>
                                Đã có lỗi xảy ra trong quá trình xử lý đơn hàng của bạn.<br>
                                Vui lòng thử lại hoặc liên hệ với chúng tôi để được hỗ trợ.
                            </c:otherwise>
                        </c:choose>
                    </p>

                    <!-- Error Details (if available) -->
                    <c:if test="${not empty errorDetails}">
                        <div
                            style="margin: 24px 0; padding: 16px; background: #fff3cd; border-left: 4px solid var(--warning); border-radius: 6px; text-align: left;">
                            <div style="font-size: 14px; font-weight: 600; color: #996800; margin-bottom: 8px;">
                                <i class="fas fa-exclamation-triangle"></i> Chi tiết lỗi:
                            </div>
                            <div style="font-size: 13px; color: #664d00; line-height: 1.6;">
                                ${errorDetails}
                            </div>
                        </div>
                    </c:if>

                    <!-- Actions -->
                    <div class="result-actions">
                        <a href="${pageContext.request.contextPath}/cart" class="btn btn-primary">
                            <i class="fas fa-shopping-cart"></i>
                            Quay lại giỏ hàng
                        </a>
                        <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">
                            <i class="fas fa-home"></i>
                            Về trang chủ
                        </a>
                    </div>

                    <!-- Support Info -->
                    <div style="margin-top: 32px; padding: 20px; background: var(--bg-gray); border-radius: 8px;">
                        <h4 style="font-size: 15px; font-weight: 600; color: var(--text-primary); margin-bottom: 12px;">
                            <i class="fas fa-headset"></i> Cần hỗ trợ?
                        </h4>
                        <div style="font-size: 14px; color: var(--text-secondary); line-height: 1.8;">
                            <div style="margin-bottom: 8px;">
                                <i class="fas fa-phone" style="color: var(--shopee-primary); width: 20px;"></i>
                                Hotline: <strong style="color: var(--shopee-primary);">1900-xxxx</strong>
                            </div>
                            <div style="margin-bottom: 8px;">
                                <i class="fas fa-envelope" style="color: var(--shopee-primary); width: 20px;"></i>
                                Email: <strong style="color: var(--shopee-primary);">support@swpshop.com</strong>
                            </div>
                            <div>
                                <i class="fas fa-clock" style="color: var(--shopee-primary); width: 20px;"></i>
                                Giờ làm việc: <strong>8:00 - 22:00 (Tất cả các ngày)</strong>
                            </div>
                        </div>
                    </div>

                    <!-- Common Issues -->
                    <div
                        style="margin-top: 24px; padding: 20px; background: var(--shopee-orange-light); border-radius: 8px; text-align: left;">
                        <h4
                            style="font-size: 15px; font-weight: 600; color: var(--shopee-primary); margin-bottom: 12px;">
                            <i class="fas fa-lightbulb"></i> Một số lý do phổ biến:
                        </h4>
                        <ul
                            style="font-size: 14px; color: var(--text-secondary); line-height: 1.8; margin: 0; padding-left: 20px;">
                            <li>Thông tin thanh toán không chính xác</li>
                            <li>Số dư tài khoản không đủ</li>
                            <li>Phiên giao dịch đã hết hạn</li>
                            <li>Sản phẩm đã hết hàng hoặc không còn bán</li>
                            <li>Lỗi kết nối mạng</li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Include Footer -->
            <jsp:include page="../layout/footer.jsp" />
        </body>

        </html>