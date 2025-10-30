<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>${product.name} - Chi tiết sản phẩm</title>

                <!-- Font Awesome -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

                <!-- Product Detail CSS -->
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/resources/client/css/product-detail.css">
            </head>

            <body class="product-page">
                <!-- Include Header -->
                <jsp:include page="../layout/header.jsp" />

                <!-- Product Container -->
                <div class="product-container">
                    <!-- Breadcrumb -->
                    <nav class="breadcrumb-nav">
                        <a href="<c:url value='/'/>">
                            <i class="fas fa-home"></i> Trang chủ
                        </a>
                        <span>/</span>
                        <a href="<c:url value='/products'/>">Sản phẩm</a>
                        <span>/</span>
                        <span class="current">${product.name}</span>
                    </nav>

                    <!-- Main Product Layout -->
                    <div class="product-layout">
                        <!-- Left: Gallery Section -->
                        <div class="gallery-section">
                            <!-- Image Carousel -->
                            <div class="image-carousel" id="imageCarousel">
                                <div class="carousel-viewport">
                                    <div class="carousel-track">
                                        <c:choose>
                                            <c:when test="${not empty product.imageUrl}">
                                                <!-- Ảnh đại diện luôn hiển thị đầu tiên -->
                                                <div class="carousel-slide" data-is-main="true">
                                                    <img src="<c:url value='/images/${product.imageUrl}'/>"
                                                        alt="${product.name}">
                                                </div>

                                                <!-- Các ảnh phụ (bỏ qua ảnh trùng với ảnh đại diện) -->
                                                <c:forEach var="img" items="${product.imageUrls}">
                                                    <c:if test="${img != product.imageUrl}">
                                                        <div class="carousel-slide">
                                                            <img src="<c:url value='/images/${img}'/>"
                                                                alt="${product.name}">
                                                        </div>
                                                    </c:if>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- Không có ảnh đại diện -->
                                                <c:choose>
                                                    <c:when test="${not empty product.imageUrls}">
                                                        <c:forEach var="img" items="${product.imageUrls}">
                                                            <div class="carousel-slide">
                                                                <img src="<c:url value='/images/${img}'/>"
                                                                    alt="${product.name}">
                                                            </div>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="carousel-slide">
                                                            <img src="https://via.placeholder.com/600x600?text=No+Image"
                                                                alt="No image">
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:otherwise>
                                        </c:choose>

                                        <!-- Variant Images -->
                                        <c:forEach var="v" items="${variants}">
                                            <c:if test="${not empty v.imageUrl}">
                                                <div class="carousel-slide">
                                                    <img src="<c:url value='/images/${v.imageUrl}'/>" alt="${v.name}">
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- Navigation Buttons -->
                                <button class="carousel-nav prev" type="button" aria-label="Previous">
                                    <i class="fas fa-chevron-left"></i>
                                </button>
                                <button class="carousel-nav next" type="button" aria-label="Next">
                                    <i class="fas fa-chevron-right"></i>
                                </button>

                                <!-- Zoom Icon -->
                                <div class="zoom-icon" title="Click để phóng to">
                                    <i class="fas fa-search-plus"></i>
                                </div>
                            </div>

                            <!-- Thumbnails -->
                            <div class="thumbnails-wrapper">
                                <c:choose>
                                    <c:when test="${not empty product.imageUrl}">
                                        <!-- Thumbnail ảnh đại diện luôn đầu tiên và active -->
                                        <button type="button" class="thumbnail active">
                                            <img src="<c:url value='/images/${product.imageUrl}'/>" alt="">
                                        </button>

                                        <!-- Thumbnails ảnh phụ (bỏ qua ảnh trùng với ảnh đại diện) -->
                                        <c:forEach var="img" items="${product.imageUrls}">
                                            <c:if test="${img != product.imageUrl}">
                                                <button type="button" class="thumbnail">
                                                    <img src="<c:url value='/images/${img}'/>" alt="">
                                                </button>
                                            </c:if>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Không có ảnh đại diện -->
                                        <c:choose>
                                            <c:when test="${not empty product.imageUrls}">
                                                <c:forEach var="img" items="${product.imageUrls}" varStatus="status">
                                                    <button type="button"
                                                        class="thumbnail ${status.index == 0 ? 'active' : ''}">
                                                        <img src="<c:url value='/images/${img}'/>" alt="">
                                                    </button>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="button" class="thumbnail active">
                                                    <img src="https://via.placeholder.com/100x100?text=No+Image" alt="">
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>

                                <!-- Variant Thumbnails -->
                                <c:forEach var="v" items="${variants}">
                                    <c:if test="${not empty v.imageUrl}">
                                        <button type="button" class="thumbnail">
                                            <img src="<c:url value='/images/${v.imageUrl}'/>" alt="${v.name}">
                                        </button>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Right: Product Info Section -->
                        <div class="product-info">
                            <!-- Product Title -->
                            <h1 class="product-title">${product.name}</h1>

                            <!-- Rating & Sold -->
                            <div class="product-meta">
                                <div class="rating-wrapper">
                                    <span class="rating-score">
                                        <fmt:formatNumber value="${avgRating != null ? avgRating : 0}"
                                            maxFractionDigits="1" />
                                    </span>
                                    <div class="stars" title="Đánh giá trung bình">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                    </div>
                                    <span class="rating-count">(${reviewCount}) đánh giá</span>
                                </div>
                                <span class="divider"></span>
                                <div class="sold-count">
                                    <strong>
                                        <c:choose>
                                            <c:when test="${soldCount >= 1000}">
                                                <fmt:formatNumber value="${soldCount / 1000}" maxFractionDigits="1" />k
                                            </c:when>
                                            <c:otherwise>
                                                ${soldCount}
                                            </c:otherwise>
                                        </c:choose>
                                    </strong> Đã bán
                                </div>
                            </div>

                            <!-- Price Section -->
                            <div class="price-section">
                                <div class="price-wrapper">
                                    <c:if test="${product.price > 0}">
                                        <span class="original-price">
                                            <fmt:formatNumber value="${product.price * 1.2}" type="number"
                                                maxFractionDigits="0" />₫
                                        </span>
                                    </c:if>
                                    <span class="current-price">
                                        <fmt:formatNumber value="${product.price}" type="number"
                                            maxFractionDigits="0" />₫
                                    </span>
                                    <span class="discount-badge">-20%</span>
                                </div>
                            </div>

                            <!-- Form chính: Thêm vào giỏ -->
                            <form method="post" action="<c:url value='/add-product-from-view-detail'/>"
                                id="productForm">
                                <input type="hidden" name="id" value="${product.id}">

                                <!-- Variants Section -->
                                <c:if test="${not empty variants}">
                                    <div class="variant-section">
                                        <div class="variant-label">Phân loại</div>
                                        <div class="variant-options">
                                            <c:forEach var="v" items="${variants}">
                                                <div class="variant-option">
                                                    <input type="radio" name="variantId" value="${v.id}"
                                                        id="variant_${v.id}" data-image="${v.imageUrl}"
                                                        data-price="${v.price}" data-variant-name="${v.name}">
                                                    <label for="variant_${v.id}">
                                                        <c:if test="${not empty v.imageUrl}">
                                                            <img src="<c:url value='/images/${v.imageUrl}'/>"
                                                                alt="${v.name}" class="variant-image">
                                                        </c:if>
                                                        <span>${v.name}</span>
                                                        <c:if test="${v.price != null && v.price > 0}">
                                                            <span class="variant-price-display">
                                                                +
                                                                <fmt:formatNumber value="${v.price - product.price}"
                                                                    type="number" maxFractionDigits="0" />₫
                                                            </span>
                                                        </c:if>
                                                    </label>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Quantity Section -->
                                <div class="quantity-section">
                                    <div class="quantity-label">Số lượng</div>
                                    <div style="display: flex; align-items: center; gap: 16px;">
                                        <div class="quantity-control">
                                            <button type="button" class="quantity-btn" id="qtyMinus">
                                                <i class="fas fa-minus"></i>
                                            </button>
                                            <input type="number" name="quantity" id="quantity" class="quantity-input"
                                                value="1" min="1" max="999">
                                            <button type="button" class="quantity-btn" id="qtyPlus">
                                                <i class="fas fa-plus"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <!-- Action Buttons -->
                                <div class="action-buttons">
                                    <button type="submit" class="btn-add-cart" id="addToCartBtn">
                                        <i class="fas fa-cart-plus"></i>
                                        Thêm vào giỏ hàng
                                    </button>
                                    <button type="button" class="btn-buy-now" id="buyNowBtn">
                                        <i class="fas fa-bolt"></i>
                                        Mua ngay
                                    </button>
                                </div>
                            </form>

                            <!-- Form ẩn dành cho Mua ngay -->
                            <form id="buyNowForm" method="post" action="${pageContext.request.contextPath}/buy-now"
                                style="display:none;">
                                <input type="hidden" name="productId" value="${product.id}">
                                <input type="hidden" name="variantId" id="bn-variantId">
                                <input type="hidden" name="qty" id="bn-qty">
                                <c:if test="${not empty _csrf}">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                </c:if>
                            </form>

                            <!-- Additional Info -->
                            <div style="padding: 16px; background: #f5f5f5; border-radius: 8px; margin-top: 16px;">
                                <div style="display: flex; gap: 24px; flex-wrap: wrap;">
                                    <div style="display: flex; align-items: center; gap: 8px;">
                                        <i class="fas fa-shield-alt" style="color: #ee4d2d;"></i>
                                        <span style="font-size: 14px;">Đảm bảo chính hãng</span>
                                    </div>
                                    <div style="display: flex; align-items: center; gap: 8px;">
                                        <i class="fas fa-truck" style="color: #ee4d2d;"></i>
                                        <span style="font-size: 14px;">Miễn phí vận chuyển</span>
                                    </div>
                                    <div style="display: flex; align-items: center; gap: 8px;">
                                        <i class="fas fa-undo" style="color: #ee4d2d;"></i>
                                        <span style="font-size: 14px;">Đổi trả trong 7 ngày</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Product Description -->
                    <div class="description-section">
                        <div class="description-header">
                            <div class="description-title-wrapper">
                                <i class="fas fa-file-alt"></i>
                                <h2 class="description-title">Chi tiết sản phẩm</h2>
                            </div>
                        </div>
                        <div class="description-content">
                            <c:choose>
                                <c:when test="${not empty product.description}">
                                    <div class="description-text">
                                        ${product.description}
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-description">
                                        <i class="fas fa-inbox"></i>
                                        <p>Chưa có mô tả chi tiết cho sản phẩm này.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Reviews -->
                    <div class="description-section" id="reviews" style="margin-top: 32px;">
                        <div class="description-header">
                            <div class="description-title-wrapper">
                                <i class="fas fa-comments"></i>
                                <h2 class="description-title">Đánh giá sản phẩm</h2>
                            </div>
                        </div>

                        <c:if test="${not empty sessionScope.id}">
                            <div
                                style="background:#f0f9ff; border:1px solid #bae6fd; color:#0c4a6e; padding:12px 16px; border-radius:8px; margin-bottom:16px; display:flex; align-items:center; justify-content:space-between; gap:12px; flex-wrap:wrap;">
                                <div style="display:flex; align-items:center; gap:8px;">
                                    <i class="fas fa-info-circle"></i>
                                    <span>Hãy vào trang <strong>Đánh giá sản phẩm đã mua</strong> để gửi nhận xét của
                                        bạn.</span>
                                </div>
                                <!-- <a href="${pageContext.request.contextPath}/orders/reviews" class="btn-review" style="background:#0ea5e9; padding:8px 14px; border-radius:8px; text-decoration:none; color:#fff;">
                    <i class="fas fa-star"></i> Đánh giá ngay
                </a> -->
                            </div>
                        </c:if>
                        <c:if test="${empty sessionScope.id}">
                            <div
                                style="background:#fffbe6; border:1px solid #ffe58f; color:#ad6800; padding:12px 16px; border-radius:8px; margin-bottom:16px;">
                                Vui lòng đăng nhập và hoàn tất mua hàng để đánh giá sản phẩm này.
                            </div>
                        </c:if>

                        <div style="display:flex; flex-direction:column; gap:12px;">
                            <c:choose>
                                <c:when test="${reviewCount == 0}">
                                    <div
                                        style="color:#666; background:#fafafa; border:1px dashed #ddd; padding:16px; border-radius:8px;">
                                        Chưa có đánh giá nào. Hãy là người đầu tiên chia sẻ cảm nhận!
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:if test="${empty reviews}">
                                        <div
                                            style="color:#666; background:#fffbe6; border:1px solid #ffe58f; padding:16px; border-radius:8px;">
                                            Không có đánh giá nào ở trang này. Vui lòng chọn trang khác.
                                        </div>
                                    </c:if>
                                    <c:forEach var="rv" items="${reviews}">
                                        <div
                                            style="background:#fff; border:1px solid #eee; border-radius:8px; padding:12px 16px;">
                                            <div style="display:flex; align-items:center; gap:8px; margin-bottom:4px;">
                                                <strong>${rv.user.fullName}</strong>
                                                <span style="color:#999;">• ${rv.createdAt}</span>
                                            </div>
                                            <div style="color:#f59e0b; margin-bottom:6px;">${rv.rating} ⭐</div>
                                            <c:if test="${not empty rv.title}">
                                                <div style="font-weight:600; margin-bottom:4px;">${rv.title}</div>
                                            </c:if>
                                            <div style="white-space:pre-wrap;">${rv.comment}</div>
                                        </div>
                                    </c:forEach>
                                    <c:if test="${reviewTotalPages >= 1}">
                                        <div
                                            style="display:flex; justify-content:center; align-items:center; gap:8px; margin-top:16px; flex-wrap:wrap;">
                                            <c:if test="${reviewCurrentPage > 1}">
                                                <c:url var="prevReviewUrl" value='/product/${product.id}'>
                                                    <c:param name="reviewPage" value="${reviewCurrentPage - 1}" />
                                                    <c:param name="reviewSize" value="${reviewPageSize}" />
                                                    <c:if test="${not empty param.reviewed}">
                                                        <c:param name="reviewed" value="${param.reviewed}" />
                                                    </c:if>
                                                </c:url>
                                                <a href="${prevReviewUrl}#reviews"
                                                    style="padding:8px 12px; border:1px solid #ddd; border-radius:6px; text-decoration:none; color:#0f172a; background:#fff;">«</a>
                                            </c:if>
                                            <c:forEach var="i" begin="1" end="${reviewTotalPages}">
                                                <c:url var="reviewPageUrl" value='/product/${product.id}'>
                                                    <c:param name="reviewPage" value="${i}" />
                                                    <c:param name="reviewSize" value="${reviewPageSize}" />
                                                    <c:if test="${not empty param.reviewed}">
                                                        <c:param name="reviewed" value="${param.reviewed}" />
                                                    </c:if>
                                                </c:url>
                                                <c:choose>
                                                    <c:when test="${i == reviewCurrentPage}">
                                                        <span
                                                            style="padding:8px 12px; border-radius:6px; background:#0ea5e9; color:#fff; font-weight:600;">${i}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${reviewPageUrl}#reviews"
                                                            style="padding:8px 12px; border:1px solid #ddd; border-radius:6px; text-decoration:none; color:#0f172a;">${i}</a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                            <c:if test="${reviewCurrentPage < reviewTotalPages}">
                                                <c:url var="nextReviewUrl" value='/product/${product.id}'>
                                                    <c:param name="reviewPage" value="${reviewCurrentPage + 1}" />
                                                    <c:param name="reviewSize" value="${reviewPageSize}" />
                                                    <c:if test="${not empty param.reviewed}">
                                                        <c:param name="reviewed" value="${param.reviewed}" />
                                                    </c:if>
                                                </c:url>
                                                <a href="${nextReviewUrl}#reviews"
                                                    style="padding:8px 12px; border:1px solid #ddd; border-radius:6px; text-decoration:none; color:#0f172a; background:#fff;">»</a>
                                            </c:if>
                                        </div>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                <!-- Include Footer -->
                <jsp:include page="../layout/footer.jsp" />

                <!-- Inline Debug Script -->
                <script>
                    console.log("=== INLINE SCRIPT IN DETAIL.JSP ===");
                    console.log("Page URL:", window.location.href);
                    console.log("Document readyState:", document.readyState);

                    setTimeout(() => {
                        console.log("--- Element Check (after 100ms) ---");
                        console.log("qtyMinus:", document.getElementById("qtyMinus"));
                        console.log("qtyPlus:", document.getElementById("qtyPlus"));
                        console.log("quantity input:", document.getElementById("quantity"));
                        console.log("addToCartBtn:", document.getElementById("addToCartBtn"));
                        console.log("buyNowBtn:", document.getElementById("buyNowBtn"));
                    }, 100);
                </script>

                <!-- Product Detail JavaScript -->
                <script
                    src="<c:url value='/resources/client/js/product-detail.js'/>?v=<%= System.currentTimeMillis() %>"></script>

                <!-- Buy Now Script: gắn sau khi DOM sẵn sàng -->
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        const buyBtn = document.getElementById('buyNowBtn');
                        if (!buyBtn) return;

                        buyBtn.addEventListener('click', function () {
                            const qtyInput = document.getElementById('quantity');
                            const qty = Math.max(1, parseInt(qtyInput ? qtyInput.value : '1', 10));

                            const variantRadios = document.querySelectorAll('input[name="variantId"]');
                            const hasVariants = variantRadios.length > 0;
                            const checked = document.querySelector('input[name="variantId"]:checked');

                            // Bắt buộc chọn variant nếu sản phẩm có phân loại
                            if (hasVariants && !checked) {
                                alert('Vui lòng chọn phân loại trước khi mua ngay.');
                                return;
                            }

                            // Gán dữ liệu vào form ẩn & submit
                            document.getElementById('bn-qty').value = qty;
                            document.getElementById('bn-variantId').value = checked ? checked.value : '';

                            document.getElementById('buyNowForm').submit();
                        });
                    });
                </script>
            </body>

            </html>