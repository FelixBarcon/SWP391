<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- Set page variables for master layout -->
        <c:set var="pageTitle" value="Dashboard" scope="request" />
        <c:set var="pageDescription" value="Tổng quan hệ thống quản lý ShopMart" scope="request" />
        <c:set var="contentPage" value="../dashboard/dashboard-content.jsp" scope="request" />

        <!-- Add dashboard specific CSS -->
        <c:set var="additionalCSS">
            <c:url value='/resources/admin/css/admin-dashboard.css' />
        </c:set>
        <c:set var="additionalCSS" value="${additionalCSS}" scope="request" />

        <!-- Dashboard JavaScript is now embedded in dashboard-content.jsp -->
        <!-- No need for external JS file -->
        <%-- <c:set var="additionalJS">
            <c:url value='/resources/admin/js/admin-dashboard-charts.js' />
            </c:set>
            <c:set var="additionalJS" value="${additionalJS}" scope="request" />
            --%>

            <!-- Include master layout -->
            <jsp:include page="../layout/master.jsp" />