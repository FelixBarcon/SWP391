// User Activity Chart
function initUserActivityChart() {
  const ctx = document.getElementById("userActivityChart").getContext("2d");
  const gradient = ctx.createLinearGradient(0, 0, 0, 400);
  gradient.addColorStop(0, "rgba(75, 192, 192, 0.5)");
  gradient.addColorStop(1, "rgba(75, 192, 192, 0.1)");

  new Chart(ctx, {
    type: "line",
    data: {
      labels: ["00:00", "04:00", "08:00", "12:00", "16:00", "20:00", "23:59"],
      datasets: [
        {
          label: "Người dùng hoạt động",
          data: [120, 90, 180, 270, 220, 350, 180],
          borderColor: "rgb(75, 192, 192)",
          backgroundColor: gradient,
          tension: 0.4,
          fill: true,
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      interaction: {
        intersect: false,
        mode: "index",
      },
      plugins: {
        legend: {
          position: "top",
        },
        tooltip: {
          callbacks: {
            label: function (context) {
              return `${context.dataset.label}: ${context.parsed.y} người dùng`;
            },
          },
        },
      },
      scales: {
        y: {
          beginAtZero: true,
          title: {
            display: true,
            text: "Số lượng người dùng",
          },
          grid: {
            display: true,
            drawBorder: false,
          },
        },
        x: {
          title: {
            display: true,
            text: "Thời gian",
          },
          grid: {
            display: false,
          },
        },
      },
    },
  });
}

// Update metrics in real-time (simulated)
function updateSystemMetrics() {
  const updateMetric = (selector, value, type = "progress") => {
    const element = document.querySelector(selector);
    if (!element) return;

    if (type === "progress") {
      element.style.width = `${value}%`;
      element
        .closest(".metric-card")
        .querySelector(".metric-value").textContent = `${value}%`;

      // Update progress bar colors based on value
      let colorClass =
        value < 50 ? "bg-info" : value < 75 ? "bg-warning" : "bg-danger";

      element.className = `progress-bar ${colorClass}`;
    } else if (type === "network") {
      element.textContent = value;
    }
  };

  // Simulate real-time updates
  setInterval(() => {
    // Random fluctuations for demo
    const cpuUsage = Math.floor(Math.random() * 20 + 35); // 35-55%
    const memoryUsage = Math.floor(Math.random() * 15 + 55); // 55-70%
    const diskUsage = Math.floor(Math.random() * 5 + 73); // 73-78%

    const downloadSpeed = (Math.random() * 1 + 2).toFixed(1); // 2.0-3.0 MB/s
    const uploadSpeed = (Math.random() * 0.8 + 1.5).toFixed(1); // 1.5-2.3 MB/s

    // Update progress bars
    updateMetric(".metric-card:nth-child(1) .progress-bar", cpuUsage);
    updateMetric(".metric-card:nth-child(2) .progress-bar", memoryUsage);
    updateMetric(".metric-card:nth-child(3) .progress-bar", diskUsage);

    // Update network stats
    updateMetric(
      ".network-stats .text-success",
      `${downloadSpeed} MB/s`,
      "network"
    );
    updateMetric(
      ".network-stats .text-primary",
      `${uploadSpeed} MB/s`,
      "network"
    );
  }, 3000); // Update every 3 seconds
}

// Initialize everything when the document is ready
document.addEventListener("DOMContentLoaded", function () {
  initUserActivityChart();
  updateSystemMetrics();

  // Period selector for user activity chart
  const periodSelector = document.getElementById("activityPeriod");
  if (periodSelector) {
    periodSelector.addEventListener("change", function (e) {
      // Here you would typically fetch new data based on the selected period
      // For demo purposes, we'll just log the change
      console.log("Selected period:", e.target.value);
    });
  }
});
