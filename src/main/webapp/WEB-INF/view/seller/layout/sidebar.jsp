<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- Seller Sidebar -->
        <aside class="seller-sidebar" id="sellerSidebar">
            <!-- Sidebar Header/Logo -->
            <div class="seller-sidebar-header">
                <a href="<c:url value='/seller'/>" class="seller-sidebar-brand">
                    <i class="fas fa-store"></i>
                    <span class="seller-sidebar-logo-text">ShopMart Seller</span>
                </a>
            </div>

            <!-- Seller Navigation -->
            <nav class="seller-sidebar-nav">
                <!-- Dashboard -->
                <div class="nav-section">
                    <div class="nav-section-title">Tổng quan</div>
                    <ul class="nav-menu">
                        <li class="nav-item">
                            <a href="<c:url value='/seller'/>"
                                class="nav-link ${(pageContext.request.servletPath.equals('/seller') || pageContext.request.servletPath.contains('/dashboard/')) && !pageContext.request.servletPath.contains('/products') ? 'active' : ''}">
                                <i class="fas fa-chart-line"></i>
                                <span class="nav-link-text">Dashboard</span>
                            </a>
                        </li>
                    </ul>
                </div>

                <!-- Store Management -->
                <div class="nav-section">
                    <div class="nav-section-title">Quản lý cửa hàng</div>
                    <ul class="nav-menu">
                        <li class="nav-item has-submenu">
                            <a href="#"
                                class="nav-link submenu-toggle ${pageContext.request.servletPath.contains('/products') ? 'active' : ''}">
                                <i class="fas fa-box"></i>
                                <span class="nav-link-text">Sản phẩm</span>
                                <i class="fas fa-chevron-down submenu-arrow"></i>
                            </a>
                            <ul class="submenu">
                                <li class="submenu-item">
                                    <a href="<c:url value='/seller/products/create'/>"
                                        class="submenu-link ${pageContext.request.servletPath.contains('/products/create') ? 'active' : ''}">
                                        <i class="fas fa-plus"></i>
                                        <span>Thêm sản phẩm</span>
                                    </a>
                                </li>
                                <li class="submenu-item">
                                    <a href="<c:url value='/seller/products'/>"
                                        class="submenu-link ${pageContext.request.servletPath.equals('/seller/products') || pageContext.request.servletPath.contains('/products/list') ? 'active' : ''}">
                                        <i class="fas fa-list"></i>
                                        <span>Danh sách sản phẩm</span>
                                    </a>
                                </li>
                            </ul>
                        </li>

                    </ul>
                </div>
            </nav>

            <!-- User Profile Section -->
            <div class="seller-sidebar-footer">
                <div class="user-profile">
                    <div class="user-avatar">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                ${sessionScope.user.firstName.substring(0,1).toUpperCase()}${sessionScope.user.lastName.substring(0,1).toUpperCase()}
                            </c:when>
                            <c:otherwise>
                                S
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
                                    Seller
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="user-role">Người bán</div>
                    </div>
                </div>

                <!-- User Actions -->
                <div class="user-actions">
                    <a href="<c:url value='/'/>" class="seller-btn-home" title="Về trang chủ">
                        <i class="fas fa-home"></i>
                        <span>Trang chủ</span>
                    </a>
                    <a href="<c:url value='/logout'/>" class="seller-btn-logout" title="Đăng xuất">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Đăng xuất</span>
                    </a>
                </div>
            </div>
        </aside>

        <!-- Mobile Menu Overlay -->
        <div class="mobile-menu-overlay" id="mobileMenuOverlay"></div>