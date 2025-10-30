<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Sản phẩm đã mua &amp; đánh giá</title>
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/client/css/order.css">
                    <style>
                        .review-container {
                            max-width: 1100px;
                            margin: 24px auto;
                            padding: 0 16px;
                        }

                        .review-card {
                            background: #fff;
                            border-radius: 16px;
                            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.06);
                            padding: 24px;
                            margin-bottom: 20px;
                            display: flex;
                            gap: 20px;
                            align-items: flex-start;
                        }

                        .review-card img {
                            width: 140px;
                            height: 140px;
                            object-fit: cover;
                            border-radius: 12px;
                            border: 1px solid #f0f0f0;
                        }

                        .review-info {
                            flex: 1;
                            display: flex;
                            flex-direction: column;
                            gap: 10px;
                        }

                        .review-title {
                            font-size: 20px;
                            font-weight: 600;
                            margin: 0;
                        }

                        .review-title a {
                            color: inherit;
                            text-decoration: none;
                        }

                        .meta-line {
                            color: #666;
                            font-size: 14px;
                            display: flex;
                            gap: 12px;
                            align-items: center;
                        }

                        .meta-line i {
                            color: #5b9bd5;
                        }

                        .review-actions {
                            display: flex;
                            gap: 12px;
                            flex-wrap: wrap;
                        }

                        .btn-review {
                            background: #5b9bd5;
                            color: #fff;
                            border: none;
                            border-radius: 8px;
                            padding: 10px 18px;
                            font-weight: 600;
                            cursor: pointer;
                            display: inline-flex;
                            align-items: center;
                            gap: 8px;
                            transition: all 0.3s;
                        }

                        .btn-review:hover {
                            background: #4a7ba7;
                            opacity: 0.95;
                        }

                        .review-form {
                            margin-top: 16px;
                            border: 1px solid #c9e3f5;
                            border-radius: 12px;
                            padding: 16px;
                            display: none;
                            background: #f0f8ff;
                        }

                        .review-form.active {
                            display: block;
                        }

                        .rating-options label {
                            margin-right: 12px;
                            font-weight: 500;
                        }

                        .review-existing {
                            background: #f6ffed;
                            border: 1px solid #b7eb8f;
                            border-radius: 12px;
                            padding: 16px;
                            color: #3f6600;
                        }

                        .review-existing.warn {
                            background: #fff1f0;
                            border-color: #ffa39e;
                            color: #a8071a;
                        }

                        .empty-state {
                            text-align: center;
                            padding: 80px 20px;
                            color: #777;
                            background: #fff;
                            border-radius: 16px;
                            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.04);
                        }

                        .empty-state i {
                            font-size: 52px;
                            color: #ddd;
                            margin-bottom: 16px;
                        }

                        @media (max-width:768px) {
                            .review-card {
                                flex-direction: column;
                                align-items: stretch;
                            }

                            .review-card img {
                                width: 100%;
                                height: 200px;
                            }
                        }
                    </style>
                    <fmt:setLocale value="vi_VN" />
                    <fmt:setTimeZone value="Asia/Ho_Chi_Minh" />
                    <jsp:include page="../layout/header.jsp" />
                </head>

                <body>
                    <div class="review-container" id="reviewList">
                        <div
                            style="display:flex; justify-content:space-between; align-items:center; gap:12px; margin-bottom:20px;">
                            <h2 style="margin:0; font-weight:700; display:flex; align-items:center; gap:10px;">
                                <i class="fas fa-star"></i> Sản phẩm đã mua &amp; đánh giá
                                <c:if test="${not empty totalItems}">
                                    <span style="font-size:16px; color:#4b5563;">(${totalItems} sản phẩm)</span>
                                </c:if>
                            </h2>
                            <div style="display:flex; gap:10px; flex-wrap:wrap;">
                                <a href="${pageContext.request.contextPath}/orders"
                                    class="btn btn-sm btn-outline-secondary"
                                    style="display:inline-flex; align-items:center; gap:6px;">
                                    <i class="fas fa-arrow-left"></i> Đơn hàng của tôi
                                </a>
                                <a href="${pageContext.request.contextPath}/products" class="btn btn-sm btn-primary"
                                    style="display:inline-flex; align-items:center; gap:6px;">
                                    <i class="fas fa-shopping-bag"></i> Tiếp tục mua sắm
                                </a>
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${totalItems == 0}">
                                <div class="empty-state">
                                    <i class="fas fa-box"></i>
                                    <h3>Chưa có sản phẩm nào đủ điều kiện đánh giá</h3>
                                    <p>Bạn hãy hoàn tất đơn hàng để có thể đánh giá sản phẩm nhé!</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:if test="${empty purchasedItems}">
                                    <div class="empty-state">
                                        <i class="fas fa-info-circle"></i>
                                        <h3>Không tìm thấy dữ liệu ở trang này</h3>
                                        <p>Hãy quay lại trang trước hoặc chọn lại trang hiển thị.</p>
                                    </div>
                                </c:if>
                                <c:if test="${not empty purchasedItems}">
                                    <c:forEach var="item" items="${purchasedItems}" varStatus="st">
                                        <c:set var="product" value="${item.product}" />
                                        <div class="review-card">
                                            <c:choose>
                                                <c:when test="${not empty product.imageUrl}">
                                                    <img src="<c:url value='/images/${product.imageUrl}'/>"
                                                        alt="${product.name}" />
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="https://via.placeholder.com/200x200?text=No+Image"
                                                        alt="${product.name}" />
                                                </c:otherwise>
                                            </c:choose>

                                            <div class="review-info">
                                                <h3 class="review-title"><a
                                                        href="${pageContext.request.contextPath}/product/${product.id}">${product.name}</a>
                                                </h3>
                                                <div class="meta-line">
                                                    <span><i class="fas fa-calendar-alt"></i> Đã mua ngày:
                                                        ${item.purchasedAt}</span>
                                                    <c:if test="${item.orderItem.order != null}">
                                                        <span><i class="fas fa-receipt"></i> Đơn hàng
                                                            #${item.orderItem.order.id}</span>
                                                    </c:if>
                                                </div>
                                                <div class="meta-line">
                                                    <span><i class="fas fa-store"></i> Shop:
                                                        ${product.shop.displayName}</span>
                                                    <span><i class="fas fa-star"></i> Điểm trung bình:
                                                        <fmt:formatNumber value="${item.averageRating}"
                                                            maxFractionDigits="1" />
                                                    </span>
                                                </div>

                                                <c:choose>
                                                    <c:when test="${item.canReview}">
                                                        <div class="review-actions">
                                                            <button type="button" class="btn-review btn-toggle-review"
                                                                data-target="reviewForm_${st.index}">
                                                                <i class="fas fa-pen"></i> Đánh giá ngay
                                                            </button>
                                                        </div>
                                                        <div id="reviewForm_${st.index}" class="review-form">
                                                            <form method="post"
                                                                action="${pageContext.request.contextPath}/product/${product.id}/reviews">
                                                                <input type="hidden" name="orderItemId"
                                                                    value="${item.orderItem.id}">
                                                                <div class="rating-options" style="margin-bottom:12px;">
                                                                    <span
                                                                        style="font-weight:600; margin-right:8px;">Chọn
                                                                        điểm:</span>
                                                                    <label><input type="radio" name="rating" value="5"
                                                                            checked> 5 ⭐</label>
                                                                    <label><input type="radio" name="rating" value="4">
                                                                        4 ⭐</label>
                                                                    <label><input type="radio" name="rating" value="3">
                                                                        3 ⭐</label>
                                                                    <label><input type="radio" name="rating" value="2">
                                                                        2 ⭐</label>
                                                                    <label><input type="radio" name="rating" value="1">
                                                                        1 ⭐</label>
                                                                </div>
                                                                <div style="margin-bottom:12px;">
                                                                    <input type="text" name="title"
                                                                        placeholder="Tiêu đề (tuỳ chọn)"
                                                                        style="width:100%; padding:10px 12px; border:1px solid #ddd; border-radius:8px;">
                                                                </div>
                                                                <div style="margin-bottom:12px;">
                                                                    <textarea name="comment" rows="4"
                                                                        placeholder="Chia sẻ cảm nhận của bạn"
                                                                        style="width:100%; padding:12px; border:1px solid #ddd; border-radius:8px;"></textarea>
                                                                </div>
                                                                <div style="text-align:right;">
                                                                    <button type="submit" class="btn-review"
                                                                        style="background:#16a34a;">
                                                                        <i class="fas fa-paper-plane"></i> Gửi đánh giá
                                                                    </button>
                                                                </div>
                                                                <c:if test="${not empty _csrf}">
                                                                    <input type="hidden" name="${_csrf.parameterName}"
                                                                        value="${_csrf.token}">
                                                                </c:if>
                                                            </form>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:choose>
                                                            <c:when test="${item.existingReview != null}">
                                                                <div class="review-existing">
                                                                    <div
                                                                        style="display:flex; align-items:center; gap:10px; font-weight:600;">
                                                                        <i class="fas fa-check-circle"></i> Bạn đã đánh
                                                                        giá sản phẩm này cho đơn hàng
                                                                        #${item.orderItem.order.id}
                                                                    </div>
                                                                    <div style="margin-top:8px;">
                                                                        <strong>Điểm:</strong>
                                                                        ${item.existingReview.rating} ⭐
                                                                    </div>
                                                                    <c:if test="${not empty item.existingReview.title}">
                                                                        <div><strong>Tiêu đề:</strong>
                                                                            ${item.existingReview.title}</div>
                                                                    </c:if>
                                                                    <c:if
                                                                        test="${not empty item.existingReview.comment}">
                                                                        <div><strong>Nội dung:</strong>
                                                                            ${item.existingReview.comment}</div>
                                                                    </c:if>
                                                                </div>
                                                                <div class="review-actions" style="margin-top:12px;">
                                                                    <button type="button"
                                                                        class="btn-review btn-toggle-review"
                                                                        data-target="editReviewForm_${st.index}"
                                                                        style="background:#0ea5e9;">
                                                                        <i class="fas fa-edit"></i> Chỉnh sửa đánh giá
                                                                    </button>
                                                                </div>
                                                                <div id="editReviewForm_${st.index}"
                                                                    class="review-form">
                                                                    <form method="post"
                                                                        action="${pageContext.request.contextPath}/product/${product.id}/reviews">
                                                                        <input type="hidden" name="orderItemId"
                                                                            value="${item.orderItem.id}">
                                                                        <div class="rating-options"
                                                                            style="margin-bottom:12px;">
                                                                            <span
                                                                                style="font-weight:600; margin-right:8px;">Chọn
                                                                                điểm:</span>
                                                                            <label><input type="radio" name="rating"
                                                                                    value="5" <c:if
                                                                                    test="${item.existingReview.rating == 5}">checked
                                </c:if>> 5 ⭐</label>
                                <label style="margin-left:8px;"><input type="radio" name="rating" value="4" <c:if
                                        test="${item.existingReview.rating == 4}">checked</c:if>> 4 ⭐</label>
                                <label style="margin-left:8px;"><input type="radio" name="rating" value="3" <c:if
                                        test="${item.existingReview.rating == 3}">checked</c:if>> 3 ⭐</label>
                                <label style="margin-left:8px;"><input type="radio" name="rating" value="2" <c:if
                                        test="${item.existingReview.rating == 2}">checked</c:if>> 2 ⭐</label>
                                <label style="margin-left:8px;"><input type="radio" name="rating" value="1" <c:if
                                        test="${item.existingReview.rating == 1}">checked</c:if>> 1 ⭐</label>
                    </div>
                    <div style="margin-bottom:12px;">
                        <input type="text" name="title" placeholder="Tiêu đề (tuỳ chọn)"
                            value="${fn:escapeXml(item.existingReview.title)}"
                            style="width:100%; padding:10px 12px; border:1px solid #ddd; border-radius:8px;">
                    </div>
                    <div style="margin-bottom:12px;">
                        <textarea name="comment" rows="4" placeholder="Chia sẻ cảm nhận của bạn"
                            style="width:100%; padding:12px; border:1px solid #ddd; border-radius:8px;">${fn:escapeXml(item.existingReview.comment)}</textarea>
                    </div>
                    <div style="text-align:right;">
                        <button type="submit" class="btn-review" style="background:#16a34a;">
                            <i class="fas fa-save"></i> Cập nhật đánh giá
                        </button>
                    </div>
                    <c:if test="${not empty _csrf}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                    </c:if>
                    </form>
                    </div>
                    </c:when>
                    <c:otherwise>
                        <div class="review-existing warn">
                            <i class="fas fa-info-circle"></i> Sản phẩm chưa đủ điều kiện để đánh giá.
                        </div>
                    </c:otherwise>
                    </c:choose>
                    </c:otherwise>
                    </c:choose>
                    </div>
                    </div>
                    </c:forEach>
                    </c:if>
                    <c:if test="${totalPages >= 1}">
                        <nav aria-label="Page navigation"
                            style="margin-top:24px; display:flex; justify-content:center;">
                            <ul class="pagination pagination-sm mb-0">
                                <c:set var="prevPage" value="${currentPage - 1}" />
                                <c:set var="nextPage" value="${currentPage + 1}" />
                                <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                    <a class="page-link"
                                        href="<c:url value='/orders/reviews'><c:param name='page' value='${prevPage}'/><c:param name='size' value='${pageSize}'/></c:url>#reviewList">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </li>
                                <li class="page-item disabled"><a class="page-link"
                                        href="#">${currentPage}/${totalPages}</a></li>
                                <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                    <a class="page-link"
                                        href="<c:url value='/orders/reviews'><c:param name='page' value='${nextPage}'/><c:param name='size' value='${pageSize}'/></c:url>#reviewList">
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                        <div style="display:none">
                            <c:if test="${currentPage > 1}">
                                <c:url var="prevPageUrl" value='/orders/reviews'>
                                    <c:param name="page" value="${currentPage - 1}" />
                                    <c:param name="size" value="${pageSize}" />
                                </c:url>
                                <a href="${prevPageUrl}#reviewList"
                                    style="padding:8px 12px; border:1px solid #ddd; border-radius:6px; text-decoration:none; color:#0f172a; background:#fff;">«</a>
                            </c:if>
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <c:url var="pageUrl" value='/orders/reviews'>
                                    <c:param name="page" value="${i}" />
                                    <c:param name="size" value="${pageSize}" />
                                </c:url>
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span
                                            style="padding:8px 12px; border-radius:6px; background:#0ea5e9; color:#fff; font-weight:600;">${i}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageUrl}#reviewList"
                                            style="padding:8px 12px; border:1px solid #ddd; border-radius:6px; text-decoration:none; color:#0f172a;">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <c:url var="nextPageUrl" value='/orders/reviews'>
                                    <c:param name="page" value="${currentPage + 1}" />
                                    <c:param name="size" value="${pageSize}" />
                                </c:url>
                                <a href="${nextPageUrl}#reviewList"
                                    style="padding:8px 12px; border:1px solid #ddd; border-radius:6px; text-decoration:none; color:#0f172a; background:#fff;">»</a>
                            </c:if>
                        </div>
                    </c:if>
                    </c:otherwise>
                    </c:choose>
                    </div>

                    <jsp:include page="../layout/footer.jsp" />

                    <script>
                        document.addEventListener('DOMContentLoaded', function () {
                            document.querySelectorAll('.btn-toggle-review').forEach(btn => {
                                btn.addEventListener('click', () => {
                                    const targetId = btn.getAttribute('data-target');
                                    const form = document.getElementById(targetId);
                                    if (form) {
                                        form.classList.toggle('active');
                                    }
                                });
                            });
                        });
                    </script>
                </body>

                </html>