<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Đăng Nhập - Marketplace</title>

                <!-- Bootstrap 5 CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

                <!-- Font Awesome -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

                <!-- Google Fonts - Inter -->
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap"
                    rel="stylesheet">

                <!-- Global CSS -->
                <link rel="stylesheet" href="<c:url value='/resources/client/css/global.css'/>">
                <link rel="stylesheet" href="<c:url value='/resources/client/css/header.css'/>">

                <!-- CSS riêng cho trang đăng nhập -->
                <link rel="stylesheet" href="<c:url value='/resources/client/css/login.css'/>">
            </head>

            <body>
                <!-- Header -->
                <jsp:include page="../layout/header.jsp" />

                <!-- Main Content -->
                <div class="login-container">
                    <div class="container">
                        <div class="row justify-content-center">
                            <div class="col-lg-4 col-md-6 col-sm-8">
                                <div class="login-card">
                                    <!-- Header Card -->
                                    <div class="login-header">
                                        <h1 class="login-title">
                                            <i class="fas fa-sign-in-alt me-2"></i>
                                            Đăng Nhập
                                        </h1>
                                        <p class="login-subtitle">
                                            Chào mừng bạn quay trở lại
                                        </p>
                                    </div>

                                    <!-- Login Form -->
                                    <div class="login-form">
                                        <!-- Hiển thị thông báo lỗi -->
                                        <c:if test="${not empty error}">
                                            <div class="alert alert-danger" role="alert">
                                                <i class="fas fa-exclamation-triangle me-2"></i>
                                                ${error}
                                            </div>
                                        </c:if>

                                        <!-- Hiển thị thông báo thành công -->
                                        <c:if test="${not empty success}">
                                            <div class="alert alert-success" role="alert">
                                                <i class="fas fa-check-circle me-2"></i>
                                                ${success}
                                            </div>
                                        </c:if>

                                        <form id="loginForm" action="${pageContext.request.contextPath}/login"
                                            method="post">

                                            <!-- Email Field -->
                                            <div class="mb-3">
                                                <label for="email" class="form-label">
                                                    <i class="fas fa-envelope me-2"></i>Email *
                                                </label>
                                                <input type="email" class="form-control" id="email" name="email"
                                                    placeholder="Nhập email của bạn" required value="${email}">
                                                <div class="invalid-feedback" id="emailError"></div>
                                            </div>

                                            <!-- Password Field -->
                                            <div class="mb-3">
                                                <label for="password" class="form-label">
                                                    <i class="fas fa-lock me-2"></i>Mật khẩu *
                                                </label>
                                                <input type="password" class="form-control" id="password"
                                                    name="password" placeholder="Nhập mật khẩu" required>
                                                <div class="invalid-feedback" id="passwordError"></div>
                                            </div>

                                            <!-- Remember Me & Forgot Password -->
                                            <div class="mb-3 d-flex justify-content-between align-items-center">
                                                <div class="form-check">
                                                    <input type="checkbox" class="form-check-input" id="rememberMe"
                                                        name="rememberMe">
                                                    <label class="form-check-label" for="rememberMe">
                                                        Ghi nhớ đăng nhập
                                                    </label>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/forgot-password"
                                                    class="forgot-link">
                                                    Quên mật khẩu?
                                                </a>
                                            </div>

                                            <!-- Submit Button -->
                                            <div class="d-grid mb-3">
                                                <button type="submit" class="btn btn-login" id="submitBtn">
                                                    <i class="fas fa-sign-in-alt me-2"></i>
                                                    Đăng Nhập
                                                </button>
                                            </div>

                                            <!-- Register Link -->
                                            <div class="text-center">
                                                <p class="register-link-text">
                                                    Chưa có tài khoản?
                                                    <a href="${pageContext.request.contextPath}/register"
                                                        class="register-link">
                                                        Đăng ký ngay
                                                    </a>
                                                </p>
                                            </div>

                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Footer -->
                <jsp:include page="../layout/footer.jsp" />

                <!-- Bootstrap JS -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

                <!-- jQuery -->
                <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>

                <!-- Login JS -->
                <script src="<c:url value='/resources/client/js/login.js'/>"></script>
            </body>

            </html>