<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Filter + Search (aligned with Shop list) -->
<div class="card border-0 shadow-sm mb-3">
    <div class="card-body">
        <form method="get" action="${pageContext.request.contextPath}/admin/reviews/products" class="row g-2 align-items-end">
            <div class="col-12 col-md-3">
                <label class="form-label">Product ID</label>
                <input type="number" class="form-control" name="productId" value="${productId}" min="1" placeholder="VD: 123" />
            </div>
            <div class="col-6 col-md-3">
                <label class="form-label">Trạng thái hiển thị</label>
                <select name="visible" class="form-select">
                    <option value="" ${visible == null ? 'selected' : ''}>Tất cả</option>
                    <option value="true" ${visible == true ? 'selected' : ''}>Hiển thị</option>
                    <option value="false" ${visible == false ? 'selected' : ''}>Đã ẩn</option>
                </select>
            </div>
            <div class="col-12 col-md-4">
                <label class="form-label">Tìm kiếm</label>
                <input type="text" class="form-control" name="q" value="${q}" placeholder="Sản phẩm, người dùng, tiêu đề, nội dung"/>
            </div>
            <div class="col-6 col-md-2">
                <label class="form-label">Kích thước trang</label>
                <select name="size" class="form-select">
                    <c:set var="_size" value="${empty size ? 10 : size}"/>
                    <option value="10" ${_size == 10 ? 'selected' : ''}>10</option>
                    <option value="20" ${_size == 20 ? 'selected' : ''}>20</option>
                    <option value="50" ${_size == 50 ? 'selected' : ''}>50</option>
                </select>
            </div>
            <div class="col-12">
                <button class="btn btn-primary" type="submit">
                    <i class="fas fa-filter me-1"></i> Lọc
                </button>
                <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/reviews/products">Xóa lọc</a>
            </div>
        </form>
    </div>
</div>

<div class="card border-0 shadow-sm">
    <div class="card-header bg-white py-3">
        <div class="row align-items-center">
            <div class="col">
                <h5 class="mb-0">Đánh giá sản phẩm</h5>
            </div>
            <div class="col-auto d-none">
                <form method="get" action="${pageContext.request.contextPath}/admin/reviews/products" class="d-flex gap-2">
                    <input type="number" class="form-control form-control-sm" name="productId" value="${productId}" placeholder="Product ID" min="1"/>
                    <select name="visible" class="form-select form-select-sm">
                        <option value="" ${visible == null ? 'selected' : ''}>Tất cả</option>
                        <option value="true" ${visible == true ? 'selected' : ''}>Hiển thị</option>
                        <option value="false" ${visible == false ? 'selected' : ''}>Đã ẩn</option>
                    </select>
                    <input type="text" class="form-control form-control-sm" name="q" value="${q}" placeholder="Tìm sản phẩm, người dùng, tiêu đề, nội dung"/>
                    <select name="size" class="form-select form-select-sm">
                        <c:set var="_size" value="${empty size ? 10 : size}"/>
                        <option value="10" ${_size == 10 ? 'selected' : ''}>10</option>
                        <option value="20" ${_size == 20 ? 'selected' : ''}>20</option>
                        <option value="50" ${_size == 50 ? 'selected' : ''}>50</option>
                    </select>
                    <button class="btn btn-sm btn-primary" type="submit">
                        <i class="fas fa-filter me-1"></i> Lọc
                    </button>
                    <a class="btn btn-sm btn-light" href="${pageContext.request.contextPath}/admin/reviews/products">Xóa lọc</a>
                </form>
            </div>
        </div>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table align-middle">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Sản phẩm</th>
                    <th>Người dùng</th>
                    <th>Đánh giá</th>
                    <th>Tiêu đề</th>
                    <th>Nội dung</th>
                    <th>Tạo lúc</th>
                    <th>Trạng thái</th>
                    <th class="text-center">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:set var="startIndex" value="${(currentPage-1) * size}"/>
                <c:forEach var="r" items="${reviews}" varStatus="s">
                    <tr>
                        <td>${startIndex + s.index + 1}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty r.product}">
                                    <a href="${pageContext.request.contextPath}/product/${r.product.id}" target="_blank">
                                        <c:out value='${r.product.name}'/>
                                    </a>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                        <td><c:out value='${r.user.fullName}'/></td>
                        <td>
                            <span class="text-warning">
                                <c:forEach var="i" begin="1" end="5">
                                    <i class="fa${i <= r.rating ? 's' : 'r'} fa-star"></i>
                                </c:forEach>
                            </span>
                        </td>
                        <td><c:out value='${r.title}'/></td>
                        <td style="max-width: 350px">
                            <div class="text-truncate" style="max-width: 340px"><c:out value='${r.comment}'/></div>
                        </td>
                        <td>${r.createdAt}</td>
                        <td>
                            <c:choose>
                                <c:when test='${r.visible}'>
                                    <span class="badge bg-success">Hiển thị</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">Đã ẩn</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test='${r.visible}'>
                                    <form method="post" class="d-inline-block m-0" action="${pageContext.request.contextPath}/admin/reviews/${r.id}/hide">
                                        <c:if test='${not empty productId}'>
                                            <input type="hidden" name="productId" value="${productId}"/>
                                        </c:if>
                                        <c:if test='${visible != null}'>
                                            <input type="hidden" name="visible" value="${visible}"/>
                                        </c:if>
                                        <c:if test='${not empty q}'>
                                            <input type="hidden" name="q" value="${q}"/>
                                        </c:if>
                                        <input type="hidden" name="page" value="${currentPage}"/>
                                        <input type="hidden" name="size" value="${size}"/>
                                        <button class="btn btn-sm btn-outline-danger" type="submit"><i class="fas fa-eye-slash me-1"></i>Ẩn</button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <form method="post" class="d-inline-block m-0" action="${pageContext.request.contextPath}/admin/reviews/${r.id}/unhide">
                                        <c:if test='${not empty productId}'>
                                            <input type="hidden" name="productId" value="${productId}"/>
                                        </c:if>
                                        <c:if test='${visible != null}'>
                                            <input type="hidden" name="visible" value="${visible}"/>
                                        </c:if>
                                        <c:if test='${not empty q}'>
                                            <input type="hidden" name="q" value="${q}"/>
                                        </c:if>
                                        <input type="hidden" name="page" value="${currentPage}"/>
                                        <input type="hidden" name="size" value="${size}"/>
                                        <button class="btn btn-sm btn-success" type="submit"><i class="fas fa-eye me-1"></i>Hiện</button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test='${empty reviews}'>
                    <tr>
                        <td colspan="9" class="text-center py-5">
                            <div class="d-flex flex-column align-items-center">
                                <div class="text-muted mb-3">
                                    <i class="fas fa-inbox fa-3x"></i>
                                </div>
                                <h6 class="fw-medium mb-1">Không có đánh giá nào</h6>
                                <p class="text-muted small mb-0">Hệ thống chưa ghi nhận đánh giá phù hợp bộ lọc</p>
                            </div>
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>

    </div>
    <div class="card-footer bg-white py-3">
        <div class="row align-items-center">
            <div class="col">
                <small class="text-muted">Trang ${currentPage}/${totalPages} • Tổng ${totalElements} đánh giá</small>
            </div>
            <div class="col-auto">
                <nav aria-label="Page navigation">
                    <ul class="pagination pagination-sm mb-0">
                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/reviews/products?productId=${productId}&visible=${visible}&q=${q}&size=${size}&page=${currentPage - 1}"><i class="fas fa-chevron-left"></i></a>
                        </li>
                        <li class="page-item disabled"><a class="page-link" href="#">${currentPage}</a></li>
                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/reviews/products?productId=${productId}&visible=${visible}&q=${q}&size=${size}&page=${currentPage + 1}"><i class="fas fa-chevron-right"></i></a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
    </div>
</div>
