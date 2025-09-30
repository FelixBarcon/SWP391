<%@ page contentType="text/html; charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Đổi Mật Khẩu - FPT Shop</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <link href="${pageContext.request.contextPath}/resources/account/css/change-password.css" rel="stylesheet">
        </head>

        <body>
            <div class="change-password-container animate-in">
                <a href="${pageContext.request.contextPath}/account/profile<c:if test='${not empty userId}'>?userId=${userId}</c:if>"
                    class="back-link">
                    <i class="fas fa-arrow-left"></i>
                    Quay lại hồ sơ
                </a>

                <div class="page-title">
                    <div class="icon-container">
                        <i class="fas fa-key"></i>
                    </div>
                    <h2>Đổi Mật Khẩu</h2>
                    <p>Cập nhật mật khẩu để bảo vệ tài khoản của bạn</p>
                </div>

                <!-- Alert Messages -->
                <c:if test="${not empty msg}">
                    <div class="alert-modern ${empty error ? 'alert-success' : 'alert-danger'}">
                        <i class="fas ${empty error ? 'fa-check-circle' : 'fa-exclamation-circle'}"></i>
                        ${msg}
                    </div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/account/change-password"
                    id="changePasswordForm">
                    <c:if test="${_csrf != null}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    </c:if>

                    <!-- DEV: giữ userId nếu không đăng nhập -->
                    <c:if test="${not empty userId}">
                        <input type="hidden" name="userId" value="${userId}" />
                    </c:if>

                    <!-- Current Password -->
                    <div class="form-group">
                        <label class="form-label" for="currentPassword">
                            <i class="fas fa-lock me-2"></i>Mật khẩu hiện tại
                        </label>
                        <div class="input-group-modern">
                            <input type="password" class="form-control-modern" id="currentPassword"
                                name="currentPassword" required placeholder="Nhập mật khẩu hiện tại">
                            <button type="button" class="password-toggle" onclick="togglePassword('currentPassword')">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <c:if test="${error == 'pw_current'}">
                            <div class="error-message">
                                <i class="fas fa-exclamation-circle"></i>
                                Mật khẩu hiện tại không đúng.
                            </div>
                        </c:if>
                    </div>

                    <!-- New Password -->
                    <div class="form-group">
                        <label class="form-label" for="newPassword">
                            <i class="fas fa-key me-2"></i>Mật khẩu mới
                        </label>
                        <div class="input-group-modern">
                            <input type="password" class="form-control-modern" id="newPassword" name="newPassword"
                                required minlength="8" placeholder="Nhập mật khẩu mới (tối thiểu 8 ký tự)">
                            <button type="button" class="password-toggle" onclick="togglePassword('newPassword')">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>

                        <!-- Password Strength Indicator -->
                        <div class="password-strength">
                            <div class="strength-bar">
                                <div class="strength-fill" id="strengthFill"></div>
                            </div>
                            <div class="strength-text" id="strengthText">Độ mạnh mật khẩu</div>
                        </div>

                        <!-- Password Requirements -->
                        <div class="requirements-list">
                            <div class="requirement-item" id="req-length">
                                <i class="fas fa-circle"></i>
                                Ít nhất 8 ký tự
                            </div>
                            <div class="requirement-item" id="req-uppercase">
                                <i class="fas fa-circle"></i>
                                Có chữ hoa
                            </div>
                            <div class="requirement-item" id="req-lowercase">
                                <i class="fas fa-circle"></i>
                                Có chữ thường
                            </div>
                            <div class="requirement-item" id="req-number">
                                <i class="fas fa-circle"></i>
                                Có số
                            </div>
                        </div>

                        <c:if test="${error == 'pw_short'}">
                            <div class="error-message">
                                <i class="fas fa-exclamation-circle"></i>
                                Mật khẩu mới phải có ít nhất 8 ký tự.
                            </div>
                        </c:if>
                    </div>

                    <!-- Confirm Password -->
                    <div class="form-group">
                        <label class="form-label" for="confirmPassword">
                            <i class="fas fa-shield-alt me-2"></i>Xác nhận mật khẩu mới
                        </label>
                        <div class="input-group-modern">
                            <input type="password" class="form-control-modern" id="confirmPassword"
                                name="confirmPassword" required minlength="8" placeholder="Nhập lại mật khẩu mới">
                            <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword')">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <c:if test="${error == 'pw_confirm'}">
                            <div class="error-message">
                                <i class="fas fa-exclamation-circle"></i>
                                Mật khẩu xác nhận không khớp.
                            </div>
                        </c:if>
                        <div id="confirmMatch" class="error-message" style="display: none;">
                            <i class="fas fa-exclamation-circle"></i>
                            Mật khẩu xác nhận không khớp.
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="btn-group-modern">
                        <button type="submit" class="btn-primary-modern" id="submitBtn">
                            <div class="loading-spinner" id="loadingSpinner"></div>
                            <i class="fas fa-save me-2"></i>
                            Cập nhật mật khẩu
                        </button>
                    </div>
                </form>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script src="${pageContext.request.contextPath}/resources/account/js/change-password.js"></script>
        </body>

        </html>