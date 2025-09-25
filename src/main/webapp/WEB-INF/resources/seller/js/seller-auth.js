document.addEventListener("DOMContentLoaded", function () {
  // Clear form data from session storage when the page loads
  const form = document.querySelector("form");
  if (form) {
    form.reset();

    // Clear browser's form autofill
    const inputs = form.querySelectorAll("input, textarea");
    inputs.forEach((input) => {
      input.autocomplete = "off";
    });
  }

  // Auto hide status message after 5 seconds
  const statusMessage = document.getElementById("statusMessage");
  if (statusMessage) {
    setTimeout(() => {
      statusMessage.style.opacity = "0";
      statusMessage.style.transform = "translateY(-10px)";
      setTimeout(() => {
        statusMessage.remove();
      }, 300);
    }, 5000);
  }
});
