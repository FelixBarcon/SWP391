<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- Seller Dashboard Content -->
        <div class="seller-dashboard">
            <!-- Page Header -->
            <div class="dashboard-header mb-4">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="dashboard-title mb-1">
                            <i class="fas fa-chart-line me-2"></i>Dashboard
                        </h2>
                        <p class="dashboard-subtitle mb-0">Tổng quan hoạt động kinh doanh của shop</p>
                    </div>
                    <div class="dashboard-date">
                        <i class="far fa-calendar-alt me-2"></i>
                        <span id="currentDate"></span>
                    </div>
                </div>
            </div>

            <!-- Main Stats -->
            <div class="row g-3 mb-4">
                <!-- Total Products -->
                <div class="col-12 col-md-6">
                    <div class="seller-stats-card h-100">
                        <div class="d-flex align-items-center">
                            <div class="stats-icon primary">
                                <i class="fas fa-box"></i>
                            </div>
                            <div class="ms-3">
                                <h3 class="stats-value mb-1">${totalProductsCount != null ? totalProductsCount : 0}</h3>
                                <p class="stats-label mb-0">Tổng sản phẩm</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Total Revenue -->
                <div class="col-12 col-md-6">
                    <div class="seller-stats-card h-100">
                        <div class="d-flex align-items-center">
                            <div class="stats-icon success">
                                <i class="fas fa-dollar-sign"></i>
                            </div>
                            <div class="ms-3">
                                <h3 class="stats-value mb-1">
                                    <c:choose>
                                        <c:when test="${totalRevenue != null}">
                                            ${String.format("%,.0f", totalRevenue)}₫
                                        </c:when>
                                        <c:otherwise>0₫</c:otherwise>
                                    </c:choose>
                                </h3>
                                <p class="stats-label mb-0">Doanh thu</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sales Chart -->
            <div class="seller-card mb-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="card-title mb-0">Doanh thu & Đơn hàng</h5>
                    <div class="btn-group btn-group-sm" role="group">
                        <button type="button" class="btn btn-outline-primary"
                            onclick="loadSalesChart('week', event)">Tuần</button>
                        <button type="button" class="btn btn-outline-primary active"
                            onclick="loadSalesChart('month', event)">Tháng</button>
                        <button type="button" class="btn btn-outline-primary"
                            onclick="loadSalesChart('year', event)">Năm</button>
                    </div>
                </div>

                <!-- Chart summary statistics -->
                <div class="row g-3 mb-3">
                    <div class="col-6 col-md-3">
                        <div class="chart-stat-card">
                            <div class="stat-value" id="chartTotalRevenue">0₫</div>
                            <div class="stat-label">Tổng doanh thu</div>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="chart-stat-card">
                            <div class="stat-value" id="chartTotalOrders">0</div>
                            <div class="stat-label">Tổng đơn hàng</div>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="chart-stat-card">
                            <div class="stat-value" id="chartAvgOrderValue">0₫</div>
                            <div class="stat-label">Giá trị TB/đơn</div>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="chart-stat-card">
                            <button class="btn btn-success btn-sm w-100" data-bs-toggle="modal"
                                data-bs-target="#exportReportModal">
                                <i class="fas fa-file-excel"></i> Xuất báo cáo
                            </button>
                        </div>
                    </div>
                </div>

                <div style="position: relative; height: 300px;">
                    <canvas id="salesChart"></canvas>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="seller-card mb-4">
                <h5 class="card-title mb-3">Thao tác nhanh</h5>
                <div class="row g-3">
                    <div class="col-6 col-md-6">
                        <a href="<c:url value='/seller/products/create'/>" class="quick-action-card">
                            <i class="fas fa-plus-circle"></i>
                            <span>Thêm sản phẩm</span>
                        </a>
                    </div>
                    <div class="col-6 col-md-6">
                        <a href="<c:url value='/seller/orders'/>" class="quick-action-card">
                            <i class="fas fa-shipping-fast"></i>
                            <span>Xử lý đơn hàng</span>
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
                            <c:choose>
                                <c:when test="${not empty recentOrders}">
                                    <c:forEach var="order" items="${recentOrders}">
                                        <tr>
                                            <td><strong>#${order.id}</strong></td>
                                            <td>${order.user.fullName}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty order.orderItems}">
                                                        ${order.orderItems.size()} sản phẩm
                                                    </c:when>
                                                    <c:otherwise>0 sản phẩm</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><strong>
                                                    <c:out value="${String.format('%,d', order.totalAmount)}" />₫
                                                </strong></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${order.orderStatus == 'PENDING_CONFIRM'}">
                                                        <span class="badge bg-warning">Chờ xác nhận</span>
                                                    </c:when>
                                                    <c:when test="${order.orderStatus == 'PENDING_PAYMENT'}">
                                                        <span class="badge bg-warning">Chờ thanh toán</span>
                                                    </c:when>
                                                    <c:when test="${order.orderStatus == 'PAID'}">
                                                        <span class="badge bg-success">Đã thanh toán</span>
                                                    </c:when>
                                                    <c:when test="${order.orderStatus == 'CANCELED'}">
                                                        <span class="badge bg-danger">Đã hủy</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">${order.orderStatus}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end">
                                                <a href="<c:url value='/seller/orders/${order.id}'/>"
                                                    class="btn btn-sm btn-outline-primary">
                                                    <i class="fas fa-eye"></i> Xem
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6" class="text-center py-4">
                                            <div class="empty-state">
                                                <img src="<c:url value='/resources/seller/images/empty-orders.svg'/>"
                                                    alt="No orders" style="width: 120px; height: 120px;">
                                                <p class="text-muted mt-2">Chưa có đơn hàng nào</p>
                                            </div>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Export Report Modal -->
        <div class="modal fade" id="exportReportModal" tabindex="-1" aria-labelledby="exportReportModalLabel"
            aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exportReportModalLabel">Xuất báo cáo Excel</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="exportReportForm">
                            <!-- Report Type -->
                            <div class="mb-3">
                                <label for="reportType" class="form-label">Loại báo cáo</label>
                                <select class="form-select" id="reportType" name="reportType"
                                    onchange="updateReportTypeDescription()">
                                    <option value="summary">Tổng quan</option>
                                    <option value="orders">Đơn hàng</option>
                                    <option value="products">Sản phẩm</option>
                                </select>
                                <div class="mt-2">
                                    <small id="reportTypeDescription" class="text-muted"></small>
                                </div>
                            </div>

                            <!-- Date Range -->
                            <div class="row g-2 mb-3">
                                <div class="col-md-6">
                                    <label for="startDate" class="form-label">Từ ngày</label>
                                    <input type="date" class="form-control" id="startDate" name="startDate" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="endDate" class="form-label">Đến ngày</label>
                                    <input type="date" class="form-control" id="endDate" name="endDate" required>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-success" onclick="exportReport()">
                            <i class="fas fa-download"></i> Tải xuống
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Link to external CSS file -->
        <link rel="stylesheet" href="<c:url value='/resources/seller/css/seller-dashboard.css'/>" />

        <!-- Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

        <!-- Dashboard JavaScript -->
        <script src="<c:url value='/resources/seller/js/seller-dashboard.js'/>"></script>