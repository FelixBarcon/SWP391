<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap"
                rel="stylesheet">

            <!-- Global CSS -->
            <link rel="stylesheet" href="<c:url value='/resources/client/css/global.css'/>">
            <link rel="stylesheet" href="<c:url value='/resources/client/css/header.css'/>">

            <!-- Homepage CSS -->
            <link rel="stylesheet" href="<c:url value='/resources/client/css/homepage.css'/>">
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
                        <h2 class="section-title">Sản phẩm nổi bật</h2>
                        <p class="section-subtitle">Những sản phẩm được yêu thích nhất</p>
                    </div>
                    <div class="row">
                        <!-- Product 1 -->
                        <div class="col-lg-3 col-md-6 mb-4">
                            <div class="product-card">
                                <div class="product-image">
                                    <img src="<c:url value='/resources/client/images/product-iphone.svg'/>"
                                        alt="iPhone 15 Pro" class="img-fluid">
                                    <div class="product-badge">Mới</div>
                                </div>
                                <div class="product-info">
                                    <h5 class="product-name">iPhone 15 Pro 128GB</h5>
                                    <div class="product-rating">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <span class="rating-count">(128)</span>
                                    </div>
                                    <div class="product-price">
                                        <span class="current-price">28.990.000₫</span>
                                        <span class="original-price">32.990.000₫</span>
                                    </div>
                                    <button class="btn btn-primary add-to-cart">
                                        <i class="fas fa-cart-plus me-2"></i>
                                        Thêm vào giỏ
                                    </button>
                                </div>
                            </div>
                        </div>
                        <!-- Product 2 -->
                        <div class="col-lg-3 col-md-6 mb-4">
                            <div class="product-card">
                                <div class="product-image">
                                    <img src="<c:url value='/resources/client/images/product-laptop.svg'/>"
                                        alt="MacBook Air M2" class="img-fluid">
                                    <div class="product-badge sale">Giảm 15%</div>
                                </div>
                                <div class="product-info">
                                    <h5 class="product-name">MacBook Air M2 13 inch</h5>
                                    <div class="product-rating">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="far fa-star"></i>
                                        <span class="rating-count">(89)</span>
                                    </div>
                                    <div class="product-price">
                                        <span class="current-price">26.990.000₫</span>
                                        <span class="original-price">31.990.000₫</span>
                                    </div>
                                    <button class="btn btn-primary add-to-cart">
                                        <i class="fas fa-cart-plus me-2"></i>
                                        Thêm vào giỏ
                                    </button>
                                </div>
                            </div>
                        </div>
                        <!-- Product 3 -->
                        <div class="col-lg-3 col-md-6 mb-4">
                            <div class="product-card">
                                <div class="product-image">
                                    <img src="<c:url value='/resources/client/images/product-shirt.svg'/>"
                                        alt="Áo thun nam" class="img-fluid">
                                    <div class="product-badge hot">Hot</div>
                                </div>
                                <div class="product-info">
                                    <h5 class="product-name">Áo thun nam cao cấp</h5>
                                    <div class="product-rating">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <span class="rating-count">(256)</span>
                                    </div>
                                    <div class="product-price">
                                        <span class="current-price">2.890.000₫</span>
                                    </div>
                                    <button class="btn btn-primary add-to-cart">
                                        <i class="fas fa-cart-plus me-2"></i>
                                        Thêm vào giỏ
                                    </button>
                                </div>
                            </div>
                        </div>
                        <!-- Product 4 -->
                        <div class="col-lg-3 col-md-6 mb-4">
                            <div class="product-card">
                                <div class="product-image">
                                    <img src="<c:url value='/resources/client/images/product-cosmetic.svg'/>"
                                        alt="Kem dưỡng da" class="img-fluid">
                                </div>
                                <div class="product-info">
                                    <h5 class="product-name">Kem dưỡng da cao cấp</h5>
                                    <div class="product-rating">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="far fa-star"></i>
                                        <span class="rating-count">(42)</span>
                                    </div>
                                    <div class="product-price">
                                        <span class="current-price">490.000₫</span>
                                        <span class="original-price">690.000₫</span>
                                    </div>
                                    <button class="btn btn-primary add-to-cart">
                                        <i class="fas fa-cart-plus me-2"></i>
                                        Thêm vào giỏ
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="text-center mt-4">
                        <a href="#" class="btn btn-outline-primary btn-lg">
                            Xem tất cả sản phẩm
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

            <!-- Bootstrap JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

            <!-- jQuery -->
            <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>

            <!-- Homepage JS -->
            <script src="<c:url value='/resources/client/js/homepage.js'/>"></script>
        </body>

        </html>