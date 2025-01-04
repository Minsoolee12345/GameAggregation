<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // 요청 파라미터에서 snakeSpeed 값을 가져옵니다. 없으면 기본값 150을 설정
    String snakeSpeedParam = request.getParameter("snakeSpeed");
    int snakeSpeed = (snakeSpeedParam != null) ? Integer.parseInt(snakeSpeedParam) : 150;
    
    // 요청 파라미터에서 obstacleP 값을 가져옵니다. 없으면 기본값 0.05를 설정
    String obstaclePParam = request.getParameter("obstacleP");
    Double obstacleP = (obstaclePParam != null) ? Double.parseDouble(obstaclePParam) : 0.05;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"> <!-- 문자 인코딩을 UTF-8로 설정 -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> <!-- 화면 크기 조정, 모바일 대응 -->
    <title>지렁이 게임</title>
    <link rel="stylesheet" href="../resource/style.css">
</head>
<body>
    <h1>지렁이 게임 (Snake Game)</h1>
     <!-- 점수를 표시할 부분 -->
    <p>현재 점수: <span id="score">0</span></p>
     <!-- 게임 화면을 그릴 캔버스 -->
    <canvas id="gameCanvas" width="400" height="400"></canvas>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        // JSP에서 설정된 snakeSpeed 값을 JavaScript 변수에 할당
        let snakeSpeed = <%= snakeSpeed %>;
        
        // JSP에서 설정된 obstacleP 값을 JavaScript 변수에 할당
        let obstacleP = <%= obstacleP %>;
    </script>
    <script src="../resource/script.js"></script>
</body>
</html>
