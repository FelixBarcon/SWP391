<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- Admin Sidebar -->
        <aside class="admin-sidebar" id="adminSidebar">
            <!-- Sidebar Header/Logo -->
            <div class="sidebar-header">
                <a href="<c:url value='/admin'/>" class="sidebar-logo">
                    <i class="fas fa-shopping-bag"></i>
                    <span class="sidebar-logo-text">ShopMart Admin</span>
                </a>
            </div>

            <!-- Sidebar Navigation -->
            <nav class="sidebar-nav">
                <!-- Dashboard Section -->
                <div class="nav-section">
                    <div class="nav-section-title">Tổng quan</div>
                    <ul class="nav-menu">
                        <li class="nav-item">
                            <a href="<c:url value='/admin'/>"
                                class="nav-link ${requestScope['javax.servlet.forward.servlet_path'] == '/admin' ? 'active' : ''}">
                                <i class="fas fa-tachometer-alt"></i>
                                <span class="nav-link-text">Dashboard</span>
                            </a>
                        </li>
                    </ul>
                </div>

                <!-- User Management Section -->
                <div class="nav-section">
                    <div class="nav-section-title">Quản lý người dùng</div>
                    <ul class="nav-menu">
                        <li class="nav-item">
                            <a href="<c:url value='/admin/user'/>"
                                class="nav-link ${requestScope['javax.servlet.forward.servlet_path'] == '/admin/user' ? 'active' : ''}">
                                <i class="fas fa-users"></i>
                                <span class="nav-link-text">Người dùng</span>
                            </a>
                        </li>
                    </ul>
                </div>

                <!-- Seller Management Section -->
                <div class="nav-section">
                    <div class="nav-section-title">Quản lý người bán</div>
                    <ul class="nav-menu">
                        <li class="nav-item">
                            <a href="<c:url value='/admin/seller/requests'/>"
                                class="nav-link ${requestScope['javax.servlet.forward.servlet_path'] == '/admin/seller/requests' ? 'active' : ''}">
                                <i class="fas fa-user-plus"></i>
                                <span class="nav-link-text">Yêu cầu đăng ký</span>
                                <c:if test="${not empty pending}">
                                    <span class="badge bg-danger rounded-pill ms-2">${pending.size()}</span>
                                </c:if>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="<c:url value='/admin/seller/list'/>"
                                class="nav-link ${requestScope['javax.servlet.forward.servlet_path'] == '/admin/seller/list' ? 'active' : ''}">
                                <i class="fas fa-store"></i>
                                <span class="nav-link-text">Danh sách Shop</span>
                            </a>
                        </li>
                    </ul>
                </div>

                <!-- Review Management Section -->
                <div class="nav-section">
                    <div class="nav-section-title">Quản lý đánh giá</div>
                    <ul class="nav-menu">
                        <li class="nav-item">
                            <a href="<c:url value='/admin/reviews/products'/>"
                                class="nav-link ${requestScope['javax.servlet.forward.servlet_path'] == '/admin/reviews/products' ? 'active' : ''}">
                                <i class="fas fa-comments"></i>
                                <span class="nav-link-text">Đánh giá sản phẩm</span>
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- User Profile Section -->
            <div class="sidebar-user-section">
                <div class="user-profile">
                    <div class="user-avatar">
                        <c:choose>
                            <c:when test="${not empty sessionScope.avatar}">
                                <img src="<c:url value='/images/${sessionScope.avatar}' />" alt="Avatar"
                                    style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${not empty sessionScope.fullName}">
                                        ${sessionScope.fullName.substring(0,1).toUpperCase()}
                                    </c:when>
                                    <c:otherwise>
                                        S
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="user-info">
                        <div class="user-name">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    ${sessionScope.user.firstName} ${sessionScope.user.lastName}
                                </c:when>
                                <c:otherwise>
                                    Administrator
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="user-role">Quản trị viên</div>
                        <div class="user-status">
                            <span class="status-dot online"></span>
                            Đang hoạt động
                        </div>
                    </div>
                </div>

                <!-- User Actions -->
                <div class="user-actions">
                    <a href="<c:url value='/'/>" class="home-btn" title="Về trang chủ">
                        <i class="fas fa-home"></i>
                        <span>Trang chủ</span>
                    </a>
                    <a href="<c:url value='/logout'/>" class="logout-btn" title="Đăng xuất">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Đăng xuất</span>
                    </a>
                </div>
            </div>
        </aside>

        <!-- Mobile Menu Overlay -->
        <div class="mobile-menu-overlay" id="mobileMenuOverlay"></div>