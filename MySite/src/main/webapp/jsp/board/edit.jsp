<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시글 수정</title>
    <link rel="stylesheet" type="text/css" href="/MySite/resource/css/detailCss.css">
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        
        .container {
            width: 80%;
            margin: 0 auto;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        
        th {
            background-color: #f4f4f4;
        }
        
        .form-section {
            margin-top: 20px;
        }
        
        .form-section input[type="text"],
        .form-section textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
        }
        
        .form-section button {
            padding: 10px 20px;
            background-color: #28a745;
            color: #fff;
            border: none;
            cursor: pointer;
        }
        
        .form-section button:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
    <div class="container">
        <div align="center">
            <h2>게시글 수정</h2>
        </div>
        <div align="center">
            <form action="/MySite/board/update.do" method="post">
                <input type="hidden" name="no" value="${board.no}">
                <table>
                    <tr>
                        <th>작성자</th>
                        <td>${board.writer}</td>
                    </tr>
                    <tr>
                        <th>제목</th>
                        <td><input type="text" name="title" value="${board.title}" required></td>
                    </tr>
                    <tr>
                        <th>내용</th>
                        <td><textarea name="content" required>${board.content}</textarea></td>
                    </tr>
                </table>
                <div class="form-section">
                    <button type="submit">수정 완료</button>
                </div>
            </form>
        </div>
        <div align="center">
            <button type="button" onclick="location.href='/MySite/board/detail.do?no=${board.no}'">취소</button>
        </div>
    </div>
</body>
</html>