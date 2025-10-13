<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Marketplace - Nền tảng thương mại điện tử hàng đầu</title>

                <!-- Bootstrap 5 CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

                <!-- Font Awesome -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

                <!-- Google Fonts - Inter -->
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap"
                    rel="stylesheet">

                <!-- Global CSS -->
                <link rel="stylesheet" href="<c:url value='/resources/client/css/global.css'/>">
                <link rel="stylesheet" href="<c:url value='/resources/client/css/header.css'/>">

                <!-- Homepage CSS -->
                <link rel="stylesheet" href="<c:url value='/resources/client/css/homepage.css'/>">

                <!-- Zalo Chat CSS -->
                <link rel="stylesheet" href="<c:url value='/resources/client/css/zalo-chat.css'/>">

                <!-- Facebook Messenger CSS -->
                <link rel="stylesheet" href="<c:url value='/resources/client/css/fb-messenger.css'/>">
            </head>

            <body>
                <!-- Include Header -->
                <jsp:include page="../layout/header.jsp" />

                <!-- Hero Section -->
                <section class="hero-section">
                    <div class="container">
                        <div class="row align-items-center">
                            <div class="col-lg-6 col-md-8">
                                <div class="hero-content">
                                    <h1 class="hero-title">
                                        Khám phá thế giới
                                        <span class="text-primary">mua sắm trực tuyến</span>
                                    </h1>
                                    <p class="hero-description">
                                        Nền tảng thương mại điện tử hàng đầu với hàng triệu sản phẩm chất lượng,
                                        giá cả cạnh tranh và dịch vụ tận tâm.
                                    </p>
                                    <div class="hero-actions">
                                        <a href="#products" class="btn btn-primary btn-lg me-3">
                                            <i class="fas fa-shopping-cart me-2"></i>
                                            Mua sắm ngay
                                        </a>
                                        <a href="#categories" class="btn btn-outline-primary btn-lg">
                                            <i class="fas fa-list me-2"></i>
                                            Danh mục sản phẩm
                                        </a>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-6">
                                <div class="hero-image">
                                    <img src="<c:url value='/resources/client/images/hero-shopping.svg'/>"
                                        alt="Shopping Online" class="img-fluid">
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Search Section -->
                <section class="search-section">
                    <div class="container">
                        <div class="search-container">
                            <div class="search-form">
                                <div class="input-group input-group-lg">
                                    <input type="text" class="form-control"
                                        placeholder="Tìm kiếm sản phẩm, thương hiệu, danh mục...">
                                    <button class="btn btn-primary" type="button">
                                        <i class="fas fa-search"></i>
                                        Tìm kiếm
                                    </button>
                                </div>
                            </div>
                            <div class="trending-keywords">
                                <span class="trending-label">Từ khóa hot:</span>
                                <a href="#" class="trending-keyword">Điện thoại</a>
                                <a href="#" class="trending-keyword">Laptop</a>
                                <a href="#" class="trending-keyword">Thời trang</a>
                                <a href="#" class="trending-keyword">Mỹ phẩm</a>
                                <a href="#" class="trending-keyword">Gia dụng</a>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Categories Section -->
                <section id="categories" class="categories-section">
                    <div class="container">
                        <div class="section-header text-center">
                            <h2 class="section-title">Danh mục nổi bật</h2>
                            <p class="section-subtitle">Khám phá các danh mục sản phẩm phổ biến nhất</p>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 col-md-4 col-6">
                                <div class="category-card">
                                    <div class="category-icon">
                                        <i class="fas fa-mobile-alt"></i>
                                    </div>
                                    <h5 class="category-name">Điện thoại</h5>
                                    <p class="category-count">1,200+ sản phẩm</p>
                                </div>
                            </div>
                            <div class="col-lg-2 col-md-4 col-6">
                                <div class="category-card">
                                    <div class="category-icon">
                                        <i class="fas fa-laptop"></i>
                                    </div>
                                    <h5 class="category-name">Laptop</h5>
                                    <p class="category-count">800+ sản phẩm</p>
                                </div>
                            </div>
                            <div class="col-lg-2 col-md-4 col-6">
                                <div class="category-card">
                                    <div class="category-icon">
                                        <i class="fas fa-tshirt"></i>
                                    </div>
                                    <h5 class="category-name">Thời trang</h5>
                                    <p class="category-count">2,500+ sản phẩm</p>
                                </div>
                            </div>
                            <div class="col-lg-2 col-md-4 col-6">
                                <div class="category-card">
                                    <div class="category-icon">
                                        <i class="fas fa-gem"></i>
                                    </div>
                                    <h5 class="category-name">Mỹ phẩm</h5>
                                    <p class="category-count">600+ sản phẩm</p>
                                </div>
                            </div>
                            <div class="col-lg-2 col-md-4 col-6">
                                <div class="category-card">
                                    <div class="category-icon">
                                        <i class="fas fa-home"></i>
                                    </div>
                                    <h5 class="category-name">Gia dụng</h5>
                                    <p class="category-count">900+ sản phẩm</p>
                                </div>
                            </div>
                            <div class="col-lg-2 col-md-4 col-6">
                                <div class="category-card">
                                    <div class="category-icon">
                                        <i class="fas fa-gamepad"></i>
                                    </div>
                                    <h5 class="category-name">Giải trí</h5>
                                    <p class="category-count">400+ sản phẩm</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Featured Products Section -->
                <section id="products" class="featured-products-section">
                    <div class="container">
                        <div class="section-header text-center">
                            <div class="section-badge">
                                <i class="fas fa-fire"></i> Hot Deal
                            </div>
                            <h2 class="section-title">Sản phẩm nổi bật</h2>
                            <p class="section-subtitle">Những sản phẩm được yêu thích nhất trong tuần</p>
                        </div>

                        <div class="row g-4">
                            <c:forEach var="p" items="${products}" varStatus="status">
                                <div class="col-lg-3 col-md-4 col-sm-6">
                                    <div class="product-card-modern ${p.status != 'ACTIVE' ? 'product-disabled' : ''}">
                                        <!-- Product Image -->
                                        <div class="product-image-wrapper">
                                            <a href="<c:url value='/product/${p.id}'/>" class="product-link">
                                                <img src="${pageContext.request.contextPath}/images/${p.imageUrl}"
                                                    alt="${p.name}" class="product-img" loading="lazy">
                                            </a>

                                            <!-- Badges -->
                                            <div class="product-badges">
                                                <c:if test="${status.index < 3}">
                                                    <span class="badge badge-hot">
                                                        <i class="fas fa-fire"></i> Hot
                                                    </span>
                                                </c:if>
                                                <c:if test="${p.status != 'ACTIVE'}">
                                                    <span class="badge badge-disabled">Ngưng bán</span>
                                                </c:if>
                                            </div>

                                            <!-- Quick Actions -->
                                            <div class="product-actions">
                                                <button class="action-btn" title="Yêu thích">
                                                    <i class="far fa-heart"></i>
                                                </button>
                                                <a href="<c:url value='/product/${p.id}'/>" class="action-btn"
                                                    title="Xem nhanh">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                            </div>

                                            <!-- Discount Badge -->
                                            <c:if test="${p.status == 'ACTIVE'}">
                                                <div class="discount-badge">
                                                    -20%
                                                </div>
                                            </c:if>
                                        </div>

                                        <!-- Product Info -->
                                        <div class="product-content">
                                            <a href="<c:url value='/product/${p.id}'/>" class="product-title-link">
                                                <h5 class="product-title">${p.name}</h5>
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
                                                <span class="rating-text">4.8</span>
                                                <span class="sold-count">| Đã bán 1.2k</span>
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
                                                                <fmt:formatNumber value="${p.price * 1.2}" type="number"
                                                                    maxFractionDigits="0" />₫
                                                            </span>
                                                        </c:if>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <!-- Action Button -->
                                            <div class="product-footer">
                                                <c:choose>
                                                    <c:when test="${p.status == 'ACTIVE'}">
                                                        <a href="<c:url value='/product/${p.id}'/>"
                                                            class="btn-view-detail">
                                                            <i class="fas fa-shopping-cart me-1"></i>
                                                            Xem chi tiết
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button class="btn-view-detail disabled" disabled>
                                                            <i class="fas fa-ban me-1"></i>
                                                            Ngưng kinh doanh
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- View More -->
                        <div class="text-center mt-5">
                            <a href="<c:url value='/products'/>" class="btn-view-more">
                                <span>Xem tất cả sản phẩm</span>
                                <i class="fas fa-arrow-right ms-2"></i>
                            </a>
                        </div>
                    </div>
                </section>

                <!-- Features Section -->
                <section class="features-section">
                    <div class="container">
                        <div class="row">
                            <div class="col-lg-3 col-md-6 mb-4">
                                <div class="feature-card">
                                    <div class="feature-icon">
                                        <i class="fas fa-shipping-fast"></i>
                                    </div>
                                    <h5 class="feature-title">Giao hàng nhanh</h5>
                                    <p class="feature-description">Giao hàng trong ngày tại TP.HCM và Hà Nội</p>
                                </div>
                            </div>
                            <div class="col-lg-3 col-md-6 mb-4">
                                <div class="feature-card">
                                    <div class="feature-icon">
                                        <i class="fas fa-shield-alt"></i>
                                    </div>
                                    <h5 class="feature-title">Bảo mật thanh toán</h5>
                                    <p class="feature-description">Thanh toán an toàn với công nghệ mã hóa SSL</p>
                                </div>
                            </div>
                            <div class="col-lg-3 col-md-6 mb-4">
                                <div class="feature-card">
                                    <div class="feature-icon">
                                        <i class="fas fa-undo-alt"></i>
                                    </div>
                                    <h5 class="feature-title">Đổi trả dễ dàng</h5>
                                    <p class="feature-description">Đổi trả miễn phí trong vòng 30 ngày</p>
                                </div>
                            </div>
                            <div class="col-lg-3 col-md-6 mb-4">
                                <div class="feature-card">
                                    <div class="feature-icon">
                                        <i class="fas fa-headset"></i>
                                    </div>
                                    <h5 class="feature-title">Hỗ trợ 24/7</h5>
                                    <p class="feature-description">Đội ngũ chăm sóc khách hàng luôn sẵn sàng</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Newsletter Section -->
                <section class="newsletter-section">
                    <div class="container">
                        <div class="row justify-content-center">
                            <div class="col-lg-6 text-center">
                                <h3 class="newsletter-title">Đăng ký nhận tin</h3>
                                <p class="newsletter-description">
                                    Nhận thông tin về sản phẩm mới và ưu đãi đặc biệt
                                </p>
                                <div class="newsletter-form">
                                    <div class="input-group">
                                        <input type="email" class="form-control" placeholder="Nhập email của bạn">
                                        <button class="btn btn-primary" type="button">
                                            Đăng ký
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Include Footer -->
                <jsp:include page="../layout/footer.jsp" />

                <!-- Zalo Chat Button -->
                <a href="javascript:void(0);" class="zalo-chat-button" title="Chat với chúng tôi qua Zalo">
                    <div class="zalo-chat-container">
                        <div class="zalo-icon-wrapper">
                            <img src="<c:url value='/resources/client/images/icon-zalo.png'/>" alt="Zalo Icon"
                                class="zalo-icon-img">
                        </div>
                        <div class="zalo-text">
                            <span class="zalo-text-line2">Chat Zalo</span>
                        </div>
                        <span class="zalo-notification-dot"></span>
                    </div>
                    <div class="zalo-tooltip">Chat với chúng tôi</div>
                </a>

                <!-- Facebook Messenger Button -->
                <a href="javascript:void(0);" class="fb-messenger-button" title="Chat với chúng tôi qua Messenger">
                    <div class="fb-messenger-container">
                        <div class="fb-messenger-icon-wrapper">
                            <img src="<c:url value='/resources/client/images/icon-message.png'/>"
                                alt="Facebook Messenger Icon" class="fb-messenger-icon-img">
                        </div>
                        <div class="fb-messenger-text">
                            <span class="fb-messenger-text-line2">Chat Messenger</span>
                        </div>
                        <span class="fb-messenger-notification-dot"></span>
                    </div>
                    <div class="fb-messenger-tooltip">Chat với chúng tôi</div>
                </a>

                <!-- Homepage JS -->
                <script src="<c:url value='/resources/client/js/homepage.js'/>"></script>

                <!-- Zalo Chat JS -->
                <script src="<c:url value='/resources/client/js/zalo-chat.js'/>"></script>

                <!-- Facebook Messenger JS -->
                <script src="<c:url value='/resources/client/js/fb-messenger.js'/>"></script>
            </body>

            </html>