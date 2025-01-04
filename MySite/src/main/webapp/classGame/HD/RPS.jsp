<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Random" %>
<%
    // 게임 선택지와 결과 처리
    String[] choices = {"가위", "바위", "보"};
    String message = "가위, 바위, 보 중 하나를 선택하세요.";
    String userChoice = request.getParameter("choice");
    String computerChoice = null;

    if (userChoice != null) {
        Random random = new Random();
        computerChoice = choices[random.nextInt(choices.length)];

        if (userChoice.equals(computerChoice)) {
            message = "비겼습니다! 컴퓨터도 " + computerChoice + "를 냈습니다.";
        } else if (
            (userChoice.equals("가위") && computerChoice.equals("보")) ||
            (userChoice.equals("바위") && computerChoice.equals("가위")) ||
            (userChoice.equals("보") && computerChoice.equals("바위"))
        ) {
            message = "축하합니다! 당신이 이겼습니다. 컴퓨터는 " + computerChoice + "를 냈습니다.";
        } else {
            message = "아쉽네요! 컴퓨터가 이겼습니다. 컴퓨터는 " + computerChoice + "를 냈습니다.";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>가위바위보 게임</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f8ff;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            text-align: center;
            background: #ffffff;
            border: 1px solid #ccc;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        h1 {
            color: #333;
        }
        p {
            font-size: 16px;
            color: #555;
        }
        .choices button {
            padding: 10px 20px;
            margin: 5px;
            background-color: #4caf50;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }
        .choices button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>가위바위보 게임</h1>
        <p><%= message %></p>
        <div class="choices">
            <form method="post">
                <button type="submit" name="choice" value="가위">가위</button>
                <button type="submit" name="choice" value="바위">바위</button>
                <button type="submit" name="choice" value="보">보</button>
            </form>
        </div>
    </div>
</body>
</html>
