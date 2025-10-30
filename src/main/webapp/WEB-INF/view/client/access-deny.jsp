<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <!DOCTYPE html>
  <html lang="vi">

  <head>
    <meta charset="UTF-8">
    <title>403 - Access Denied</title>
    <!-- Tailwind (CDN) -->
    <script src="https://cdn.tailwindcss.com"></script>
  </head>

  <body class="min-h-screen bg-gray-50">
    <div class="min-h-screen flex items-center justify-center px-4">
      <div class="w-full max-w-2xl">
        <!-- Card -->
        <div
          class="bg-white shadow-2xl rounded-3xl overflow-hidden transform hover:scale-[1.01] transition-transform duration-300 border border-gray-100">
          <!-- Header màu xanh -->
          <div class="p-8 text-white"
            style="background: linear-gradient(135deg, #7bb3e8 0%, #5b9bd5 50%, #4a7ba7 100%);">
            <div class="flex items-start gap-6">
              <!-- Icon khoá lớn hơn -->
              <div class="flex-shrink-0 bg-white/20 p-4 rounded-2xl backdrop-blur-sm">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-14 h-14" fill="none" viewBox="0 0 24 24"
                  stroke="currentColor" stroke-width="1.5">
                  <path stroke-linecap="round" stroke-linejoin="round"
                    d="M16.5 10.5V7.5a4.5 4.5 0 10-9 0v3m-.75 0h10.5c.621 0 1.125.504 1.125 1.125v7.5A2.625 2.625 0 0115.75 21.75H8.25A2.625 2.625 0 015.625 19.125v-7.5c0-.621.504-1.125 1.125-1.125z" />
                </svg>
              </div>
              <div class="flex-1">
                <div
                  class="inline-block px-3 py-1 bg-white/20 rounded-full text-xs font-semibold mb-3 backdrop-blur-sm">
                  Lỗi 403
                </div>
                <h1 class="text-3xl font-bold mb-2">Không có quyền truy cập</h1>
                <p class="text-blue-100 text-lg">Bạn không có quyền xem trang này.</p>
              </div>
            </div>
          </div>

          <!-- Body -->
          <div class="p-8 space-y-6">
            <!-- Thông báo chi tiết -->
            <div class="border-l-4 p-4 rounded-r-lg" style="background-color: #e8f4fc; border-color: #5b9bd5;">
              <div class="flex items-start gap-3">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 flex-shrink-0 mt-0.5" style="color: #5b9bd5;"
                  fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <div class="text-sm text-gray-700">
                  <p class="font-medium mb-1" style="color: #4a7ba7;">Có thể do:</p>
                  <ul class="list-disc list-inside space-y-1 text-gray-600">
                    <li>Tài khoản của bạn không có quyền truy cập trang này</li>
                    <li>Bạn cần đăng nhập với tài khoản khác có quyền phù hợp</li>
                    <li>Liên hệ quản trị viên để được cấp quyền truy cập</li>
                  </ul>
                </div>
              </div>
            </div>

            <!-- Thông tin người dùng -->
            <c:if test="${pageContext.request.userPrincipal != null}">
              <div class="rounded-xl border p-5 mt-5"
                style="background: linear-gradient(to right, #f0f8ff, #e8f4fc); border-color: #c9e3f5;">
                <div class="flex items-center gap-3">
                  <div class="p-2 rounded-lg" style="background-color: #5b9bd5;">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24"
                      stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                    </svg>
                  </div>
                  <div>
                    <p class="text-xs font-medium uppercase tracking-wide" style="color: #5b9bd5;">Tài khoản hiện tại
                    </p>
                    <p class="text-sm font-semibold" style="color: #4a7ba7;">${pageContext.request.userPrincipal.name}
                    </p>
                  </div>
                </div>
              </div>
            </c:if>

            <!-- Actions -->
            <div class="pt-4 flex flex-wrap gap-3">
              <a href="${pageContext.request.contextPath}/" class="inline-flex items-center gap-2 px-6 py-3 rounded-xl font-semibold text-white
                        shadow-lg hover:shadow-xl
                        transform hover:-translate-y-0.5 transition-all duration-200"
                style="background: linear-gradient(135deg, #7bb3e8 0%, #5b9bd5 50%, #4a7ba7 100%);">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="none"
                  stroke="currentColor" stroke-width="2">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M3 12l9-9 9 9M4.5 10.5V21h15V10.5" />
                </svg>
                Về trang chủ
              </a>
              <a href="javascript:history.back()" class="inline-flex items-center gap-2 px-6 py-3 rounded-xl font-semibold border-2
                        transform hover:-translate-y-0.5 transition-all duration-200"
                style="color: #5b9bd5; background-color: #f0f8ff; border-color: #c9e3f5;"
                onmouseover="this.style.backgroundColor='#e8f4fc'; this.style.borderColor='#5b9bd5';"
                onmouseout="this.style.backgroundColor='#f0f8ff'; this.style.borderColor='#c9e3f5';">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24"
                  stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                </svg>
                Quay lại
              </a>
            </div>
          </div>
        </div>

        <!-- Footer -->
        <div class="text-center text-sm mt-6 flex items-center justify-center gap-2" style="color: #5b9bd5;">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
          </svg>
          <span>SWP Shop · Hệ thống bảo mật</span>
        </div>
      </div>
    </div>
  </body>

  </html>