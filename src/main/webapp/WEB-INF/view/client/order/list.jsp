<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Đơn hàng của tôi - SWP Shop</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/client/css/order.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <style>
                    .orders-container {
                        max-width: 1000px;
                        margin: 24px auto;
                    }

                    .orders-card {
                        background: #fff;
                        border-radius: 12px;
                        padding: 20px;
                        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
                    }

                    .order-row {
                        display: grid;
                        grid-template-columns: 1fr 1fr 1fr 1fr auto;
                        gap: 12px;
                        align-items: center;
                        padding: 12px 0;
                        border-bottom: 1px solid #efefef;
                    }

                    .order-row:last-child {
                        border-bottom: none;
                    }

                    .status-badge {
                        padding: 6px 10px;
                        border-radius: 999px;
                        font-size: 12px;
                        font-weight: 600;
                    }

                    .status-PENDING_CONFIRM {
                        background: #fff3cd;
                        color: #856404;
                    }

                    .status-PENDING_PAYMENT {
                        background: #cfe2ff;
                        color: #084298;
                    }

                    .status-PAID {
                        background: #d1e7dd;
                        color: #0f5132;
                    }

                    .status-CANCELED {
                        background: #f8d7da;
                        color: #842029;
                    }
                </style>
                <fmt:setLocale value="vi_VN" />
                <fmt:setTimeZone value="Asia/Ho_Chi_Minh" />
                <jsp:include page="../layout/header.jsp" />
            </head>

            <body>
                <div class="orders-container">
                    <div class="orders-card">
                        <div class="d-flex justify-content-between align-items-center mb-3"
                            style="display:flex; justify-content:space-between; align-items:center; gap:12px;">
                            <h4 class="mb-0"><i class="fas fa-box me-2"></i>Đơn hàng của tôi</h4>
                            <div style="display:flex; gap:10px;">
                                <a href="${pageContext.request.contextPath}/orders/reviews"
                                    class="btn btn-sm btn-primary"
                                    style="display:inline-flex; align-items:center; gap:6px;">
                                    <i class="fas fa-star"></i> Đánh giá sản phẩm
                                </a>
                                <a href="<c:url value='/'/>" class="btn btn-sm btn-outline-secondary"><i
                                        class="fas fa-home"></i> Về trang chủ</a>
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${empty orders}">
                                <div class="text-center py-5 text-muted">
                                    <i class="fas fa-box-open" style="font-size:48px; color:#ddd"></i>
                                    <p class="mt-3">Bạn chưa có đơn hàng nào.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="order-row fw-semibold text-muted">
                                    <div>STT</div>
                                    <div>Ngày tạo</div>
                                    <div>Trạng thái</div>
                                    <div class="text-end">Tổng tiền</div>
                                    <div></div>
                                </div>
                                <c:forEach var="o" items="${orders}" varStatus="st">
                                    <div class="order-row">
                                        <div>
                                            <c:set var="stt" value="${st.index + 1 + (currentPage * pageSize)}" />
                                            ${stt}
                                        </div>
                                        <div>${o.createdAt}</div>
                                        <div>
                                            <span class="status-badge status-${o.orderStatus}">
                                                <c:choose>
                                                    <c:when test="${o.orderStatus == 'PENDING_CONFIRM'}">
                                                        <i class="fas fa-clock"></i> Chờ xác nhận
                                                    </c:when>
                                                    <c:when test="${o.orderStatus == 'PENDING_PAYMENT'}">
                                                        <i class="fas fa-credit-card"></i> Chờ thanh toán
                                                    </c:when>
                                                    <c:when test="${o.orderStatus == 'PAID'}">
                                                        <i class="fas fa-check-circle"></i> Đã thanh toán
                                                    </c:when>
                                                    <c:when test="${o.orderStatus == 'CANCELED'}">
                                                        <i class="fas fa-times-circle"></i> Đã hủy
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${o.orderStatus}
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="text-end">
                                            <fmt:formatNumber value="${o.totalAmount}" type="currency" />
                                        </div>
                                        <div class="text-end">
                                            <a class="btn btn-sm btn-primary" href="<c:url value='/orders/${o.id}'/>">
                                                <i class="fas fa-eye"></i> Xem
                                            </a>
                                        </div>
                                    </div>
                                </c:forEach>

                                <!-- Pagination -->
                                <nav aria-label="Orders pagination" class="mt-3">
                                    <ul class="pagination justify-content-center">
                                        <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                                            <a class="page-link"
                                                href="?page=${currentPage - 1}&size=${pageSize}">Trước</a>
                                        </li>
                                        <c:forEach var="i" begin="0" end="${totalPages - 1}">
                                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                <a class="page-link" href="?page=${i}&size=${pageSize}">${i + 1}</a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item ${currentPage + 1 >= totalPages ? 'disabled' : ''}">
                                            <a class="page-link"
                                                href="?page=${currentPage + 1}&size=${pageSize}">Sau</a>
                                        </li>
                                    </ul>
                                </nav>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <jsp:include page="../layout/footer.jsp" />
            </body>

            </html>