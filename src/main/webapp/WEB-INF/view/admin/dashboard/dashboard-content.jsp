<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- Dashboard Content -->
        <div class="dashboard-content">
            <!-- Stats Cards Row -->
            <div class="row mb-4">
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="stats-card">
                        <div class="stats-card-body">
                            <div class="stats-icon">
                                <i class="fas fa-shopping-cart"></i>
                            </div>
                            <div class="stats-info">
                                <h3 class="stats-number">1,247</h3>
                                <p class="stats-label">Đơn hàng</p>
                                <span class="stats-change positive">
                                    <i class="fas fa-arrow-up"></i> +12.5%
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="stats-card">
                        <div class="stats-card-body">
                            <div class="stats-icon revenue">
                                <i class="fas fa-dollar-sign"></i>
                            </div>
                            <div class="stats-info">
                                <h3 class="stats-number">₫125.4M</h3>
                                <p class="stats-label">Doanh thu</p>
                                <span class="stats-change positive">
                                    <i class="fas fa-arrow-up"></i> +8.2%
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="stats-card">
                        <div class="stats-card-body">
                            <div class="stats-icon users">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="stats-info">
                                <h3 class="stats-number">8,549</h3>
                                <p class="stats-label">Khách hàng</p>
                                <span class="stats-change positive">
                                    <i class="fas fa-arrow-up"></i> +15.3%
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="stats-card">
                        <div class="stats-card-body">
                            <div class="stats-icon products">
                                <i class="fas fa-box"></i>
                            </div>
                            <div class="stats-info">
                                <h3 class="stats-number">2,156</h3>
                                <p class="stats-label">Sản phẩm</p>
                                <span class="stats-change negative">
                                    <i class="fas fa-arrow-down"></i> -2.1%
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Charts & Tables Row -->
            <div class="row mb-4">
                <!-- Revenue Chart -->
                <div class="col-lg-8 mb-4">
                    <div class="dashboard-card">
                        <div class="card-header">
                            <h5 class="card-title">
                                <i class="fas fa-chart-line me-2"></i>
                                Doanh thu theo tháng
                            </h5>
                            <div class="card-tools">
                                <select class="form-select form-select-sm">
                                    <option>2024</option>
                                    <option>2023</option>
                                </select>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="revenueChart" width="400" height="200"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Top Products -->
                <div class="col-lg-4 mb-4">
                    <div class="dashboard-card">
                        <div class="card-header">
                            <h5 class="card-title">
                                <i class="fas fa-trophy me-2"></i>
                                Sản phẩm bán chạy
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="top-products-list">
                                <div class="product-item">
                                    <div class="product-info">
                                        <div class="product-name">iPhone 15 Pro Max</div>
                                        <div class="product-sales">1,234 đã bán</div>
                                    </div>
                                    <div class="product-revenue">₫45.2M</div>
                                </div>
                                <div class="product-item">
                                    <div class="product-info">
                                        <div class="product-name">Samsung Galaxy S24</div>
                                        <div class="product-sales">987 đã bán</div>
                                    </div>
                                    <div class="product-revenue">₫32.8M</div>
                                </div>
                                <div class="product-item">
                                    <div class="product-info">
                                        <div class="product-name">MacBook Pro M3</div>
                                        <div class="product-sales">456 đã bán</div>
                                    </div>
                                    <div class="product-revenue">₫28.1M</div>
                                </div>
                                <div class="product-item">
                                    <div class="product-info">
                                        <div class="product-name">AirPods Pro 2</div>
                                        <div class="product-sales">2,345 đã bán</div>
                                    </div>
                                    <div class="product-revenue">₫15.6M</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Orders & Quick Actions -->
            <div class="row">
                <!-- Recent Orders -->
                <div class="col-lg-8 mb-4">
                    <div class="dashboard-card">
                        <div class="card-header">
                            <h5 class="card-title">
                                <i class="fas fa-clock me-2"></i>
                                Đơn hàng gần đây
                            </h5>
                            <a href="<c:url value='/admin/orders'/>" class="btn btn-sm btn-outline-primary">
                                Xem tất cả
                            </a>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Mã đơn</th>
                                            <th>Khách hàng</th>
                                            <th>Sản phẩm</th>
                                            <th>Tổng tiền</th>
                                            <th>Trạng thái</th>
                                            <th>Thời gian</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td><strong>#ORD001</strong></td>
                                            <td>Nguyễn Văn A</td>
                                            <td>iPhone 15 Pro Max</td>
                                            <td>₫29.990.000</td>
                                            <td><span class="badge bg-warning">Chờ xử lý</span></td>
                                            <td>5 phút trước</td>
                                        </tr>
                                        <tr>
                                            <td><strong>#ORD002</strong></td>
                                            <td>Trần Thị B</td>
                                            <td>Samsung Galaxy S24</td>
                                            <td>₫22.990.000</td>
                                            <td><span class="badge bg-success">Đã xác nhận</span></td>
                                            <td>12 phút trước</td>
                                        </tr>
                                        <tr>
                                            <td><strong>#ORD003</strong></td>
                                            <td>Lê Văn C</td>
                                            <td>MacBook Pro M3</td>
                                            <td>₫45.990.000</td>
                                            <td><span class="badge bg-info">Đang giao</span></td>
                                            <td>25 phút trước</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="col-lg-4 mb-4">
                    <div class="dashboard-card">
                        <div class="card-header">
                            <h5 class="card-title">
                                <i class="fas fa-bolt me-2"></i>
                                Thao tác nhanh
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="quick-actions">
                                <a href="<c:url value='/admin/products/create'/>" class="quick-action-btn">
                                    <i class="fas fa-plus"></i>
                                    <span>Thêm sản phẩm</span>
                                </a>
                                <a href="<c:url value='/admin/orders'/>" class="quick-action-btn">
                                    <i class="fas fa-list"></i>
                                    <span>Quản lý đơn hàng</span>
                                </a>
                                <a href="<c:url value='/admin/users'/>" class="quick-action-btn">
                                    <i class="fas fa-users"></i>
                                    <span>Quản lý khách hàng</span>
                                </a>
                                <a href="<c:url value='/admin/reports'/>" class="quick-action-btn">
                                    <i class="fas fa-chart-bar"></i>
                                    <span>Báo cáo</span>
                                </a>
                                <a href="<c:url value='/admin/settings'/>" class="quick-action-btn">
                                    <i class="fas fa-cog"></i>
                                    <span>Cài đặt</span>
                                </a>
                                <a href="<c:url value='/admin/backup'/>" class="quick-action-btn">
                                    <i class="fas fa-download"></i>
                                    <span>Sao lưu dữ liệu</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Dashboard Styles -->
        <style>
            /* Stats Cards */
            .stats-card {
                background: var(--bg-white);
                border-radius: var(--border-radius-md);
                box-shadow: var(--shadow-sm);
                transition: var(--admin-transition);
                border: 1px solid var(--border-light);
            }

            .stats-card:hover {
                box-shadow: var(--shadow-md);
                transform: translateY(-2px);
            }

            .stats-card-body {
                padding: var(--spacing-md);
                display: flex;
                align-items: center;
            }

            .stats-icon {
                width: 60px;
                height: 60px;
                background: var(--primary-gradient);
                border-radius: var(--border-radius-md);
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: var(--spacing);
                font-size: var(--font-size-xl);
                color: var(--text-white);
            }

            .stats-icon.revenue {
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            }

            .stats-icon.users {
                background: linear-gradient(135deg, #17a2b8 0%, #6f42c1 100%);
            }

            .stats-icon.products {
                background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            }

            .stats-info {
                flex: 1;
            }

            .stats-number {
                font-size: var(--font-size-3xl);
                font-weight: var(--font-weight-bold);
                color: var(--text-primary);
                margin-bottom: var(--spacing-xs);
            }

            .stats-label {
                color: var(--text-secondary);
                margin-bottom: var(--spacing-xs);
                font-weight: var(--font-weight-medium);
            }

            .stats-change {
                font-size: var(--font-size-sm);
                font-weight: var(--font-weight-semibold);
            }

            .stats-change.positive {
                color: var(--success-color);
            }

            .stats-change.negative {
                color: var(--danger-color);
            }

            /* Dashboard Cards */
            .dashboard-card {
                background: var(--bg-white);
                border-radius: var(--border-radius-md);
                box-shadow: var(--shadow-sm);
                border: 1px solid var(--border-light);
                height: 100%;
            }

            .card-header {
                padding: var(--spacing-md);
                border-bottom: 1px solid var(--border-light);
                display: flex;
                justify-content: between;
                align-items: center;
            }

            .card-title {
                margin: 0;
                font-weight: var(--font-weight-semibold);
                color: var(--text-primary);
            }

            .card-tools {
                margin-left: auto;
            }

            .card-body {
                padding: var(--spacing-md);
            }

            /* Top Products */
            .top-products-list {
                display: flex;
                flex-direction: column;
                gap: var(--spacing);
            }

            .product-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: var(--spacing-sm) 0;
                border-bottom: 1px solid var(--border-light);
            }

            .product-item:last-child {
                border-bottom: none;
            }

            .product-name {
                font-weight: var(--font-weight-medium);
                color: var(--text-primary);
                font-size: var(--font-size-sm);
            }

            .product-sales {
                color: var(--text-muted);
                font-size: var(--font-size-xs);
            }

            .product-revenue {
                font-weight: var(--font-weight-semibold);
                color: var(--primary-color);
                font-size: var(--font-size-sm);
            }

            /* Quick Actions */
            .quick-actions {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: var(--spacing);
            }

            .quick-action-btn {
                display: flex;
                flex-direction: column;
                align-items: center;
                padding: var(--spacing);
                background: var(--bg-light);
                border-radius: var(--border-radius);
                text-decoration: none;
                color: var(--text-primary);
                transition: var(--admin-transition);
                border: 1px solid var(--border-light);
            }

            .quick-action-btn:hover {
                background: var(--primary-color);
                color: var(--text-white);
                text-decoration: none;
                transform: translateY(-2px);
                box-shadow: var(--shadow-primary);
            }

            .quick-action-btn i {
                font-size: var(--font-size-xl);
                margin-bottom: var(--spacing-xs);
            }

            .quick-action-btn span {
                font-size: var(--font-size-xs);
                font-weight: var(--font-weight-medium);
                text-align: center;
            }

            /* Chart Container */
            .chart-container {
                position: relative;
                height: 300px;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .stats-card-body {
                    flex-direction: column;
                    text-align: center;
                }

                .stats-icon {
                    margin-right: 0;
                    margin-bottom: var(--spacing);
                }

                .quick-actions {
                    grid-template-columns: 1fr;
                }
            }
        </style>