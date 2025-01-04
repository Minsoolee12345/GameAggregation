<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시글 상세 보기</title>
    <style>
        /* 전체 컨테이너 */
        .container {
            width: 80%;
            margin: 0 auto;
            padding: 20px;
            font-family: Arial, sans-serif;
        }

        /* 제목 중앙 정렬 */
        .container h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        /* 게시글 정보 테이블 */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        table th, table td {
            border: 1px solid #ddd;
            padding: 10px;
        }

        table th {
            background-color: #f2f2f2;
            text-align: left;
            width: 15%;
        }

        /* 버튼 스타일 */
        .action-buttons {
            text-align: center;
            margin-bottom: 20px;
        }

        .action-buttons button {
            margin: 0 5px;
            padding: 10px 20px;
            cursor: pointer;
        }

        /* 댓글 섹션 */
        .comment-section {
            margin-top: 40px;
        }

        /* 공통 스타일 */
        .comment-container {
            border: 1px solid #ccc;
            padding: 10px;
            margin-bottom: 10px;
            position: relative;
            border-radius: 5px;
        }

        /* 댓글 스타일 */
        .comment-container.comment {
            background-color: #e6f7ff; /* 연한 파란색 배경 */
            border-left: 5px solid #1890ff; /* 왼쪽에 두꺼운 파란색 테두리 */
            position: relative;
        }

        .comment-container.comment::before {
            content: "💬"; /* 댓글 아이콘 */
            position: absolute;
            left: -25px;
            top: 10px;
            font-size: 20px;
        }

        .comment-author {
            font-weight: bold;
            color: #0050b3;
        }

        .comment-content {
            margin: 5px 0;
            font-size: 16px;
        }

        .comment-date {
            font-size: 0.9em;
            color: #777;
        }

        /* 대댓글 스타일 */
        .comment-container.reply {
            background-color: #fffbe6; /* 연한 노란색 배경 */
            border-left: 5px solid #ffd666; /* 왼쪽에 두꺼운 노란색 테두리 */
            margin-left: 40px; /* 들여쓰기 */
            position: relative;
        }

        .comment-container.reply::before {
            content: "🔁"; /* 대댓글 아이콘 */
            position: absolute;
            left: -25px;
            top: 10px;
            font-size: 20px;
        }

        .reply-author {
            font-weight: bold;
            color: #ad6800;
        }

        .reply-content {
            margin: 5px 0;
            font-size: 14px;
            font-style: italic;
        }

        .reply-date {
            font-size: 0.9em;
            color: #777;
        }

        /* 대댓글의 대댓글 스타일 */
        .comment-container.subreply {
            background-color: #f0fff4; /* 연한 녹색 배경 */
            border-left: 5px solid #73d13d; /* 왼쪽에 두꺼운 녹색 테두리 */
            margin-left: 80px; /* 더 깊은 들여쓰기 */
            position: relative;
        }

        .comment-container.subreply::before {
            content: "🗨️"; /* 대댓글의 대댓글 아이콘 */
            position: absolute;
            left: -25px;
            top: 10px;
            font-size: 20px;
        }

        .subreply-author {
            font-weight: bold;
            color: #237804;
        }

        .subreply-content {
            margin: 5px 0;
            font-size: 14px;
            font-style: italic;
        }

        .subreply-date {
            font-size: 0.9em;
            color: #777;
        }

        /* 댓글 및 대댓글 액션 버튼 */
        .comment-actions, .reply-actions, .subreply-actions {
            margin-top: 10px;
        }

        .comment-actions button, .reply-actions button, .subreply-actions button,
        .comment-actions form button, .reply-actions form button, .subreply-actions form button {
            margin-right: 5px;
            padding: 5px 10px;
            cursor: pointer;
            border: none;
            border-radius: 3px;
        }

        /* 답글 폼 */
        .reply-form, .subreply-form {
            display: none; /* 기본 숨김 */
            margin-top: 10px;
            margin-left: 40px; /* 들여쓰기 */
            border: 1px solid #ddd;
            padding: 10px;
            background-color: #fefefe;
            border-radius: 5px;
        }

        /* 대댓글의 대댓글 폼 */
        .subreply-form {
            margin-left: 80px; /* 더 깊은 들여쓰기 */
        }

        .reply-form textarea, .subreply-form textarea {
            width: 100%;
            height: 60px;
            padding: 5px;
            margin-bottom: 5px;
            resize: vertical;
            border-radius: 3px;
            border: 1px solid #ccc;
        }

        /* 댓글 작성 폼 */
        .comment-form textarea {
            width: 100%;
            height: 80px;
            padding: 5px;
            margin-bottom: 5px;
            resize: vertical;
            border-radius: 3px;
            border: 1px solid #ccc;
        }

        /* 댓글 작성 폼 및 버튼 스타일 */
        .comment-form, .reply-form, .subreply-form {
            border: 1px solid #ddd;
            padding: 10px;
            background-color: #fefefe;
            border-radius: 5px;
        }

        /* 목록으로 버튼 */
        .action-buttons button {
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 3px;
            transition: background-color 0.3s ease;
        }

        .action-buttons button:hover {
            background-color: #45a049;
        }

        /* 삭제 버튼 스타일 */
        .delete-button {
            background-color: #f44336;
            color: white;
            border: none;
            border-radius: 3px;
            transition: background-color 0.3s ease;
        }

        .delete-button:hover {
            background-color: #da190b;
        }

        /* 수정 버튼 스타일 */
        .edit-button {
            background-color: #008CBA;
            color: white;
            border: none;
            border-radius: 3px;
            transition: background-color 0.3s ease;
        }

        .edit-button:hover {
            background-color: #007bb5;
        }

        /* 답글 버튼 스타일 */
        .reply-button, .subreply-button {
            background-color: #e7e7e7;
            color: black;
            border: none;
            border-radius: 3px;
            transition: background-color 0.3s ease;
        }

        .reply-button:hover, .subreply-button:hover {
            background-color: #d6d6d6;
        }

        /* 답글 폼의 제출 버튼 스타일 */
        .reply-form button, .comment-form button, .subreply-form button {
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 3px;
            transition: background-color 0.3s ease;
        }

        .reply-form button:hover, .comment-form button:hover, .subreply-form button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="container">
        <div>
            <h2>게시글 상세 보기</h2>
        </div>
        <div>
            <table>
                <tr>
                    <th>작성자</th>
                    <td>${board.writer}</td>
                </tr>
                <tr>
                    <th>제목</th>
                    <td>${board.title}</td>
                </tr>
                <tr>
                    <th>내용</th>
                    <td>${board.content}</td>
                </tr>
                <tr>
                    <th>등록일</th>
                    <td>${board.regDate}</td>
                </tr>
                <!-- 선택된 게임 표시 -->
                <c:if test="${not empty board.gameTitle}">
                    <tr>
                        <th>선택된 게임</th>
                        <td>${board.gameTitle}</td>
                    </tr>
                </c:if>
            </table>
        </div>

        <!-- 작성자가 현재 사용자와 동일한 경우 수정 및 삭제 버튼 표시 -->
        <c:if test="${not empty currentUser and currentUser.id == board.writer}">
            <div class="action-buttons">
                <button type="button" class="edit-button" onclick="location.href='/MySite/board/edit.do?no=${board.no}'">수정</button>
                <form action="/MySite/board/delete.do" method="post" style="display:inline;">
                    <input type="hidden" name="no" value="${board.no}">
                    <button type="submit" class="delete-button" onclick="return confirm('정말로 삭제하시겠습니까?');">삭제</button>
                </form>
            </div>
        </c:if>

        <!-- 댓글 섹션 -->
        <div class="comment-section">
            <h3>댓글</h3>
            <c:if test="${empty commentList}">
                <p>댓글이 없습니다.</p>
            </c:if>

            <c:if test="${not empty commentList}">
                <c:forEach var="comment" items="${commentList}">
                    <div class="comment-container comment">
                        <!-- 댓글 내용 표시 -->
                        <div class="comment-author">${comment.writer}</div>
                        <div class="comment-content">${comment.content}</div>
                        <div class="comment-date">${comment.regDate}</div>

                        <!-- 댓글 액션 버튼들 -->
                        <div class="comment-actions">
                            <c:if test="${not empty currentUser and currentUser.id == comment.writer}">
                                <form action="/MySite/reply/replyDelete.do" method="post" style="display:inline;">
                                    <input type="hidden" name="replyNo" value="${comment.replyNo}">
                                    <input type="hidden" name="boardNo" value="${board.no}">
                                    <button type="submit" class="delete-button" onclick="return confirm('정말로 삭제하시겠습니까?');">삭제</button>
                                </form>
                            </c:if>
                            <c:if test="${not empty currentUser}">
                                <button type="button" class="reply-button" onclick="toggleReplyForm(event)">답글</button>
                            </c:if>
                        </div>

                        <!-- 답글 폼 -->
                        <div class="reply-form">
                            <form action="/MySite/reply/addComment.do" method="post">
                                <input type="hidden" name="boardNo" value="${board.no}">
                                <input type="hidden" name="parentReplyNo" value="${comment.replyNo}">
                                <textarea name="content" placeholder="대댓글을 작성해 주세요." required></textarea>
                                <button type="submit">대댓글 작성</button>
                            </form>
                        </div>

                        <!-- 대댓글이 있는 경우 -->
                        <c:if test="${not empty comment.children}">
                            <c:forEach var="reply" items="${comment.children}">
                                <div class="comment-container reply">
                                    <!-- 대댓글 내용 표시 -->
                                    <div class="reply-author">${reply.writer}</div>
                                    <div class="reply-content">${reply.content}</div>
                                    <div class="reply-date">${reply.regDate}</div>

                                    <!-- 대댓글 액션 버튼들 -->
                                    <div class="reply-actions">
                                        <c:if test="${not empty currentUser and currentUser.id == reply.writer}">
                                            <form action="/MySite/reply/replyUpdateForm.do" method="get" style="display:inline;">
                                                <input type="hidden" name="replyNo" value="${reply.replyNo}">
                                                <button type="submit" class="edit-button">수정</button>
                                            </form>
                                            <form action="/MySite/reply/replyDelete.do" method="post" style="display:inline;">
                                                <input type="hidden" name="replyNo" value="${reply.replyNo}">
                                                <input type="hidden" name="boardNo" value="${board.no}">
                                                <button type="submit" class="delete-button" onclick="return confirm('정말로 삭제하시겠습니까?');">삭제</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${not empty currentUser}">
                                            <button type="button" class="subreply-button" onclick="toggleSubReplyForm(event)">대댓글</button>
                                        </c:if>
                                    </div>

                                    <!-- 대댓글 답글 폼 -->
                                    <div class="subreply-form">
                                        <form action="/MySite/reply/addComment.do" method="post">
                                            <input type="hidden" name="boardNo" value="${board.no}">
                                            <input type="hidden" name="parentReplyNo" value="${reply.replyNo}">
                                            <textarea name="content" placeholder="대댓글을 작성해 주세요." required></textarea>
                                            <button type="submit">대댓글 작성</button>
                                        </form>
                                    </div>

                                    <!-- 대댓글의 대댓글이 있는 경우 -->
                                    <c:if test="${not empty reply.children}">
                                        <c:forEach var="subreply" items="${reply.children}">
                                            <div class="comment-container subreply">
                                                <!-- 대댓글의 대댓글 내용 표시 -->
                                                <div class="subreply-author">${subreply.writer}</div>
                                                <div class="subreply-content">${subreply.content}</div>
                                                <div class="subreply-date">${subreply.regDate}</div>

                                                <!-- 대댓글의 대댓글 액션 버튼들 -->
                                                <div class="subreply-actions">
                                                    <c:if test="${not empty currentUser and currentUser.id == subreply.writer}">
                                                        <form action="/MySite/reply/replyUpdateForm.do" method="get" style="display:inline;">
                                                            <input type="hidden" name="replyNo" value="${subreply.replyNo}">
                                                            <button type="submit" class="edit-button">수정</button>
                                                        </form>
                                                        <form action="/MySite/reply/replyDelete.do" method="post" style="display:inline;">
                                                            <input type="hidden" name="replyNo" value="${subreply.replyNo}">
                                                            <input type="hidden" name="boardNo" value="${board.no}">
                                                            <button type="submit" class="delete-button" onclick="return confirm('정말로 삭제하시겠습니까?');">삭제</button>
                                                        </form>
                                                    </c:if>
                                                    <c:if test="${not empty currentUser}">
                                                        <button type="button" class="subreply-button" onclick="toggleSubReplyForm(event)">대댓글</button>
                                                    </c:if>
                                                </div>

                                                <!-- 대댓글의 대댓글 답글 폼 -->
                                                <div class="subreply-form">
                                                    <form action="/MySite/reply/addComment.do" method="post">
                                                        <input type="hidden" name="boardNo" value="${board.no}">
                                                        <input type="hidden" name="parentReplyNo" value="${subreply.replyNo}">
                                                        <textarea name="content" placeholder="대댓글을 작성해 주세요." required></textarea>
                                                        <button type="submit">대댓글 작성</button>
                                                    </form>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:if>
                    </div>
                </c:forEach>
            </c:if>

            <!-- 댓글 작성 폼 -->
            <c:if test="${not empty currentUser}">
                <div class="comment-form">
                    <h4>댓글 작성</h4>
                    <form action="/MySite/reply/addComment.do" method="post">
                        <input type="hidden" name="boardNo" value="${board.no}">
                        <textarea name="content" placeholder="댓글을 작성해 주세요." required></textarea>
                        <button type="submit">댓글 작성</button>
                    </form>
                </div>
            </c:if>

            <!-- 로그인하지 않은 경우 -->
            <c:if test="${empty currentUser}">
                <p>댓글을 작성하려면 <a href="/MySite/login.do">로그인</a>하세요.</p>
            </c:if>
        </div>

        <!-- 게시글 목록으로 이동 버튼 -->
        <div class="action-buttons">
            <button type="button" onclick="location.href='/MySite/board/list.do'">목록으로</button>
        </div>
    </div>

    <script>
        function toggleReplyForm(event) {
            const button = event.target;
            const commentElement = button.closest('.comment-container');
            if (!commentElement) {
                console.error('Comment element not found.');
                return;
            }
            const form = commentElement.querySelector('.reply-form');
            if (!form) {
                console.error('Reply form not found.');
                return;
            }
            if (form.style.display === 'none' || form.style.display === '') {
                form.style.display = 'block';
            } else {
                form.style.display = 'none';
            }
        }

        function toggleSubReplyForm(event) {
            const button = event.target;
            const commentElement = button.closest('.comment-container');
            if (!commentElement) {
                console.error('Comment element not found.');
                return;
            }
            const form = commentElement.querySelector('.subreply-form');
            if (!form) {
                console.error('Subreply form not found.');
                return;
            }
            if (form.style.display === 'none' || form.style.display === '') {
                form.style.display = 'block';
            } else {
                form.style.display = 'none';
            }
        }
    </script>
</body>
</html>