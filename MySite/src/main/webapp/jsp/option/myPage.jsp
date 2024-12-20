<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="kr.ac.kopo.vo.MemberVO"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <!-- 올바른 URI로 수정 -->
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지</title>
    <link rel="stylesheet" type="text/css" href="/MySite/resource/css/myPageCss.css">
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script>
        $(document).ready(function() {
            $("#editButton").click(function() {
                $("#editForm").toggle();
            });

            $("#deleteAccountButton").click(function() {
                if (confirm("정말로 회원탈퇴 하시겠습니까?")) {
                    var userId = "${userVO.id}"; // EL을 사용해 사용자 ID를 가져오기
                    $.ajax({
                        type: "POST",
                        url: "/MySite/deleteAccount.do",
                        data: { id: userId }, // 'id: id'에서 'id: userId'로 수정
                        success: function(response) {
                            alert(response.message);
                            if (response.message === "회원탈퇴가 완료되었습니다.") {
                                window.location.href = "/MySite/jsp/login/login.jsp"; // 로그인 페이지로 이동
                            }
                        },
                        error: function(xhr) {
                            alert("회원탈퇴 중 오류가 발생했습니다.");
                        }
                    });
                }
            });
        });
    </script>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f9e8; /* 부드러운 연두색 배경 */
            color: #333;
        }
        #container {
            width: 60%;
            margin: 0 auto;
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        header h1 {
            color: #4d774e;
            margin-bottom: 20px;
        }
        #userInfo h2 {
            color: #4d774e;
        }
        #userInfo p {
            font-size: 16px;
        }
        #editButton, #deleteAccountButton {
            background-color: #4d774e;
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            margin-top: 10px;
            border-radius: 4px;
        }
        #editButton:hover, #deleteAccountButton:hover {
            background-color: #3e625b;
        }
        #deleteAccountButton {
            background-color: #d9534f;
        }
        #deleteAccountButton:hover {
            background-color: #c9302c;
        }
        #editForm {
            margin-top: 20px;
        }
        #editForm div {
            margin-bottom: 10px;
        }
        label {
            display: inline-block;
            width: 120px;
            font-weight: bold;
        }
        input[type="text"], input[type="password"] {
            width: 70%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        button[type="submit"] {
            background-color: #4d774e;
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            border-radius: 4px;
        }
        button[type="submit"]:hover {
            background-color: #3e625b;
        }
        #homeButton {
            position: absolute;
            top: 20px;
            right: 20px;
            background-color: #4caf50;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            text-decoration: none;
        }
        #homeButton:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <a id="homeButton" href="/MySite/index.do">홈으로 돌아가기</a>
    <div id="container">
        <header>
            <div align="center">
                <h1>마이페이지</h1>
            </div>
        </header>
        <div id="userInfo">
            <c:choose>
                <c:when test="${not empty userVO}">
                    <h2>
                        <strong>${userVO.name}</strong>님의 마이페이지
                    </h2>
                    <p>
                        <strong>아이디:</strong> ${userVO.id}
                    </p>
                    <p>
                        <strong>이메일:</strong> ${userVO.emailId}@${userVO.emailDomain}
                    </p>
                    <button id="editButton">개인 정보 수정하기</button>
                    <button id="deleteAccountButton">회원탈퇴</button>
                </c:when>
                <c:otherwise>
                    <p>로그인 정보가 없습니다. 로그인을 해주세요.</p>
                    <a href="../login/login.jsp">로그인 페이지로 이동</a>
                </c:otherwise>
            </c:choose>
        </div>
        <div id="editForm" style="display: none;">
            <h3>개인 정보 수정</h3>
            <form action="/MySite/updateMember.do" method="post">
                <input type="hidden" name="id" value="${userVO.id}">
                <div>
                    <label for="password">비밀번호: </label>
                    <input type="password" id="password" name="password" required>
                </div>
                <div>
                    <label for="emailId">이메일 아이디: </label>
                    <input type="text" id="emailId" name="emailId" value="${userVO.emailId}" required>
                </div>
                <div>
                    <label for="emailDomain">이메일 도메인: </label>
                    <input type="text" id="emailDomain" name="emailDomain" value="${userVO.emailDomain}" required>
                </div>
                <button type="submit">수정하기</button>
            </form>
        </div>
    </div>
</body>
</html>