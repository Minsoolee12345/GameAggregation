<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>버그 게시판</title>
    <link rel="stylesheet" type="text/css" href="/MySite/resource/css/listCss.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script>
        $(document).ready(function () {
            // "버그 문의하기" 버튼 클릭 시 이동
            $('#bugReport').click(function () {
                location.href = '/MySite/board/write.do';
            });

            // 제목 클릭 시 AJAX 요청
            $('.titleLink').click(function (e) {
                e.preventDefault(); // 기본 링크 이동 방지
                const detailUrl = $(this).attr('href'); // 상세 페이지 URL
                const viewCountElement = $(this).closest('tr').find('.viewCount'); // 조회수 표시 영역

                // AJAX 요청
                $.ajax({
                    url: detailUrl,
                    type: 'GET',
                    success: function () {
                        // 성공적으로 처리된 경우 조회수 갱신
                        const currentCount = parseInt(viewCountElement.text());
                        viewCountElement.text(currentCount + 1);
                        // 상세 페이지로 이동
                        window.location.href = detailUrl;
                    },
                    error: function () {
                        alert('조회수 증가에 실패했습니다.');
                    }
                });
            });
        });
    </script>
    <style>
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
    <c:if test="${loginRequired}">
        <script>
            alert('로그인 후 이용 가능합니다');
            location.href = '/MySite/jsp/login/login.jsp';
        </script>
    </c:if>

    <c:if test="${not loginRequired}">
        <div align="center">
            <h2>버그게시판 목록 페이지</h2>
        </div>

        <!-- 게시판 테이블 -->
        <div align="center">
            <table>
                <thead>
                    <tr>
                        <th>제목</th>
                        <th>작성자</th>
                        <th>내용</th>
<!--                         <th>등록일</th> -->
<!--                         <th>조회수</th> -->
                    </tr>
                </thead>
                <tbody>
                    <!-- 게시판 리스트 출력 -->
                    <c:forEach var="board" items="${boardList}">
                        <tr>
                            <td>
                                <!-- 제목 클릭 시 상세 페이지로 이동 -->
                                <a href="/MySite/board/detail.do?no=${board.no}" class="titleLink">
                                    ${board.title}
                                </a>
                            </td>
                            <td>${board.writer}</td>
                            <td>${board.content}</td>
<%--                             <td>${board.regDate}</td> --%>
<%--                             <td class="viewCount">${board.viewCnt}</td> --%>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <br>

            <!-- 페이징 UI -->
            <div class="pagination">
                <c:if test="${totalPages > 1}">
                    <!-- 이전 페이지 버튼 -->
                    <c:if test="${currentPage > 1}">
                        <a href="/MySite/board/list.do?page=${currentPage - 1}">이전</a>
                    </c:if>

                    <!-- 페이지 번호 -->
                    <c:forEach begin="1" end="${totalPages}" var="page">
                        <c:choose>
                            <c:when test="${page == currentPage}">
                                <strong>${page}</strong>
                            </c:when>
                            <c:otherwise>
                                <a href="/MySite/board/list.do?page=${page}">${page}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <!-- 다음 페이지 버튼 -->
                    <c:if test="${currentPage < totalPages}">
                        <a href="/MySite/board/list.do?page=${currentPage + 1}">다음</a>
                    </c:if>
                </c:if>
            </div>
            <button type="button" id="bugReport">버그 문의하기</button>
        </div>
    </c:if>
</body>
</html>
