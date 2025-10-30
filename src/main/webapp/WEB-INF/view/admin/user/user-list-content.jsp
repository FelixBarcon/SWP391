<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Filter + Search (aligned with Shop list) -->
<div class="card border-0 shadow-sm mb-3">
    <div class="card-body">
        <form class="row g-2 align-items-end" method="get" action="${pageContext.request.contextPath}/admin/user">
            <div class="col-12 col-md-4">
                <label class="form-label">Tìm kiếm</label>
                <input type="text" class="form-control" name="q" value="${q}" placeholder="Tên, email hoặc SĐT">
            </div>
            <div class="col-6 col-md-3">
                <label class="form-label">Trạng thái</label>
                <select class="form-select" name="status">
                    <option value="" ${filterStatus == null ? 'selected' : ''}>Tất cả</option>
                    <option value="ACTIVE" ${filterStatus == 'ACTIVE' ? 'selected' : ''}>Đang hoạt động</option>
                    <option value="INACTIVE" ${filterStatus == 'INACTIVE' ? 'selected' : ''}>Đã khóa</option>
                </select>
            </div>
            <div class="col-6 col-md-3">
                <label class="form-label">Vai trò</label>
                <select class="form-select" name="role">
                    <option value="" ${empty filterRole ? 'selected' : ''}>Tất cả</option>
                    <c:forEach var="r" items="${roles}">
                        <option value="${r.name}" ${filterRole == r.name ? 'selected' : ''}>${r.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-6 col-md-2">
                <label class="form-label">Kích thước trang</label>
                <select class="form-select" name="size">
                    <c:set var="ps" value="${pageSize != null ? pageSize : 10}"/>
                    <option value="10" ${ps == 10 ? 'selected' : ''}>10</option>
                    <option value="20" ${ps == 20 ? 'selected' : ''}>20</option>
                    <option value="30" ${ps == 30 ? 'selected' : ''}>30</option>
                    <option value="50" ${ps == 50 ? 'selected' : ''}>50</option>
                </select>
            </div>
            <div class="col-12">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-filter me-1"></i> Lọc
                </button>
                <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/user">Xóa lọc</a>
            </div>
        </form>
    </div>
    </div>

<div class="card border-0 shadow-sm">
    <div class="card-header bg-white py-3">
        <div class="row align-items-center">
            <div class="col">
                <h5 class="mb-0">Danh sách người dùng</h5>
            </div>
            <div class="col-auto d-none">
                <form method="get" action="${pageContext.request.contextPath}/admin/user" class="d-flex gap-2">
                    <input type="hidden" name="page" value="1"/>
                    <input type="hidden" name="size" value="${pageSize != null ? pageSize : 10}"/>
                    <input type="text" name="q" value="${q}" class="form-control form-control-sm" placeholder="Tìm tên, email hoặc SĐT"/>
                    <select name="status" class="form-select form-select-sm">
                        <option value="" ${filterStatus == null ? 'selected' : ''}>Tất cả trạng thái</option>
                        <option value="ACTIVE" ${filterStatus == 'ACTIVE' ? 'selected' : ''}>Đang hoạt động</option>
                        <option value="INACTIVE" ${filterStatus == 'INACTIVE' ? 'selected' : ''}>Đã khóa</option>
                    </select>
                    <select name="role" class="form-select form-select-sm">
                        <option value="" ${empty filterRole ? 'selected' : ''}>Tất cả vai trò</option>
                        <c:forEach var="r" items="${roles}">
                            <option value="${r.name}" ${filterRole == r.name ? 'selected' : ''}>${r.name}</option>
                        </c:forEach>
                    </select>
                    <button class="btn btn-sm btn-primary" type="submit">
                        <i class="fas fa-search me-1"></i> Lọc
                    </button>
                    <a class="btn btn-sm btn-light" href="${pageContext.request.contextPath}/admin/user">Xóa lọc</a>
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
                    <th>Họ tên</th>
                    <th>Email</th>
                    <th>Vai trò</th>
                    <th>Trạng thái</th>
                    <th class="text-center">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:set var="startIndex" value="${(currentPage-1) * pageSize}"/>
                <c:forEach var="u" items="${users}" varStatus="s">
                    <tr>
                        <td class="align-middle">${startIndex + s.index + 1}</td>
                        <td class="align-middle">
                            <div class="d-flex align-items-center gap-2">
                                <div>
                                    <div class="fw-medium">${u.fullName}</div>
                                </div>
                            </div>
                        </td>
                        <td class="align-middle">${u.email}</td>
                        <td class="align-middle">
                            <c:choose>
                                <c:when test="${u.role != null}">${u.role.name}</c:when>
                                <c:otherwise>USER</c:otherwise>
                            </c:choose>
                        </td>
                        <td class="align-middle">
                            <c:choose>
                                <c:when test="${u.active}">
                                    <span class="badge bg-success">Đang hoạt động</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger">Đã khóa</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="align-middle">
                            <div class="d-flex gap-2 justify-content-center">
                                <c:choose>
                                    <c:when test="${u.active}">
                                        <button class="btn btn-sm btn-outline-danger" data-bs-toggle="modal"
                                                data-bs-target="#deactivateModal-${u.id}">
                                            <i class="fas fa-user-slash me-1"></i> Khóa
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <form method="post" class="d-inline-block m-0"
                                              action="${pageContext.request.contextPath}/admin/user/${u.id}/restore">
                                            <c:if test="${_csrf != null}">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            </c:if>
                                            <button class="btn btn-sm btn-success" type="submit">
                                                <i class="fas fa-undo me-1"></i> Khôi phục
                                            </button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <!-- Deactivate Modal -->
                            <div class="modal fade" id="deactivateModal-${u.id}" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title">Khóa tài khoản #${u.id}</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/user/${u.id}/deactivate">
                                            <div class="modal-body">
                                                <div class="mb-3">
                                                    <label class="form-label">Lý do (sẽ gửi qua email cho người dùng)</label>
                                                    <textarea name="reason" class="form-control" rows="3" placeholder="Nhập lý do khóa tài khoản..."></textarea>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                                                <c:if test="${_csrf != null}">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                </c:if>
                                                <button type="submit" class="btn btn-danger">Xác nhận khóa</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty users}">
                    <tr>
                        <td colspan="6" class="text-center py-5">
                            <div class="d-flex flex-column align-items-center">
                                <div class="text-muted mb-3">
                                    <i class="fas fa-users fa-3x"></i>
                                </div>
                                <h6 class="fw-medium mb-1">Chưa có người dùng nào</h6>
                                <p class="text-muted small mb-0">Hệ thống chưa ghi nhận người dùng</p>
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
                <small class="text-muted">Trang ${currentPage}/${totalPages} • Tổng ${totalElements} người dùng</small>
            </div>
            <div class="col-auto">
                <nav aria-label="Page navigation">
                    <ul class="pagination pagination-sm mb-0">
                        <c:set var="prevPage" value="${currentPage - 1}" />
                        <c:set var="nextPage" value="${currentPage + 1}" />
                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                            <a class="page-link" href="<c:url value='/admin/user'><c:param name='page' value='${prevPage}'/><c:param name='size' value='${pageSize}'/><c:param name='q' value='${q}'/><c:param name='status' value='${filterStatus}'/><c:param name='role' value='${filterRole}'/></c:url>"><i class="fas fa-chevron-left"></i></a>
                        </li>
                        <li class="page-item disabled"><a class="page-link" href="#">${currentPage}</a></li>
                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="<c:url value='/admin/user'><c:param name='page' value='${nextPage}'/><c:param name='size' value='${pageSize}'/><c:param name='q' value='${q}'/><c:param name='status' value='${filterStatus}'/><c:param name='role' value='${filterRole}'/></c:url>"><i class="fas fa-chevron-right"></i></a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</div>
