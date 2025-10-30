<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../layout/master.jsp">
    <jsp:param name="pageTitle" value="${pageTitle}" />
    <jsp:param name="pageDescription" value="${pageDescription}" />
    <jsp:param name="contentPage" value="${contentPage}" />
    <jsp:param name="breadcrumb" value="${breadcrumb}" />
    <jsp:param name="pageActions" value="${pageActions}" />
    <jsp:param name="additionalCSS" value="${additionalCSS}" />
    <jsp:param name="additionalJS" value="${additionalJS}" />
    <jsp:param name="inlineJS" value="${inlineJS}" />
    <jsp:param name="successMessage" value="${successMessage}" />
    <jsp:param name="errorMessage" value="${errorMessage}" />
    <jsp:param name="warningMessage" value="${warningMessage}" />
    <jsp:param name="infoMessage" value="${infoMessage}" />
 </jsp:include>

