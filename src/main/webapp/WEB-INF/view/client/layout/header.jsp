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
                                            <span class="notification-badge cart-count">
                                                ${not empty sessionScope.cartCount ? sessionScope.cartCount : 0}
                                            </span>
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
                                            <li><a class="dropdown-item" href="<c:url value='/account/profile' />">
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

        <!-- ===== BOOTSTRAP & JQUERY JAVASCRIPT ===== -->
        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- ===== HEADER JAVASCRIPT ===== -->
        <script>
            // ===== JAVASCRIPT XỬ LÝ TƯƠNG TÁC HEADER =====
            (function () {
                'use strict';

                // Đợi DOM load xong
                if (document.readyState === 'loading') {
                    document.addEventListener('DOMContentLoaded', initHeader);
                } else {
                    initHeader();
                }

                function initHeader() {
                    // ===== XỬ LÝ TÌM KIẾM =====
                    const searchForms = document.querySelectorAll('.search-container form');
                    const searchInputs = document.querySelectorAll('.search-input');

                    // Xử lý khi gửi form tìm kiếm
                    searchForms.forEach((searchForm, index) => {
                        if (searchForm && searchInputs[index]) {
                            searchForm.addEventListener('submit', function (e) {
                                const query = searchInputs[index].value.trim();
                                if (!query) {
                                    e.preventDefault();
                                    searchInputs[index].focus();
                                    // Hiệu ứng rung khi không nhập gì
                                    searchInputs[index].style.animation = 'shake 0.5s';
                                    setTimeout(() => searchInputs[index].style.animation = '', 500);
                                }
                            });
                        }
                    });

                    // Enhanced search with glow effect
                    searchInputs.forEach(searchInput => {
                        if (!searchInput) return;

                        searchInput.addEventListener('input', function () {
                            const query = this.value.trim();
                            if (query.length > 2) {
                                this.style.boxShadow = '0 0 20px rgba(116, 185, 255, 0.3)';
                            } else {
                                this.style.boxShadow = 'none';
                            }
                        });

                        searchInput.addEventListener('blur', function () {
                            this.style.boxShadow = 'none';
                        });

                        searchInput.addEventListener('keydown', function (e) {
                            if (e.key === 'Escape') {
                                this.blur();
                            }
                        });
                    });

                    // ===== KHỞI TẠO BOOTSTRAP DROPDOWNS =====
                    const dropdownElementList = document.querySelectorAll('.dropdown-toggle');
                    const dropdownList = [...dropdownElementList].map(dropdownToggleEl => {
                        return new bootstrap.Dropdown(dropdownToggleEl, {
                            autoClose: true
                        });
                    });

                    // ===== SMOOTH DROPDOWN ANIMATIONS =====
                    const dropdowns = document.querySelectorAll('.dropdown');
                    dropdowns.forEach(dropdown => {
                        dropdown.addEventListener('show.bs.dropdown', function () {
                            const menu = this.querySelector('.dropdown-menu');
                            if (menu) {
                                menu.classList.add('slide-down');
                            }
                        });
                    });

                    // ===== ĐÓNG MENU MOBILE KHI CLICK LINK =====
                    const navLinks = document.querySelectorAll('.navbar-nav .nav-link:not(.dropdown-toggle)');
                    const navbarCollapse = document.querySelector('.navbar-collapse');

                    navLinks.forEach(link => {
                        link.addEventListener('click', function () {
                            if (window.innerWidth < 992 && navbarCollapse && navbarCollapse.classList.contains('show')) {
                                const bsCollapse = new bootstrap.Collapse(navbarCollapse);
                                bsCollapse.hide();
                            }
                        });
                    });

                    // ===== ĐÁNH DẤU LINK HIỆN TẠI =====
                    const currentPath = window.location.pathname;
                    navLinks.forEach(link => {
                        const href = link.getAttribute('href');
                        if (href && href === currentPath) {
                            link.classList.add('active');
                        }
                    });

                    // ===== BADGE ANIMATION =====
                    const badges = document.querySelectorAll('.notification-badge');
                    badges.forEach(badge => {
                        const count = parseInt(badge.textContent);
                        if (!isNaN(count) && count > 0) {
                            badge.style.display = 'flex';
                        }
                    });
                }
            })();

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

            // ===== GLOBAL FUNCTION TO UPDATE CART BADGE =====
            window.updateCartBadge = function () {
                const badges = document.querySelectorAll('.cart-count');

                // Fetch current cart count via AJAX
                fetch(window.location.href, {
                    method: 'GET',
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                    .then(response => response.text())
                    .then(html => {
                        // Parse the response to extract cart count
                        const parser = new DOMParser();
                        const doc = parser.parseFromString(html, 'text/html');
                        const newBadge = doc.querySelector('.cart-count');

                        if (newBadge) {
                            const newCount = newBadge.textContent.trim();
                            badges.forEach(badge => {
                                badge.textContent = newCount;

                                // Show/hide based on count
                                if (parseInt(newCount) > 0) {
                                    badge.style.display = 'flex';
                                    // Add animation
                                    badge.style.animation = 'shake 0.5s ease-in-out';
                                    setTimeout(() => {
                                        badge.style.animation = '';
                                    }, 500);
                                } else {
                                    badge.style.display = 'none';
                                }
                            });
                        }
                    })
                    .catch(err => {
                        console.log('Could not update cart badge:', err);
                    });
            };
        </script>