<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게임 신청 관리</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f9e8;
            color: #333;
        }

        h1 {
            text-align: center;
            color: #4d774e;
        }

        .table-container {
            width: 80%;
            margin: 20px auto;
            max-height: 600px;
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
            background-color: #43a047;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .action-button.reject {
            background-color: #e53935;
        }

        .action-button:hover {
            opacity: 0.8;
        }

        .no-applications {
            text-align: center;
            padding: 20px;
            color: #777;
        }

        /* 메시지 스타일 */
        .message {
            width: 80%;
            margin: 20px auto;
            padding: 10px;
            border-radius: 4px;
            text-align: center;
            font-weight: bold;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script>
        $(document).ready(function() {
            // 메시지 박스를 5초 후에 자동으로 사라지게 함
            setTimeout(function(){
                $(".message").fadeOut("slow");
            }, 5000); // 5000 밀리초 = 5초

            // 승인 버튼 클릭 시 확인 대화상자 표시
            $(".approve-button").click(function(event) {
                var confirmApprove = confirm("정말로 이 게임 신청을 승인하시겠습니까?");
                if (!confirmApprove) {
                    event.preventDefault(); // 폼 제출 중단
                }
            });

            // 거절 버튼 클릭 시 확인 대화상자 표시
            $(".reject-button").click(function(event) {
                var confirmReject = confirm("정말로 이 게임 신청을 거절하시겠습니까?");
                if (!confirmReject) {
                    event.preventDefault(); // 폼 제출 중단
                }
            });
        });
    </script>
</head>
<body>
    <div id="container">
        <header>
            <h1>게임 신청 관리</h1>
        </header>
        
        <!-- 메시지 표시 영역 -->
        <c:if test="${not empty message}">
            <div class="message 
                <c:choose>
                    <c:when test="${messageType == 'success'}">success</c:when>
                    <c:otherwise>error</c:otherwise>
                </c:choose>
            ">
                ${message}
            </div>
        </c:if>
        
        <div class="table-container">
            <c:if test="${empty pendingApplications}">
                <p class="no-applications">현재 승인 대기 중인 게임 신청이 없습니다.</p>
            </c:if>
            <c:if test="${not empty pendingApplications}">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>게임 URL</th>
                            <th>게임 제목</th>
                            <th>게임 소개</th>
                            <th>신청일</th>
                            <th>승인</th>
                            <th>거절</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="application" items="${pendingApplications}">
                            <tr id="application-${application.id}">
                                <td>${application.id}</td>
                                <td><a href="${application.gameUrl}" target="_blank">링크 보기</a></td>
                                <td>${application.gameTitle}</td>
                                <td>${application.gameIntro}</td>
                                <td>${application.createdDate}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/approveGameApplication.do" method="post" style="display:inline;">
                                        <input type="hidden" name="applicationId" value="${application.id}">
                                        <button type="submit" class="action-button approve-button">승인</button>
                                    </form>
                                </td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/rejectGameApplication.do" method="post" style="display:inline;">
                                        <input type="hidden" name="applicationId" value="${application.id}">
                                        <button type="submit" class="action-button reject-button">거절</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>
        <div style="text-align: center; margin-top: 20px;">
            <a href="/MySite/admin.do" class="admin-button">관리자 페이지로 돌아가기</a>
        </div>
    </div>
</body>
</html>