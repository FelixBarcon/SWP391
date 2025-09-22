// Sales Chart
const salesCtx = document.getElementById("salesChart").getContext("2d");
const salesChart = new Chart(salesCtx, {
  type: "line",
  data: {
    labels: ["00:00", "04:00", "08:00", "12:00", "16:00", "20:00", "23:59"],
    datasets: [
      {
        label: "Doanh số",
        data: [12, 19, 15, 25, 22, 30, 28],
        borderColor: "#ee4d2d",
        backgroundColor: "rgba(238, 77, 45, 0.1)",
        tension: 0.4,
        fill: true,
      },
      {
        label: "Đơn hàng",
        data: [5, 12, 18, 20, 15, 25, 22],
        borderColor: "#1890ff",
        backgroundColor: "rgba(24, 144, 255, 0.1)",
        tension: 0.4,
        fill: true,
      },
    ],
  },
  options: {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        position: "top",
      },
      title: {
        display: true,
        text: "Thống kê doanh số và đơn hàng",
      },
    },
    scales: {
      y: {
        beginAtZero: true,
        grid: {
          drawBorder: false,
        },
      },
      x: {
        grid: {
          display: false,
        },
      },
    },
  },
});

// Categories Chart
const categoriesCtx = document
  .getElementById("categoriesChart")
  .getContext("2d");
const categoriesChart = new Chart(categoriesCtx, {
  type: "doughnut",
  data: {
    labels: ["Điện thoại", "Laptop", "Thời trang", "Mỹ phẩm", "Khác"],
    datasets: [
      {
        data: [30, 25, 20, 15, 10],
        backgroundColor: [
          "#ee4d2d",
          "#1890ff",
          "#52c41a",
          "#722ed1",
          "#faad14",
        ],
      },
    ],
  },
  options: {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        position: "bottom",
      },
      title: {
        display: true,
        text: "Phân bố danh mục",
      },
    },
  },
});

// Handle period change
document.getElementById("salesPeriod").addEventListener("change", function (e) {
  // Here you would typically fetch new data based on the selected period
  // and update the chart
  console.log("Selected period:", e.target.value);
});
