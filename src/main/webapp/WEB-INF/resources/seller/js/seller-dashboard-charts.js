// Charts for seller dashboard
document.addEventListener("DOMContentLoaded", function () {
  // Revenue Chart
  const revenueCtx = document.getElementById("revenueChart").getContext("2d");
  new Chart(revenueCtx, {
    type: "line",
    data: {
      labels: [
        "T1",
        "T2",
        "T3",
        "T4",
        "T5",
        "T6",
        "T7",
        "T8",
        "T9",
        "T10",
        "T11",
        "T12",
      ],
      datasets: [
        {
          label: "Doanh thu",
          data: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
          borderColor: "#2E7D32",
          tension: 0.4,
          fill: false,
        },
      ],
    },
    options: {
      responsive: true,
      plugins: {
        title: {
          display: true,
          text: "Biểu đồ doanh thu theo tháng",
        },
      },
      scales: {
        y: {
          beginAtZero: true,
          ticks: {
            callback: function (value) {
              return value.toLocaleString("vi-VN", {
                style: "currency",
                currency: "VND",
              });
            },
          },
        },
      },
    },
  });

  // Orders Chart
  const ordersCtx = document.getElementById("ordersChart").getContext("2d");
  new Chart(ordersCtx, {
    type: "bar",
    data: {
      labels: [
        "T1",
        "T2",
        "T3",
        "T4",
        "T5",
        "T6",
        "T7",
        "T8",
        "T9",
        "T10",
        "T11",
        "T12",
      ],
      datasets: [
        {
          label: "Đơn hàng",
          data: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
          backgroundColor: "#43A047",
          borderRadius: 5,
        },
      ],
    },
    options: {
      responsive: true,
      plugins: {
        title: {
          display: true,
          text: "Số lượng đơn hàng theo tháng",
        },
      },
      scales: {
        y: {
          beginAtZero: true,
          ticks: {
            stepSize: 1,
          },
        },
      },
    },
  });

  // Products Chart
  const productsCtx = document.getElementById("productsChart").getContext("2d");
  new Chart(productsCtx, {
    type: "doughnut",
    data: {
      labels: ["Còn hàng", "Sắp hết", "Hết hàng"],
      datasets: [
        {
          data: [0, 0, 0],
          backgroundColor: ["#43A047", "#FB8C00", "#E53935"],
          borderWidth: 0,
        },
      ],
    },
    options: {
      responsive: true,
      plugins: {
        title: {
          display: true,
          text: "Tình trạng kho hàng",
        },
      },
    },
  });
});
