<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- Dashboard Content -->
        <div class="admin-dashboard">
            <!-- Title and Actions -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="h3 mb-0 text-gray-800">Bảng điều khiển</h1>
                <div class="d-flex gap-2">
                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#backupModal">
                        <i class="fas fa-database me-1"></i>Sao lưu dữ liệu
                    </button>
                    <button class="btn btn-info btn-sm" data-bs-toggle="modal" data-bs-target="#settingsModal">
                        <i class="fas fa-cogs me-1"></i>Cài đặt hệ thống
                    </button>
                </div>
            </div>

            <!-- Overview Statistics -->
            <div class="row mb-4">
                <!-- Total Users -->
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card">
                        <div class="stats-card-body">
                            <div class="stats-icon users">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="stats-info">
                                <h3 class="stats-number">8,549</h3>
                                <p class="stats-label">Tổng người dùng</p>
                                <span class="stats-change positive">
                                    <i class="fas fa-arrow-up"></i> +15.3%
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Active Users -->
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card">
                        <div class="stats-card-body">
                            <div class="stats-icon active">
                                <i class="fas fa-user-check"></i>
                            </div>
                            <div class="stats-info">
                                <h3 class="stats-number">6,832</h3>
                                <p class="stats-label">Người dùng hoạt động</p>
                                <span class="stats-change positive">
                                    <i class="fas fa-arrow-up"></i> +8.2%
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- System Performance -->
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card">
                        <div class="stats-card-body">
                            <div class="stats-icon performance">
                                <i class="fas fa-server"></i>
                            </div>
                            <div class="stats-info">
                                <h3 class="stats-number">98.5%</h3>
                                <p class="stats-label">Hiệu suất hệ thống</p>
                                <span class="stats-change positive">
                                    <i class="fas fa-check-circle"></i> Ổn định
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Reports -->
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card">
                        <div class="stats-card-body">
                            <div class="stats-icon reports">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                            <div class="stats-info">
                                <h3 class="stats-number">24</h3>
                                <p class="stats-label">Báo cáo chờ xử lý</p>
                                <span class="stats-change warning">
                                    <i class="fas fa-exclamation-circle"></i> Cần xử lý
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Content -->
            <div class="row">
                <!-- Left Column -->
                <div class="col-xl-8">
                    <!-- User Activity Chart -->
                    <div class="dashboard-card mb-4">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="card-title">
                                <i class="fas fa-chart-line me-2"></i>
                                Hoạt động người dùng
                            </h5>
                            <div class="card-tools">
                                <select class="form-select form-select-sm" id="activityPeriod">
                                    <option value="today">Hôm nay</option>
                                    <option value="week">Tuần này</option>
                                    <option value="month" selected>Tháng này</option>
                                    <option value="year">Năm nay</option>
                                </select>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="userActivityChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- System Logs -->
                    <div class="dashboard-card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="card-title">
                                <i class="fas fa-history me-2"></i>
                                Nhật ký hệ thống
                            </h5>
                            <div class="card-tools">
                                <button class="btn btn-sm btn-outline-secondary me-2" data-bs-toggle="modal"
                                    data-bs-target="#filterLogsModal">
                                    <i class="fas fa-filter me-1"></i>Lọc
                                </button>
                                <a href="<c:url value='/admin/logs'/>" class="btn btn-sm btn-primary">
                                    <i class="fas fa-external-link-alt me-1"></i>Xem tất cả
                                </a>
                            </div>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead>
                                        <tr>
                                            <th>Thời gian</th>
                                            <th>Người dùng</th>
                                            <th>Hành động</th>
                                            <th>IP</th>
                                            <th>Trạng thái</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>
                                                <small class="text-muted">2025-09-21 14:30:15</small>
                                            </td>
                                            <td>admin@system.com</td>
                                            <td>Chặn người dùng</td>
                                            <td>192.168.1.100</td>
                                            <td><span class="badge bg-success">Thành công</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-light" title="Xem chi tiết">
                                                    <i class="fas fa-info-circle"></i>
                                                </button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <small class="text-muted">2025-09-21 14:28:45</small>
                                            </td>
                                            <td>user123</td>
                                            <td>Đăng nhập thất bại</td>
                                            <td>192.168.1.201</td>
                                            <td><span class="badge bg-danger">Thất bại</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-light" title="Xem chi tiết">
                                                    <i class="fas fa-info-circle"></i>
                                                </button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <small class="text-muted">2025-09-21 14:25:30</small>
                                            </td>
                                            <td>system</td>
                                            <td>Sao lưu dữ liệu</td>
                                            <td>localhost</td>
                                            <td><span class="badge bg-success">Thành công</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-light" title="Xem chi tiết">
                                                    <i class="fas fa-info-circle"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Column -->
                <div class="col-xl-4">
                    <!-- System Metrics -->
                    <div class="dashboard-card mb-4">
                        <div class="card-header">
                            <h5 class="card-title">
                                <i class="fas fa-server me-2"></i>
                                Hiệu suất hệ thống
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="system-metrics">
                                <!-- CPU Usage -->
                                <div class="metric-card">
                                    <div class="metric-header d-flex justify-content-between align-items-center">
                                        <span><i class="fas fa-microchip me-2"></i>CPU</span>
                                        <span class="metric-value">45%</span>
                                    </div>
                                    <div class="progress mt-2">
                                        <div class="progress-bar bg-info" role="progressbar" style="width: 45%"></div>
                                    </div>
                                </div>

                                <!-- Memory Usage -->
                                <div class="metric-card">
                                    <div class="metric-header d-flex justify-content-between align-items-center">
                                        <span><i class="fas fa-memory me-2"></i>Bộ nhớ</span>
                                        <span class="metric-value">60%</span>
                                    </div>
                                    <div class="progress mt-2">
                                        <div class="progress-bar bg-warning" role="progressbar" style="width: 60%">
                                        </div>
                                    </div>
                                </div>

                                <!-- Disk Usage -->
                                <div class="metric-card">
                                    <div class="metric-header d-flex justify-content-between align-items-center">
                                        <span><i class="fas fa-hdd me-2"></i>Ổ đĩa</span>
                                        <span class="metric-value">75%</span>
                                    </div>
                                    <div class="progress mt-2">
                                        <div class="progress-bar bg-danger" role="progressbar" style="width: 75%"></div>
                                    </div>
                                </div>

                                <!-- Network Usage -->
                                <div class="metric-card">
                                    <div class="metric-header d-flex justify-content-between align-items-center">
                                        <span><i class="fas fa-network-wired me-2"></i>Mạng</span>
                                        <div class="network-stats small">
                                            <span class="text-success me-2">
                                                <i class="fas fa-arrow-down"></i> 2.5 MB/s
                                            </span>
                                            <span class="text-primary">
                                                <i class="fas fa-arrow-up"></i> 1.8 MB/s
                                            </span>
                                        </div>
                                    </div>
                                    <div class="progress mt-2">
                                        <div class="progress-bar bg-success" role="progressbar" style="width: 35%">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="dashboard-card mb-4">
                        <div class="card-header">
                            <h5 class="card-title">
                                <i class="fas fa-bolt me-2"></i>
                                Thao tác nhanh
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="quick-actions">
                                <a href="<c:url value='/admin/users'/>" class="quick-action-btn">
                                    <i class="fas fa-users-cog"></i>
                                    <span>Quản lý người dùng</span>
                                </a>
                                <a href="<c:url value='/admin/security'/>" class="quick-action-btn">
                                    <i class="fas fa-shield-alt"></i>
                                    <span>Cài đặt bảo mật</span>
                                </a>
                                <a href="<c:url value='/admin/reports'/>" class="quick-action-btn">
                                    <i class="fas fa-flag"></i>
                                    <span>Xử lý báo cáo</span>
                                </a>
                                <a href="<c:url value='/admin/system'/>" class="quick-action-btn">
                                    <i class="fas fa-cogs"></i>
                                    <span>Cấu hình hệ thống</span>
                                </a>
                                <a href="<c:url value='/admin/backup'/>" class="quick-action-btn">
                                    <i class="fas fa-database"></i>
                                    <span>Sao lưu dữ liệu</span>
                                </a>
                                <a href="<c:url value='/admin/logs'/>" class="quick-action-btn">
                                    <i class="fas fa-history"></i>
                                    <span>Nhật ký hoạt động</span>
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Reports -->
                    <div class="dashboard-card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="card-title">
                                <i class="fas fa-flag me-2"></i>
                                Báo cáo mới
                            </h5>
                            <a href="<c:url value='/admin/reports'/>" class="btn btn-sm btn-primary">
                                Xem tất cả
                            </a>
                        </div>
                        <div class="card-body p-0">
                            <div class="report-list">
                                <div class="report-item">
                                    <div class="report-icon bg-danger">
                                        <i class="fas fa-exclamation-triangle"></i>
                                    </div>
                                    <div class="report-content">
                                        <h6>Spam bình luận</h6>
                                        <p>Người dùng user123 bị báo cáo spam</p>
                                        <small class="text-muted">5 phút trước</small>
                                    </div>
                                    <button class="btn btn-sm btn-light">
                                        <i class="fas fa-arrow-right"></i>
                                    </button>
                                </div>
                                <div class="report-item">
                                    <div class="report-icon bg-warning">
                                        <i class="fas fa-user-shield"></i>
                                    </div>
                                    <div class="report-content">
                                        <h6>Yêu cầu xác minh</h6>
                                        <p>2 yêu cầu xác minh người dùng mới</p>
                                        <small class="text-muted">15 phút trước</small>
                                    </div>
                                    <button class="btn btn-sm btn-light">
                                        <i class="fas fa-arrow-right"></i>
                                    </button>
                                </div>
                                <div class="report-item">
                                    <div class="report-icon bg-info">
                                        <i class="fas fa-bug"></i>
                                    </div>
                                    <div class="report-content">
                                        <h6>Báo cáo lỗi</h6>
                                        <p>Lỗi hiển thị trong trang cá nhân</p>
                                        <small class="text-muted">1 giờ trước</small>
                                    </div>
                                    <button class="btn btn-sm btn-light">
                                        <i class="fas fa-arrow-right"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modals -->
        <!-- Backup Modal -->
        <div class="modal fade" id="backupModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Sao lưu dữ liệu</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p>Bạn có chắc chắn muốn tạo bản sao lưu mới không?</p>
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" id="backupDb">
                            <label class="form-check-label" for="backupDb">
                                Sao lưu cơ sở dữ liệu
                            </label>
                        </div>
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" id="backupFiles">
                            <label class="form-check-label" for="backupFiles">
                                Sao lưu tệp tin hệ thống
                            </label>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-primary">
                            <i class="fas fa-download me-1"></i>Tạo bản sao lưu
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Settings Modal -->
        <div class="modal fade" id="settingsModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Cài đặt hệ thống</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Chế độ bảo trì</label>
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="maintenanceMode">
                                <label class="form-check-label" for="maintenanceMode">
                                    Kích hoạt chế độ bảo trì
                                </label>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Giới hạn đăng nhập thất bại</label>
                            <input type="number" class="form-control" value="5">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Thời gian khóa tài khoản (phút)</label>
                            <input type="number" class="form-control" value="30">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Lưu thay đổi
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filter Logs Modal -->
        <div class="modal fade" id="filterLogsModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Lọc nhật ký</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Khoảng thời gian</label>
                            <select class="form-select">
                                <option value="today">Hôm nay</option>
                                <option value="yesterday">Hôm qua</option>
                                <option value="week">Tuần này</option>
                                <option value="month">Tháng này</option>
                                <option value="custom">Tùy chỉnh</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Loại hoạt động</label>
                            <select class="form-select" multiple>
                                <option value="login">Đăng nhập</option>
                                <option value="user">Quản lý người dùng</option>
                                <option value="system">Hệ thống</option>
                                <option value="security">Bảo mật</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Trạng thái</label>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" value="success" checked>
                                <label class="form-check-label">Thành công</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" value="error" checked>
                                <label class="form-check-label">Thất bại</label>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-primary">
                            <i class="fas fa-filter me-1"></i>Áp dụng
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Initialize Charts -->
        <script src="<c:url value='/resources/admin/js/admin-dashboard-charts.js'/>"></script>