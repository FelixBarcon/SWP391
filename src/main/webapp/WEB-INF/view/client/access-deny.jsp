<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>403 - Access Denied</title>
  <!-- Tailwind (CDN) -->
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-gradient-to-br from-orange-500 via-orange-500 to-red-500">
  <div class="min-h-screen flex items-center justify-center px-4">
    <div class="w-full max-w-xl">
      <!-- Card -->
      <div class="bg-white/95 backdrop-blur shadow-2xl rounded-2xl overflow-hidden">
        <!-- Header màu cam -->
        <div class="bg-gradient-to-r from-orange-500 to-red-500 p-6 text-white flex items-center gap-4">
          <!-- Icon khoá -->
          <svg xmlns="http://www.w3.org/2000/svg" class="w-10 h-10 flex-shrink-0"
               fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
            <path stroke-linecap="round" stroke-linejoin="round"
                  d="M16.5 10.5V7.5a4.5 4.5 0 10-9 0v3m-.75 0h10.5c.621 0 1.125.504 1.125 1.125v7.5A2.625 2.625 0 0115.75 21.75H8.25A2.625 2.625 0 015.625 19.125v-7.5c0-.621.504-1.125 1.125-1.125z" />
          </svg>
          <div>
            <h1 class="text-2xl font-bold">403 — Không có quyền truy cập</h1>
            <p class="text-white/90">Bạn không có quyền xem trang này.</p>
          </div>
        </div>

        <!-- Body -->
        <div class="p-8 space-y-4 text-gray-700">
          <p>
            Nếu bạn nghĩ đây là nhầm lẫn, vui lòng liên hệ quản trị viên hoặc thử đăng nhập bằng tài khoản khác.
          </p>

          <!-- Thông tin người dùng (tuỳ chọn: hiển thị username nếu có) -->
          <c:if test="${pageContext.request.userPrincipal != null}">
            <div class="rounded-xl border border-orange-100 bg-orange-50 p-4 text-sm">
              <span class="font-medium text-orange-700">Tài khoản hiện tại:</span>
              <span class="ml-1 text-orange-800">
                ${pageContext.request.userPrincipal.name}
              </span>
            </div>
          </c:if>

          <!-- Actions -->
          <div class="pt-2 flex flex-wrap gap-3">
            <a href="${pageContext.request.contextPath}/"
               class="inline-flex items-center gap-2 px-5 py-2.5 rounded-xl font-medium text-white
                      bg-gradient-to-r from-orange-500 to-red-500 hover:opacity-90 transition">
              <!-- icon home -->
              <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="none"
                   stroke="currentColor" stroke-width="1.5">
                <path stroke-linecap="round" stroke-linejoin="round"
                      d="M3 12l9-9 9 9M4.5 10.5V21h15V10.5" />
              </svg>
              Về trang chủ
            </a>
          </div>
        </div>
      </div>

      <!-- Footer nhỏ -->
      <div class="text-center text-white/80 text-sm mt-4">
        SWP · Bảo mật truy cập
      </div>
    </div>
  </div>
</body>
</html>
