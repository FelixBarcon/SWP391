<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <c:set var="pageTitle" value="Thêm sản phẩm mới" scope="request" />
        <c:set var="additionalCSS" value="${['/resources/seller/css/product-create.css']}" scope="request" />
        <c:set var="additionalJS" value="${['/resources/seller/js/product-form.js']}" scope="request" />

        <c:set var="contentPage" value="/WEB-INF/view/seller/product/create/product-create-content.jsp"
            scope="request" />

        <%@ include file="../../layout/master.jsp" %>