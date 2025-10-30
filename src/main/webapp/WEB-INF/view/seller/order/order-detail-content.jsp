<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!-- CSS -->
            <link rel="stylesheet" href="<c:url value='/resources/seller/css/seller-order-detail.css'/>">

            <!-- Page Header -->
            <div class="order-detail-header">
                <h1 class="order-detail-title">
                    <i class="fas fa-file-invoice"></i>
                    Chi tiết đơn hàng
                    <span class="order-number-badge">#${order.id}</span>
                </h1>
                <a href="<c:url value='/seller/orders'/>" class="btn-back-to-list">
                    <i class="fas fa-arrow-left"></i> Quay lại danh sách
                </a>
            </div>

            <!-- Order Information Grid -->
            <div class="order-info-grid">
                <!-- Customer Info -->
                <div class="info-card">
                    <div class="info-card-header">
                        <div class="info-card-icon customer">
                            <i class="fas fa-user"></i>
                        </div>
                        <h3 class="info-card-title">Thông tin khách hàng</h3>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Tên khách hàng:</span>
                        <span class="info-value">
                            <c:out value='${order.user != null ? order.user.fullName : "Khách hàng"}' />
                        </span>q
                    </div>
                    <div class="info-item">
                        <span class="info-label">Số điện thoại:</span>
                        <span class="info-value">
                            <c:out value='${order.receiverPhone}' />
                        </span>
                    </div>
                </div>

                <!-- Shipping Info -->
                <div class="info-card">
                    <div class="info-card-header">
                        <div class="info-card-icon shipping">
                            <i class="fas fa-shipping-fast"></i>
                        </div>
                        <h3 class="info-card-title">Thông tin vận chuyển</h3>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Người nhận:</span>
                        <span class="info-value">
                            <c:out value='${order.receiverName}' />
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Địa chỉ:</span>
                        <span class="info-value">
                            <c:out value='${order.receiverAddress}' />,
                            <c:out value='${order.receiverWard}' />,
                            <c:out value='${order.receiverDistrict}' />,
                            <c:out value='${order.receiverProvince}' />
                        </span>
                    </div>
                </div>

                <!-- Payment & Status Info -->
                <div class="info-card">
                    <div class="info-card-header">
                        <div class="info-card-icon payment">
                            <i class="fas fa-credit-card"></i>
                        </div>
                        <h3 class="info-card-title">Thanh toán & Trạng thái</h3>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Thanh toán:</span>
                        <span class="info-value">
                            <span class="payment-method-badge">
                                <i class="fas fa-wallet"></i>
                                ${order.paymentMethod}
                            </span>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Trạng thái:</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${order.orderStatus == 'PENDING_CONFIRM'}">
                                    <span class="status-badge-inline pending">
                                        <i class="fas fa-clock"></i>
                                        Chờ xác nhận
                                    </span>
                                </c:when>
                                <c:when test="${order.orderStatus == 'PENDING_PAYMENT'}">
                                    <span class="status-badge-inline processing">
                                        <i class="fas fa-credit-card"></i>
                                        Chờ thanh toán
                                    </span>
                                </c:when>
                                <c:when test="${order.orderStatus == 'PAID'}">
                                    <span class="status-badge-inline completed">
                                        <i class="fas fa-check-circle"></i>
                                        Đã thanh toán
                                    </span>
                                </c:when>
                                <c:when test="${order.orderStatus == 'CANCELED'}">
                                    <span class="status-badge-inline cancelled">
                                        <i class="fas fa-times-circle"></i>
                                        Đã hủy
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge-inline pending">
                                        ${order.orderStatus}
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>

                <!-- Date Info -->
                <div class="info-card">
                    <div class="info-card-header">
                        <div class="info-card-icon date">
                            <i class="fas fa-calendar-alt"></i>
                        </div>
                        <h3 class="info-card-title">Thông tin thời gian</h3>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Ngày tạo:</span>
                        <span class="info-value">
                            <i class="far fa-calendar"></i>
                            ${order.createdAt}
                        </span>
                    </div>
                </div>
            </div>

            <!-- Products Table -->
            <div class="order-products-card">
                <div class="products-card-header">
                    <h2 class="products-card-title">
                        <i class="fas fa-box-open"></i>
                        Danh sách sản phẩm
                    </h2>
                </div>

                <table class="products-table">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Sản phẩm</th>
                            <th class="text-end">Số lượng</th>
                            <th class="text-end">Đơn giá</th>
                            <th class="text-end">Thành tiền</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="it" items="${shopItems}" varStatus="st">
                            <tr>
                                <td>
                                    <span class="product-index">${st.index + 1}</span>
                                </td>
                                <td>
                                    <div class="product-name">
                                        <c:out value='${it.product != null ? it.product.name : "Sản phẩm"}' />
                                    </div>
                                </td>
                                <td class="text-end">
                                    <span class="product-quantity">${it.quantity}</span>
                                </td>
                                <td class="text-end">
                                    <span class="product-price">
                                        <fmt:formatNumber value='${it.unitPrice}' type='currency' currencySymbol='₫'
                                            groupingUsed='true' />
                                    </span>
                                </td>
                                <td class="text-end">
                                    <span class="product-total-price">
                                        <fmt:formatNumber value='${it.totalPrice}' type='currency' currencySymbol='₫'
                                            groupingUsed='true' />
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${it.status == 'CONFIRMED'}">
                                            <span class="item-status-badge active">
                                                <i class="fas fa-check"></i>
                                                Đã xác nhận
                                            </span>
                                        </c:when>
                                        <c:when test="${it.status == 'PENDING'}">
                                            <span class="item-status-badge inactive">
                                                <i class="fas fa-clock"></i>
                                                Chờ xử lý
                                            </span>
                                        </c:when>
                                        <c:when test="${it.status == 'CANCELED'}">
                                            <span class="item-status-badge inactive">
                                                <i class="fas fa-times"></i>
                                                Đã hủy
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="item-status-badge inactive">
                                                ${it.status}
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Order Summary -->
            <div class="order-summary-wrapper">
                <div class="order-summary-card">
                    <h3 class="summary-title">
                        <i class="fas fa-calculator"></i>
                        Tổng kết đơn hàng
                    </h3>
                    <div class="summary-row">
                        <span class="summary-label">Tổng tiền hàng:</span>
                        <span class="summary-value">
                            <fmt:formatNumber value='${shopTotal}' type='currency' currencySymbol='₫'
                                groupingUsed='true' />
                        </span>
                    </div>
                    <div class="summary-row summary-total">
                        <span class="summary-label">Tổng cộng:</span>
                        <span class="summary-value">
                            <fmt:formatNumber value='${shopTotal}' type='currency' currencySymbol='₫'
                                groupingUsed='true' />
                        </span>
                    </div>
                </div>
            </div>