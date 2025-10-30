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
                                        Hiển thị ${ (currentPage-1) * pageSize + (products.size() > 0 ? 1 : 0) }
                                        - ${ (currentPage-1) * pageSize + products.size() }
                                        trên tổng số ${totalProducts} sản phẩm
                                    </span>
                                </c:if>
                            </div>
                        </div>

                        <div class="content-layout">
                            <!-- Sidebar Filters -->
                            <aside class="filter-sidebar">
                                <form method="get" action="${pageContext.request.contextPath}/products"
                                    class="filter-form" id="productFilterForm">
                                    <div class="filter-group">
                                        <div class="filter-title">Tìm kiếm</div>
                                        <input type="text" name="q" value="${q}" placeholder="Tên sản phẩm..." />
                                    </div>
                                    <!-- <div class="filter-group">
                                        <div class="filter-title">Danh mục</div>
                                        <div class="filter-options">
                                            <c:forEach var="c" items="${categories}">
                                                <label class="filter-checkbox">
                                                    <input type="checkbox" name="category" value="${c.id}"
                                                           <c:if test='${selectedCategories != null && selectedCategories.contains(c.id)}'>checked</c:if> />
                                                    <span>${c.name}</span>
                                                </label>
                                            </c:forEach>
                                        </div>
                                    </div> -->
                                    <div class="filter-group">
                                        <div class="filter-title">Khoảng giá</div>
                                        <div class="price-range">
                                            <input type="number" min="0" step="any" inputmode="decimal" name="minPrice"
                                                value="${minPrice}" placeholder="Từ" />
                                            <span>-</span>
                                            <input type="number" min="0" step="any" inputmode="decimal" name="maxPrice"
                                                value="${maxPrice}" placeholder="Đến" />
                                        </div>
                                    </div>
                                    <div class="filter-group">
                                        <div class="filter-title">Đánh giá</div>
                                        <div class="filter-options">
                                            <label class="filter-radio"><input type="radio" name="rating" value="" <c:if
                                                    test='${empty rating}'>checked</c:if>/> Bất kỳ</label>
                                            <label class="filter-radio"><input type="radio" name="rating" value="5"
                                                    <c:if test='${rating == 5}'>checked</c:if>/> 5 sao</label>
                                            <label class="filter-radio"><input type="radio" name="rating" value="4"
                                                    <c:if test='${rating == 4}'>checked</c:if>/> Từ 4 sao</label>
                                            <label class="filter-radio"><input type="radio" name="rating" value="3"
                                                    <c:if test='${rating == 3}'>checked</c:if>/> Từ 3 sao</label>
                                            <label class="filter-radio"><input type="radio" name="rating" value="2"
                                                    <c:if test='${rating == 2}'>checked</c:if>/> Từ 2 sao</label>
                                            <label class="filter-radio"><input type="radio" name="rating" value="1"
                                                    <c:if test='${rating == 1}'>checked</c:if>/> Từ 1 sao</label>
                                        </div>
                                        <!-- Checkbox includeUnrated đã bị ẩn để đơn giản hóa UX -->
                                    </div>
                                    <div class="filter-actions">
                                        <input type="hidden" name="sort" value="${sort}" />
                                        <button type="submit" class="btn btn-apply">Áp dụng</button>
                                        <a class="btn btn-clear" href="${pageContext.request.contextPath}/products">Xóa
                                            lọc</a>
                                    </div>
                                </form>
                            </aside>

                            <!-- Main Content -->
                            <section>
                                <!-- Toolbar -->
                                <div class="toolbar">
                                    <span class="sort-label">
                                        <i class="fas fa-sort-amount-down"></i> Sắp xếp theo:
                                    </span>
                                    <div class="sort-options">
                                        <c:url var="baseParams" value="/products">
                                            <c:param name="page" value="${currentPage}" />
                                            <c:param name="size" value="${pageSize}" />
                                            <c:if test='${not empty q}'>
                                                <c:param name="q" value="${q}" />
                                            </c:if>
                                            <c:if test='${not empty minPrice}'>
                                                <c:param name="minPrice" value="${minPrice}" />
                                            </c:if>
                                            <c:if test='${not empty maxPrice}'>
                                                <c:param name="maxPrice" value="${maxPrice}" />
                                            </c:if>
                                            <c:if test='${not empty rating}'>
                                                <c:param name="rating" value="${rating}" />
                                            </c:if>
                                            <c:forEach var="cid" items="${selectedCategories}">
                                                <c:param name="category" value="${cid}" />
                                            </c:forEach>
                                        </c:url>
                                        <a href="${pageContext.request.contextPath}${baseParams}"
                                            class="sort-btn ${empty sort ? 'active' : ''}">
                                            <i class="fas fa-star"></i> Mặc định
                                        </a>
                                        <c:url var="sortAscUrl" value="/products">
                                            <c:param name="page" value="${currentPage}" />
                                            <c:param name="size" value="${pageSize}" />
                                            <c:param name="sort" value="gia-tang-dan" />
                                            <c:if test='${not empty q}'>
                                                <c:param name="q" value="${q}" />
                                            </c:if>
                                            <c:if test='${not empty minPrice}'>
                                                <c:param name="minPrice" value="${minPrice}" />
                                            </c:if>
                                            <c:if test='${not empty maxPrice}'>
                                                <c:param name="maxPrice" value="${maxPrice}" />
                                            </c:if>
                                            <c:if test='${not empty rating}'>
                                                <c:param name="rating" value="${rating}" />
                                            </c:if>
                                            <c:forEach var="cid" items="${selectedCategories}">
                                                <c:param name="category" value="${cid}" />
                                            </c:forEach>
                                        </c:url>
                                        <a href="${pageContext.request.contextPath}${sortAscUrl}"
                                            class="sort-btn ${sort == 'gia-tang-dan' ? 'active' : ''}">
                                            <i class="fas fa-arrow-up"></i> Giá tăng dần
                                        </a>
                                        <c:url var="sortDescUrl" value="/products">
                                            <c:param name="page" value="${currentPage}" />
                                            <c:param name="size" value="${pageSize}" />
                                            <c:param name="sort" value="gia-giam-dan" />
                                            <c:if test='${not empty q}'>
                                                <c:param name="q" value="${q}" />
                                            </c:if>
                                            <c:if test='${not empty minPrice}'>
                                                <c:param name="minPrice" value="${minPrice}" />
                                            </c:if>
                                            <c:if test='${not empty maxPrice}'>
                                                <c:param name="maxPrice" value="${maxPrice}" />
                                            </c:if>
                                            <c:if test='${not empty rating}'>
                                                <c:param name="rating" value="${rating}" />
                                            </c:if>
                                            <c:forEach var="cid" items="${selectedCategories}">
                                                <c:param name="category" value="${cid}" />
                                            </c:forEach>
                                        </c:url>
                                        <a href="${pageContext.request.contextPath}${sortDescUrl}"
                                            class="sort-btn ${sort == 'gia-giam-dan' ? 'active' : ''}">
                                            <i class="fas fa-arrow-down"></i> Giá giảm dần
                                        </a>
                                        <c:url var="sortNewUrl" value="/products">
                                            <c:param name="page" value="${currentPage}" />
                                            <c:param name="size" value="${pageSize}" />
                                            <c:param name="sort" value="moi-nhat" />
                                            <c:if test='${not empty q}'>
                                                <c:param name="q" value="${q}" />
                                            </c:if>
                                            <c:if test='${not empty minPrice}'>
                                                <c:param name="minPrice" value="${minPrice}" />
                                            </c:if>
                                            <c:if test='${not empty maxPrice}'>
                                                <c:param name="maxPrice" value="${maxPrice}" />
                                            </c:if>
                                            <c:if test='${not empty rating}'>
                                                <c:param name="rating" value="${rating}" />
                                            </c:if>
                                            <c:forEach var="cid" items="${selectedCategories}">
                                                <c:param name="category" value="${cid}" />
                                            </c:forEach>
                                        </c:url>
                                        <a href="${pageContext.request.contextPath}${sortNewUrl}"
                                            class="sort-btn ${sort == 'moi-nhat' ? 'active' : ''}">
                                            <i class="fas fa-clock"></i> Mới nhất
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
                                                        <c:set var="rating" value="${productRatings[p.id]}" />
                                                        <c:set var="reviewCount" value="${productReviewCounts[p.id]}" />
                                                        <div class="product-rating">
                                                            <div class="stars">
                                                                <c:forEach begin="1" end="5" var="i">
                                                                    <c:choose>
                                                                        <c:when test="${i <= rating}">
                                                                            <i class="fas fa-star"></i>
                                                                        </c:when>
                                                                        <c:when
                                                                            test="${i - rating < 1 && i - rating > 0}">
                                                                            <i class="fas fa-star-half-alt"></i>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <i class="far fa-star"></i>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:forEach>
                                                            </div>
                                                            <span class="rating-count">
                                                                (
                                                                <fmt:formatNumber value="${rating}"
                                                                    maxFractionDigits="1" minFractionDigits="1" />)
                                                            </span>
                                                        </div>

                                                        <!-- Price -->
                                                        <div class="product-price">
                                                            <c:choose>
                                                                <c:when
                                                                    test="${p.priceMin != null && p.priceMax != null && p.priceMin ne p.priceMax}">
                                                                    <span class="current-price">
                                                                        <fmt:formatNumber value="${p.priceMin}"
                                                                            type="number" maxFractionDigits="0" />₫
                                                                    </span>
                                                                    <span style="color: #999; font-size: 14px;"> -
                                                                    </span>
                                                                    <span class="current-price">
                                                                        <fmt:formatNumber value="${p.priceMax}"
                                                                            type="number" maxFractionDigits="0" />₫
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="current-price">
                                                                        <fmt:formatNumber value="${p.price}"
                                                                            type="number" maxFractionDigits="0" />₫
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
                                                        <c:set var="soldCount" value="${productSoldCounts[p.id]}" />
                                                        <c:if test="${soldCount > 0}">
                                                            <div class="sold-count">
                                                                <i class="fas fa-shopping-cart"></i> Đã bán <strong>
                                                                    <c:choose>
                                                                        <c:when test="${soldCount >= 1000}">
                                                                            <fmt:formatNumber
                                                                                value="${soldCount / 1000}"
                                                                                maxFractionDigits="1" />k
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            ${soldCount}
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </strong>
                                                            </div>
                                                        </c:if>
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
                                                        <c:url var="prevUrl" value="/products">
                                                            <c:param name="page" value="${currentPage - 1}" />
                                                            <c:param name="size" value="${pageSize}" />
                                                            <c:if test='${not empty sort}'>
                                                                <c:param name="sort" value="${sort}" />
                                                            </c:if>
                                                            <c:if test='${not empty q}'>
                                                                <c:param name="q" value="${q}" />
                                                            </c:if>
                                                            <c:if test='${not empty minPrice}'>
                                                                <c:param name="minPrice" value="${minPrice}" />
                                                            </c:if>
                                                            <c:if test='${not empty maxPrice}'>
                                                                <c:param name="maxPrice" value="${maxPrice}" />
                                                            </c:if>
                                                            <c:if test='${includeUnrated}'>
                                                                <c:param name="includeUnrated" value="true" />
                                                            </c:if>
                                                            <c:if test='${not empty rating}'>
                                                                <c:param name="rating" value="${rating}" />
                                                            </c:if>
                                                            <c:forEach var="cid" items="${selectedCategories}">
                                                                <c:param name="category" value="${cid}" />
                                                            </c:forEach>
                                                        </c:url>
                                                        <a href="${pageContext.request.contextPath}${prevUrl}"
                                                            class="page-btn"><i class="fas fa-chevron-left"></i></a>
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
                                                        <c:url var="pageUrl" value="/products">
                                                            <c:param name="page" value="${i}" />
                                                            <c:param name="size" value="${pageSize}" />
                                                            <c:if test='${not empty sort}'>
                                                                <c:param name="sort" value="${sort}" />
                                                            </c:if>
                                                            <c:if test='${not empty q}'>
                                                                <c:param name="q" value="${q}" />
                                                            </c:if>
                                                            <c:if test='${not empty minPrice}'>
                                                                <c:param name="minPrice" value="${minPrice}" />
                                                            </c:if>
                                                            <c:if test='${not empty maxPrice}'>
                                                                <c:param name="maxPrice" value="${maxPrice}" />
                                                            </c:if>
                                                            <c:if test='${includeUnrated}'>
                                                                <c:param name="includeUnrated" value="true" />
                                                            </c:if>
                                                            <c:if test='${not empty rating}'>
                                                                <c:param name="rating" value="${rating}" />
                                                            </c:if>
                                                            <c:forEach var="cid" items="${selectedCategories}">
                                                                <c:param name="category" value="${cid}" />
                                                            </c:forEach>
                                                        </c:url>
                                                        <a href="${pageContext.request.contextPath}${pageUrl}"
                                                            class="page-btn ${i == currentPage ? 'active' : ''}">${i}</a>
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
                                                        <c:url var="nextUrl" value="/products">
                                                            <c:param name="page" value="${currentPage + 1}" />
                                                            <c:param name="size" value="${pageSize}" />
                                                            <c:if test='${not empty sort}'>
                                                                <c:param name="sort" value="${sort}" />
                                                            </c:if>
                                                            <c:if test='${not empty q}'>
                                                                <c:param name="q" value="${q}" />
                                                            </c:if>
                                                            <c:if test='${not empty minPrice}'>
                                                                <c:param name="minPrice" value="${minPrice}" />
                                                            </c:if>
                                                            <c:if test='${not empty maxPrice}'>
                                                                <c:param name="maxPrice" value="${maxPrice}" />
                                                            </c:if>
                                                            <c:if test='${includeUnrated}'>
                                                                <c:param name="includeUnrated" value="true" />
                                                            </c:if>
                                                            <c:if test='${not empty rating}'>
                                                                <c:param name="rating" value="${rating}" />
                                                            </c:if>
                                                            <c:forEach var="cid" items="${selectedCategories}">
                                                                <c:param name="category" value="${cid}" />
                                                            </c:forEach>
                                                        </c:url>
                                                        <a href="${pageContext.request.contextPath}${nextUrl}"
                                                            class="page-btn"><i class="fas fa-chevron-right"></i></a>
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
                                            <p>Hãy thử điều chỉnh bộ lọc hoặc từ khóa tìm kiếm.</p>
                                            <a href="${pageContext.request.contextPath}/products" class="btn">
                                                <i class="fas fa-redo"></i> Xóa lọc
                                            </a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </section>
                        </div>
                    </div>
                    <script>
                        (function () {
                            const form = document.getElementById('productFilterForm');
                            if (!form) return;
                            form.addEventListener('submit', function (e) {
                                const minInput = form.querySelector('input[name="minPrice"]');
                                const maxInput = form.querySelector('input[name="maxPrice"]');
                                const minVal = minInput && minInput.value !== '' ? Number(minInput.value) : null;
                                const maxVal = maxInput && maxInput.value !== '' ? Number(maxInput.value) : null;
                                if (minVal != null && maxVal != null && !isNaN(minVal) && !isNaN(maxVal) && minVal > maxVal) {
                                    // Swap to keep valid range
                                    const tmp = minInput.value;
                                    minInput.value = maxInput.value;
                                    maxInput.value = tmp;
                                }
                            });
                        })();
                    </script>

                    <!-- Include Footer -->
                    <jsp:include page="../layout/footer.jsp" />

                    <!-- Product List JavaScript -->
                    <script
                        src="${pageContext.request.contextPath}/resources/client/js/product-list.js?v=<%= System.currentTimeMillis() %>"></script>
                </body>

                </html>