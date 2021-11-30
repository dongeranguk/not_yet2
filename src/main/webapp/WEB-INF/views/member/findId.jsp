<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="<c:url value='/js/common.js'/>" charset="utf-8"></script>
    <title>아이디 찾기 | MUSCLE</title>
    <style>
        .container {
            border-top: 1px solid gray;
            padding: 5px 20px;
            width: 50%;
            height: 70%;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .searchForm {
            width: 30%;
        }


    </style>
</head>
<body>

<%@ include file="/WEB-INF/views/template/header.jsp" %>
<div style="height: 160px;"></div>
<div align="center">
    <h3>Login</h3>
</div>
<div style="height: 30px;"></div>

<div class="container">
    <div style="margin-bottom: 10px;" class="custom-control custom-radio custom-control-inline">
        <a href="javascript:location.reload();" class="btn btn-outline-primary">아이디 찾기</a>
        <a href="${pageContext.request.contextPath}/member/findPw" class="btn btn-outline-primary">비밀번호 찾기</a>
    </div>
    <div style="margin-bottom: 10px;" class="custom-control custom-radio custom-control-inline">
        <input type="radio" class="custom-control-input" id="phoneRadioBtn" name="search_with" onclick="search_with(1)"
               checked="checked">
        <label class="custom-control-label font-weight-bold text-black" for="phoneRadioBtn">휴대전화</label>
    </div>
    <div style="margin-bottom: 10px;" class="custom-control custom-radio custom-control-inline">
        <input type="radio" class="custom-control-input" id="emailRadioBtn" name="search_with" onclick="search_with(2)">
        <label class="custom-control-label font-weight-bold text-black" for="emailRadioBtn">이메일</label>
    </div>

    <!-- 아이디 찾기 -->
    <div id="searchID" class="searchForm">
        <div class="form-group">
            <div>
                <input type="text" class="form-control" id="MEM_NAME" name="MEM_NAME" placeholder="이름 입력">
            </div>
        </div>
        <div class="form-group">
            <div>
                <input type="email" style="display: none" class="form-control" id="MEM_EMAIL" name="MEM_EMAIL"
                       placeholder="이메일 입력">
            </div>
        </div>
        <div class="form-group">
            <div>
                <input type="text" class="form-control" id="MEM_PHONE" name="MEM_PHONE" placeholder="휴대전화 입력(-없이)">
                <button type="button" class="btn btn-primary" id="sendCertPhoneBtn"
                        style="width:35%; margin-top:-37px; font-size:15px; float:right;">인증요청
                </button>
                <button type="button" class="btn btn-primary" id="reSendCertPhoneBtn"
                        style="width:35%; margin-top:-37px; font-size:15px; float:right; display:none;">다시받기
                </button>
            </div>
        </div>
        <div class="form-group">
            <div>
                <input type="text" class="form-control" id="CertPhoneNum" name="CertPhoneNum" style="display:none;"
                       placeholder="인증번호 입력">
                <button type="button" class="btn btn-primary" id="authSmsBtn"
                        style="width:35%; margin-top:-37px; font-size:15px; float:right; display:none;">확인</button>
            </div>
        </div>
        <div class="form-group">
            <button id="searchIdBtn" type="button" class="btn btn-primary" style="width:49%; float:left;">확인</button>
            <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/member/openLoginForm"
               style="width:49%; float:right;">취소</a>
        </div>
        <input type="hidden" id="requestMemberName" name="MEM_ID"/>
        <input type="hidden" id="requestPhoneNumber" name="MEM_PHONE"/>
        <input type="hidden" id="randomKey" name="randomKey"/>
        <input type="hidden" id="checkSmsCertification" value="1"/>
    </div>
</div>
<%@ include file="/WEB-INF/include/include-body.jspf" %>
<!-- footer       -->
<div style="height:190px;"></div>
<footer style="border-top:1px solid #D5D5D5;">
    <%@ include file="/WEB-INF/views/template/footer.jsp" %>
</footer>
<script>
    $(document).ready(function () {
        $('#MEM_NAME').focus();
    });

    var search_with = function (num) {
        switch (num) {
            case 1 :
                $("#MEM_NAME").show();
                $("#MEM_EMAIL").hide();
                $("#MEM_PHONE").show();
                $("#sendCertPhoneBtn").show();
                break;
            case 2 :
                $("#MEM_NAME").show();
                $("#MEM_EMAIL").show();
                $("#MEM_PHONE").hide();
                $("#sendCertPhoneBtn").hide();
                break;
        }
    }

    $("#searchBtn").click(function () {
        $("#modal").removeAttr("class").addClass("three");
    });

    $(".close").click(function () {
        $("#modal").addClass("out");
    });

    //.on
    $('#sendCertPhoneBtn, #reSendCertPhoneBtn').on("click", function () {
        if (!$('#MEM_NAME').val()) {
            alert("이름을 입력해주세요.");
            return false;
        }
        if (!$('#MEM_PHONE').val()) {
            alert("휴대전화 번호를 입력해주세요.");
            return false;
        }
        setTimeout(function () {
            var params = {
                name : $('#MEM_NAME').val(),
                phone : $('#MEM_PHONE').val()
            }
            $.ajax({
                type: "POST",
                url: "/muscle/member/send/authCode/sms",
                data: params,
                success: function (response) {
                    console.log(response);
                    var success = response.success;

                    if (success) {
                        $('#sendCertPhoneBtn').hide();
                        $('#reSendCertPhoneBtn').show();
                        $('#CertPhoneNum').show();
                        $('#randomKey').val(response.randomKey);
                        $('#authSmsBtn').show();
                    } else {
                        $('#sendCertPhoneBtn').show();
                        $('#reSendCertPhoneBtn').hide();
                        $('#CertPhoneNum').hide();
                    }
                    alert(response.message);
                }
            }, true)
        }, 300)
    });

    $('#authSmsBtn').click(function() {
        if(!$('#MEM_NAME').val()) {
            alert("이름을 입력해주세요.");
            return false;
        }
        if(!$('#MEM_PHONE').val()) {
            alert("휴대전화 번호를 입력해주세요.");
            return false;
        }
        if(!$('#CertPhoneNum').val()) {
            alert("인증번호를 입력해주세요.");
            return false;
        }
        setTimeout(function () {
            var params = {
                name : $('#MEM_NAME').val(),
                phone : $('#MEM_PHONE').val(),
                certPhoneNum : $('#CertPhoneNum').val(),
                randomKey : $('#randomKey').val()
            }
            $.ajax({
                type:"POST",
                url:"/muscle/member/api/sms/certification",
                data: params,
                success:function(response) {
                    alert(response.message);
                    var success = response.success;

                    if(success) {
                        $("input[name='checkSmsCertification']").val('1');
                        $("#searchIdBtn").prop("disabled", false);
                    } else {
                        $("input[name='checkSmsCertification']").val('0');
                        $("#searchIdBtn").prop("disabled", true);
                    }
                }
            }, true)
        }, 300);
    });


    /*document.getElementById('sendCertPhoneBtn').style.display = "none";
    document.getElementById('reSendCertPhoneBtn').style.display = "block";
    document.getElementById('CertPhoneNum').style.display = "block";*/


    function moveSearchResult(searchChannelType) {
        var memberIdResultUrl;
        var name = $('#requestMemberName').val();
        var phone = $('#requestPhoneNumber').val();
        if (searchChannelType != '') {
            var memberIdResultUrl = '${pageContext.request.contextPath}/member/findId/' + searchChannelType + '?name=' + name + '&phone=' + phone;
            location.href = memberIdResultUrl;
        } else {
            window.location = "/muscle/member/openLoginForm";
        }
    };

    $(document).ready(function () {
        $('#searchIdBtn').click(function () {
            if ($('#phoneRadioBtn').prop('checked')) {
                $('#requestMemberName').val($('#MEM_NAME').val());
                $('#requestPhoneNumber').val($('#MEM_PHONE').val());
                moveSearchResult('phone');
            }
            if ($('#emailRadioBtn').prop('checked')) {
                var params2 = {
                    MEM_NAME: $('#MEM_NAME').val(),
                    MEM_EMAIL: $('#MEM_EMAIL').val()
                }
                $.ajax({
                    async: false,
                    type: "POST",
                    url: "<c:url value='/member/findIdWithemail'/>",
                    data: params2,
                    success: function (data) {
                        if (data == 'true') {
                            alert("아이디를 이메일로 발송했습니다.");
                            window.location = "/muscle/member/openLoginForm";
                        } else if (data == 'false') {
                            alert("일치하는 아이디가 없습니다.");
                        }
                    }
                });
            }
        });
    });


</script>
</body>
</html>