<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Đăng Ký - Marketplace</title>
                <!-- Bootstrap CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <!-- Font Awesome -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <!-- Google Fonts - Inter -->
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
                    rel="stylesheet">
                <!-- Global CSS với biến chung -->
                <link rel="stylesheet" href="<c:url value='/resources/client/css/global.css' />">
                <!-- Header CSS -->
                <link rel="stylesheet" href="<c:url value='/resources/client/css/header.css' />">
                <!-- CSS riêng cho trang đăng ký -->
                <link rel="stylesheet" href="<c:url value='/resources/client/css/register.css'/>">
            </head>

            <body>
                <!-- Header -->
                <jsp:include page="../layout/header.jsp" />

                <!-- Main Content -->
                <div class="register-container">
                    <div class="container">
                        <div class="row justify-content-center">
                            <div class="col-lg-6 col-md-8 col-sm-10">
                                <div class="register-card">
                                    <!-- Header Card -->
                                    <div class="register-header">
                                        <h2 class="register-title">
                                            <i class="fas fa-user-plus me-2"></i>
                                            Đăng Ký Tài Khoản
                                        </h2>
                                        <p class="register-subtitle">
                                            Tạo tài khoản mới để bắt đầu mua sắm
                                        </p>
                                    </div>

                                    <!-- Registration Form -->
                                    <form:form method="post" action="${pageContext.request.contextPath}/register"
                                        modelAttribute="newUser" class="register-form" id="registerForm">

                                        <!-- First Name Field -->
                                        <div class="mb-3">
                                            <label for="firstName" class="form-label">
                                                <i class="fas fa-user me-2"></i>Họ *
                                            </label>
                                            <input type="text" class="form-control" id="firstName" name="firstName"
                                                placeholder="Nhập họ của bạn" required />
                                            <div class="invalid-feedback" id="firstNameError"></div>
                                        </div>

                                        <!-- Last Name Field -->
                                        <div class="mb-3">
                                            <label for="lastName" class="form-label">
                                                <i class="fas fa-user me-2"></i>Tên *
                                            </label>
                                            <input type="text" class="form-control" id="lastName" name="lastName"
                                                placeholder="Nhập tên của bạn" required />
                                            <div class="invalid-feedback" id="lastNameError"></div>
                                        </div>

                                        <!-- Email Field -->
                                        <div class="mb-3">
                                            <label for="email" class="form-label">
                                                <i class="fas fa-envelope me-2"></i>Email *
                                            </label>
                                            <form:input path="email" type="email" class="form-control" id="email"
                                                placeholder="Nhập địa chỉ email của bạn" required="true" />
                                            <div class="invalid-feedback" id="emailError"></div>
                                        </div>

                                        <!-- Password Field -->
                                        <div class="mb-3">
                                            <label for="password" class="form-label">
                                                <i class="fas fa-lock me-2"></i>Mật khẩu *
                                            </label>
                                            <div class="password-input-wrapper">
                                                <form:input path="passWord" type="password" class="form-control"
                                                    id="password" placeholder="Nhập mật khẩu" required="true" />
                                                <button type="button" class="password-toggle-btn" id="togglePassword">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </div>
                                            <div class="password-strength" id="passwordStrength"></div>
                                            <div class="invalid-feedback" id="passwordError"></div>
                                        </div>

                                        <!-- Confirm Password Field -->
                                        <div class="mb-3">
                                            <label for="confirmPassword" class="form-label">
                                                <i class="fas fa-lock me-2"></i>Xác nhận mật khẩu *
                                            </label>
                                            <div class="password-input-wrapper">
                                                <input type="password" class="form-control" id="confirmPassword"
                                                    placeholder="Nhập lại mật khẩu" required>
                                                <button type="button" class="password-toggle-btn"
                                                    id="toggleConfirmPassword">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </div>
                                            <div class="invalid-feedback" id="confirmPasswordError"></div>
                                        </div>

                                        <!-- Terms and Conditions -->
                                        <div class="mb-3 form-check">
                                            <input type="checkbox" class="form-check-input" id="termsCheck" required>
                                            <label class="form-check-label" for="termsCheck">
                                                Tôi đồng ý với
                                                <a href="#" class="terms-link">Điều khoản sử dụng</a>
                                                và
                                                <a href="#" class="terms-link">Chính sách bảo mật</a>
                                            </label>
                                            <div class="invalid-feedback" id="termsError"></div>
                                        </div>

                                        <!-- Submit Button -->
                                        <div class="d-grid mb-3">
                                            <button type="submit" class="btn btn-register" id="submitBtn">
                                                <i class="fas fa-user-plus me-2"></i>
                                                Đăng Ký
                                            </button>
                                        </div>

                                        <!-- Login Link -->
                                        <div class="text-center">
                                            <p class="login-link-text">
                                                Đã có tài khoản?
                                                <a href="${pageContext.request.contextPath}/login" class="login-link">
                                                    Đăng nhập ngay
                                                </a>
                                            </p>
                                        </div>

                                    </form:form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Footer -->
                <jsp:include page="../layout/footer.jsp" />

                <!-- Bootstrap JS -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <!-- Custom JS -->
                <script src="<c:url value='/resources/client/js/register.js'/>"></script>
            </body>

            </html>