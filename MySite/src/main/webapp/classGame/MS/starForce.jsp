<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>단계별 공 맞추기 게임</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <style>
        body {
            text-align: center;
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin-top: 50px;
            transform: scale(2.5); /* 화면을 확대 */
            transform-origin: top center;
        }
        
        h1 {
            color: #333;
            font-size: 3em;
        }
        
        #gameArea {
            position: relative;
            width: 1500px;
            height: 100px;
            background-color: #e0e0e0;
            margin: 40px auto;
            overflow: hidden;
            border: 5px solid #888;
            border-radius: 20px;
        }
        
        #ball {
            position: absolute;
            width: 75px;
            height: 75px;
            background-color: #ff5722;
            border-radius: 50%;
            top: 12.5px;
        }
        
        #targetArea {
            position: absolute;
            width: 150px;
            height: 75px;
            background-color: rgba(0, 150, 136, 0.5);
            top: 12.5px;
            border-radius: 10px;
        }
        
        #controls {
            margin-top: 30px;
        }
        #controls button {
            font-size: 24px;
            padding: 15px 30px;
            margin: 15px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
        }
        #startButton {
            background-color: #4CAF50;
            color: white;
        }
        #stopButton {
            background-color: #f44336;
            color: white;
        }
        #status {
            margin-top: 30px;
            font-size: 26px;
            color: #333;
        }
        #currentLevel {
            font-size: 26px;
            color: #555;
            margin-top: 20px;
        }
        #countdown {
            font-size: 24px;
            color: #d9534f;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <h1>단계별 공 맞추기 게임</h1>
    <div id="gameArea">
        <div id="ball"></div>
        <div id="targetArea"></div>
    </div>
    <div id="controls">
        <button id="startButton">시작</button>
        <button id="stopButton" disabled>정지</button>
    </div>
    <div id="status"></div>
    <div id="currentLevel">현재 단계: <span id="levelDisplay">1</span></div>
    <div id="countdown">카운트다운: <span id="countdownDisplay">8</span>초</div>

    <script>
        let level = 1; // 현재 레벨
        let maxLevel = 10; // 최대 레벨
        let speed = 1000; // 공 이동 속도
        let targetWidth = 150; // 목표 영역 너비
        let ballMoving = false; // 공 이동 상태
        let ballPosition = 0; // 공 위치
        let ballDirection = 1; // 공 이동 방향
        let intervalId; // 공 이동을 위한 interval ID
        let countdownInterval; // 카운트다운을 위한 interval ID
        let countdownTime = 8; // 카운트다운 시간 (초 단위)

        // 현재 레벨을 화면에 표시하는 함수
        function updateLevelDisplay() {
            $('#levelDisplay').text(level); // 현재 레벨을 levelDisplay 요소에 출력
        }

        // 카운트다운을 화면에 표시하는 함수
        function updateCountdownDisplay() {
            $('#countdownDisplay').text(countdownTime); // 카운트다운을 countdownDisplay 요소에 출력
        }

        // 게임 시작 함수
        function startGame() {
            $('#startButton').hide(); // 시작 버튼 숨기기
            $('#stopButton').prop('disabled', false); // 정지 버튼 활성화
            $('#status').text('단계 ' + level + ' 시작!'); // 현재 단계 표시
            updateLevelDisplay(); // 레벨 업데이트
            setTargetArea(); // 목표 영역 설정
            moveBall(); // 공 이동 시작
            startCountdown(); // 카운트다운 시작
        }

        // 목표 영역을 설정하는 함수 (무작위 위치에 배치)
        function setTargetArea() {
            let targetStart = Math.random() * ($('#gameArea').width() - targetWidth); // 무작위 위치 지정
            $('#targetArea').css({
                width: targetWidth + 'px', // 목표 영역의 너비 설정
                left: targetStart + 'px' // 목표 영역의 위치 선정
            });
        }

        // 공을 좌우로 움직이는 함수
        function moveBall() 
        {
            ballMoving = true; // 공이 움직이는 상태로 설정
            intervalId = setInterval(() => {
                ballPosition += ballDirection * 10; // 방향에 따라 공 위치 업데이트

                // 공이 벽에 닿으면 방향을 반대로 전환
                if(ballPosition <= 0 || ballPosition >= $('#gameArea').width() - $('#ball').width()) 
                {
                    ballDirection *= -1;
                }

                $('#ball').css('left', ballPosition + 'px'); // 공의 위치를 화면에 반영
            }, speed / 50); // 속도 조정 (속도가 클수록 느려짐)
        }

        // 카운트다운 시작 함수
        function startCountdown() 
        {
            countdownTime = 8; // 카운트다운을 8초로 초기화
            updateCountdownDisplay(); // 화면에 카운트다운을 업데이트
            countdownInterval = setInterval(() => {
                countdownTime--; // 카운트다운 시간 감소
                updateCountdownDisplay(); // 감소된 시간을 화면에 업데이트

                if(countdownTime <= 0) 
                { // 시간이 0이 되면 게임 실패 처리
                    clearInterval(countdownInterval); // 카운트다운 정지
                    $('#status').text('실패! 1단계부터 다시 시작하세요.'); // 실패 메시지 출력
                    resetGame(true); // 게임 초기화
                }
            }, 1000); // 1초마다 카운트다운 업데이트
        }

        // 게임 정지 함수
        function stopGame() 
        {
            clearInterval(intervalId); // 공 이동 정지
            clearInterval(countdownInterval); // 카운트다운 정지
            ballMoving = false;

            let ballLeft = $('#ball').position().left; // 공의 왼쪽 좌표
            let targetLeft = $('#targetArea').position().left; // 목표 영역의 왼쪽 좌표
            let targetRight = targetLeft + $('#targetArea').width(); // 목표 영역의 오른쪽 좌표

            // 공이 목표 내에 있으면 성공 처리, 아니면 실패 처리
            if(ballLeft >= targetLeft && ballLeft <= targetRight)
            {
                $('#status').text('성공! 다음 단계로 이동합니다.');
                nextLevel(); // 성공 시 다음 단계로 이동
            } 
            else 
            {
                $('#status').text('실패! 1단계부터 다시 시작하세요.');
                resetGame(true); // 실패 시 게임 초기화
            }
        }

        // 다음 레벨로 이동하는 함수
        function nextLevel() 
        {
        	// 최대 레벨까지 진행하지 않았다면
            if(level < maxLevel) 
            {
                level++; // 레벨 증가
                updateLevelDisplay(); // 레벨 업데이트
                speed *= 0.85; // 공 이동 속도 증가
                targetWidth *= 0.9; // 목표 영역 너비 축소
                $('#stopButton').prop('disabled', true); // 정지 버튼 비활성화
                $('#startButton').text('다음 단계 시작').show(); // 다음 단계 시작 버튼 표시
            } 
            else 
            {
                $('#status').text('축하합니다! 모든 단계를 클리어하셨습니다!'); // 모든 단계를 클리어한 경우
                $('#startButton').text('다시 시작').show(); // 다시 시작 버튼 표시
            }
        }

     // 게임 초기화 함수
        function resetGame(isFailure) {
            clearInterval(countdownInterval); // 카운트다운 정지
            clearInterval(intervalId); // 공 이동 정지
            ballMoving = false; // 공 이동 상태 초기화
            
            if (isFailure) {
                level = 1; // 실패 시 레벨 초기화
                speed = 1000; // 속도 초기화
                targetWidth = 150; // 목표 영역 너비 초기화
                $('#status').text('게임 실패! 1단계로 돌아갑니다.'); // 상태 메시지 업데이트
            }

            updateLevelDisplay(); // 레벨 표시 업데이트
            $('#stopButton').prop('disabled', true); // 정지 버튼 비활성화
            $('#startButton').text('1단계 시작').show(); // 시작 버튼 표시
            countdownTime = 8; // 카운트다운 초기화
            updateCountdownDisplay(); // 카운트다운 표시 업데이트
        }

        // 시작 버튼 클릭 시 게임 시작
        $('#startButton').click(startGame);
        // 정지 버튼 클릭 시 게임 정지
        $('#stopButton').click(stopGame);

        // 스페이스바를 눌러서 게임을 정지
        $(document).keydown(function(event) 
        {
            if (event.keyCode === 32 && !$('#stopButton').prop('disabled')) 
            {
                stopGame();
            }
        });
    </script>
</body>
</html>