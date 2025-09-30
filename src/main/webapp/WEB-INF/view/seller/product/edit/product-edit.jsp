<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <c:set var="pageTitle" value="Chỉnh sửa sản phẩm" scope="request" />
        <c:set var="additionalCSS" value="${'/resources/seller/css/product-edit.css'}" scope="request" />
        <c:set var="additionalJS" value="${['/resources/seller/js/product-edit.js']}" scope="request" />

        <c:set var="contentPage" value="/WEB-INF/view/seller/product/edit/product-edit-content.jsp" scope="request" />

        <%@ include file="../../layout/master.jsp" %>