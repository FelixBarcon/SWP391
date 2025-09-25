<%@ page contentType="text/html; charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- Stats Overview -->
        <div class="row g-4 mb-4">
            <!-- Total Requests Card -->
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card border-0 shadow-sm">
                    <div class="card-body">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <h6 class="card-title mb-1">Tổng yêu cầu</h6>
                                <h3 class="mb-0 fw-bold">${pending.size()}</h3>
                            </div>
                            <div class="rounded-3 p-3 bg-primary bg-opacity-10">
                                <i class="fas fa-store text-primary fs-4"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Pending Time Card -->
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card border-0 shadow-sm">
                    <div class="card-body">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <h6 class="card-title mb-1">Thời gian chờ TB</h6>
                                <h3 class="mb-0 fw-bold">2.5 ngày</h3>
                            </div>
                            <div class="rounded-3 p-3 bg-warning bg-opacity-10">
                                <i class="fas fa-clock text-warning fs-4"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Approved Today Card -->
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card border-0 shadow-sm">
                    <div class="card-body">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <h6 class="card-title mb-1">Đã duyệt hôm nay</h6>
                                <h3 class="mb-0 fw-bold">5</h3>
                            </div>
                            <div class="rounded-3 p-3 bg-success bg-opacity-10">
                                <i class="fas fa-check-circle text-success fs-4"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Rejected Today Card -->
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card border-0 shadow-sm">
                    <div class="card-body">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <h6 class="card-title mb-1">Đã từ chối hôm nay</h6>
                                <h3 class="mb-0 fw-bold">2</h3>
                            </div>
                            <div class="rounded-3 p-3 bg-danger bg-opacity-10">
                                <i class="fas fa-times-circle text-danger fs-4"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Alert Messages -->
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

        <!-- Main Content Card -->
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3">
                <div class="row align-items-center">
                    <div class="col">
                        <h5 class="mb-0">Danh sách yêu cầu đang chờ duyệt</h5>
                    </div>
                    <div class="col-auto">
                        <div class="dropdown">
                            <button class="btn btn-light btn-sm dropdown-toggle" type="button"
                                data-bs-toggle="dropdown">
                                <i class="fas fa-filter me-1"></i> Lọc
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="#">Mới nhất</a></li>
                                <li><a class="dropdown-item" href="#">Cũ nhất</a></li>
                                <li>
                                    <hr class="dropdown-divider">
                                </li>
                                <li><a class="dropdown-item" href="#">Tất cả trạng thái</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="bg-light">
                            <tr>
                                <th class="py-3" style="width: 80px;">Shop ID</th>
                                <th class="py-3" style="width: 80px;">User ID</th>
                                <th class="py-3" style="width: 200px;">Thông tin Shop</th>
                                <th class="py-3">Thông tin liên hệ</th>
                                <th class="py-3" style="width: 200px;">Thông tin thanh toán</th>
                                <th class="py-3" style="width: 180px;">Thời gian</th>
                                <th class="py-3 text-center" style="width: 230px;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody class="border-top-0">
                            <c:forEach var="s" items="${pending}">
                                <tr>
                                    <td class="align-middle">
                                        <span class="fw-bold">#
                                            <c:out value="${s.id}" />
                                        </span>
                                    </td>
                                    <td class="align-middle">
                                        <span class="fw-bold">#
                                            <c:out value="${s.user.id}" />
                                        </span>
                                    </td>
                                    <td class="align-middle">
                                        <div class="d-flex align-items-center">
                                            <div
                                                class="shop-avatar rounded-3 bg-secondary bg-opacity-10 text-secondary p-2 me-3">
                                                <i class="fas fa-store"></i>
                                            </div>
                                            <div>
                                                <h6 class="mb-1">
                                                    <c:out value="${s.displayName}" />
                                                </h6>
                                                <p class="small text-muted mb-0">
                                                    <c:out value="${s.description}" />
                                                </p>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="align-middle">
                                        <div>
                                            <div class="mb-1">
                                                <i class="fas fa-phone-alt text-muted me-2"></i>
                                                <c:out value="${s.contactPhone}" />
                                            </div>
                                            <div>
                                                <i class="fas fa-map-marker-alt text-muted me-2"></i>
                                                <c:out value="${s.pickupAddress}" />
                                            </div>
                                        </div>
                                    </td>
                                    <td class="align-middle">
                                        <div>
                                            <div class="mb-1">
                                                <span class="badge bg-primary me-2">
                                                    <c:out value="${s.bankCode}" />
                                                </span>
                                            </div>
                                            <div class="small">
                                                <span class="text-muted">STK:</span>
                                                <span class="fw-medium">
                                                    <c:out value="${s.bankAccountNo}" />
                                                </span>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="align-middle">
                                        <div>
                                            <div class="small text-muted mb-1">Đăng ký:</div>
                                            <div class="fw-medium">24/09/2025 14:30</div>
                                        </div>
                                    </td>
                                    <td class="align-middle text-center">
                                        <div class="d-flex gap-2 justify-content-center">
                                            <form method="post" class="d-inline-block m-0"
                                                action="${pageContext.request.contextPath}/admin/seller/${s.id}/approve">
                                                <c:if test="${_csrf != null}">
                                                    <input type="hidden" name="${_csrf.parameterName}"
                                                        value="${_csrf.token}" />
                                                </c:if>
                                                <button class="btn btn-success btn-sm px-3" type="submit"
                                                    title="Duyệt yêu cầu">
                                                    <i class="fas fa-check me-1"></i> Duyệt
                                                </button>
                                            </form>
                                            <form method="post" class="d-inline-block m-0"
                                                action="${pageContext.request.contextPath}/admin/seller/${s.id}/reject">
                                                <c:if test="${_csrf != null}">
                                                    <input type="hidden" name="${_csrf.parameterName}"
                                                        value="${_csrf.token}" />
                                                </c:if>
                                                <button class="btn btn-danger btn-sm px-3" type="submit"
                                                    title="Từ chối yêu cầu">
                                                    <i class="fas fa-times me-1"></i> Từ chối
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty pending}">
                                <tr>
                                    <td colspan="7" class="text-center py-5">
                                        <div class="d-flex flex-column align-items-center">
                                            <div class="text-muted mb-3">
                                                <i class="fas fa-inbox fa-3x"></i>
                                            </div>
                                            <h6 class="fw-medium mb-1">Không có yêu cầu nào</h6>
                                            <p class="text-muted small mb-0">Tất cả yêu cầu đã được xử lý</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Card Footer with Pagination -->
            <div class="card-footer bg-white py-3">
                <div class="row align-items-center">
                    <div class="col">
                        <small class="text-muted">Hiển thị 1-${pending.size()} trong tổng số ${pending.size()} yêu
                            cầu</small>
                    </div>
                    <div class="col-auto">
                        <nav aria-label="Page navigation">
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item disabled">
                                    <a class="page-link" href="#"><i class="fas fa-chevron-left"></i></a>
                                </li>
                                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                <li class="page-item disabled">
                                    <a class="page-link" href="#"><i class="fas fa-chevron-right"></i></a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>