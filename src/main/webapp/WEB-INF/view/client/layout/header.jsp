<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
            rel="stylesheet">

        <!-- Global CSS với biến chung -->
        <link rel="stylesheet" href="<c:url value='/resources/client/css/global.css' />">
        <!-- CSS riêng cho header -->
        <link rel="stylesheet" href="<c:url value='/resources/client/css/header.css' />">

         <!-- CSS riêng cho footer -->
        <link rel="stylesheet" href="<c:url value='/resources/client/css/footer.css' />">

        <!-- ===== BẮT ĐẦU HEADER HTML ===== -->
        <header class="main-header fade-in">
            <nav class="navbar navbar-expand-lg">
                <div class="container-fluid px-4">

                    <!-- ===== LOGO THƯƠNG HIỆU ===== -->
                    <a class="brand-logo" href="<c:url value='/' />">
                        <div class="brand-icon">
                            <i class="fas fa-store"></i>
                        </div>
                        <span>SWP</span>
                    </a>

                    <!-- ===== NÚT MENU CHO MOBILE ===== -->
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                        data-bs-target="#navbarContent">
                        <span class="navbar-toggler-icon"></span>
                    </button>

                    <!-- ===== NỘI DUNG MENU CHÍNH ===== -->
                    <div class="collapse navbar-collapse" id="navbarContent">

                        <!-- ===== DROPDOWN DANH MỤC SẢN PHẨM ===== -->
                        <div class="categories-dropdown dropdown d-none d-lg-block">
                            <button class="dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                <i class="fas fa-th-large me-2"></i>Danh mục
                            </button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#"><i class="fas fa-laptop text-primary"></i>Điện
                                        tử</a></li>
                                <li><a class="dropdown-item" href="#"><i class="fas fa-tshirt text-success"></i>Thời
                                        trang</a></li>
                                <li><a class="dropdown-item" href="#"><i class="fas fa-home text-warning"></i>Gia
                                        dụng</a></li>
                                <li><a class="dropdown-item" href="#"><i class="fas fa-gamepad text-danger"></i>Thể
                                        thao</a></li>
                                <li><a class="dropdown-item" href="#"><i class="fas fa-book text-info"></i>Sách</a>
                                </li>
                                <li><a class="dropdown-item" href="#"><i class="fas fa-car text-dark"></i>Ô
                                        tô</a></li>
                                <li>
                                    <hr class="dropdown-divider">
                                </li>
                                <li><a class="dropdown-item fw-bold" href="#"><i class="fas fa-eye text-primary"></i>Xem
                                        tất cả</a></li>
                            </ul>
                        </div>

                        <!-- ===== THANH TÌM KIẾM ===== -->
                        <div class="search-wrapper">
                            <div class="search-container">
                                <form class="d-flex" action="<c:url value='/search' />" method="get">
                                    <input class="search-input" type="search" name="q"
                                        placeholder="Tìm kiếm sản phẩm, thương hiệu..." autocomplete="off">
                                    <button class="search-btn" type="submit">
                                        <i class="fas fa-search"></i>
                                    </button>
                                </form>
                            </div>
                        </div>

                        <!-- ===== MENU ĐIỀU HƯỚNG ===== -->
                        <ul class="navbar-nav ms-auto align-items-center">

                            <!-- Link cho người bán hàng -->
                            <li class="nav-item">
                                <a class="nav-link" href="<c:url value='/seller/register' />">
                                    <i class="fas fa-store"></i>Bán hàng
                                </a>
                            </li>

                            <!-- ===== KIỂM TRA TRẠNG THÁI ĐĂNG NHẬP ===== -->
                            <c:choose>
                                <c:when test="${not empty sessionScope.fullName}">
                                    <!-- ===== MENU CHO USER ĐÃ ĐĂNG NHẬP ===== -->

                                    <!-- Thông báo -->
                                    <li class="nav-item position-relative me-2">
                                        <a class="nav-link" href="<c:url value='/notifications' />" title="Thông báo">
                                            <i class="fas fa-bell"></i>
                                            <span class="notification-badge">3</span>
                                        </a>
                                    </li>

                                    <!-- Yêu thích -->
                                    <li class="nav-item position-relative me-2">
                                        <a class="nav-link" href="<c:url value='/wishlist' />" title="Yêu thích">
                                            <i class="fas fa-heart"></i>
                                            <span class="notification-badge" style="background: #34495e;">5</span>
                                        </a>
                                    </li>

                                    <!-- Giỏ hàng -->
                                    <li class="nav-item position-relative me-3">
                                        <a class="nav-link" href="<c:url value='/cart' />" title="Giỏ hàng">
                                            <i class="fas fa-shopping-cart"></i>
                                            <span class="notification-badge" style="background: #1a252f;">2</span>
                                        </a>
                                    </li> <!-- Menu user -->
                                    <li class="nav-item dropdown">
                                        <a class="nav-link dropdown-toggle d-flex align-items-center" href="#"
                                            data-bs-toggle="dropdown">
                                            <div class="user-avatar">
                                                <c:choose>
                                                    <c:when test="${not empty sessionScope.avatar}">
                                                        <img src="${sessionScope.avatar}" alt="Avatar"
                                                            style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:choose>
                                                            <c:when test="${not empty sessionScope.fullName}">
                                                                ${sessionScope.fullName.substring(0,1).toUpperCase()}
                                                            </c:when>
                                                            <c:otherwise>
                                                                U
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <span class="d-none d-lg-inline fw-semibold">
                                                ${sessionScope.fullName}
                                            </span>
                                        </a>
                                        <ul class="dropdown-menu dropdown-menu-end">
                                            <li><a class="dropdown-item" href="<c:url value='/profile' />">
                                                    <i class="fas fa-user"></i>Hồ sơ cá nhân</a></li>
                                            <li><a class="dropdown-item" href="<c:url value='/orders' />">
                                                    <i class="fas fa-box"></i>Đơn hàng của tôi</a></li>
                                            <li><a class="dropdown-item" href="<c:url value='/addresses' />">
                                                    <i class="fas fa-map-marker-alt"></i>Địa chỉ</a></li>

                                            <!-- Menu dành cho người bán -->
                                            <c:if test="${sessionScope.role == 'SELLER'}">
                                                <li>
                                                    <hr class="dropdown-divider">
                                                </li>
                                                <li><a class="dropdown-item" href="<c:url value='/seller/dashboard' />">
                                                        <i class="fas fa-tachometer-alt"></i>Bảng điều khiển</a>
                                                </li>
                                                <li><a class="dropdown-item" href="<c:url value='/seller/products' />">
                                                        <i class="fas fa-cube"></i>Sản phẩm của tôi</a></li>
                                            </c:if>

                                            <li>
                                                <hr class="dropdown-divider">
                                            </li>
                                            <li><a class="dropdown-item" href="<c:url value='/settings' />">
                                                    <i class="fas fa-cog"></i>Cài đặt</a></li>
                                            <li><a class="dropdown-item" href="<c:url value='/help' />">
                                                    <i class="fas fa-question-circle"></i>Trợ giúp</a></li>
                                            <li>
                                                <hr class="dropdown-divider">
                                            </li>
                                            <li>
                                                <form method="post" action="<c:url value='/logout' />"
                                                    style="display: inline;">
                                                    <input type="hidden" name="${_csrf.parameterName}"
                                                        value="${_csrf.token}" />
                                                    <button type="submit" class="dropdown-item text-danger"
                                                        style="border: none; background: none; width: 100%; text-align: left;">
                                                        <i class="fas fa-sign-out-alt"></i>Đăng xuất
                                                    </button>
                                                </form>
                                            </li>
                                        </ul>
                                    </li>
                                </c:when>
                                <c:otherwise>
                                    <!-- ===== MENU CHO KHÁCH VÃNG LAI ===== -->
                                    <li class="nav-item">
                                        <a href="<c:url value='/login' />" class="auth-btn">
                                            <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<c:url value='/register' />" class="auth-btn auth-btn-outline">
                                            <i class="fas fa-user-plus me-2"></i>Đăng ký
                                        </a>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </div>
                </div>
            </nav>
        </header>

        <!-- ===== BOOTSTRAP JAVASCRIPT ===== -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            // ===== JAVASCRIPT XỬ LÝ TƯƠNG TÁC HEADER =====
            document.addEventListener('DOMContentLoaded', function () {

                // ===== XỬ LÝ TÌM KIẾM =====
                const searchForm = document.querySelector('.search-container form');
                const searchInput = document.querySelector('.search-input');

                // Xử lý khi gửi form tìm kiếm
                if (searchForm) {
                    searchForm.addEventListener('submit', function (e) {
                        const query = searchInput.value.trim();
                        if (!query) {
                            e.preventDefault();
                            searchInput.focus();
                            // Hiệu ứng rung khi không nhập gì
                            searchInput.style.animation = 'shake 0.5s';
                            setTimeout(() => searchInput.style.animation = '', 500);
                        }
                    });
                }

                // ===== ĐÓNG MENU MOBILE KHI CLICK LINK =====
                const navLinks = document.querySelectorAll('.navbar-nav .nav-link:not(.dropdown-toggle)');
                const navbarCollapse = document.querySelector('.navbar-collapse');

                navLinks.forEach(link => {
                    link.addEventListener('click', function () {
                        if (window.innerWidth < 992 && navbarCollapse.classList.contains('show')) {
                            const bsCollapse = new bootstrap.Collapse(navbarCollapse);
                            bsCollapse.hide();
                        }
                    });
                });

                // ===== ĐÁNH DẤU LINK HIỆN TẠI =====
                const currentPath = window.location.pathname;
                navLinks.forEach(link => {
                    if (link.getAttribute('href') === currentPath) {
                        link.classList.add('active');
                    }
                });
            });

            // ===== THÊM HIỆU ỨNG RUNG =====
            const style = document.createElement('style');
            style.textContent = `
    @keyframes shake {
        0%, 100% { transform: translateX(0); }
        25% { transform: translateX(-5px); }
        75% { transform: translateX(5px); }
    }
`;
            document.head.appendChild(style);
        </script>

        <!-- Navigation Content -->
        <div class="collapse navbar-collapse" id="navbarContent">
            <!-- Categories Dropdown -->
            <div class="category-menu dropdown d-none d-lg-block">
                <button class="dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fas fa-th-large me-2"></i>Categories
                </button>
                <ul class="dropdown-menu slide-down">
                    <li><a class="dropdown-item" href="#"><i class="fas fa-laptop text-primary"></i>Electronics
                            &
                            Tech</a></li>
                    <li><a class="dropdown-item" href="#"><i class="fas fa-tshirt text-success"></i>Fashion
                            & Style</a></li>
                    <li><a class="dropdown-item" href="#"><i class="fas fa-home text-warning"></i>Home &
                            Garden</a></li>
                    <li><a class="dropdown-item" href="#"><i class="fas fa-gamepad text-danger"></i>Sports &
                            Games</a></li>
                    <li><a class="dropdown-item" href="#"><i class="fas fa-book text-info"></i>Books &
                            Media</a></li>
                    <li><a class="dropdown-item" href="#"><i class="fas fa-car text-dark"></i>Automotive</a>
                    </li>
                    <li><a class="dropdown-item" href="#"><i class="fas fa-baby text-pink"></i>Baby &
                            Kids</a></li>
                    <li><a class="dropdown-item" href="#"><i class="fas fa-heartbeat text-danger"></i>Health
                            & Beauty</a></li>
                    <li>
                        <hr class="dropdown-divider">
                    </li>
                    <li><a class="dropdown-item fw-bold" href="#"><i class="fas fa-eye text-primary"></i>View
                            All
                            Categories</a></li>
                </ul>
            </div>

            <!-- Search Bar -->
            <div class="search-container">
                <form class="d-flex" role="search" action="<c:url value='/search' />" method="get">
                    <div class="search-wrapper w-100">
                        <input class="search-input" type="search" name="q"
                            placeholder="Search for products, brands, and more..." aria-label="Search"
                            autocomplete="off">
                        <button class="search-btn" type="submit" aria-label="Search">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </form>
            </div>

            <!-- Navigation Links -->
            <ul class="navbar-nav ms-auto align-items-center">
                <!-- Seller Link -->
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/seller/register' />">
                        <i class="fas fa-store"></i>Become a Seller
                    </a>
                </li>

                <!-- Check if user is logged in -->
                <c:choose>
                    <c:when test="${not empty sessionScope.fullName}">
                        <!-- Notifications -->
                        <li class="nav-item position-relative me-2">
                            <a class="nav-link" href="<c:url value='/notifications' />" title="Notifications">
                                <i class="fas fa-bell fa-lg"></i>
                                <span class="notification-badge">3</span>
                            </a>
                        </li>

                        <!-- Wishlist -->
                        <li class="nav-item position-relative me-2">
                            <a class="nav-link" href="<c:url value='/wishlist' />" title="Wishlist">
                                <i class="fas fa-heart fa-lg"></i>
                                <span class="notification-badge"
                                    style="background: linear-gradient(135deg, #ff6b6b, #ee5a52);">5</span>
                            </a>
                        </li>

                        <!-- Shopping Cart -->
                        <li class="nav-item position-relative me-3">
                            <a class="nav-link" href="<c:url value='/cart' />" title="Shopping Cart">
                                <i class="fas fa-shopping-cart fa-lg"></i>
                                <span class="notification-badge"
                                    style="background: linear-gradient(135deg, #00b894, #00a085);">2</span>
                            </a>
                        </li>

                        <!-- User Menu -->
                        <li class="nav-item dropdown user-menu">
                            <a class="nav-link dropdown-toggle d-flex align-items-center" href="#"
                                data-bs-toggle="dropdown" aria-expanded="false">
                                <div class="user-avatar">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.avatar}">
                                            <img src="${sessionScope.avatar}" alt="Avatar"
                                                style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">
                                        </c:when>
                                        <c:otherwise>
                                            <c:choose>
                                                <c:when test="${not empty sessionScope.fullName}">
                                                    ${sessionScope.fullName.substring(0,1).toUpperCase()}
                                                </c:when>
                                                <c:otherwise>
                                                    U
                                                </c:otherwise>
                                            </c:choose>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <span class="d-none d-lg-inline fw-semibold">${sessionScope.fullName}</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end slide-down">
                                <li>
                                    <a class="dropdown-item" href="<c:url value='/profile' />">
                                        <i class="fas fa-user-circle"></i>My Profile
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="<c:url value='/orders' />">
                                        <i class="fas fa-box-open"></i>My Orders
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="<c:url value='/addresses' />">
                                        <i class="fas fa-map-marker-alt"></i>My Addresses
                                    </a>
                                </li>
                                <c:if test="${sessionScope.role == 'SELLER'}">
                                    <li>
                                        <hr class="dropdown-divider">
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="<c:url value='/seller/dashboard' />">
                                            <i class="fas fa-tachometer-alt"></i>Seller Dashboard
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="<c:url value='/seller/products' />">
                                            <i class="fas fa-cube"></i>My Products
                                        </a>
                                    </li>
                                </c:if>
                                <li>
                                    <hr class="dropdown-divider">
                                </li>
                                <li>
                                    <a class="dropdown-item" href="<c:url value='/settings' />">
                                        <i class="fas fa-cog"></i>Account Settings
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="<c:url value='/help' />">
                                        <i class="fas fa-question-circle"></i>Help & Support
                                    </a>
                                </li>
                                <li>
                                    <hr class="dropdown-divider">
                                </li>
                                <li>
                                    <form method="post" action="<c:url value='/logout' />" style="display: inline;">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <button type="submit" class="dropdown-item text-danger"
                                            style="border: none; background: none; width: 100%; text-align: left;">
                                            <i class="fas fa-sign-out-alt"></i>Logout
                                        </button>
                                    </form>
                                </li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <!-- Authentication Buttons for Guests -->
                        <li class="nav-item">
                            <a href="<c:url value='/login' />" class="btn btn-auth">
                                <i class="fas fa-sign-in-alt me-2"></i>Sign In
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="<c:url value='/register' />" class="btn btn-auth btn-register">
                                <i class="fas fa-user-plus me-2"></i>Join Now
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
        </div>
        </nav>
        </header>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Header JavaScript -->
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Search functionality
                const searchForm = document.querySelector('.search-container form');
                const searchInput = document.querySelector('.search-input');

                // Enhanced search with suggestions
                searchInput.addEventListener('input', function () {
                    const query = this.value.trim();
                    if (query.length > 2) {
                        // Add subtle glow effect while typing
                        this.style.boxShadow = '0 0 20px rgba(116, 185, 255, 0.3)';
                    } else {
                        this.style.boxShadow = 'none';
                    }
                });

                // Remove glow on blur
                searchInput.addEventListener('blur', function () {
                    this.style.boxShadow = 'none';
                });

                // Handle search form submission
                searchForm.addEventListener('submit', function (e) {
                    const query = searchInput.value.trim();
                    if (!query) {
                        e.preventDefault();
                        searchInput.focus();
                        // Add shake animation
                        searchInput.style.animation = 'shake 0.5s';
                        setTimeout(() => searchInput.style.animation = '', 500);
                    }
                });

                // Smooth dropdown animations
                const dropdowns = document.querySelectorAll('.dropdown');
                dropdowns.forEach(dropdown => {
                    dropdown.addEventListener('show.bs.dropdown', function () {
                        const menu = this.querySelector('.dropdown-menu');
                        menu.classList.add('slide-down');
                    });
                });

                // Close mobile menu when clicking on a link
                const navLinks = document.querySelectorAll('.navbar-nav .nav-link:not(.dropdown-toggle)');
                const navbarCollapse = document.querySelector('.navbar-collapse');

                navLinks.forEach(link => {
                    link.addEventListener('click', function () {
                        if (window.innerWidth < 992 && navbarCollapse.classList.contains('show')) {
                            const bsCollapse = new bootstrap.Collapse(navbarCollapse);
                            bsCollapse.hide();
                        }
                    });
                });

                // Active link highlighting
                const currentPath = window.location.pathname;
                navLinks.forEach(link => {
                    if (link.getAttribute('href') === currentPath) {
                        link.classList.add('active');
                    }
                });

                // Scroll effect for header
                let lastScrollTop = 0;
                const header = document.querySelector('.marketplace-header');

                window.addEventListener('scroll', function () {
                    const scrollTop = window.pageYOffset || document.documentElement.scrollTop;

                    if (scrollTop > lastScrollTop && scrollTop > 100) {
                        // Scrolling down
                        header.style.transform = 'translateY(-100%)';
                    } else {
                        // Scrolling up
                        header.style.transform = 'translateY(0)';
                    }

                    // Add backdrop blur when scrolled
                    if (scrollTop > 50) {
                        header.style.backdropFilter = 'blur(25px)';
                        header.style.background = 'linear-gradient(135deg, rgba(30, 60, 114, 0.95) 0%, rgba(42, 82, 152, 0.95) 50%, rgba(102, 126, 234, 0.95) 100%)';
                    } else {
                        header.style.backdropFilter = 'blur(20px)';
                        header.style.background = 'linear-gradient(135deg, #1e3c72 0%, #2a5298 50%, #667eea 100%)';
                    }

                    lastScrollTop = scrollTop;
                }, { passive: true });

                // Add keydown navigation for search
                searchInput.addEventListener('keydown', function (e) {
                    if (e.key === 'Escape') {
                        this.blur();
                    }
                });

                // Badge animation
                const badges = document.querySelectorAll('.notification-badge');
                badges.forEach(badge => {
                    if (parseInt(badge.textContent) > 0) {
                        badge.style.display = 'flex';
                    }
                });
            });

            // Add shake animation
            const style = document.createElement('style');
            style.textContent = `
    @keyframes shake {
        0%, 100% { transform: translateX(0); }
        25% { transform: translateX(-5px); }
        75% { transform: translateX(5px); }
    }
`;
            document.head.appendChild(style);
        </script>