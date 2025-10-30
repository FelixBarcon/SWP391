<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- Dashboard Content -->
        <div class="admin-dashboard">
            <!-- Title and Export Button -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="h3 mb-0 text-gray-800">Bảng điều khiển</h1>
                <div class="d-flex gap-2">
                    <button class="btn btn-success btn-sm" onclick="openExportModal()">
                        <i class="fas fa-file-excel me-1"></i>Xuất báo cáo Excel
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
                                <h3 class="stats-number">${totalUsers}</h3>
                                <p class="stats-label">Tổng người dùng</p>
                                <span class="stats-change positive">
                                    <i class="fas fa-users"></i> Hệ thống
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
                                <h3 class="stats-number">${activeUsers}</h3>
                                <p class="stats-label">Người dùng hoạt động</p>
                                <span class="stats-change positive">
                                    <i class="fas fa-arrow-up"></i> ${activeUserPercentage}%
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Total Orders -->
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card">
                        <div class="stats-card-body">
                            <div class="stats-icon performance">
                                <i class="fas fa-shopping-cart"></i>
                            </div>
                            <div class="stats-info">
                                <h3 class="stats-number">${totalOrders}</h3>
                                <p class="stats-label">Tổng đơn hàng</p>
                                <span class="stats-change positive">
                                    <i class="fas fa-check-circle"></i> Hệ thống
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Total Products -->
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card">
                        <div class="stats-card-body">
                            <div class="stats-icon reports">
                                <i class="fas fa-box"></i>
                            </div>
                            <div class="stats-info">
                                <h3 class="stats-number">${totalProducts}</h3>
                                <p class="stats-label">Tổng sản phẩm</p>
                                <span class="stats-change positive">
                                    <i class="fas fa-check-circle"></i> Hệ thống
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- User Activity Chart -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="dashboard-card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-chart-line me-2"></i>
                                Biểu đồ đơn hàng theo thời gian
                            </h5>
                            <div class="card-tools">
                                <select class="form-select form-select-sm" id="activityPeriod"
                                    onchange="loadChartData()">
                                    <option value="today">Hôm nay</option>
                                    <option value="week">Tuần này</option>
                                    <option value="month" selected>Tháng này</option>
                                    <option value="year">Năm nay</option>
                                </select>
                            </div>
                        </div>
                        <div class="card-body">
                            <!-- Summary Statistics -->
                            <div class="row mb-4" id="chartSummary" style="display: none;">
                                <div class="col-md-3">
                                    <div class="summary-stat">
                                        <div class="stat-icon" style="background: rgba(75, 192, 192, 0.1);">
                                            <i class="fas fa-shopping-cart" style="color: rgb(75, 192, 192);"></i>
                                        </div>
                                        <div class="stat-content">
                                            <h4 id="summaryTotalOrders">0</h4>
                                            <p>Tổng đơn hàng</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="summary-stat">
                                        <div class="stat-icon" style="background: rgba(255, 205, 86, 0.1);">
                                            <i class="fas fa-clock" style="color: rgb(255, 205, 86);"></i>
                                        </div>
                                        <div class="stat-content">
                                            <h4 id="summaryPending">0</h4>
                                            <p>Chờ xử lý</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="summary-stat">
                                        <div class="stat-icon" style="background: rgba(54, 162, 235, 0.1);">
                                            <i class="fas fa-check-circle" style="color: rgb(54, 162, 235);"></i>
                                        </div>
                                        <div class="stat-content">
                                            <h4 id="summaryPaid">0</h4>
                                            <p>Đã thanh toán</p>
                                            <small class="text-success" id="successRate"></small>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="summary-stat">
                                        <div class="stat-icon" style="background: rgba(255, 99, 132, 0.1);">
                                            <i class="fas fa-times-circle" style="color: rgb(255, 99, 132);"></i>
                                        </div>
                                        <div class="stat-content">
                                            <h4 id="summaryCanceled">0</h4>
                                            <p>Đã hủy</p>
                                            <small class="text-danger" id="cancelRate"></small>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Chart -->
                            <div class="chart-container" style="position: relative; height: 400px;">
                                <canvas id="userActivityChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Export Modal -->
        <div class="modal fade" id="exportModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-file-excel me-2"></i>Xuất báo cáo Excel
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form id="exportForm">
                            <div class="mb-3">
                                <label class="form-label fw-bold">
                                    <i class="fas fa-file-alt me-1"></i>Loại báo cáo
                                </label>
                                <select class="form-select" id="reportType" name="reportType">
                                    <option value="summary">Tổng quan (Thống kê tổng hợp)</option>
                                    <option value="users">Người dùng (Toàn hệ thống - không theo thời gian)</option>
                                    <option value="orders">Đơn hàng (Theo thời gian)</option>
                                    <option value="products">Sản phẩm (Theo thời gian)</option>
                                </select>
                                <div class="form-text" id="reportTypeHelp">
                                    <i class="fas fa-info-circle"></i>
                                    <span id="reportTypeDescription">Chọn loại báo cáo phù hợp với nhu cầu của
                                        bạn</span>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">
                                            <i class="fas fa-calendar-alt me-1"></i>Từ ngày
                                        </label>
                                        <input type="date" class="form-control" id="startDate" name="startDate">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">
                                            <i class="fas fa-calendar-check me-1"></i>Đến ngày
                                        </label>
                                        <input type="date" class="form-control" id="endDate" name="endDate">
                                    </div>
                                </div>
                            </div>

                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-success" onclick="exportExcel()">
                            <i class="fas fa-download me-1"></i>Tải xuống
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Chart.js Library -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

        <!-- Dashboard Chart Script -->
        <script>
            let chartInstance = null;

            // Load chart data when page loads
            document.addEventListener('DOMContentLoaded', function () {
                loadChartData();

                // Set default dates (last 30 days)
                const today = new Date();
                const lastMonth = new Date(today);
                lastMonth.setMonth(lastMonth.getMonth() - 1);

                document.getElementById('endDate').valueAsDate = today;
                document.getElementById('startDate').valueAsDate = lastMonth;

                // Add report type change listener
                document.getElementById('reportType').addEventListener('change', function () {
                    updateReportTypeDescription(this.value);
                });
            });

            function loadChartData() {
                const period = document.getElementById('activityPeriod').value;

                fetch('/api/admin/dashboard/user-activity-chart?period=' + period + '&v=' + Date.now())
                    .then(response => response.json())
                    .then(data => {
                        console.log('Chart data loaded:', data); // Debug log
                        renderChart(data);
                        updateSummary(data.summary);
                    })
                    .catch(error => {
                        console.error('Error loading chart data:', error);
                    });
            }

            function updateSummary(summary) {
                if (!summary) return;

                document.getElementById('chartSummary').style.display = 'flex';
                document.getElementById('summaryTotalOrders').textContent = summary.totalOrders.toLocaleString();
                document.getElementById('summaryPending').textContent = summary.totalPending.toLocaleString();
                document.getElementById('summaryPaid').textContent = summary.totalPaid.toLocaleString();
                document.getElementById('summaryCanceled').textContent = summary.totalCanceled.toLocaleString();

                document.getElementById('successRate').textContent =
                    summary.successRate.toFixed(1) + '% thành công';
                document.getElementById('cancelRate').textContent =
                    summary.cancelRate.toFixed(1) + '% hủy';
            }

            function renderChart(data) {
                const ctx = document.getElementById('userActivityChart').getContext('2d');

                // Destroy existing chart if exists
                if (chartInstance) {
                    chartInstance.destroy();
                }

                chartInstance = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: data.labels,
                        datasets: [
                            {
                                label: 'Đơn chờ xử lý',
                                data: data.pendingOrders,
                                borderColor: 'rgb(255, 205, 86)',
                                backgroundColor: 'rgba(255, 205, 86, 0.1)',
                                borderWidth: 2,
                                tension: 0.4,
                                fill: true,
                                pointRadius: 3,
                                pointHoverRadius: 5
                            },
                            {
                                label: 'Đơn đã thanh toán',
                                data: data.paidOrders,
                                borderColor: 'rgb(54, 162, 235)',
                                backgroundColor: 'rgba(54, 162, 235, 0.1)',
                                borderWidth: 2,
                                tension: 0.4,
                                fill: true,
                                pointRadius: 3,
                                pointHoverRadius: 5
                            },
                            {
                                label: 'Đơn đã hủy',
                                data: data.canceledOrders,
                                borderColor: 'rgb(255, 99, 132)',
                                backgroundColor: 'rgba(255, 99, 132, 0.1)',
                                borderWidth: 2,
                                tension: 0.4,
                                fill: true,
                                pointRadius: 3,
                                pointHoverRadius: 5
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'top',
                                labels: {
                                    usePointStyle: true,
                                    padding: 15,
                                    font: {
                                        size: 12
                                    }
                                }
                            },
                            title: {
                                display: false
                            },
                            tooltip: {
                                mode: 'index',
                                intersect: false,
                                backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                padding: 12,
                                titleFont: {
                                    size: 14
                                },
                                bodyFont: {
                                    size: 13
                                },
                                callbacks: {
                                    label: function (context) {
                                        let label = context.dataset.label || '';
                                        if (label) {
                                            label += ': ';
                                        }
                                        if (context.parsed.y !== null) {
                                            label += context.parsed.y + ' đơn';
                                        }
                                        return label;
                                    }
                                }
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    stepSize: 1,
                                    callback: function (value) {
                                        return Number.isInteger(value) ? value : '';
                                    }
                                },
                                title: {
                                    display: true,
                                    text: 'Số lượng đơn hàng',
                                    font: {
                                        size: 13,
                                        weight: 'bold'
                                    }
                                },
                                grid: {
                                    drawBorder: false
                                }
                            },
                            x: {
                                grid: {
                                    display: false
                                }
                            }
                        },
                        interaction: {
                            mode: 'nearest',
                            axis: 'x',
                            intersect: false
                        }
                    }
                });
            }

            function openExportModal() {
                const modal = new bootstrap.Modal(document.getElementById('exportModal'));
                modal.show();
                updateReportTypeDescription('all'); // Set default description
            }

            function updateReportTypeDescription(reportType) {
                const descElement = document.getElementById('reportTypeDescription');
                const descriptions = {
                    'summary': 'Xuất bảng thống kê tổng hợp về đơn hàng, sản phẩm và người dùng',
                    'users': 'Xuất danh sách tất cả người dùng (không phụ thuộc vào thời gian chọn)',
                    'orders': 'Xuất danh sách đơn hàng chi tiết trong khoảng thời gian đã chọn',
                    'products': 'Xuất danh sách sản phẩm chi tiết trong khoảng thời gian đã chọn'
                };
                descElement.textContent = descriptions[reportType] || descriptions['summary'];
            }

            function exportExcel() {
                const reportType = document.getElementById('reportType').value;
                const startDate = document.getElementById('startDate').value;
                const endDate = document.getElementById('endDate').value;

                if (!startDate || !endDate) {
                    alert('Vui lòng chọn khoảng thời gian');
                    return;
                }

                // Build URL with parameters
                let url = '/api/admin/dashboard/export-report?reportType=' + reportType;
                if (startDate) url += '&startDate=' + startDate;
                if (endDate) url += '&endDate=' + endDate;

                // Download file
                window.location.href = url;

                // Close modal after a short delay
                setTimeout(() => {
                    bootstrap.Modal.getInstance(document.getElementById('exportModal')).hide();
                }, 500);
            }
        </script>

        <style>
            .dashboard-card {
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                margin-bottom: 20px;
            }

            .dashboard-card .card-header {
                padding: 15px 20px;
                border-bottom: 1px solid #e3e6f0;
                background: transparent;
            }

            .dashboard-card .card-title {
                margin: 0;
                font-size: 1.1rem;
                font-weight: 600;
                color: #5a5c69;
            }

            .dashboard-card .card-body {
                padding: 20px;
            }

            .chart-container {
                position: relative;
            }

            .card-tools .form-select {
                min-width: 150px;
            }

            #chartSummary {
                padding: 15px 0;
                border-bottom: 1px solid #e3e6f0;
                margin-bottom: 20px;
            }

            .summary-stat {
                display: flex;
                align-items: center;
                gap: 15px;
                padding: 15px;
                background: #f8f9fc;
                border-radius: 8px;
                height: 100%;
            }

            .summary-stat .stat-icon {
                width: 50px;
                height: 50px;
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24px;
            }

            .summary-stat .stat-content {
                flex: 1;
            }

            .summary-stat .stat-content h4 {
                margin: 0;
                font-size: 24px;
                font-weight: 700;
                color: #2c3e50;
            }

            .summary-stat .stat-content p {
                margin: 0;
                font-size: 13px;
                color: #7f8c8d;
            }

            .summary-stat .stat-content small {
                font-size: 11px;
                font-weight: 600;
            }

            /* Export Modal Styles */
            #reportTypeHelp {
                margin-top: 8px;
                padding: 8px 12px;
                background: #f0f8ff;
                border-left: 3px solid #0dcaf0;
                border-radius: 4px;
                font-size: 13px;
                color: #055160;
            }

            #reportTypeHelp i {
                color: #0dcaf0;
            }

            .form-label.fw-bold {
                color: #2c3e50;
                margin-bottom: 8px;
            }

            .form-label.fw-bold i {
                color: #3498db;
            }

            .alert-info ul {
                padding-left: 20px;
            }

            .alert-info ul li {
                margin-bottom: 4px;
            }

            .form-select {
                font-size: 14px;
                padding: 10px 12px;
            }

            .form-select:focus {
                border-color: #0dcaf0;
                box-shadow: 0 0 0 0.2rem rgba(13, 202, 240, 0.15);
            }
        </style>