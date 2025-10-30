<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${empty pageTitle}">
    <c:set var="pageTitle" value="Đơn hàng" scope="request" />
</c:if>
<c:if test="${empty pageDescription}">
    <c:set var="pageDescription" value="Danh sách đơn hàng của shop" scope="request" />
</c:if>

<c:set var="contentPage" value="../order/orders-content.jsp" scope="request" />

<jsp:include page="../layout/master.jsp" />

