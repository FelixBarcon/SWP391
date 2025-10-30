<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- CSS -->
        <link rel="stylesheet" href="<c:url value='/resources/seller/css/seller-orders.css'/>">


        <!-- Orders Table -->
        <div class="orders-table-card">
            <div class="orders-table-header">
                <h2 class="orders-table-title">
                    <i class="fas fa-receipt"></i>
                    Danh sách đơn hàng
                </h2>
                <div class="orders-search-box">
                    <input type="text" class="orders-search-input" placeholder="Tìm kiếm đơn hàng..." id="searchInput">
                    <i class="fas fa-search orders-search-icon"></i>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty orders}">
                    <div class="orders-empty-state">
                        <div class="empty-state-icon">
                            <i class="fas fa-shopping-bag"></i>
                        </div>
                        <h3 class="empty-state-title">Chưa có đơn hàng nào</h3>
                        <p class="empty-state-text">Các đơn hàng từ khách hàng sẽ xuất hiện ở đây</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="orders-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Khách hàng</th>
                                <th>Ngày tạo</th>
                                <th>Trạng thái</th>
                                <th style="text-align: right;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="o" items="${orders}" varStatus="st">
                                <tr>
                                    <td>
                                        <span class="order-index">
                                            <c:set var="stt" value="${st.index + 1 + (currentPage * pageSize)}" />
                                            ${stt}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="customer-info">
                                            <div class="customer-avatar">
                                                <c:choose>
                                                    <c:when test="${not empty o.user and not empty o.user.fullName}">
                                                        ${o.user.fullName.substring(0, 1).toUpperCase()}
                                                    </c:when>
                                                    <c:otherwise>?</c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div>
                                                <div class="customer-name">
                                                    <c:choose>
                                                        <c:when test="${not empty o.user}">${o.user.fullName}</c:when>
                                                        <c:otherwise>Khách hàng</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="order-date">
                                            <i class="far fa-calendar-alt"></i>
                                            ${o.createdAt}
                                        </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${o.orderStatus == 'PENDING_CONFIRM'}">
                                                <span class="order-status-badge status-pending">
                                                    <i class="fas fa-clock"></i>
                                                    Chờ xác nhận
                                                </span>
                                            </c:when>
                                            <c:when test="${o.orderStatus == 'PENDING_PAYMENT'}">
                                                <span class="order-status-badge status-processing">
                                                    <i class="fas fa-credit-card"></i>
                                                    Chờ thanh toán
                                                </span>
                                            </c:when>
                                            <c:when test="${o.orderStatus == 'PAID'}">
                                                <span class="order-status-badge status-completed">
                                                    <i class="fas fa-check-circle"></i>
                                                    Đã thanh toán
                                                </span>
                                            </c:when>
                                            <c:when test="${o.orderStatus == 'CANCELED'}">
                                                <span class="order-status-badge status-cancelled">
                                                    <i class="fas fa-times-circle"></i>
                                                    Đã hủy
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="order-status-badge status-pending">
                                                    ${o.orderStatus}
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="order-actions">
                                            <a href="<c:url value='/seller/orders/${o.id}'/>" class="btn-view-order">
                                                <i class="fas fa-eye"></i>
                                                Chi tiết
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="orders-pagination-wrapper">
                            <ul class="orders-pagination">
                                <li class="pagination-item ${currentPage == 0 ? 'disabled' : ''}">
                                    <a class="pagination-link"
                                        href="?page=${currentPage - 1}&size=${pageSize}${not empty param.status ? '&status='.concat(param.status) : ''}">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </li>
                                <c:forEach var="i" begin="0" end="${totalPages - 1}">
                                    <li class="pagination-item ${i == currentPage ? 'active' : ''}">
                                        <a class="pagination-link"
                                            href="?page=${i}&size=${pageSize}${not empty param.status ? '&status='.concat(param.status) : ''}">${i
                                            + 1}</a>
                                    </li>
                                </c:forEach>
                                <li class="pagination-item ${currentPage + 1 >= totalPages ? 'disabled' : ''}">
                                    <a class="pagination-link"
                                        href="?page=${currentPage + 1}&size=${pageSize}${not empty param.status ? '&status='.concat(param.status) : ''}">
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Search Script -->
        <script>
            document.getElementById('searchInput')?.addEventListener('input', function (e) {
                const searchTerm = e.target.value.toLowerCase();
                const rows = document.querySelectorAll('.orders-table tbody tr');

                rows.forEach(row => {
                    const customerName = row.querySelector('.customer-name')?.textContent.toLowerCase() || '';
                    const orderDate = row.querySelector('.order-date')?.textContent.toLowerCase() || '';

                    if (customerName.includes(searchTerm) || orderDate.includes(searchTerm)) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            });
        </script>