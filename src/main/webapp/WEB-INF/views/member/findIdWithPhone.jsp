
<%--
  Created by IntelliJ IDEA.
  User: rooet
  Date: 2021-11-24
  Time: 오전 1:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <title>아이디 찾기 | MUSCLE</title>
</head>
<body>
<h1>아이디 찾기 결과</h1>
<div class="bg-div">
<c:if test="${result == 0}">
    <p>찾으시는 아이디가 존재하지 않습니다.</p>
</c:if>

<c:if test="${map != null && map != ''}">
    <c:forEach var="result" items="${map}">
        <li>
            <ul>${result}</ul>
        </li>
    </c:forEach>
</c:if>
<button onclick="location.href='${pageContext.request.contextPath}/member/openLoginForm'">로그인</button>
<a href="#" onclick="javascript:history.go(-1);">뒤로가기</a>
<a href="<c:url value='/member/findPw'/>">비밀번호가 기억나지 않으세요?</a>
</div>
</body>
</html>
