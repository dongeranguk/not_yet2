<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>  
<meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
  <script src="<c:url value='/js/common.js'/>" charset="utf-8"></script>
<title>아이디 찾기</title>
	<style>
		.container {
			border: 1px solid gray;
			padding: 5px 20px;
			width: 50%;
			height: 70%;

			display: flex;
			flex-direction: column;
			justify-content: center;
			align-items: center;
		}
	</style>
</head>
<script>
function search_check(num) {
	if (num == '1') {
		document.getElementById("searchPW").style.display = "none";
		document.getElementById("searchID").style.display = "";
	} else {
		document.getElementById("searchID").style.display = "none";
		document.getElementById("searchPW").style.display = "";
	}
}

$(document).ready(function() {

	$("#searchBtn").click(function(){
	    $("#modal").removeAttr("class").addClass("three");
	});

	$(".close").click(function(){
	    $("#modal").addClass("out");
	});

	
});



var idSearch_click = function(){
	var name = $("#MEM_NAME").val();
	$.ajax({
		type:"POST",
		url:"${pageContext.request.contextPath}/member/openFindIdResult?MEM_NAME="
				+name+"&MEM_EMAIL="+$('#MEM_EMAIL').val(),
		success:function(data){
			if(data == "0"){
				alert("일치하는 회원이 없습니다.");
				
			} else{
				alert("회원님의 아이디는 " + data + "입니다.");
			}
		}
	}); 
}



var pwSearch_click = function(){
	var params = {
		MEM_ID : $("#MEM_ID").val(),
		MEM_EMAIL : $("#MEM_EMAIL2").val(),
		authCode : $("#random").val()
	}

	/*var id = $('#MEM_ID').val();
	var email = $('#MEM_EMAIL').val();
	alert("요청하신 정보를 확인 중 입니다..\n최대 10초의 시간이 소요될 수 있습니다.\n확인 버튼을 눌러주세요.");*/
	$.ajax({
		type:"POST",
		url : "<c:url value='/member/openFindPwResult'/>",
		data : params,
		success : function(data){
			if(data == true){
			alert("임시비밀번호를 발송하였습니다.");
			window.location = "/muscle/member/openLoginForm";
			}else{
				alert("아이디 혹은 이메일을 잘못 입력하셨습니다.\n다시 한번 입력 바랍니다.");
			}
		},
		error: function(data){
			alert("에러가 발생했습니다.");
			return false;
		}
	});
	
}


</script>
<body>
<%@ include file="/WEB-INF/views/template/header.jsp"%>
<div style="height: 160px;"></div>
<div align="center">
   <h3>Login</h3> 
</div>
<div style="height: 30px;"></div>

<div class="container">
	<div id="searchtest">
		<input type="button" id="testsearchID" name="searchID" value="아이디 찾기" onclick="search_check(1)" class="btn btn-primary"/>
		<input type="button" id="testsearchPW" name="searchPW" value="비밀번호 찾기" onclick="search_check(2)" class="btn btn-primary"/>
	</div>
	<div style="margin-bottom: 10px;" class="custom-control custom-radio custom-control-inline">
		<input type="radio" class="custom-control-input" id="search_1" name="search_total" onclick="search_check(1)" checked="checked">
		<label class="custom-control-label font-weight-bold text-black"	for="search_1">아이디 찾기</label>
	</div>
	<div class="custom-control custom-radio custom-control-inline">
		<input type="radio" class="custom-control-input" id="search_2" name="search_total" onclick="search_check(2)"> 
		<label class="custom-control-label font-weight-bold text-black" for="search_2">비밀번호 찾기</label>
	</div>
	
					<!-- 아이디 찾기 -->
				<div id="searchID">
					<div class="form-group">
						<label class="text-black" for="inputName_1">이름</label>
						<div>
							<input type="text" class="form-control" id="MEM_NAME" name="MEM_NAME" placeholder="이름을 입력해주세요.">
						</div>
					</div>
					<div class="form-group">
						<label class="text-black" for="inputEmail_1">이메일</label>
						<div>
							<input type="email" class="form-control" id="MEM_EMAIL" name="MEM_EMAIL" placeholder="이메일을 입력해주세요.">
						</div>
					</div>
					<div class="form-group">
						<button id="searchBtn" type="button" onclick="idSearch_click()" class="btn btn-primary" style="width:49%; float:left;">확인</button>
						<a class="btn btn-outline-primary"	href="${pageContext.request.contextPath}/member/openLoginForm" style="width:49%; float:right;">취소</a>
					</div>
				</div>
				
				<!-- 비밀번호 찾기 -->
				<div id="searchPW" style="display: none;">
					<div class="form-group">
						<label class="text-black" for="inputId">아이디</label>
						<div>
							<input type="text" class="form-control" id="MEM_ID" name="MEM_ID" placeholder="아이디를 입력해주세요.">
						</div>
					</div>
					<div class="form-group">
						<label class="text-black" for="inputEmail">이메일</label>
						<div>
							<input type="email" class="form-control" id="MEM_EMAIL2" name="MEM_EMAIL2" placeholder="이메일을 입력해주세요.">
						</div>
					</div>
					<div class="form-group">
						<button id="searchBtn2" type="button" onclick="pwSearch_click()" class="btn btn-primary" style="width:49%; float:left;">확인</button>
						<a class="btn btn-outline-primary"	href="${pageContext.request.contextPath}/member/openLoginForm" style="width:49%; float:right;">취소</a>
						<input type="hidden" path="random" id="random" value="${random}"/>
				</div>
				</div>
</div>
   <%@ include file="/WEB-INF/include/include-body.jspf"%>
<!-- footer       -->
   <div style="height:190px;"></div>
   <footer style="border-top:1px solid #D5D5D5;">
   <%@ include file="/WEB-INF/views/template/footer.jsp"%> 
   </footer>
</body>
</html>