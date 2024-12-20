<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Aim Training Game</title>
<style>
#gameArea {
	position: relative;
	width: 800px;
	height: 600px;
	border: 1px solid #000;
	overflow: hidden;
	margin: 0 auto;
}

.target {
	position: absolute;
	width: 50px;
	height: 50px;
	background-color: red;
	border-radius: 50%;
	cursor: pointer;
}

#info {
	text-align: center;
	margin-top: 10px;
}

#score, #time {
	font-size: 20px;
	margin: 0 20px;
}

#startButton, #restartButton {
	display: block;
	margin: 20px auto;
	font-size: 20px;
	padding: 10px 20px;
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
	var score = 0;
	var timeLeft = 30;
	var timerId;
	var totalTargets = 3;
	var targets = [];

	function startGame() {
		document.getElementById('startButton').style.display = 'none';
		document.getElementById('restartButton').style.display = 'none';
		score = 0;
		timeLeft = 30;
		document.getElementById('score').innerHTML = 'Score: ' + score;
		document.getElementById('time').innerHTML = 'Time Left: ' + timeLeft
				+ 's';

		// 기존 타겟 제거
		var gameArea = document.getElementById('gameArea');
		gameArea.innerHTML = '';

		// 타겟 배열 초기화 및 타겟 생성
		targets = [];
		for (var i = 0; i < totalTargets; i++) {
			createTarget(i);
		}

		timerId = setInterval(countDown, 1000);
	}

	function createTarget(index) {
		var gameArea = document.getElementById('gameArea');
		var target = document.createElement('div');
		target.className = 'target';
		target.id = 'target' + index;
		target.onclick = function() {
			hitTarget(this);
		};
		gameArea.appendChild(target);
		targets.push(target);
		moveTarget(target);
	}

	function moveTarget(target) {
		var gameArea = document.getElementById('gameArea');
		var maxWidth = gameArea.offsetWidth - 50; // 타겟의 너비
		var maxHeight = gameArea.offsetHeight - 50; // 타겟의 높이
		var randX = Math.floor(Math.random() * maxWidth);
		var randY = Math.floor(Math.random() * maxHeight);
		target.style.left = randX + 'px';
		target.style.top = randY + 'px';
	}

	function hitTarget(target) {
		score++;
		document.getElementById('score').innerHTML = 'Score: ' + score;
		moveTarget(target); // 클릭된 타겟을 새로운 위치로 이동
	}

	function countDown() {
		timeLeft--;
		document.getElementById('time').innerHTML = 'Time Left: ' + timeLeft
				+ 's';
		if (timeLeft <= 0) {
			clearInterval(timerId);
			// 타겟 제거
			targets.forEach(function(target) {
				target.parentNode.removeChild(target);
			});
			targets = [];
			alert('Game Over! Your score is ' + score);
			// 게임 종료 후 "처음부터 하기" 버튼 표시
			document.getElementById('restartButton').style.display = 'block';
			// 서버로 점수 전송
			submitScore('aimTest', score);
		}
	}

	function restartGame() {
		startGame();
	}

	function submitScore(gameId, score) {
	    // 세션에서 userId를 가져와 서버로 전달
	    const userId = document.getElementById("userId").value; // 사용자 ID를 숨겨진 필드에서 가져오기

	    $.ajax({
	        url: '/MySite/submitScore.do', // 점수 제출 경로
	        method: 'POST',
	        data: {
	            gameId: gameId,
	            score: score,
	            userId: userId // userId를 추가
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
	<button id="startButton" onclick="startGame()">Start</button>
	<button id="restartButton" onclick="restartGame()"
		style="display: none;">처음부터 하기</button>
	<div id="gameArea">
		<!-- 타겟은 JavaScript에서 동적으로 생성됩니다 -->
	</div>
	<div id="info">
		<span id="score">Score: 0</span> <span id="time">Time Left: 30s</span>
	</div>
</body>
</html>