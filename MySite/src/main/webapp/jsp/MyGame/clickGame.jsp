<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="kr.ac.kopo.vo.GameVO"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>간단한 클릭 게임</title>
    <style>
        /* 기존 스타일 유지 */
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            background-color: #f0f0f0;
        }

        .game-container {
            background-color: #fff;
            padding: 50px;
            margin: 100px auto;
            width: 300px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        button {
            padding: 10px 20px;
            font-size: 16px;
            margin: 10px;
            cursor: pointer;
        }

        #clickButton {
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
        }

        #startButton {
            background-color: #008CBA;
            color: white;
            border: none;
            border-radius: 5px;
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
    <!-- jQuery 포함 -->
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script>
        // JavaScript 코드
        let score = 0;
        let timeLeft = 10; // 게임 시간 (초)
        let timerInterval;
        let gameId = ${game.gameId}; // 서버에서 전달된 gameId

        function startGame() {
            document.getElementById("startButton").disabled = true;
            document.getElementById("score").innerText = "점수: 0";
            timeLeft = 10;
            score = 0;
            document.getElementById("time").innerText = "남은 시간: " + timeLeft + "초";

            // 타이머 시작
            timerInterval = setInterval(function() {
                timeLeft--;
                document.getElementById("time").innerText = "남은 시간: " + timeLeft + "초";
                if (timeLeft <= 0) {
                    clearInterval(timerInterval);
                    endGame();
                }
            }, 1000);
        }

        function clickButton() {
            if (timeLeft > 0) {
                score++;
                document.getElementById("score").innerText = "점수: " + score;
            }
        }

        function endGame() {
            document.getElementById("startButton").disabled = false;
            alert("게임 종료! 당신의 점수는 " + score + "점입니다.");
            // 서버로 점수 전송
            submitScore(gameId, score);
        }

        // 서버로 점수를 전송하는 함수
		function submitScore(gameId, score) {
		    $.ajax({
		        url: '/MySite/submitScore.do', // 점수 제출 경로
		        method: 'POST',
		        data: {
		            gameId: gameId,
		            score: score
		        },
		        dataType: 'text', // 서버에서 문자열 응답을 기대
		        success: function(response) {
		            if (response.trim() === "점수 제출 성공") {
		                alert("점수가 성공적으로 저장되었습니다!");
		                window.location.href = '/MySite/leaderboard.do?gameId=' + encodeURIComponent(gameId);
		            } else {
		                alert("점수 제출 실패: " + response);
		            }
		        },
		        error: function(xhr, status, error) {
		            alert("점수 제출 중 오류 발생: " + xhr.responseText);
		        }
		    });
		}

    </script>
</head>

<body>
    <a id="homeButton" href="/MySite/index.do">홈으로 돌아가기</a>
    <div class="game-container">
        <h1>간단한 클릭 게임</h1>
        <p id="time">남은 시간: 10초</p>
        <p id="score">점수: 0</p>
        <button id="clickButton" onclick="clickButton()">클릭하세요!</button>
        <br>
        <br>
        <button id="startButton" onclick="startGame()">게임 시작</button>
    </div>
</body>
</html>
