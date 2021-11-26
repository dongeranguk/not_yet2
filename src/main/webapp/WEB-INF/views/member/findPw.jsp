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
    <title>비밀번호 찾기 | MUSCLE</title>
    <style>
        .container {
            border-top: 1px solid gray;
            padding: 5px 20px;
            width: 30%;
            height: 70%;

            display: flex;
            flex-direction: column;
            justify-content: center;
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

    var search_with = function(num) {
        switch(num) {
            case 1 :
                $("#MEM_ID").show();
                $("#MEM_NAME").show();
                $("#MEM_EMAIL").hide();
                $("#MEM_PHONE").show();
                $("#sendCertPhoneBtn").show();
                break;
            case 2 :
                $("#MEM_NAME").hide();
                $("#MEM_EMAIL").show();
                $("#MEM_PHONE").hide();
                $("#sendCertPhoneBtn").hide();
                break;
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
        var params = {
            MEM_NAME : $("#MEM_NAME").val(),
            MEM_EMAIL : $("#MEM_EMAIL").val(),
        }
        $.ajax({
            type:"POST",
            url:"<c:url value='/member/openFindIdResult'/>",
            data:params,
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
            MEM_EMAIL : $("#MEM_EMAIL").val(),
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
                    alert("입력하신 메일로 임시비밀번호를 발송하였습니다.");
                    window.location = "/muscle/member/openLoginForm";
                }else{
                    alert("아이디 혹은 이메일을 잘못 입력하셨습니다.\n다시 한번 입력 해주세요.");
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
    <div style="margin-bottom: 10px;" class="custom-control custom-radio custom-control-inline">
        <a href="${pageContext.request.contextPath}/member/findId" class="btn btn-outline-primary">아이디 찾기</a>
        <a href="javascript:location.reload()" class="btn btn-outline-primary">비밀번호 찾기</a>
<%--    <input type="button" id="search_1" name="search_total" value="아이디 찾기" onclick="search_check(1)" class="btn btn-primary"/>
        <input type="button" id="search_2" name="search_total" value="비밀번호 찾기" onclick="search_check(2)" class="btn btn-primary"/>--%>
    </div>

    <div style="margin-bottom: 10px;" class="custom-control custom-radio custom-control-inline">
        <input type="radio" class="custom-control-input" id="search_with1" name="search_with" onclick="search_with(1)" checked="checked">
        <label class="custom-control-label font-weight-bold text-black" for="search_with1">휴대전화</label>
    </div>
    <div style="margin-bottom: 10px;" class="custom-control custom-radio custom-control-inline">
        <input type="radio" class="custom-control-input" id="search_with2" name="search_with" onclick="search_with(2)">
        <label class="custom-control-label font-weight-bold text-black" for="search_with2">이메일</label>
    </div>
<%--    <div style="margin-bottom: 10px;" class="custom-control custom-radio custom-control-inline">
        <input type="radio" class="custom-control-input" id="search_with3" name="search_with" onclick="search_with(3)">
        <label class="custom-control-label font-weight-bold text-black" for="search_with3">본인인증</label>
    </div>--%>

    <%--	<div style="margin-bottom: 10px;" class="custom-control custom-radio custom-control-inline">
            <input type="radio" class="custom-control-input" id="search_1" name="search_total" onclick="search_check(1)" checked="checked">
            <label class="custom-control-label font-weight-bold text-black"	for="search_1">아이디 찾기</label>
        </div>
        <div class="custom-control custom-radio custom-control-inline">
            <input type="radio" class="custom-control-input" id="search_2" name="search_total" onclick="search_check(2)">
            <label class="custom-control-label font-weight-bold text-black" for="search_2">비밀번호 찾기</label>
        </div>--%>

    <!-- 아이디 찾기 -->
<%--    <div id="searchPW">
        <div class="form-group">
            <div>
                <input type="text" class="form-control" id="MEM_NAME" name="MEM_NAME" placeholder="이름 입력">
            </div>
        </div>
        <div class="form-group">
            <div>
                <input type="text" style="display: none" class="form-control" id="MEM_EMAIL" name="MEM_EMAIL" placeholder="아이디 입력">
            </div>
        </div>
        <div class="form-group">
            <div>
                <input type="text" class="form-control" id="MEM_PHONE" name="MEM_PHONE" placeholder="휴대전화 입력(-없이)">
                <button type="button" class="btn btn-primary" id="sendCertPhoneBtn" style="width:20%; margin-top:-38px; float:right;">인증요청</button>
                <button type="button" class="btn btn-primary" id="reSendCertPhoneBtn" style="width:20%; margint-top:-38px; float:right; display:none">다시받기</button>
            </div>
        </div>
        <div class="form-group">
            <button id="searchBtn" type="button" onclick="idSearch_click()" class="btn btn-primary" style="width:49%; float:left;">확인</button>
            <a class="btn btn-outline-primary"	href="${pageContext.request.contextPath}/member/openLoginForm" style="width:49%; float:right;">취소</a>
        </div>
    </div>--%>

    <!-- 비밀번호 찾기 -->
    <div id="searchPW">
        <div class="form-group">
            <div>
                <input type="text" class="form-control" id="MEM_ID" name="MEM_ID" placeholder="아이디 입력">
            </div>
        </div>
        <div class="form-group">
            <div>
                <input type="text" class="form-control" id="MEM_NAME" name="MEM_NAME" placeholder="이름 입력">
            </div>
        </div>
        <div class="form-group">
            <div>
                <input type="email" class="form-control" id="MEM_EMAIL" name="MEM_EMAIL" placeholder="이메일 입력" style="display:none">
            </div>
        </div>
        <div class="form-group">
            <div>
                <input type="text" class="form-control" id="MEM_PHONE2" name="MEM_PHONE2" placeholder="휴대전화 입력(-없이)">
                <button type="button" class="btn btn-primary" onclick="sendCertPhoneBtn(1)" style="width:20%; margin-top:-38px; float:right;">인증요청</button>
                <button type="button" class="btn btn-primary" onclick="sendCertPhoneBtn(2)" style="display:none">다시받기</button>
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