<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <link rel="stylesheet" type="text/css" href="/MySite/resource/css/loginCss.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#MemAddBtn').click(function() {
                location.href = '/MySite/jsp/member/memberForm.jsp';
            });
        });

        function checkForm() {
            let id = document.loginForm.id;
            let password = document.loginForm.password;

            if (id.value.trim() === '') {
                alert('ID를 입력하세요');
                id.focus();
                return false;
            }

            if (password.value.trim() === '') {
                alert('PASSWORD를 입력하세요');
                password.focus();
                return false;
            }

            return true;
        }
    </script>
</head>
<body>
    <section>
        <div align="center">
            <br>
            <hr>
            <h2>로그인</h2>
            <hr>
            <br>
            <c:if test="${not empty errorMessage}">
                <p style="color: red;">${errorMessage}</p>
            </c:if>
            <form name="loginForm" action="/MySite/login.do" method="post"
                onsubmit="return checkForm()">
                <table>
                    <tr>
                        <th>ID</th>
                        <td><input type="text" name="id"></td>
                    </tr>
                    <tr>
                        <th>PASSWORD</th>
                        <td><input type="password" name="password"></td>
                    </tr>
                </table>
                <br>
                <input type="submit" value="로그인" id="loginBtn">
            </form>
            <button type="button" id="MemAddBtn">회원가입</button>  
            <br><br>
            <!-- 카카오 로그인 버튼 추가 -->
            <a href="/MySite/kakaoLogin.do">
                <img src="/MySite/img/klogin_img.png" alt="카카오 로그인" class="kakao-login-btn">
            </a>
        </div>
    </section>
</body>
</html>