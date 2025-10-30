// Seller Dashboard JavaScript
let salesChart = null;
let currentPeriod = "month";

// Load chart on page load
document.addEventListener("DOMContentLoaded", function () {
  // Update current date in header
  updateCurrentDate();

  // Load sales chart
  loadSalesChart("month");

  // Set date pickers and description when modal opens
  const exportModal = document.getElementById("exportReportModal");
  if (exportModal) {
    exportModal.addEventListener("show.bs.modal", function () {
      initializeDatePickers();
      updateReportTypeDescription();
    });
  }
});

// Update current date display
function updateCurrentDate() {
  const dateElement = document.getElementById("currentDate");
  if (dateElement) {
    const options = {
      weekday: "long",
      year: "numeric",
      month: "long",
      day: "numeric",
    };
    const today = new Date();
    dateElement.textContent = today.toLocaleDateString("vi-VN", options);
  }
}

// Load sales chart data
function loadSalesChart(period, event) {
  currentPeriod = period;

  // Update active button
  if (event && event.target) {
    document.querySelectorAll(".btn-group .btn").forEach((btn) => {
      btn.classList.remove("active");
    });
    event.target.classList.add("active");
  }

  fetch(`/api/seller/dashboard/sales-chart?period=${period}`)
    .then((response) => response.json())
    .then((data) => {
      updateChartStats(data.summary);
      renderSalesChart(data);
    })
    .catch((error) => {
      console.error("Error loading chart:", error);
      alert("Không thể tải dữ liệu biểu đồ. Vui lòng thử lại!");
    });
}

// Update chart statistics
function updateChartStats(summary) {
  const totalRevenueEl = document.getElementById("chartTotalRevenue");
  const totalOrdersEl = document.getElementById("chartTotalOrders");
  const avgOrderValueEl = document.getElementById("chartAvgOrderValue");

  if (totalRevenueEl) {
    totalRevenueEl.textContent = formatCurrency(summary.totalRevenue);
  }
  if (totalOrdersEl) {
    totalOrdersEl.textContent = summary.totalOrders;
  }
  if (avgOrderValueEl) {
    avgOrderValueEl.textContent = formatCurrency(summary.averageOrderValue);
  }
}

// Render chart
function renderSalesChart(data) {
  const ctx = document.getElementById("salesChart");
  if (!ctx) return;

  const context = ctx.getContext("2d");

  if (salesChart) {
    salesChart.destroy();
  }

  salesChart = new Chart(context, {
    type: "line",
    data: {
      labels: data.labels,
      datasets: [
        {
          label: "Doanh thu (₫)",
          data: data.revenueData,
          borderColor: "rgb(13, 110, 253)",
          backgroundColor: "rgba(13, 110, 253, 0.1)",
          yAxisID: "y",
          tension: 0.4,
          fill: true,
        },
        {
          label: "Đơn hàng",
          data: data.orderData,
          borderColor: "rgb(25, 135, 84)",
          backgroundColor: "rgba(25, 135, 84, 0.1)",
          yAxisID: "y1",
          tension: 0.4,
          fill: true,
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      interaction: {
        mode: "index",
        intersect: false,
      },
      plugins: {
        legend: {
          display: true,
          position: "top",
        },
        tooltip: {
          callbacks: {
            label: function (context) {
              let label = context.dataset.label || "";
              if (label) {
                label += ": ";
              }
              if (context.parsed.y !== null) {
                if (context.datasetIndex === 0) {
                  label += formatCurrency(context.parsed.y);
                } else {
                  label += context.parsed.y;
                }
              }
              return label;
            },
          },
        },
      },
      scales: {
        y: {
          type: "linear",
          display: true,
          position: "left",
          title: {
            display: true,
            text: "Doanh thu (₫)",
          },
          ticks: {
            callback: function (value) {
              return formatCurrency(value);
            },
          },
        },
        y1: {
          type: "linear",
          display: true,
          position: "right",
          title: {
            display: true,
            text: "Số đơn hàng",
          },
          grid: {
            drawOnChartArea: false,
          },
        },
      },
    },
  });
}

// Format currency
function formatCurrency(value) {
  return new Intl.NumberFormat("vi-VN", {
    style: "currency",
    currency: "VND",
  }).format(value);
}

// Initialize date pickers with default values
function initializeDatePickers() {
  const today = new Date();
  const oneMonthAgo = new Date(today);
  oneMonthAgo.setMonth(today.getMonth() - 1);

  // Format dates to YYYY-MM-DD for input type="date"
  const formatDate = (date) => {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const day = String(date.getDate()).padStart(2, "0");
    return `${year}-${month}-${day}`;
  };

  const startDateInput = document.getElementById("startDate");
  const endDateInput = document.getElementById("endDate");

  if (startDateInput && endDateInput) {
    startDateInput.value = formatDate(oneMonthAgo);
    endDateInput.value = formatDate(today);
  }
}

// Update report type description
function updateReportTypeDescription() {
  const reportType = document.getElementById("reportType");
  const descriptionEl = document.getElementById("reportTypeDescription");

  if (!reportType || !descriptionEl) return;

  const descriptions = {
    summary: `
            <strong>Bao gồm:</strong>
            <ul class="mb-0 mt-1 ps-3">
                <li>Tổng số đơn hàng (tất cả và trong kỳ)</li>
                <li>Số đơn hàng đã thanh toán</li>
                <li>Doanh thu trong khoảng thời gian</li>
                <li>Tổng số sản phẩm của shop</li>
            </ul>
        `,
    orders: `
            <strong>Bao gồm:</strong>
            <ul class="mb-0 mt-1 ps-3">
                <li>Mã đơn hàng, khách hàng, email</li>
                <li>Tổng tiền, trạng thái đơn hàng</li>
                <li>Ngày tạo đơn hàng</li>
                <li>Tổng doanh thu từ các đơn đã thanh toán</li>
            </ul>
        `,
    products: `
            <strong>Bao gồm:</strong>
            <ul class="mb-0 mt-1 ps-3">
                <li>ID, tên sản phẩm</li>
                <li>Giá bán, trạng thái</li>
                <li>Thống kê số lượng sản phẩm đang hoạt động</li>
            </ul>
        `,
  };

  descriptionEl.innerHTML =
    descriptions[reportType.value] || descriptions["summary"];
}

// Export report
function exportReport() {
  const reportType = document.getElementById("reportType").value;
  const startDate = document.getElementById("startDate").value;
  const endDate = document.getElementById("endDate").value;

  if (!startDate || !endDate) {
    alert("Vui lòng chọn khoảng thời gian!");
    return;
  }

  if (new Date(startDate) > new Date(endDate)) {
    alert("Ngày bắt đầu phải trước ngày kết thúc!");
    return;
  }

  // Create download link
  const url = `/api/seller/dashboard/export-report?reportType=${reportType}&startDate=${startDate}&endDate=${endDate}`;

  window.location.href = url;

  // Close modal after a short delay
  setTimeout(() => {
    const modal = bootstrap.Modal.getInstance(
      document.getElementById("exportReportModal")
    );
    if (modal) {
      modal.hide();
    }
  }, 500);
}
