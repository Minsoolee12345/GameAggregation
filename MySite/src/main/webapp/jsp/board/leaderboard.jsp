<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>${gameName} 리더보드</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f9e8; /* 부드러운 연두색 배경 */
            color: #333;
        }
        h1 {
            text-align: center;
            margin-top: 20px;
            color: #4d774e;
        }
        table {
            width: 60%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: #ffffff;
        }
        th, td {
            padding: 12px;
            border: 1px solid #d0e8c0;
            text-align: center;
        }
        th {
            background-color: #a3d9a5; /* 연한 녹색 */
            color: #ffffff;
        }
        tr:nth-child(even) {
            background-color: #e6f4ea;
        }
        tr:hover {
            background-color: #d2f1d0; /* 마우스 오버 시 부드러운 강조 색상 */
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
    <h1>${gameName} 리더보드</h1>
    <table>
        <thead>
            <tr>
                <th>순위</th>
                <th>사용자 ID</th>
                <th>점수</th>
                <th>기록 시간</th>
            </tr>
        </thead>
        <tbody>
            <c:if test="${not empty topScores}">
                <c:forEach var="vo" items="${topScores}" varStatus="status">
                    <tr>
                        <td>${status.index + 1}</td>
                        <td>${vo.userId}</td>
                        <td>${vo.score}</td>
                        <td><fmt:formatDate value="${vo.recordedAt}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                    </tr>
                </c:forEach>
            </c:if>
            <c:if test="${empty topScores}">
                <tr>
                    <td colspan="4">리더보드에 기록된 점수가 없습니다.</td>
                </tr>
            </c:if>
        </tbody>
    </table>
</body>
</html>
