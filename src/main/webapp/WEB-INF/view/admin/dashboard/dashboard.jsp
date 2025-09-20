<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- Set page variables for master layout -->
        <c:set var="pageTitle" value="Dashboard" scope="request" />
        <c:set var="pageDescription" value="Tổng quan hệ thống quản lý ShopMart" scope="request" />
        <c:set var="contentPage" value="../dashboard/dashboard-content.jsp" scope="request" />

        <!-- Include master layout -->
        <jsp:include page="../layout/master.jsp" />