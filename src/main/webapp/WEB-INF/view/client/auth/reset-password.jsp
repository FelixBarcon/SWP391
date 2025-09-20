<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Đặt lại mật khẩu - ShopMart</title>

            <!-- Bootstrap 5 & Font Awesome -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
                rel="stylesheet">

            <!-- Global CSS -->
            <link rel="stylesheet" href="<c:url value='/resources/client/css/global.css' />">
            <link rel="stylesheet" href="<c:url value='/resources/client/css/register.css' />">
            <style>
                .reset-password-container {
                    min-height: 100vh;
                    display: flex;
                    align-items: center;
                    background: #f8f9fa;
                    padding: 2rem 0;
                }

                .reset-card {
                    background: white;
                    padding: 2rem;
                    border-radius: 1rem;
                    box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
                }

                .reset-header {
                    text-align: center;
                    margin-bottom: 2rem;
                }

                .reset-title {
                    color: #2C3345;
                    font-size: 1.75rem;
                    font-weight: 700;
                    margin-bottom: 0.5rem;
                }

                .btn-reset {
                    width: 100%;
                    padding: 0.75rem;
                    font-weight: 600;
                    border-radius: 0.5rem;
                    background-color: #F45B69;
                    border-color: #F45B69;
                }

                .btn-reset:hover {
                    background-color: #d64c59;
                    border-color: #d64c59;
                }

                .password-strength {
                    height: 4px;
                    margin-top: 0.5rem;
                    border-radius: 2px;
                    background-color: #e9ecef;
                }

                .password-strength.weak {
                    background-color: #dc3545;
                    width: 33%;
                }

                .password-strength.medium {
                    background-color: #ffc107;
                    width: 66%;
                }

                .password-strength.strong {
                    background-color: #28a745;
                    width: 100%;
                }
            </style>
        </head>

        <body>
            <!-- Main Content -->
            <div class="reset-password-container">
                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-lg-5 col-md-7 col-sm-9">
                            <div class="reset-card">
                                <!-- Header Card -->
                                <div class="reset-header">
                                    <div class="key-icon mb-3">
                                        <i class="fas fa-key fa-2x text-primary"></i>
                                    </div>
                                    <h1 class="reset-title">Đặt lại mật khẩu</h1>
                                    <p class="text-muted">Nhập mật khẩu mới cho tài khoản của bạn</p>
                                </div>

                                <!-- Reset Password Form -->
                                <div class="reset-form">
                                    <!-- Hiển thị thông báo lỗi -->
                                    <c:if test="${not empty errorMessage}">
                                        <div class="alert alert-danger" role="alert">
                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                            ${errorMessage}
                                        </div>
                                    </c:if>

                                    <form id="resetPasswordForm"
                                        action="${pageContext.request.contextPath}/reset-password" method="post">
                                        <!-- CSRF Token -->
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <!-- Reset Token -->
                                        <input type="hidden" name="token" value="${token}" />

                                        <!-- Password Field -->
                                        <div class="mb-3">
                                            <label for="password" class="form-label">
                                                <i class="fas fa-lock me-2"></i>Mật khẩu mới
                                            </label>
                                            <div class="password-input-wrapper">
                                                <input type="password" class="form-control" id="password"
                                                    name="password" placeholder="••••" required minlength="8">
                                                <button type="button" class="password-toggle-btn" id="togglePassword">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </div>
                                            <div class="password-strength" id="passwordStrength"></div>
                                            <div class="invalid-feedback" id="passwordError"></div>
                                        </div>

                                        <!-- Confirm Password Field -->
                                        <div class="mb-4">
                                            <label for="confirmPassword" class="form-label">
                                                <i class="fas fa-lock me-2"></i>Xác nhận mật khẩu
                                            </label>
                                            <div class="password-input-wrapper">
                                                <input type="password" class="form-control" id="confirmPassword"
                                                    name="confirmPassword" placeholder="••••" required>
                                                <button type="button" class="password-toggle-btn"
                                                    id="toggleConfirmPassword">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </div>
                                            <div class="invalid-feedback" id="confirmPasswordError"></div>
                                        </div>

                                        <!-- Submit Button -->
                                        <div class="d-grid mb-4">
                                            <button type="submit" class="btn btn-primary btn-reset" id="submitBtn">
                                                Đặt lại mật khẩu
                                            </button>
                                        </div>

                                        <!-- Back to Login -->
                                        <div class="text-center">
                                            <a href="${pageContext.request.contextPath}/login"
                                                class="text-decoration-none">
                                                <i class="fas fa-arrow-left me-1"></i>
                                                Quay lại đăng nhập
                                            </a>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bootstrap JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

            <!-- Password Reset Script -->
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    // DOM Elements
                    const form = document.getElementById('resetPasswordForm');
                    const password = document.getElementById('password');
                    const confirmPassword = document.getElementById('confirmPassword');
                    const submitBtn = document.getElementById('submitBtn');

                    // Initialize functionality
                    initPasswordToggle();
                    initValidation();

                    function initPasswordToggle() {
                        const togglePassword = document.getElementById('togglePassword');
                        const toggleConfirmPassword = document.getElementById('toggleConfirmPassword');

                        if (togglePassword) {
                            togglePassword.addEventListener('click', function () {
                                togglePasswordVisibility(password, this);
                            });
                        }

                        if (toggleConfirmPassword) {
                            toggleConfirmPassword.addEventListener('click', function () {
                                togglePasswordVisibility(confirmPassword, this);
                            });
                        }
                    }

                    function togglePasswordVisibility(passwordField, toggleBtn) {
                        const icon = toggleBtn.querySelector('i');
                        if (passwordField.type === 'password') {
                            passwordField.type = 'text';
                            icon.classList.remove('fa-eye');
                            icon.classList.add('fa-eye-slash');
                        } else {
                            passwordField.type = 'password';
                            icon.classList.remove('fa-eye-slash');
                            icon.classList.add('fa-eye');
                        }
                    }

                    function initValidation() {
                        // Password strength check
                        if (password) {
                            password.addEventListener('input', function () {
                                checkPasswordStrength(this.value);
                            });

                            password.addEventListener('blur', function () {
                                validatePassword();
                            });
                        }

                        // Confirm password validation
                        if (confirmPassword) {
                            confirmPassword.addEventListener('input', validateConfirmPassword);
                            confirmPassword.addEventListener('blur', validateConfirmPassword);
                        }

                        // Form submission
                        if (form) {
                            form.addEventListener('submit', function (e) {
                                if (!validateForm()) {
                                    e.preventDefault();
                                    return false;
                                }
                            });
                        }
                    }

                    function checkPasswordStrength(passwordValue) {
                        const strengthBar = document.getElementById('passwordStrength');
                        const passwordError = document.getElementById('passwordError');

                        let strength = 0;
                        let feedback = '';

                        // Reset classes
                        strengthBar.className = 'password-strength';

                        if (passwordValue.length === 0) {
                            passwordError.textContent = '';
                            passwordError.style.display = 'none';
                            return;
                        }

                        // Check length
                        if (passwordValue.length >= 8) {
                            strength++;
                        } else {
                            feedback = 'Mật khẩu phải có ít nhất 8 ký tự';
                        }

                        // Check uppercase
                        if (/[A-Z]/.test(passwordValue)) {
                            strength++;
                        } else if (passwordValue.length >= 8) {
                            feedback = 'Thêm chữ hoa để tăng độ bảo mật';
                        }

                        // Check lowercase
                        if (/[a-z]/.test(passwordValue)) {
                            strength++;
                        }

                        // Check numbers
                        if (/[0-9]/.test(passwordValue)) {
                            strength++;
                        } else if (passwordValue.length >= 8 && strength >= 2) {
                            feedback = 'Thêm số để tăng độ bảo mật';
                        }

                        // Update strength bar
                        if (strength < 3) {
                            strengthBar.classList.add('weak');
                            if (!feedback) feedback = 'Mật khẩu yếu';
                        } else if (strength < 4) {
                            strengthBar.classList.add('medium');
                            if (!feedback) feedback = 'Mật khẩu trung bình';
                        } else {
                            strengthBar.classList.add('strong');
                            feedback = 'Mật khẩu mạnh';
                        }

                        // Show feedback
                        if (passwordError) {
                            if (strength >= 3 || passwordValue.length === 0) {
                                passwordError.textContent = '';
                                passwordError.style.display = 'none';
                            } else {
                                passwordError.textContent = feedback;
                                passwordError.style.display = 'block';
                            }
                        }
                    }

                    function validatePassword() {
                        const passwordError = document.getElementById('passwordError');

                        if (!password || !passwordError) return false;

                        if (password.value.length === 0) {
                            password.classList.remove('is-valid', 'is-invalid');
                            passwordError.style.display = 'none';
                            return false;
                        }

                        if (password.value.length < 8) {
                            password.classList.add('is-invalid');
                            password.classList.remove('is-valid');
                            passwordError.textContent = 'Mật khẩu phải có ít nhất 8 ký tự';
                            passwordError.style.display = 'block';
                            return false;
                        }

                        password.classList.add('is-valid');
                        password.classList.remove('is-invalid');
                        passwordError.style.display = 'none';
                        return true;
                    }

                    function validateConfirmPassword() {
                        const confirmPasswordError = document.getElementById('confirmPasswordError');

                        if (!confirmPassword || !password || !confirmPasswordError) return false;

                        if (confirmPassword.value === '') {
                            confirmPassword.classList.remove('is-valid', 'is-invalid');
                            confirmPasswordError.style.display = 'none';
                            return false;
                        }

                        if (confirmPassword.value !== password.value) {
                            confirmPassword.classList.add('is-invalid');
                            confirmPassword.classList.remove('is-valid');
                            confirmPasswordError.textContent = 'Mật khẩu xác nhận không khớp';
                            confirmPasswordError.style.display = 'block';
                            return false;
                        }

                        confirmPassword.classList.add('is-valid');
                        confirmPassword.classList.remove('is-invalid');
                        confirmPasswordError.style.display = 'none';
                        return true;
                    }

                    function validateForm() {
                        return validatePassword() && validateConfirmPassword();
                    }
                });
            </script>
        </body>

        </html>