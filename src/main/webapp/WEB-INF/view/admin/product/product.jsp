<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- Set page variables for master layout -->
        <c:set var="pageTitle" value="Quản lý sản phẩm" scope="request" />
        <c:set var="pageDescription" value="Danh sách sản phẩm trong hệ thống" scope="request" />
        <c:set var="contentPage" value="../product/product-content.jsp" scope="request" />

        <!-- Include master layout -->
        <jsp:include page="../layout/master.jsp" />