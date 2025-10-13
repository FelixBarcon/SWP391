<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Danh sách sản phẩm - SWP Shop</title>

                    <!-- Font Awesome -->
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

                    <!-- Product List CSS -->
                    <link rel="stylesheet"
                        href="${pageContext.request.contextPath}/resources/client/css/product-list.css">
                </head>

                <body>
                    <!-- Include Header -->
                    <jsp:include page="../layout/header.jsp" />

                    <!-- Product List Container -->
                    <div class="product-list-container">
                        <!-- Page Header -->
                        <div class="page-header">
                            <div>
                                <h1 class="page-title">
                                    <i class="fas fa-shopping-bag"></i>
                                    Tất cả sản phẩm
                                </h1>
                                <c:if test="${not empty products}">
                                    <span class="product-count">
                                        Hiển thị ${(currentPage - 1) * 20 + 1} - ${currentPage * 20 >
                                        fn:length(products) ? fn:length(products) : currentPage * 20}
                                        trên tổng số ${totalProducts} sản phẩm
                                    </span>
                                </c:if>
                            </div>
                        </div>

                        <!-- Toolbar -->
                        <div class="toolbar">
                            <span class="sort-label">
                                <i class="fas fa-sort-amount-down"></i> Sắp xếp theo:
                            </span>
                            <div class="sort-options">
                                <a href="${pageContext.request.contextPath}/products?page=${currentPage}"
                                    class="sort-btn ${empty sort ? 'active' : ''}">
                                    <i class="fas fa-star"></i> Mặc định
                                </a>
                                <a href="${pageContext.request.contextPath}/products?page=${currentPage}&sort=gia-tang-dan"
                                    class="sort-btn ${sort == 'gia-tang-dan' ? 'active' : ''}">
                                    <i class="fas fa-arrow-up"></i> Giá tăng dần
                                </a>
                                <a href="${pageContext.request.contextPath}/products?page=${currentPage}&sort=gia-giam-dan"
                                    class="sort-btn ${sort == 'gia-giam-dan' ? 'active' : ''}">
                                    <i class="fas fa-arrow-down"></i> Giá giảm dần
                                </a>
                            </div>
                        </div>

                        <!-- Products Grid -->
                        <c:choose>
                            <c:when test="${not empty products}">
                                <div class="products-grid">
                                    <c:forEach var="p" items="${products}" varStatus="status">
                                        <div class="product-card">
                                            <!-- Badge -->
                                            <c:if test="${status.index < 3}">
                                                <span class="product-badge hot">HOT</span>
                                            </c:if>
                                            <c:if test="${status.index >= 3 && status.index < 6}">
                                                <span class="product-badge new">MỚI</span>
                                            </c:if>

                                            <!-- Product Image -->
                                            <a href="${pageContext.request.contextPath}/product/${p.id}"
                                                class="product-image">
                                                <c:choose>
                                                    <c:when test="${not empty p.imageUrl}">
                                                        <img src="${pageContext.request.contextPath}/images/${p.imageUrl}"
                                                            alt="${p.name}" loading="lazy">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="https://via.placeholder.com/300x300?text=No+Image"
                                                            alt="${p.name}" loading="lazy">
                                                    </c:otherwise>
                                                </c:choose>

                                                <!-- Quick Actions (Overlay) -->
                                                <div class="quick-actions">
                                                    <a href="${pageContext.request.contextPath}/product/${p.id}"
                                                        class="quick-btn view">
                                                        <i class="fas fa-eye"></i> Xem
                                                    </a>
                                                    <form
                                                        action="${pageContext.request.contextPath}/add-product-to-cart/${p.id}"
                                                        method="post" class="quick-add-cart-form"
                                                        style="flex: 1; margin: 0;">
                                                        <button type="submit" class="quick-btn cart">
                                                            <i class="fas fa-cart-plus"></i> Giỏ
                                                        </button>
                                                    </form>
                                                </div>
                                            </a>

                                            <!-- Product Info -->
                                            <div class="product-info">
                                                <a href="${pageContext.request.contextPath}/product/${p.id}"
                                                    class="product-name" title="${p.name}">
                                                    ${p.name}
                                                </a>

                                                <!-- Rating -->
                                                <div class="product-rating">
                                                    <div class="stars">
                                                        <i class="fas fa-star"></i>
                                                        <i class="fas fa-star"></i>
                                                        <i class="fas fa-star"></i>
                                                        <i class="fas fa-star"></i>
                                                        <i class="fas fa-star-half-alt"></i>
                                                    </div>
                                                    <span class="rating-count">(4.5)</span>
                                                </div>

                                                <!-- Price -->
                                                <div class="product-price">
                                                    <c:choose>
                                                        <c:when
                                                            test="${p.priceMin != null && p.priceMax != null && p.priceMin ne p.priceMax}">
                                                            <span class="current-price">
                                                                <fmt:formatNumber value="${p.priceMin}" type="number"
                                                                    maxFractionDigits="0" />₫
                                                            </span>
                                                            <span style="color: #999; font-size: 14px;"> - </span>
                                                            <span class="current-price">
                                                                <fmt:formatNumber value="${p.priceMax}" type="number"
                                                                    maxFractionDigits="0" />₫
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="current-price">
                                                                <fmt:formatNumber value="${p.price}" type="number"
                                                                    maxFractionDigits="0" />₫
                                                            </span>
                                                            <c:if test="${p.price > 0}">
                                                                <span class="original-price">
                                                                    <fmt:formatNumber value="${p.price * 1.2}"
                                                                        type="number" maxFractionDigits="0" />₫
                                                                </span>
                                                                <span class="discount-percent">-20%</span>
                                                            </c:if>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <!-- Sold Count -->
                                                <div class="sold-count">
                                                    Đã bán <strong>${(status.index + 1) * 127}</strong>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <!-- Pagination -->
                                <c:if test="${totalPages > 1}">
                                    <div class="pagination">
                                        <!-- Previous Button -->
                                        <c:choose>
                                            <c:when test="${currentPage > 1}">
                                                <a href="${pageContext.request.contextPath}/products?page=${currentPage - 1}<c:if test='${not empty sort}'>&sort=${sort}</c:if>"
                                                    class="page-btn">
                                                    <i class="fas fa-chevron-left"></i>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="page-btn" disabled>
                                                    <i class="fas fa-chevron-left"></i>
                                                </button>
                                            </c:otherwise>
                                        </c:choose>

                                        <!-- Page Numbers -->
                                        <c:forEach var="i" begin="1" end="${totalPages}">
                                            <c:if
                                                test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                                <a href="${pageContext.request.contextPath}/products?page=${i}<c:if test='${not empty sort}'>&sort=${sort}</c:if>"
                                                    class="page-btn ${i == currentPage ? 'active' : ''}">
                                                    ${i}
                                                </a>
                                            </c:if>
                                            <c:if test="${i == currentPage - 3 && i > 1}">
                                                <span class="page-btn"
                                                    style="border: none; pointer-events: none;">...</span>
                                            </c:if>
                                            <c:if test="${i == currentPage + 3 && i < totalPages}">
                                                <span class="page-btn"
                                                    style="border: none; pointer-events: none;">...</span>
                                            </c:if>
                                        </c:forEach>

                                        <!-- Next Button -->
                                        <c:choose>
                                            <c:when test="${currentPage < totalPages}">
                                                <a href="${pageContext.request.contextPath}/products?page=${currentPage + 1}<c:if test='${not empty sort}'>&sort=${sort}</c:if>"
                                                    class="page-btn">
                                                    <i class="fas fa-chevron-right"></i>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="page-btn" disabled>
                                                    <i class="fas fa-chevron-right"></i>
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <!-- Empty State -->
                                <div class="empty-state">
                                    <i class="fas fa-box-open"></i>
                                    <h3>Không tìm thấy sản phẩm</h3>
                                    <p>Hiện tại chưa có sản phẩm nào trong danh mục này.</p>
                                    <a href="${pageContext.request.contextPath}/" class="btn">
                                        <i class="fas fa-home"></i> Về trang chủ
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Include Footer -->
                    <jsp:include page="../layout/footer.jsp" />

                    <!-- Product List JavaScript -->
                    <script
                        src="${pageContext.request.contextPath}/resources/client/js/product-list.js?v=<%= System.currentTimeMillis() %>"></script>
                </body>

                </html>