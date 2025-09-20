<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Quên mật khẩu - ShopMart</title>

            <!-- Bootstrap 5 & Font Awesome -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
                rel="stylesheet">

            <!-- Global CSS và CSS riêng -->
            <link rel="stylesheet" href="<c:url value='/resources/client/css/global.css' />">
            <link rel="stylesheet" href="<c:url value='/resources/client/css/forgot-password.css' />">
        </head>

        <body class="forgot-password-page">
            <div class="forgot-password-container">
                <div class="container-fluid">
                    <div class="row min-vh-100">
                        <!-- Left Side - Branding -->
                        <div class="col-lg-6 d-none d-lg-flex branding-section">
                            <div class="branding-content">
                                <div class="brand-logo">
                                    <i class="fas fa-shopping-bag"></i>
                                    <span>ShopMart</span>
                                </div>
                                <h2 class="branding-title">Khôi phục tài khoản</h2>
                                <p class="branding-subtitle">
                                    Đừng lo lắng! Chúng tôi sẽ giúp bạn lấy lại quyền truy cập vào tài khoản một cách
                                    nhanh chóng và an toàn.
                                </p>
                                <div class="security-features">
                                    <div class="security-item">
                                        <i class="fas fa-shield-alt"></i>
                                        <span>Bảo mật cao</span>
                                    </div>
                                    <div class="security-item">
                                        <i class="fas fa-clock"></i>
                                        <span>Xử lý nhanh chóng</span>
                                    </div>
                                    <div class="security-item">
                                        <i class="fas fa-envelope-open"></i>
                                        <span>Gửi email tự động</span>
                                    </div>
                                </div>

                                <!-- Illustration -->
                                <div class="reset-illustration">
                                    <div class="email-icon">
                                        <i class="fas fa-envelope"></i>
                                    </div>
                                    <div class="security-shield">
                                        <i class="fas fa-shield-alt"></i>
                                    </div>
                                    <div class="key-icon">
                                        <i class="fas fa-key"></i>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Right Side - Reset Form -->
                        <div class="col-lg-6 forgot-form-section">
                            <div class="forgot-form-container">
                                <!-- Back to Login -->
                                <div class="back-link">
                                    <a href="<c:url value='/login'/>" class="btn-back">
                                        <i class="fas fa-arrow-left"></i>
                                        Quay lại đăng nhập
                                    </a>
                                </div>

                                <!-- Form Header -->
                                <div class="form-header">
                                    <h1 class="form-title">Quên mật khẩu?</h1>
                                    <p class="form-subtitle">
                                        Nhập địa chỉ email của bạn và chúng tôi sẽ gửi link khôi phục mật khẩu
                                    </p>
                                </div>

                                <!-- Success Message -->
                                <c:if test="${not empty successMessage}">
                                    <div class="alert alert-success alert-dismissible fade show" role="alert"
                                        id="successAlert">
                                        <i class="fas fa-check-circle me-2"></i>
                                        ${successMessage}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                </c:if>

                                <!-- Error Message -->
                                <c:if test="${not empty errorMessage}">
                                    <div class="alert alert-danger alert-dismissible fade show" role="alert"
                                        id="errorAlert">
                                        <i class="fas fa-exclamation-circle me-2"></i>
                                        ${errorMessage}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                </c:if>

                                <!-- Forgot Password Form -->
                                <form id="forgotPasswordForm" action="<c:url value='/forgot-password'/>" method="post"
                                    class="forgot-form">
                                    <!-- CSRF Token -->
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <div class="form-step active" id="step1">
                                        <div class="mb-4">
                                            <label for="email" class="form-label">
                                                <i class="fas fa-envelope me-2"></i>
                                                Địa chỉ email
                                            </label>
                                            <div class="input-wrapper">
                                                <input type="email" class="form-control" id="email" name="email"
                                                    placeholder="Nhập email của bạn" required>
                                                <div class="input-icon">
                                                    <i class="fas fa-envelope"></i>
                                                </div>
                                            </div>
                                            <div class="invalid-feedback" id="emailError"></div>
                                            <div class="form-hint">
                                                <i class="fas fa-info-circle"></i>
                                                Chúng tôi sẽ gửi link khôi phục đến email này
                                            </div>
                                        </div>

                                        <button type="submit" class="btn btn-primary btn-submit" id="submitBtn">
                                            <span class="btn-text">
                                                <i class="fas fa-paper-plane me-2"></i>
                                                Gửi link khôi phục
                                            </span>
                                            <span class="btn-loading d-none">
                                                <i class="fas fa-spinner fa-spin me-2"></i>
                                                Đang gửi...
                                            </span>
                                        </button>
                                    </div>

                                    <!-- Success Step -->
                                    <div class="form-step" id="step2">
                                        <div class="success-content">
                                            <div class="success-icon">
                                                <i class="fas fa-check-circle"></i>
                                            </div>
                                            <h3>Email đã được gửi!</h3>
                                            <p>Chúng tôi đã gửi link khôi phục mật khẩu đến</p>
                                            <p class="email-sent" id="emailSent"></p>

                                            <div class="next-steps">
                                                <div class="step-item">
                                                    <span class="step-number">1</span>
                                                    <span>Kiểm tra hộp thư đến</span>
                                                </div>
                                                <div class="step-item">
                                                    <span class="step-number">2</span>
                                                    <span>Nhấp vào link trong email</span>
                                                </div>
                                                <div class="step-item">
                                                    <span class="step-number">3</span>
                                                    <span>Tạo mật khẩu mới</span>
                                                </div>
                                            </div>

                                            <div class="resend-section">
                                                <p>Không nhận được email?</p>
                                                <button type="button" class="btn btn-outline-primary btn-resend"
                                                    id="resendBtn">
                                                    <i class="fas fa-redo me-2"></i>
                                                    Gửi lại
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </form>

                                <!-- Additional Help -->
                                <div class="additional-help">
                                    <div class="help-section">
                                        <h6>Cần thêm trợ giúp?</h6>
                                        <div class="help-options">
                                            <a href="#" class="help-link">
                                                <i class="fas fa-headset"></i>
                                                Liên hệ hỗ trợ
                                            </a>
                                            <a href="#" class="help-link">
                                                <i class="fas fa-question-circle"></i>
                                                Câu hỏi thường gặp
                                            </a>
                                        </div>
                                    </div>
                                </div>

                                <!-- Footer Links -->
                                <div class="form-footer">
                                    <p>Nhớ lại mật khẩu? <a href="<c:url value='/login'/>">Đăng nhập ngay</a></p>
                                    <p>Chưa có tài khoản? <a href="<c:url value='/register'/>">Đăng ký miễn phí</a></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bootstrap JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

            <!-- Forgot Password JS -->
            <script src="<c:url value='/resources/client/js/forgot-password.js'/>"></script>
        </body>

        </html>