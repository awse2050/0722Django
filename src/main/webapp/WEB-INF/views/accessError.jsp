<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>접근 거부</h1>
<h2><c:out value="${SPRING_SECURITY_403_EXCEPTION.getMessage() }"/></h2>
<h2><c:out value="${msg}"/></h2>

</body>
</html>