<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="kr.ac.kopo.vo.MemberVO"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게임 집합소</title>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <style>
        /* 기존 스타일 유지 */
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            overflow: hidden; /* 전체 페이지에서 스크롤 숨기기 */
        }

        body {
            background-color: #f0f9e8;
            font-family: Arial, sans-serif;
            color: #333;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        #container {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            flex: 1 1 auto; /* Flex-grow와 Flex-shrink 설정 */
            display: flex;
            flex-direction: column;
            overflow: hidden; /* 내부에서만 스크롤 허용 */
        }

        header {
            background-color: #e0f7da;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            flex: 0 0 auto;
        }

        nav {
            background-color: #c8e6c9;
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 20px;
            position: relative;
            flex: 0 0 auto;
        }

        #settingsButton {
            background-color: #a5d6a7;
            color: #333;
            border: none;
            padding: 10px;
            border-radius: 4px;
            cursor: pointer;
        }

        #settingsButton:hover {
            background-color: #9ccc65;
        }

        #settingsMenu {
            display: none;
            background-color: #a5d6a7;
            padding: 10px;
            border-radius: 4px;
            position: absolute;
            top: 40px;
            right: 0;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        #settingsMenu a {
            display: block;
            color: #333;
            text-decoration: none;
            margin: 5px 0;
        }

        #settingsMenu a:hover {
            text-decoration: underline;
        }

        #search-container {
            margin-bottom: 20px;
            padding: 10px;
            background-color: #dcedc8;
            border-radius: 8px;
            flex: 0 0 auto;
        }

        #searchInput {
            padding: 8px;
            border: 1px solid #aed581;
            border-radius: 4px;
            width: calc(100% - 220px);
        }

        #searchButton, #returnButton {
            background-color: #8bc34a;
            color: #ffffff;
            border: none;
            padding: 10px;
            margin-left: 5px;
            border-radius: 4px;
            cursor: pointer;
        }

        #searchButton:hover, #returnButton:hover {
            background-color: #7cb342;
        }

        #links {
            flex: 1 1 auto; /* 남은 공간을 채우도록 설정 */
            overflow-y: auto; /* 내부 스크롤 허용 */
            padding-right: 10px;
            scrollbar-width: thin;
            scrollbar-color: #8bc34a #f0f9e8;
        }

        #links::-webkit-scrollbar {
            width: 10px;
        }

        #links::-webkit-scrollbar-track {
            background: #f0f9e8;
            border-radius: 8px;
        }

        #links::-webkit-scrollbar-thumb {
            background: #8bc34a;
            border-radius: 8px;
        }

        #links::-webkit-scrollbar-thumb:hover {
            background: #7cb342;
        }

        .game-item {
            background-color: #e8f5e9;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 15px;
        }

        .game-item h3 {
            color: #388e3c;
        }

        .game-item p {
            color: #558b2f;
        }

        .addFavoriteForm button {
            background-color: #fbc02d;
            color: #ffffff;
            border: none;
            padding: 8px;
            border-radius: 4px;
            cursor: pointer;
        }

        .addFavoriteForm button:hover {
            background-color: #f9a825;
        }

        .viewRankingButton {
            background-color: #43a047;
            color: #ffffff;
            border: none;
            padding: 10px;
            border-radius: 4px;
            cursor: pointer;
        }

        .viewRankingButton:hover {
            background-color: #388e3c;
        }

        footer {
            background-color: #c5e1a5;
            padding: 20px;
            border-radius: 8px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            flex: 0 0 auto;
        }

        /* 공통 Footer 링크 스타일 */
        .footer-link {
            text-align: center;
            margin: 10px 0;
            flex: 1 1 30%;
        }

        .footer-link a {
            text-decoration: none;
            color: #333;
            font-size: 18px;
            font-weight: bold;
        }

        .footer-link a:hover {
            text-decoration: underline;
            color: #555;
        }

        #gameRegis a.admin-button {
            background-color: #ff9800;
            color: #fff;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 16px;
            font-weight: bold;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease, transform 0.2s ease;
            cursor: pointer;
        }

        #gameRegis a.admin-button:hover {
            background-color: #e68900;
            transform: translateY(-2px);
        }

        #gameRegis a.admin-button:active {
            background-color: #cc7a00;
            transform: translateY(0);
        }

        .admin-button {
            display: inline-block;
            padding: 12px 24px;
            margin: 20px auto;
            background-color: #ff9800;
            color: #fff;
            text-decoration: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease, transform 0.2s ease;
            border: none;
            cursor: pointer;
        }

        .admin-button:hover {
            background-color: #e68900;
            transform: translateY(-2px);
        }

        .admin-button:active {
            background-color: #cc7a00;
            transform: translateY(0);
        }

        /* 관리자 페이지 버튼 스타일 */
        .admin-back-button {
            display: inline-block;
            padding: 12px 24px;
            margin-top: 20px;
            background-color: #ff9800; /* 밝은 주황색 */
            color: #fff;
            text-decoration: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease, transform 0.2s ease;
            border: none;
            cursor: pointer;
        }

        .admin-back-button:hover {
            background-color: #e68900; /* 더 진한 주황색 */
            transform: translateY(-2px); /* 약간 위로 이동 */
        }

        .admin-back-button:active {
            background-color: #cc7a00; /* 눌린 상태 */
            transform: translateY(0); /* 원래 위치로 돌아옴 */
        }
    </style>
    <script>
        $(document).ready(function () {
            // 설정 메뉴 토글
            $("#settingsButton").click(function () {
                $("#settingsMenu").slideToggle("fast");
            });

            // 즐겨찾기 추가 폼을 AJAX로 처리
            $(".addFavoriteForm").submit(function (event) {
                event.preventDefault(); // 기본 폼 제출 방지

                var form = $(this);
                var action = form.find('input[name="action"]').val();
                var gameId = form.find('input[name="gameId"]').val();

                // gameId 값 유효성 검사
                if (!gameId || gameId.trim() === "") {
                    alert("게임 ID가 올바르지 않습니다.");
                    return;
                }

                $.ajax({
                    type: "POST",
                    url: form.attr('action'),
                    data: {
                        action: action,
                        gameId: gameId
                    },
                    dataType: "json",
                    success: function (jsonResponse) {
                        alert(jsonResponse.message);
                    },
                    error: function (xhr, status, error) {
                        alert("즐겨찾기 추가에 실패했습니다.");
                    }
                });
            });

            // 랭킹보기 버튼 클릭 이벤트
            $(".viewRankingButton").click(function () {
                var gameId = $(this).data("game-id");
                if (gameId) {
                    // 단순히 페이지를 이동하도록 수정
                    location.href = "/MySite/leaderboard.do?gameId=" + encodeURIComponent(gameId);
                } else {
                    alert("게임 ID가 유효하지 않습니다.");
                }
            });

            // 검색 기능
            $("#searchButton").click(function () {
                var searchText = $("#searchInput").val().toLowerCase();
                var hasResult = false;

                $("#links > .game-item").each(function () {
                    var gameTitle = $(this).find("h3:not(:has(a))").text().toLowerCase();
                    if (gameTitle.includes(searchText)) {
                        $(this).show();
                        hasResult = true;
                    } else {
                        $(this).hide();
                    }
                });

                if (!hasResult) {
                    alert("검색 결과가 없습니다.");
                } else {
                    $("#returnButton").show();
                }
            });

            // 돌아가기 버튼 클릭 시
            $("#returnButton").click(function () {
                $("#links > .game-item").show();
                $(this).hide();
                $("#searchInput").val('');
            });
        });
    </script>
</head>

<body>
    <div id="container">
        <header>
            <div align="center">
                <h1>게임 집합소</h1>
            </div>
        </header>
        <nav>
            <div style="float: right;">
                <c:choose>
                    <c:when test="${not empty userVO}">
                        안녕하세요, <strong>${userVO.id}</strong>님!
                    </c:when>
                    <c:otherwise>
                        <a href="./jsp/login/login.jsp">로그인</a>
                    </c:otherwise>
                </c:choose>
            </div>
            <button id="settingsButton">설정</button>
            <div id="settingsMenu">
                <a href="/MySite/jsp/option/myPage.jsp">마이페이지</a>
                <a href="/MySite/viewFavorites.do">즐겨찾기</a>
                <c:if test="${not empty userVO}">
                    <a href="/MySite/logout.do">로그아웃</a>
                </c:if>
            </div>
        </nav>
        <div id="search-container">
            <input type="text" id="searchInput" placeholder="검색어를 입력하세요">
            <button id="searchButton">검색</button>
            <button id="returnButton" style="display: none;">돌아가기</button>
        </div>
        <div id="links">
            <c:if test="${empty gameList}">
                <p>등록된 게임이 없습니다. 곧 새로운 게임이 추가될 예정입니다!</p>
            </c:if>
            <c:forEach var="game" items="${gameList}">
                <div class="game-item">
                    <div>
                        <h3>
                            <a href="${game.gameUrl}">게임하기!</a>
                        </h3>
                        <h3>${game.gameTitle}</h3>
                        <p>${game.gameIntro}</p>
                        <form class="addFavoriteForm" action="/MySite/addFavorite.do" method="post" style="display: inline;">
                            <input type="hidden" name="gameId" value="${game.gameId}">
                            <input type="hidden" name="action" value="add">
                            <button type="submit">&#9733;</button>
                        </form>
                        <button class="viewRankingButton" data-game-id="${game.gameTitle}">랭킹보기</button>
                    </div>
                </div>
            </c:forEach>
        </div>

        <c:if test="${userVO.id == 'admin'}">
            <div style="text-align: center; margin-top: 20px;">
                <button class="admin-back-button" onclick="location.href='/MySite/admin.do'">
                    관리자 페이지로 돌아가기
                </button>
            </div>
        </c:if>
    </div>
    <footer>
        <div id="companyWay" class="footer-link">
            <h3>
                <a href="/MySite/jsp/location/location.jsp">회사 오시는 길</a>
            </h3>
        </div>
        <!-- 게임 신청하기 버튼 추가 -->
        <div id="gameRegis" class="footer-link">
            <h3>
                <a href="/MySite/submitGameApplication.do" class="admin-button">게임 신청하기</a>
            </h3>
        </div>
        <div id="bugReport" class="footer-link">
            <h3>
                <a href="/MySite/board/list.do">버그게시판</a>
            </h3>
        </div>
    </footer>
</body>
</html>