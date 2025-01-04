<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="kr.ac.kopo.vo.MemberVO"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 - 즐겨찾기</title>
    <link rel="stylesheet" type="text/css" href="/MySite/resource/css/myPageCss.css">
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f9e8;
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
        #favoritesContainer {
            margin-top: 20px;
        }
        #favoritesList {
            list-style-type: none;
            padding: 0;
        }
        #favoritesList li {
            padding: 10px;
            border-bottom: 1px solid #d0e8c0;
            position: relative;
            background-color: #e6f4ea;
        }
        #favoritesList li a {
            text-decoration: none;
            color: #333;
            font-weight: bold;
        }
        #favoritesList li a:hover {
            text-decoration: underline;
        }
        .removeButton {
            background-color: transparent;
            border: none;
            color: red;
            cursor: pointer;
            position: absolute;
            right: 10px;
            top: 10px;
            font-size: 16px;
        }
        .removeButton:hover {
            color: darkred;
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
    <script>
    $(document).ready(function() {
        // 즐겨찾기 제거
        $(".removeButton").click(function() {
            var gameId = $(this).data("game");
            console.log("Removing game with ID:", gameId); // 콘솔에서 gameId 확인
            if (confirm("정말로 이 게임을 즐겨찾기에서 제거하시겠습니까?")) {
                $.ajax({
                    type: "POST",
                    url: "${pageContext.request.contextPath}/removeFavorite.do",
                    data: { action: "remove", gameId: gameId },
                    dataType: "json",
                    success: function(response) {
                        alert(response.message); // 성공 메시지
                        // 페이지 새로고침 대신 즐겨찾기 목록 페이지로 이동
                        window.location.href = "/MySite/viewFavorites.do";
                    },
                    error: function(xhr) {
                        console.error("Error response: ", xhr.responseText);
                        console.error("Status: " + xhr.status + ", StatusText: " + xhr.statusText);
                        alert("즐겨찾기 제거에 실패했습니다.\n서버 응답 상태: " + xhr.status + " " + xhr.statusText);
                    }
                });
            }
        });
    });
    </script>
</head>
<body>
<a id="homeButton" href="/MySite/index.do">홈으로 돌아가기</a>
<div id="container">
    <header>
        <div align="center">
            <h1>즐겨찾기</h1>
        </div>
    </header>
    <div id="userInfo">
        <c:choose>
            <c:when test="${not empty userVO}">
                <h2>
                    <strong>
                        <c:choose>
                            <c:when test="${not empty userVO.name}">${userVO.name}</c:when>
                            <c:otherwise>${userVO.id}</c:otherwise>
                        </c:choose>
                    </strong>님의 즐겨찾기 페이지
                </h2>
            </c:when>
            <c:otherwise>
                <p>로그인 정보가 없습니다. 로그인을 해주세요.</p>
                <a href="/MySite/jsp/login/login.jsp">로그인 페이지로 이동</a>
            </c:otherwise>
        </c:choose>
    </div>
    <div id="favoritesContainer">
        <c:if test="${not empty favoritesList}">
            <ul id="favoritesList">
                <c:forEach var="game" items="${favoritesList}">
                    <li>
                        <a href="${game.gameUrl}">${game.gameTitle}</a>
                        <button class="removeButton" data-game="${game.gameId}">✕</button>
                    </li>
                </c:forEach>
            </ul>
        </c:if>
        <c:if test="${empty favoritesList}">
            <p>즐겨찾기한 게임이 없습니다.</p>
        </c:if>
    </div>
</div>
</body>
</html>
