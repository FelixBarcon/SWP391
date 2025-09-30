<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>
                <c:if test="${not empty pageTitle}">${pageTitle} - </c:if>ShopMart Seller
            </title>

            <!-- Favicon -->
            <link rel="icon" type="image/x-icon" href="<c:url value='/resources/seller/images/favicon.ico'/>">

            <!-- Bootstrap 5 & Font Awesome -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

            <!-- Google Fonts -->
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
                rel="stylesheet">

            <!-- Seller CSS Files -->
            <link rel="stylesheet" href="<c:url value='/resources/seller/css/seller-global.css'/>">
            <link rel="stylesheet" href="<c:url value='/resources/seller/css/seller-sidebar.css'/>">

            <!-- Page Specific CSS -->
            <c:if test="${not empty additionalCSS}">
                <c:forEach var="css" items="${additionalCSS}">
                    <link rel="stylesheet" href="<c:url value='${css}'/>">
                </c:forEach>
            </c:if>

            <!-- Meta Tags for SEO -->
            <meta name="description" content="ShopMart Seller Panel - Quản lý cửa hàng trực tuyến">
            <meta name="keywords" content="seller, người bán, quản lý, bán hàng, e-commerce">
            <meta name="author" content="ShopMart Team">
            <meta name="robots" content="noindex, nofollow">
        </head>

        <body class="seller-body">
            <!-- Mobile Menu Toggle -->
            <button class="mobile-menu-toggle d-lg-none" id="mobileMenuToggle">
                <i class="fas fa-bars"></i>
            </button>

            <!-- Seller Layout Container -->
            <div class="seller-layout">
                <!-- Include Sidebar -->
                <jsp:include page="/WEB-INF/view/seller/layout/sidebar.jsp" />

                <!-- Main Content Area -->
                <main class="seller-main" id="sellerMain">
                    <!-- Page Content -->
                    <div class="admin-content">
                        <!-- Breadcrumb Navigation (Optional) -->
                        <c:if test="${not empty breadcrumb}">
                            <nav aria-label="breadcrumb" class="mb-4">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item">
                                        <a href="<c:url value='/admin'/>">
                                            <i class="fas fa-home"></i> Dashboard
                                        </a>
                                    </li>
                                    <c:forEach var="item" items="${breadcrumb}" varStatus="status">
                                        <c:choose>
                                            <c:when test="${status.last}">
                                                <li class="breadcrumb-item active" aria-current="page">${item.name}</li>
                                            </c:when>
                                            <c:otherwise>
                                                <li class="breadcrumb-item">
                                                    <a href="<c:url value='${item.url}'/>">${item.name}</a>
                                                </li>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </ol>
                            </nav>
                        </c:if>

                        <!-- Page Header -->
                        <c:if test="${not empty pageTitle and empty contentPage}">
                            <div class="seller-page-header mb-4">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="seller-page-header-content">
                                        <h1 class="seller-page-title">${pageTitle}</h1>
                                        <c:if test="${not empty pageDescription}">
                                            <p class="seller-page-description">${pageDescription}</p>
                                        </c:if>
                                    </div>
                                    <c:if test="${not empty pageActions}">
                                        <div class="seller-page-actions">
                                            ${pageActions}
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:if>

                        <!-- Alert Messages -->
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>
                                ${successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>
                                ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <c:if test="${not empty warningMessage}">
                            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                ${warningMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <c:if test="${not empty infoMessage}">
                            <div class="alert alert-info alert-dismissible fade show" role="alert">
                                <i class="fas fa-info-circle me-2"></i>
                                ${infoMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Main Content Area -->
                        <div class="content-wrapper">
                            <c:choose>
                                <c:when test="${not empty contentPage}">
                                    <jsp:include page="${contentPage}" />
                                </c:when>
                                <c:otherwise>
                                    <!-- Default content if no contentPage specified -->
                                    <div class="text-center py-5">
                                        <h3>Nội dung sẽ được hiển thị ở đây</h3>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>


                </main>
            </div>

            <!-- Mobile Overlay for Sidebar -->
            <div class="mobile-overlay" id="mobileOverlay"></div>

            <!-- Loading Overlay -->
            <div class="loading-overlay d-none" id="loadingOverlay">
                <div class="loading-spinner">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <div class="loading-text mt-2">Đang tải...</div>
                </div>
            </div>

            <!-- JavaScript Libraries -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

            <!-- Admin JavaScript -->
            <script src="<c:url value='/resources/admin/js/admin-layout.js'/>"></script>

            <!-- Page Specific JavaScript -->
            <c:if test="${not empty additionalJS}">
                <c:forEach var="js" items="${additionalJS}">
                    <script src="<c:url value='${js}'/>"></script>
                </c:forEach>
            </c:if>

            <!-- Inline JavaScript -->
            <c:if test="${not empty inlineJS}">
                <script type="text/javascript">
                    <c:out value="${inlineJS}" escapeXml="false" />
                </script>
            </c:if>

            <!-- Global Admin JavaScript -->
            <script>
                // Global admin configuration
                window.adminConfig = {
                    baseUrl: '<c:url value="/admin"/>',
                    csrfToken: '${_csrf.token}',
                    currentUser: {
                        id: '${sessionScope.user.id}',
                        name: '${sessionScope.user.firstName} ${sessionScope.user.lastName}',
                        role: 'admin'
                    }
                };

                // Auto-dismiss alerts after 5 seconds
                document.addEventListener('DOMContentLoaded', function () {
                    const alerts = document.querySelectorAll('.alert');
                    alerts.forEach(function (alert) {
                        setTimeout(function () {
                            const bsAlert = new bootstrap.Alert(alert);
                            bsAlert.close();
                        }, 5000);
                    });
                });

                // Loading overlay functions
                function showLoading() {
                    document.getElementById('loadingOverlay').classList.remove('d-none');
                }

                function hideLoading() {
                    document.getElementById('loadingOverlay').classList.add('d-none');
                }

                // Global error handler
                window.addEventListener('error', function (e) {
                    console.error('Global error:', e.error);
                    // Could send error reports to server
                });
            </script>

            <!-- Chart.js for Dashboard -->
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

            <!-- Seller Sidebar JavaScript -->
            <script src="<c:url value='/resources/seller/js/seller-sidebar.js'/>"></script>

            <!-- Page Specific JavaScript -->
            <c:if test="${not empty additionalJS}">
                <c:forEach var="js" items="${additionalJS}">
                    <script src="<c:url value='${js}'/>"></script>
                </c:forEach>
            </c:if>
        </body>

        </html>