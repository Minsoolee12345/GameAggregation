<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게임 신청 완료</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f9e8;
            text-align: center;
            padding: 50px;
        }

        .message {
            display: inline-block;
            padding: 20px;
            border-radius: 8px;
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
            margin-bottom: 20px;
        }

        a {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #4d774e;
            color: #fff;
            text-decoration: none;
            border-radius: 4px;
        }

        a:hover {
            background-color: #3e6740;
        }
    </style>
</head>
<body>
    <div class="message">
        게임 신청이 성공적으로 제출되었습니다!
    </div>
    <br/>
    <a href="${pageContext.request.contextPath}/index.do">홈으로 돌아가기</a>
</body>
</html>