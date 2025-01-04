<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게임 관리하기</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f9e8;
            color: #333;
        }

        h1 {
            color: #4d774e;
            text-align: center;
        }

        .table-container {
            width: 80%;
            margin: 20px auto;
            max-height: 400px;
            overflow-y: auto;
            border: 1px solid #d0e8c0;
            border-radius: 8px;
            background-color: #ffffff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .table-container::-webkit-scrollbar {
            width: 8px;
        }

        .table-container::-webkit-scrollbar-thumb {
            background-color: #a3d9a5;
            border-radius: 4px;
        }

        .table-container::-webkit-scrollbar-thumb:hover {
            background-color: #8ac28a;
        }

        .table-container::-webkit-scrollbar-track {
            background-color: #f0f9e8;
            border-radius: 4px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #ffffff;
        }

        th, td {
            border: 1px solid #d0e8c0;
            padding: 10px;
            text-align: center;
        }

        th {
            background-color: #a3d9a5;
            color: #ffffff;
        }

        tr:nth-child(even) {
            background-color: #e6f4ea;
        }

        tr:hover {
            background-color: #d2f1d0;
        }

        .action-button {
            padding: 8px 16px;
            background-color: #f5b7b1;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .action-button:hover {
            background-color: #ec7063;
        }

        .add-game-form {
            width: 80%;
            margin: 20px auto;
            padding: 20px;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .add-game-form input, .add-game-form button {
            padding: 10px;
            margin: 5px;
        }

        .add-game-form button {
            background-color: #4d774e;
            color: #fff;
            border: none;
            cursor: pointer;
        }

        .add-game-form button:hover {
            background-color: #388e3c;
        }
    </style>
</head>
<body>
    <h1>게임 관리하기</h1>
    
    <!-- 게임 목록 조회 및 삭제 -->
    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>게임 ID</th>
                    <th>게임 URL</th>
                    <th>게임 제목</th>
                    <th>게임 소개</th>
                    <th>삭제</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="game" items="${gameList}">
                    <tr>
                        <td>${game.gameId}</td>
                        <td><a href="${game.gameUrl}" target="_blank">게임 링크</a></td>
                        <td>${game.gameTitle}</td>
                        <td>${game.gameIntro}</td>
                        <td>
                            <form action="/MySite/deleteGame.do" method="post" style="display:inline;">
                                <input type="hidden" name="gameId" value="${game.gameId}">
                                <button type="submit" class="action-button">삭제</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- 게임 추가 폼 -->
    <div class="add-game-form">
        <h2>게임 추가하기</h2>
        <form action="/MySite/addGame.do" method="post">
            <input type="text" name="gameUrl" placeholder="게임 URL" required>
            <input type="text" name="gameTitle" placeholder="게임 제목" required>
            <input type="text" name="gameIntro" placeholder="게임 소개" required>
            <button type="submit">게임 추가</button>
        </form>
    </div>
    <a id="homeButton" href="javascript:history.back();">이전 페이지로 돌아가기</a>
</body>
</html>
