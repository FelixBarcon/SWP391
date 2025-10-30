<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${empty pageTitle}">
    <c:set var="pageTitle" value="Chi tiết đơn hàng" scope="request" />
</c:if>
<c:if test="${empty pageDescription}">
    <c:set var="pageDescription" value="Thông tin chi tiết đơn hàng" scope="request" />
</c:if>

<c:set var="contentPage" value="../order/order-detail-content.jsp" scope="request" />

<jsp:include page="../layout/master.jsp" />

