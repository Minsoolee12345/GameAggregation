<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 - 회원 목록</title>
<link rel="stylesheet" type="text/css"
    href="/MySite/resource/css/adminCss.css">
<style>
/* 공통 스타일 */
body {
    font-family: Arial, sans-serif;
    background-color: #f0f9e8; /* 부드러운 연두색 배경 */
    color: #333;
}

h1 {
    color: #4d774e;
    text-align: center;
}

/* 검색 컨테이너 스타일 추가 */
.search-container {
    text-align: center;
    margin: 20px;
}

.search-container input[type="text"] {
    width: 200px;
    padding: 8px;
    border: 1px solid #d0e8c0;
    border-radius: 4px;
}

.search-container button {
    padding: 8px 16px;
    background-color: #a3d9a5;
    color: #fff;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

.search-container button:hover {
    background-color: #4d774e;
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
    background-color: #a3d9a5; /* 연한 녹색 */
    color: #ffffff;
}

tr:nth-child(even) {
    background-color: #e6f4ea;
}

tr:hover {
    background-color: #d2f1d0; /* 마우스 오버 시 부드러운 강조 색상 */
}

/* 테이블 스크롤 스타일 */
.table-container {
    max-height: 400px; /* 테이블 최대 높이 설정 */
    overflow-y: auto; /* 수직 스크롤 추가 */
    margin: 20px auto;
    width: 80%;
}

/* 버그게시판 링크 스타일 */
#bugReport {
    margin: 20px;
}

#bugReport a {
    display: inline-block;
    padding: 10px 20px;
    background-color: #f5b7b1; /* 부드러운 빨간색 */
    color: #fff;
    text-decoration: none;
    border-radius: 5px;
    font-weight: bold;
}

#bugReport a:hover {
    background-color: #ec7063; /* 조금 더 진한 빨간색 */
}

/* 게임 관리하기 스타일 */
#GameMan {
    margin: 10px;
}

#GameMan a {
    display: inline-block;
    padding: 10px 20px;
    background-color: #7fb3d5; /* 부드러운 파란색 */
    color: #fff;
    text-decoration: none;
    border-radius: 5px;
    font-weight: bold;
}

#GameMan a:hover {
    background-color: #5499c7; /* 조금 더 진한 파란색 */
}

/* 메인페이지로 가기 스타일 */
#mainPage {
    margin: 10px;
}

#mainPage a {
    display: inline-block;
    padding: 10px 20px;
    background-color: #f7dc6f; /* 부드러운 노란색 */
    color: #333; /* 버튼 텍스트를 더 읽기 쉽게 */
    text-decoration: none;
    border-radius: 5px;
    font-weight: bold;
}

#mainPage a:hover {
    background-color: #f4d03f; /* 조금 더 진한 노란색 */
}

/* 게임 신청 관리하기 스타일 */
#gameApplicationManagement {
    margin: 10px;
}

#gameApplicationManagement a {
    display: inline-block;
    padding: 10px 20px;
    background-color: #58d68d; /* 부드러운 초록색 */
    color: #fff;
    text-decoration: none;
    border-radius: 5px;
    font-weight: bold;
}

#gameApplicationManagement a:hover {
    background-color: #45b39d; /* 조금 더 진한 초록색 */
}
</style>
</head>
<body>
    <h1>관리자 계정입니다</h1>
    <div class="search-container">
        <form action="/MySite/jsp/admin/searchMember.jsp" method="get">
            <input type="text" name="id" placeholder="회원 ID 검색">
            <button type="submit">검색</button>
        </form>
    </div>

    <!-- 테이블 컨테이너 -->
    <div class="table-container">
        <table border="1">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>이름</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="member" items="${members}">
                    <c:if test="${empty param.id || member.id == param.id}">
                        <tr>
                            <td>
                                <a href="/MySite/jsp/admin/searchMember.jsp?id=${member.id}">
                                    ${member.id}
                                </a>
                            </td>
                            <td>${member.name}</td>
                        </tr>
                    </c:if>
                </c:forEach>
                <c:if test="${empty members}">
                    <tr>
                        <td colspan="4">검색된 결과가 없습니다.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <div align="right" id="bugReport">
        <a href="/MySite/board/list.do">버그게시판</a>
    </div>
    <div align="right" id="GameMan">
        <a href="/MySite/gameManagement.do">게임 관리하기</a>
    </div>
    <div align="right" id="gameApplicationManagement">
        <a href="/MySite/gameApplicationManagement.do" class="game-application-button">게임 신청 관리</a>
    </div>
    <div align="right" id="mainPage">
        <a href="/MySite/index.do">메인페이지로 가기</a>
    </div>
</body>
</html>