<%@ page contentType="text/html; charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Hồ sơ cá nhân - SWP Platform</title>

            <!-- External Libraries -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

            <!-- Custom CSS -->
            <link href="${pageContext.request.contextPath}/resources/account/css/profile.css" rel="stylesheet">

            <!-- Meta tags for SEO -->
            <meta name="description" content="Quản lý hồ sơ cá nhân và thông tin tài khoản trên SWP Platform">
            <meta name="keywords" content="profile, account, settings, SWP">
            <meta name="author" content="SWP Platform">
        </head>

        <body>
            <div class="profile-wrapper">
                <div class="container">
                    <!-- Header -->
                    <div class="profile-header">
                        <div class="header-content">
                            <h1 class="profile-title">
                                <i class="fas fa-user-circle"></i>
                                Hồ sơ cá nhân
                            </h1>
                            <p class="profile-subtitle">Quản lý thông tin tài khoản và cài đặt bảo mật của bạn</p>
                        </div>
                    </div>

                    <!-- Alerts -->
                    <div class="alert-container">
                        <c:if test="${param.updated != null}">
                            <div class="alert-modern alert-success">
                                <i class="fas fa-check-circle"></i>
                                <span>Đã cập nhật thành công: ${param.updated}</span>
                            </div>
                        </c:if>
                        <c:if test="${param.error != null}">
                            <div class="alert-modern alert-danger">
                                <i class="fas fa-exclamation-circle"></i>
                                <span>Có lỗi xảy ra: ${param.error}</span>
                            </div>
                        </c:if>
                    </div>

                    <!-- Main Content -->
                    <c:choose>
                        <c:when test="${u == null}">
                            <div class="profile-card">
                                <div class="error-state">
                                    <i class="fas fa-user-slash error-icon"></i>
                                    <h3>Không tìm thấy thông tin người dùng</h3>
                                    <p>Vui lòng đăng nhập lại để tiếp tục sử dụng dịch vụ.</p>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="profile-card">
                                <!-- Avatar Section -->
                                <div class="avatar-section">
                                    <div class="avatar-container">
                                        <c:choose>
                                            <c:when test="${not empty u.avatar}">
                                                <img src="${pageContext.request.contextPath}/images/${u.avatar}"
                                                    alt="Avatar" class="avatar-image" id="avatarPreview" />
                                            </c:when>
                                            <c:otherwise>
                                                <div class="avatar-placeholder">
                                                    <i class="fas fa-user"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="avatar-upload">
                                        <div class="file-input-wrapper">
                                            <input type="file" name="avatarFile" accept="image/*" class="file-input"
                                                id="avatarFile" form="profileForm" />
                                            <label for="avatarFile" class="file-input-label">
                                                <i class="fas fa-cloud-upload-alt"></i>
                                                <span>Chọn ảnh đại diện mới</span>
                                            </label>
                                        </div>
                                        <small class="text-muted d-block mt-2 text-center">
                                            Định dạng: JPG, PNG. Tối đa: 5MB
                                        </small>
                                    </div>

                                    <c:if test="${not empty u.avatar}">
                                        <div class="remove-avatar">
                                            <label>
                                                <input type="checkbox" name="removeAvatar" value="true"
                                                    form="profileForm" />
                                                <i class="fas fa-trash-alt"></i>
                                                Xóa ảnh đại diện hiện tại
                                            </label>
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Form Section -->
                                <div class="form-section">
                                    <h3 class="section-title">
                                        <i class="fas fa-id-card"></i>
                                        Thông tin cá nhân
                                    </h3>

                                    <form method="post" enctype="multipart/form-data"
                                        action="${pageContext.request.contextPath}/account/profile/update"
                                        id="profileForm">
                                        <c:if test="${_csrf != null}">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        </c:if>
                                        <input type="hidden" name="userId" value="${u.id}" />

                                        <div class="form-grid">
                                            <div class="form-group">
                                                <label class="form-label">
                                                    <i class="fas fa-envelope"></i>
                                                    Email <span class="required">*</span>
                                                </label>
                                                <input type="hidden" name="email" value="${u.email}" class="form-input"
                                                    required placeholder="example@email.com" />
                                                <input disabled type="email" name="email" value="${u.email}"
                                                    class="form-input" required placeholder="example@email.com" />
                                            </div>

                                            <div class="form-group">
                                                <label class="form-label">
                                                    <i class="fas fa-phone"></i>
                                                    Số điện thoại
                                                </label>
                                                <input type="tel" name="phone" value="${u.phone}" class="form-input"
                                                    placeholder="0123456789" />
                                            </div>
                                        </div>

                                        <div class="form-grid">
                                            <div class="form-group">
                                                <label class="form-label">
                                                    <i class="fas fa-user"></i>
                                                    Họ
                                                </label>
                                                <input type="text" name="lastName" value="${u.lastName}"
                                                    class="form-input" placeholder="Nguyễn" />
                                            </div>

                                            <div class="form-group">
                                                <label class="form-label">
                                                    <i class="fas fa-user"></i>
                                                    Tên
                                                </label>
                                                <input type="text" name="firstName" value="${u.firstName}"
                                                    class="form-input" placeholder="Văn A" />
                                            </div>
                                        </div>

                                        <!-- <div class="form-group">
                                            <label class="form-label">
                                                <i class="fas fa-id-badge"></i>
                                                Họ và tên đầy đủ <span class="required">*</span>
                                            </label>
                                        </div> -->
                                        <input type="hidden" name="fullName" value="${u.fullName}" class="form-input"
                                            required placeholder="Nguyễn Văn A" />

                                        <div class="form-group">
                                            <label class="form-label">
                                                <i class="fas fa-map-marker-alt"></i>
                                                Địa chỉ
                                            </label>
                                            <textarea name="address" class="form-input form-textarea"
                                                placeholder="Nhập địa chỉ của bạn...">${u.address}</textarea>
                                        </div>

                                        <div class="form-actions">
                                            <a href="${pageContext.request.contextPath}/account/change-password<c:if test='${not empty u.id}'>?userId=${u.id}</c:if>"
                                                class="btn-secondary">
                                                <i class="fas fa-key"></i>
                                                Đổi mật khẩu
                                            </a>

                                            <button type="submit" class="btn-primary" id="saveBtn">
                                                <span class="btn-text">
                                                    <i class="fas fa-save"></i>
                                                    Lưu thông tin
                                                </span>
                                                <div class="loading-spinner"></div>
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- External Scripts -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

            <!-- Custom Scripts -->
            <script src="${pageContext.request.contextPath}/resources/account/js/profile.js"></script>
        </body>

        </html>