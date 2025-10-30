<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Alert Messages (reuse master.jsp top alerts too) -->
<c:if test="${not empty success}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fas fa-check-circle me-2"></i>
        ${success}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    </c:if>
<c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="fas fa-exclamation-circle me-2"></i>
        ${error}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<!-- Filter + Search -->
<div class="card border-0 shadow-sm mb-3">
    <div class="card-body">
        <form class="row g-2 align-items-end" method="get" action="${pageContext.request.contextPath}/admin/seller/list">
            <div class="col-12 col-md-4">
                <label class="form-label">Tìm kiếm</label>
                <input type="text" class="form-control" name="q" value="${q}" placeholder="Tên shop, email, chủ shop">
            </div>
            <div class="col-6 col-md-3">
                <label class="form-label">Trạng thái duyệt</label>
                <select class="form-select" name="verify">
                    <option value="">Tất cả</option>
                    <c:forEach var="vs" items="${verifyStatuses}">
                        <option value="${vs}" ${filterVerify == vs ? 'selected' : ''}>${vs}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-6 col-md-3">
                <label class="form-label">Tài khoản</label>
                <select class="form-select" name="userStatus">
                    <option value="">Tất cả</option>
                    <c:forEach var="us" items="${userStatuses}">
                        <option value="${us}" ${filterUserStatus == us ? 'selected' : ''}>${us}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-6 col-md-2">
                <label class="form-label">Kích thước trang</label>
                <select class="form-select" name="size">
                    <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                    <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                    <option value="30" ${pageSize == 30 ? 'selected' : ''}>30</option>
                    <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                </select>
            </div>
            <div class="col-12 col-md-12">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-search me-1"></i> Lọc
                </button>
                <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/seller/list">Xóa lọc</a>
            </div>
        </form>
    </div>
    </div>

<!-- Shops Table -->
<div class="card border-0 shadow-sm">
    <div class="card-header bg-white py-3">
        <div class="row align-items-center">
            <div class="col">
                <h5 class="mb-0">Danh sách Shop</h5>
            </div>
        </div>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead class="bg-light">
                    <tr>
                        <th style="width: 80px;" class="py-3">Shop ID</th>
                        <th style="width: 200px;" class="py-3">Shop</th>
                        <th class="py-3">Chủ shop (email)</th>
                        <th class="py-3">Trạng thái</th>
                        <th style="width: 180px;" class="py-3">Ngày tạo</th>
                        <th style="width: 200px;" class="py-3 text-center">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="s" items="${shops}">
                        <tr>
                            <td class="align-middle fw-bold">#${s.id}</td>
                            <td class="align-middle">
                                <div class="d-flex align-items-center">
                                    <div class="shop-avatar rounded-3 bg-secondary bg-opacity-10 text-secondary p-2 me-3">
                                        <i class="fas fa-store"></i>
                                    </div>
                                    <div>
                                        <div class="fw-semibold">${s.displayName}</div>
                                        <div class="small text-muted">${s.description}</div>
                                    </div>
                                </div>
                            </td>
                            <td class="align-middle">
                                <div class="fw-medium">${s.user.fullName}</div>
                                <div class="small text-muted">${s.user.email}</div>
                            </td>
                            <td class="align-middle">
                                <div class="d-flex flex-column">
                                    <div>
                                        <span class="badge ${s.user.status == 'ACTIVE' ? 'bg-success' : 'bg-danger'}">
                                            ${s.user.status}
                                        </span>
                                        <span class="badge bg-info ms-2">${s.verifyStatus}</span>
                                    </div>
                                    <c:if test="${not empty s.user.deactivationReason && s.user.status == 'INACTIVE'}">
                                        <div class="small text-muted mt-1">Lý do: ${s.user.deactivationReason}</div>
                                    </c:if>
                                </div>
                            </td>
                            <td class="align-middle">
                                <div class="small text-muted mb-1">Tạo ngày</div>
                                <div class="fw-medium">${s.createdAt}</div>
                            </td>
                            <td class="align-middle text-center">
                                <div class="d-flex gap-2 justify-content-center">
                                    <!-- Lock/Unlock forms -->
                                    <c:choose>
                                        <c:when test="${s.user.status == 'ACTIVE'}">
                                            <form method="post" class="d-inline-block m-0" action="${pageContext.request.contextPath}/admin/seller/${s.id}/lock">
                                                <c:if test="${_csrf != null}">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                </c:if>
                                                <input type="hidden" name="reason" value="Vi phạm chính sách hoặc theo yêu cầu quản trị" />
                                                <button class="btn btn-danger btn-sm px-3" type="submit" title="Khóa shop và tài khoản">
                                                    <i class="fas fa-lock me-1"></i> Khóa
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <form method="post" class="d-inline-block m-0" action="${pageContext.request.contextPath}/admin/seller/${s.id}/unlock">
                                                <c:if test="${_csrf != null}">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                </c:if>
                                                <button class="btn btn-success btn-sm px-3" type="submit" title="Mở khóa shop và bán lại">
                                                    <i class="fas fa-unlock me-1"></i> Mở khóa
                                                </button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty shops}">
                        <tr>
                            <td colspan="6" class="text-center py-5">
                                <div class="d-flex flex-column align-items-center">
                                    <div class="text-muted mb-3">
                                        <i class="fas fa-inbox fa-3x"></i>
                                    </div>
                                    <h6 class="fw-medium mb-1">Không có shop nào</h6>
                                    <p class="text-muted small mb-0">Hệ thống chưa có dữ liệu shop.</p>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Pagination -->
    <div class="card-footer bg-white py-3">
        <div class="row align-items-center">
            <div class="col">
                <small class="text-muted">Trang ${currentPage}/${totalPages} • Tổng ${totalElements} shop</small>
            </div>
            <div class="col-auto">
                <nav aria-label="Page navigation">
                    <ul class="pagination pagination-sm mb-0">
                        <c:set var="prevPage" value="${currentPage - 1}" />
                        <c:set var="nextPage" value="${currentPage + 1}" />
                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                            <a class="page-link"
                               href="<c:url value='/admin/seller/list'><c:param name='page' value='${prevPage}'/><c:param name='size' value='${pageSize}'/><c:param name='q' value='${q}'/><c:param name='verify' value='${filterVerify}'/><c:param name='userStatus' value='${filterUserStatus}'/></c:url>">
                                <i class="fas fa-chevron-left"></i>
                            </a>
                        </li>
                        <li class="page-item disabled"><a class="page-link" href="#">${currentPage}</a></li>
                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                            <a class="page-link"
                               href="<c:url value='/admin/seller/list'><c:param name='page' value='${nextPage}'/><c:param name='size' value='${pageSize}'/><c:param name='q' value='${q}'/><c:param name='verify' value='${filterVerify}'/><c:param name='userStatus' value='${filterUserStatus}'/></c:url>">
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</div>
