<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Đặt hàng thành công - SWP Shop</title>

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
                        <!-- Success Icon -->
                        <div class="result-icon success">
                            <i class="fas fa-check-circle"></i>
                        </div>

                        <!-- Title -->
                        <h1 class="result-title success">
                            Đặt hàng thành công!
                        </h1>

                        <!-- Message -->
                        <p class="result-message">
                            Cảm ơn bạn đã tin tưởng và mua sắm tại SWP Shop.<br>
                            Đơn hàng của bạn đã được ghi nhận và đang được xử lý.
                        </p>

                        <!-- Order Info -->
                        <div class="order-info">
                            <div class="order-id">
                                <i class="fas fa-receipt" style="color: var(--shopee-primary); margin-right: 8px;"></i>
                                Mã đơn hàng: <strong>#${orderId}</strong>
                            </div>
                        </div>

                        <!-- Actions -->
                        <div class="result-actions">
                            <a href="${pageContext.request.contextPath}/orders/${orderId}" class="btn btn-primary">
                                <i class="fas fa-file-alt"></i>
                                Xem chi tiết đơn hàng
                            </a>
                            <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">
                                <i class="fas fa-home"></i>
                                Về trang chủ
                            </a>
                        </div>

                        <!-- Additional Info -->
                        <div
                            style="margin-top: 32px; padding: 20px; background: var(--shopee-orange-light); border-radius: 8px; text-align: left;">
                            <h4
                                style="font-size: 15px; font-weight: 600; color: var(--shopee-primary); margin-bottom: 12px;">
                                <i class="fas fa-info-circle"></i> Thông tin quan trọng
                            </h4>
                            <ul
                                style="font-size: 14px; color: var(--text-secondary); line-height: 1.8; margin: 0; padding-left: 20px;">
                                <li>Đơn hàng sẽ được xác nhận và giao trong vòng 2-3 ngày làm việc</li>
                                <li>Bạn sẽ nhận được thông báo qua email/SMS khi đơn hàng được vận chuyển</li>
                                <li>Vui lòng kiểm tra kỹ sản phẩm trước khi thanh toán</li>
                                <li>Liên hệ hotline <strong style="color: var(--shopee-primary);">1900-xxxx</strong> nếu
                                    cần hỗ trợ</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Include Footer -->
                <jsp:include page="../layout/footer.jsp" />

                <!-- Confetti Animation (Optional) -->
                <script>
                    // Simple confetti effect
                    function createConfetti() {
                        const colors = ['#ee4d2d', '#ff6633', '#ffb900', '#00c48c', '#0088ff'];
                        const confettiCount = 50;

                        for (let i = 0; i < confettiCount; i++) {
                            const confetti = document.createElement('div');
                            confetti.style.cssText = `
                    position: fixed;
                    width: 10px;
                    height: 10px;
                    background: ${colors[Math.floor(Math.random() * colors.length)]};
                    top: -10px;
                    left: ${Math.random() * 100}%;
                    opacity: ${Math.random()};
                    transform: rotate(${Math.random() * 360}deg);
                    animation: confettiFall ${2 + Math.random() * 3}s linear forwards;
                    pointer-events: none;
                    z-index: 10000;
                `;
                            document.body.appendChild(confetti);

                            setTimeout(() => confetti.remove(), 5000);
                        }
                    }

                    // Add animation keyframes
                    const style = document.createElement('style');
                    style.textContent = `
            @keyframes confettiFall {
                to {
                    top: 100vh;
                    transform: translateY(0) rotate(720deg);
                }
            }
        `;
                    document.head.appendChild(style);

                    // Trigger confetti on load
                    window.addEventListener('load', () => {
                        setTimeout(createConfetti, 200);
                    });
                </script>
            </body>

            </html>