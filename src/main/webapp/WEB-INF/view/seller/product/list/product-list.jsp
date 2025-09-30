<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- Set page variables for master layout -->
        <c:set var="pageTitle" value="Danh sách sản phẩm" scope="request" />
        <c:set var="pageDescription" value="Quản lý sản phẩm của cửa hàng" scope="request" />
        <c:set var="contentPage" value="../product/list/product-list-content.jsp" scope="request" />

        <!-- Add product list specific CSS - Shopee Style -->
        <c:set var="additionalCSS">
            <c:url value='/resources/seller/css/seller-product-list.css' />
        </c:set>
        <c:set var="additionalCSS" value="${additionalCSS}" scope="request" />

        <!-- Include master layout -->
        <jsp:include page="../../layout/master.jsp" />