<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Đăng ký trở thành người bán | Fashion Shop</title>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <!-- Global CSS -->
                <link rel="stylesheet" href="/resources/seller/css/seller-global.css">
                <!-- Auth CSS -->
                <link rel="stylesheet" href="/resources/seller/css/seller-auth.css">
                <!-- Register Form CSS -->
                <link rel="stylesheet" href="/resources/seller/css/register-form.css">
                <!-- Status Card CSS -->
                <link rel="stylesheet" href="/resources/seller/css/status-card.css">
                <!-- Font Awesome -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            </head>

            <body>
                <div class="register-container">
                    <div class="register-wrapper">
                        <!-- Left Banner Section -->
                        <div class="register-banner">
                            <div class="banner-content">
                                <h1 class="banner-title">Bắt đầu hành trình bán hàng của bạn</h1>
                                <p class="banner-description">Tham gia cộng đồng người bán của Fashion Shop và mở rộng
                                    kinh doanh của bạn</p>

                                <ul class="benefits-list">
                                    <li class="benefit-item">
                                        <i class="fas fa-check"></i>
                                        <span>Tiếp cận hàng triệu khách hàng tiềm năng</span>
                                    </li>
                                    <li class="benefit-item">
                                        <i class="fas fa-check"></i>
                                        <span>Công cụ quản lý bán hàng hiện đại</span>
                                    </li>
                                    <li class="benefit-item">
                                        <i class="fas fa-check"></i>
                                        <span>Hỗ trợ vận chuyển toàn quốc</span>
                                    </li>
                                    <li class="benefit-item">
                                        <i class="fas fa-check"></i>
                                        <span>Thanh toán an toàn và bảo mật</span>
                                    </li>
                                </ul>
                            </div>
                        </div>

                        <!-- Right Form Section -->
                        <div class="register-form-section">
                            <!-- Messages -->
                            <c:if test="${not empty error}">
                                <div class="toast-message error">
                                    <i class="fas fa-exclamation-circle"></i>
                                    ${error}
                                </div>
                            </c:if>
                            <c:if test="${not empty success}">
                                <div class="toast-message success">
                                    <i class="fas fa-check-circle"></i>
                                    ${success}
                                </div>
                            </c:if>

                            <!-- Status Message -->
                            <c:if test="${not empty currentStatus}">
                                <div
                                    class="status-card ${currentStatus eq 'REJECTED' ? 'rejected' : currentStatus eq 'PENDING' ? 'pending' : 'approved'}">
                                    <div class="status-icon">
                                        <c:choose>
                                            <c:when test="${currentStatus eq 'REJECTED'}">
                                                <i class="fas fa-times-circle"></i>
                                            </c:when>
                                            <c:when test="${currentStatus eq 'PENDING'}">
                                                <i class="fas fa-clock"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fas fa-check-circle"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="status-content">
                                        <h3 class="status-title">Trạng thái đăng ký</h3>
                                        <p class="status-text">
                                            <c:choose>
                                                <c:when test="${currentStatus eq 'REJECTED'}">
                                                    Yêu cầu chưa được đăng ký hoặc đã bị từ chối
                                                </c:when>
                                                <c:when test="${currentStatus eq 'PENDING'}">
                                                    Đang chờ xét duyệt
                                                </c:when>
                                                <c:otherwise>
                                                    Đã được phê duyệt
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Progress Steps -->
                            <div class="progress-steps">
                                <div class="step active">
                                    <div class="step-circle">1</div>
                                    <div class="step-label">Thông tin cửa hàng</div>
                                </div>
                                <div class="step">
                                    <div class="step-circle">2</div>
                                    <div class="step-label">Thông tin vận chuyển</div>
                                </div>
                                <div class="step">
                                    <div class="step-circle">3</div>
                                    <div class="step-label">Thông tin thanh toán</div>
                                </div>
                            </div>

                            <!-- Form Content -->
                            <form:form method="post" modelAttribute="sellerForm">
                                <!-- Store Information Section -->
                                <div class="form-section">
                                    <div class="section-header">
                                        <div class="section-icon">
                                            <i class="fas fa-store"></i>
                                        </div>
                                        <h2 class="section-title">Thông tin cửa hàng</h2>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label" for="displayName">Tên hiển thị <span
                                                class="required">*</span></label>
                                        <form:input path="displayName" class="form-control"
                                            placeholder="Nhập tên hiển thị của cửa hàng" />
                                        <form:errors path="displayName" class="error-message" />
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label" for="description">Mô tả cửa hàng</label>
                                        <form:textarea path="description" class="form-control" rows="3"
                                            placeholder="Mô tả ngắn về cửa hàng của bạn" />
                                        <form:errors path="description" class="error-message" />
                                    </div>
                                </div>

                                <!-- Shipping Information Section -->
                                <div class="form-section">
                                    <div class="section-header">
                                        <div class="section-icon">
                                            <i class="fas fa-truck"></i>
                                        </div>
                                        <h2 class="section-title">Thông tin vận chuyển</h2>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label" for="contactPhone">Số điện thoại liên hệ</label>
                                        <form:input path="contactPhone" class="form-control"
                                            placeholder="Số điện thoại để liên hệ giao nhận" />
                                        <form:errors path="contactPhone" class="error-message" />
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label" for="pickupAddress">Địa chỉ lấy hàng</label>
                                        <form:input path="pickupAddress" class="form-control"
                                            placeholder="Địa chỉ kho/cửa hàng để lấy hàng" />
                                        <form:errors path="pickupAddress" class="error-message" />
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label" for="returnAddress">Địa chỉ trả hàng</label>
                                        <form:input path="returnAddress" class="form-control"
                                            placeholder="Địa chỉ nhận hàng hoàn trả" />
                                        <form:errors path="returnAddress" class="error-message" />
                                    </div>
                                </div>

                                <!-- Payment Information Section -->
                                <div class="form-section">
                                    <div class="section-header">
                                        <div class="section-icon">
                                            <i class="fas fa-money-check"></i>
                                        </div>
                                        <h2 class="section-title">Thông tin thanh toán</h2>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label" for="bankCode">Ngân hàng</label>
                                        <form:input path="bankCode" class="form-control"
                                            placeholder="Mã ngân hàng (VD: BIDV, VCB, TCB)" />
                                        <form:errors path="bankCode" class="error-message" />
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label" for="bankAccountNo">Số tài khoản</label>
                                        <form:input path="bankAccountNo" class="form-control"
                                            placeholder="Số tài khoản ngân hàng" />
                                        <form:errors path="bankAccountNo" class="error-message" />
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label" for="bankAccountName">Chủ tài khoản</label>
                                        <form:input path="bankAccountName" class="form-control"
                                            placeholder="Tên chủ tài khoản ngân hàng" />
                                        <form:errors path="bankAccountName" class="error-message" />
                                    </div>
                                </div>

                                <!-- Navigation Buttons -->
                                <div class="form-navigation">
                                    <button type="button" class="nav-button next-button" onclick="nextStep()">
                                        <i class="fas fa-arrow-right"></i>
                                        Tiếp theo
                                    </button>
                                </div>


                            </form:form>
                        </div>
                    </div>
                </div>

                <!-- JavaScript for form navigation -->
                <script src="/resources/seller/js/register-form.js"></script>

                <!-- Form validation styles -->
                <link rel="stylesheet" href="/resources/seller/css/register-form-validation.css">
            </body>

            </html>