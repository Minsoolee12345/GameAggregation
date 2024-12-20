<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>버그 문의 작성</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9fafb;
            color: #333;
            margin: 0;
            padding: 20px;
            line-height: 1.6;
        }

        h2 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 20px;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        table {
            width: 100%;
            border-spacing: 0;
        }

        td {
            padding: 10px;
            vertical-align: top;
        }

        input[type="text"],
        textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccd0d5;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 14px;
        }

        textarea {
            resize: vertical;
        }

        button {
            background-color: #3498db;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #2980b9;
        }

        #selectedGame {
            margin-top: 10px;
            font-weight: bold;
            color: #27ae60;
        }

        #selectedGame span {
            color: #e74c3c;
            cursor: pointer;
            text-decoration: underline;
        }

        #selectedGame span:hover {
            text-decoration: none;
        }

        #searchContainer {
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }

        #searchInput {
            flex-grow: 1;
            padding: 8px;
            border: 1px solid #ccd0d5;
            border-radius: 4px;
            font-size: 14px;
        }

        #searchButton {
            margin-left: 10px;
            background-color: #27ae60;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
        }

        #searchButton:hover {
            background-color: #229954;
        }

        .games-list {
            max-height: 300px;
            overflow-y: auto;
            border: 1px solid #ccd0d5;
            border-radius: 4px;
            padding: 10px;
            background-color: #fdfdfd;
            margin-top: 10px;
        }

        .game-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px;
            border-bottom: 1px solid #eaeaea;
        }

        .game-item:last-child {
            border-bottom: none;
        }

        .game-item span {
            font-size: 14px;
            color: #2c3e50;
        }

        .select-game-button {
            background-color: #2980b9;
            color: white;
            padding: 5px 10px;
            border: none;
            border-radius: 4px;
            font-size: 12px;
            cursor: pointer;
        }

        .select-game-button:hover {
            background-color: #1c598a;
        }

    </style>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script>
        $(document).ready(function () {
            // 게임 검색 기능
            $("#searchButton").click(function () {
                var query = $("#searchInput").val().toLowerCase();
                $(".games-list .game-item").each(function () {
                    var gameTitle = $(this).find(".game-title").text().toLowerCase();
                    if (gameTitle.includes(query)) {
                        $(this).show();
                    } else {
                        $(this).hide();
                    }
                });
            });

            // 이벤트 위임을 사용해 게임 선택 처리
            $(document).on("click", ".select-game-button", function () {
                var gameTitle = $(this).data("game-title");
                var gameId = $(this).data("game-id");

                // 선택된 게임 표시 (문자열 연결 방식)
                $("#selectedGame").html("선택된 게임: <strong>" + gameTitle + "</strong> <span id='removeSelection'>[선택 취소]</span>");

                // 숨겨진 입력 필드에 게임 ID 설정
                $("#selectedGameInput").val(gameId);

                // 선택 취소 이벤트 설정
                $("#removeSelection").off("click").on("click", function () {
                    $("#selectedGame").html("게임을 선택하세요.");
                    $("#selectedGameInput").val("");
                });
            });
        });
    </script>
</head>
<body>
    <h2>버그 문의 작성</h2>
    <div class="container">
        <div class="form-section">
            <form action="${pageContext.request.contextPath}/board/write.do" method="post">
                <table>
                    <tr>
                        <td>제목</td>
                        <td><input type="text" name="title" id="title" placeholder="제목을 입력하세요" required></td>
                    </tr>
                    <tr>
                        <td>작성자</td>
                        <td>${userVO.id}</td>
                    </tr>
                    <tr>
                        <td>선택된 게임</td>
                        <td id="selectedGame">게임을 선택하세요.</td>
                    </tr>
                    <tr>
                        <td>게임 검색</td>
                        <td>
                            <div id="searchContainer">
                                <input type="text" id="searchInput" placeholder="게임 이름을 검색하세요">
                                <button type="button" id="searchButton">검색</button>
                            </div>
                            <div class="games-list">
                                <c:forEach var="game" items="${gameList}">
                                    <div class="game-item">
                                        <span class="game-title">${game.gameTitle}</span>
                                        <button type="button" class="select-game-button" 
                                                data-game-id="${game.gameId}" 
                                                data-game-title="${game.gameTitle}">
                                            선택
                                        </button>
                                    </div>
                                </c:forEach>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>내용</td>
                        <td><textarea name="content" rows="5" required></textarea></td>
                    </tr>
                </table>
                <!-- 숨겨진 입력 필드에 선택된 게임 ID 저장 -->
                <input type="hidden" id="selectedGameInput" name="gameId" value="">
                <button type="submit">등록</button>
            </form>
        </div>
    </div>
</body>
</html>