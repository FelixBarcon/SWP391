<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- Seller Dashboard Content -->
        <div class="seller-dashboard">
            <!-- Main Stats -->
            <div class="row g-3 mb-4">
                <!-- Pending Orders -->
                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="seller-stats-card h-100">
                        <div class="d-flex align-items-center">
                            <div class="stats-icon warning">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div class="ms-3">
                                <h3 class="stats-value mb-1">0</h3>
                                <p class="stats-label mb-0">Đơn hàng chờ xử lý</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Total Products -->
                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="seller-stats-card h-100">
                        <div class="d-flex align-items-center">
                            <div class="stats-icon primary">
                                <i class="fas fa-box"></i>
                            </div>
                            <div class="ms-3">
                                <h3 class="stats-value mb-1">0</h3>
                                <p class="stats-label mb-0">Tổng sản phẩm</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Low Stock -->
                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="seller-stats-card h-100">
                        <div class="d-flex align-items-center">
                            <div class="stats-icon danger">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                            <div class="ms-3">
                                <h3 class="stats-value mb-1">0</h3>
                                <p class="stats-label mb-0">Sắp hết hàng</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Total Revenue -->
                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="seller-stats-card h-100">
                        <div class="d-flex align-items-center">
                            <div class="stats-icon success">
                                <i class="fas fa-dollar-sign"></i>
                            </div>
                            <div class="ms-3">
                                <h3 class="stats-value mb-1">0₫</h3>
                                <p class="stats-label mb-0">Doanh thu</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="seller-card mb-4">
                <h5 class="card-title mb-3">Thao tác nhanh</h5>
                <div class="row g-3">
                    <div class="col-6 col-md-3">
                        <a href="<c:url value='/seller/products/new'/>" class="quick-action-card">
                            <i class="fas fa-plus-circle"></i>
                            <span>Thêm sản phẩm</span>
                        </a>
                    </div>
                    <div class="col-6 col-md-3">
                        <a href="<c:url value='/seller/orders'/>" class="quick-action-card">
                            <i class="fas fa-shipping-fast"></i>
                            <span>Xử lý đơn hàng</span>
                        </a>
                    </div>
                    <div class="col-6 col-md-3">
                        <a href="<c:url value='/seller/inventory'/>" class="quick-action-card">
                            <i class="fas fa-boxes"></i>
                            <span>Cập nhật kho</span>
                        </a>
                    </div>
                    <div class="col-6 col-md-3">
                        <a href="<c:url value='/seller/profile'/>" class="quick-action-card">
                            <i class="fas fa-store-alt"></i>
                            <span>Thông tin shop</span>
                        </a>
                    </div>
                </div>
            </div>

            <!-- Recent Orders -->
            <div class="seller-card">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="card-title mb-0">Đơn hàng gần đây</h5>
                    <a href="<c:url value='/seller/orders'/>" class="seller-btn-text">
                        Xem tất cả <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th scope="col">Mã đơn</th>
                                <th scope="col">Khách hàng</th>
                                <th scope="col">Sản phẩm</th>
                                <th scope="col">Tổng tiền</th>
                                <th scope="col">Trạng thái</th>
                                <th scope="col" class="text-end">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td colspan="6" class="text-center py-4">
                                    <div class="empty-state">
                                        <img src="<c:url value='/resources/seller/images/empty-orders.svg'/>"
                                            alt="No orders" style="width: 120px; height: 120px;">
                                        <p class="text-muted mt-2">Chưa có đơn hàng nào</p>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Link to external CSS file -->
        <link rel="stylesheet" href="<c:url value='/resources/seller/css/seller-dashboard.css'/>"