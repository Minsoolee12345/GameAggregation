<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게임 신청하기</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f9e8;
            margin: 0;
            padding: 20px;
            line-height: 1.6;
        }

        .container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #333;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        th, td {
            padding: 10px;
        }

        th {
            text-align: left;
            width: 20%;
            background-color: #f5f5f5;
        }

        input[type="text"], textarea {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
        }

        textarea {
            resize: vertical;
            height: 100px;
        }

        button {
            padding: 10px 15px;
            background-color: #3498db;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            display: block;
            margin: 0 auto;
        }

        button:hover {
            background-color: #2980b9;
        }

        /* 메시지 스타일 */
        .message {
            width: 100%;
            margin-bottom: 20px;
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
        });
    </script>
</head>
<body>
    <div class="container">
        <h2>게임 신청하기</h2>
        
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
        
        <form action="${pageContext.request.contextPath}/submitGameApplication.do" method="post">
            <table>
                <tr>
                    <th>게임 URL</th>
                    <td><input type="text" name="gameUrl" placeholder="게임 URL을 입력하세요" required></td>
                </tr>
                <tr>
                    <th>게임 제목</th>
                    <td><input type="text" name="gameTitle" placeholder="게임 제목을 입력하세요" required></td>
                </tr>
                <tr>
                    <th>게임 소개</th>
                    <td><textarea name="gameIntro" placeholder="게임 소개를 입력하세요" required></textarea></td>
                </tr>
            </table>
            <button type="submit">신청 제출</button>
        </form>
    </div>
</body>
</html>