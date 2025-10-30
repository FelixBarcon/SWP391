<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <fmt:setLocale value="vi_VN" />
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Đơn hàng #${order.id} - SWP Shop</title>

                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/client/css/order-detail.css">
            </head>

            <body>
                <jsp:include page="../layout/header.jsp" />

                <div class="order-detail-container">
                    <div class="order-detail-header">
                        <div class="left">
                            <h1 class="title"><i class="fas fa-receipt"></i> Đơn hàng #${order.id}</h1>
                            <div class="meta">
                                <span><i class="fas fa-calendar"></i> ${order.createdAt}</span>
                                <span class="dot">•</span>
                                <span><i class="fas fa-credit-card"></i> ${order.paymentMethod}</span>
                            </div>
                        </div>
                        <div class="right">
                            <a class="btn" href="${pageContext.request.contextPath}/orders">
                                <i class="fas fa-arrow-left"></i> Danh sách đơn hàng
                            </a>
                            <span class="status-badge status-${order.orderStatus} ">
                                <c:choose>
                                    <c:when test="${order.orderStatus == 'PENDING_CONFIRM'}">
                                        <i class="fas fa-clock"></i> Chờ xác nhận
                                    </c:when>
                                    <c:when test="${order.orderStatus == 'PENDING_PAYMENT'}">
                                        <i class="fas fa-credit-card"></i> Chờ thanh toán
                                    </c:when>
                                    <c:when test="${order.orderStatus == 'PAID'}">
                                        <i class="fas fa-check-circle"></i> Đã thanh toán
                                    </c:when>
                                    <c:when test="${order.orderStatus == 'CANCELED'}">
                                        <i class="fas fa-times-circle"></i> Đã hủy
                                    </c:when>
                                    <c:otherwise>
                                        ${order.orderStatus}
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>

                    <div class="order-detail-layout">
                        <!-- Left: main info -->
                        <div class="order-main">
                            <!-- Shipping info -->
                            <div class="card">
                                <div class="card-header">
                                    <i class="fas fa-map-marker-alt"></i>
                                    Địa chỉ nhận hàng
                                </div>
                                <div class="card-body">
                                    <div class="addr-name"><i class="fas fa-user"></i> ${order.receiverName}</div>
                                    <div class="addr-phone"><i class="fas fa-phone"></i> ${order.receiverPhone}</div>
                                    <div class="addr-detail"><i class="fas fa-home"></i>
                                        ${order.receiverAddress}, ${order.receiverWard}, ${order.receiverDistrict},
                                        ${order.receiverProvince}
                                    </div>
                                </div>
                            </div>

                            <!-- Items list -->
                            <div class="card mt-3">
                                <div class="card-header">
                                    <i class="fas fa-box"></i>
                                    Sản phẩm trong đơn
                                </div>
                                <div class="card-body">
                                    <c:if test="${empty order.orderItems}">
                                        <div class="empty">Không có sản phẩm trong đơn hàng.</div>
                                    </c:if>
                                    <c:forEach var="it" items="${order.orderItems}">
                                        <div class="item-row">
                                            <div class="item-left">
                                                <div class="thumb">
                                                    <c:choose>
                                                        <c:when
                                                            test="${not empty it.product and not empty it.product.imageUrl}">
                                                            <img src="${pageContext.request.contextPath}/images/${it.product.imageUrl}"
                                                                alt="${it.product.name}">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="https://via.placeholder.com/60x60?text=No+Image"
                                                                alt="${it.product != null ? it.product.name : 'Sản phẩm'}">
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="info">
                                                    <div class="name">${it.product != null ? it.product.name : 'Sản
                                                        phẩm'}</div>
                                                    <div class="shop"><i class="fas fa-store"></i> ${it.shop != null ?
                                                        it.shop.displayName : 'Shop'}</div>
                                                </div>
                                            </div>
                                            <div class="item-mid">x${it.quantity}</div>
                                            <div class="item-price">
                                                <div class="unit">
                                                    <fmt:formatNumber value="${it.unitPrice}" type="currency" />
                                                </div>
                                                <div class="total">
                                                    <fmt:formatNumber
                                                        value="${it.totalPrice != 0 ? it.totalPrice : it.unitPrice * it.quantity}"
                                                        type="currency" />
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <!-- Right: summary -->
                        <div class="order-summary">
                            <div class="summary-card">
                                <div class="summary-header"><i class="fas fa-money-check-alt"></i> Chi tiết thanh toán
                                </div>
                                <div class="summary-body">
                                    <div class="row">
                                        <span>Tổng tiền hàng</span>
                                        <strong>
                                            <fmt:formatNumber value="${order.itemsTotal}" type="currency" />
                                        </strong>
                                    </div>
                                    <div class="row">
                                        <span>Phí vận chuyển</span>
                                        <strong>
                                            <fmt:formatNumber value="${order.shippingFee}" type="currency" />
                                        </strong>
                                    </div>
                                    <div class="row total">
                                        <span>Tổng thanh toán</span>
                                        <strong>
                                            <fmt:formatNumber value="${order.totalAmount}" type="currency" />
                                        </strong>
                                    </div>

                                    <div class="actions">
                                        <a class="btn primary" href="${pageContext.request.contextPath}/products">
                                            <i class="fas fa-shopping-bag "></i> Mua thêm
                                        </a>
                                        <a class="btn" href="#" onclick="window.print();return false;">
                                            <i class="fas fa-print"></i> In hóa đơn
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <jsp:include page="../layout/footer.jsp" />

            </body>

            </html>