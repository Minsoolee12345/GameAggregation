<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>반응 속도 테스트</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            background-color: #f5f5f5;
            padding: 20px;
            margin: 0;
            height: 100vh;
            position: relative;
        }

        h1 {
            color: #333;
        }

        #score, #round {
            font-size: 20px;
            margin: 10px 0;
        }

        button {
            font-size: 18px;
            padding: 10px 20px;
            margin: 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        button:disabled {
            background-color: #a5d6a7;
            cursor: not-allowed;
        }

        button:hover:not(:disabled) {
            background-color: #45a049;
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
        let startTime;
        let totalScore = 0;
        let round = 0;
        let isRoundInProgress = false; // 라운드 진행 상태

        // 페이지 로드 시 초기 설정
        window.onload = function() {
            document.getElementById("startButton").disabled = false;
            // 이벤트 리스너 추가
            document.addEventListener("click", clickReaction);
        };

        function startRound() {
            if (isRoundInProgress) {
                return; // 이미 라운드가 진행 중이면 함수 종료
            }

            if (round >= 5) {
                alert("게임 종료! 총 점수: " + totalScore);
                // 서버로 점수 전송
                const gameId = "Reaction_Time_Test"; // 고유 게임 ID
                const userId = document.getElementById("userId").value; // 숨겨진 필드에서 userId 가져오기
                submitScore(gameId, userId, totalScore);
                return;
            }

            round++;
            document.getElementById("round").innerText = "Round: " + round;

            // 라운드 시작 전에 화면을 원래 색으로 복원
            document.body.style.backgroundColor = "#f5f5f5";

            // "라운드 시작" 버튼 비활성화
            document.getElementById("startButton").disabled = true;

            setTimeout(function() {
                document.body.style.backgroundColor = "green"; // 화면을 초록색으로 바꿈
                startTime = new Date().getTime();
                isRoundInProgress = true; // 라운드 진행 상태를 true로 설정
                console.log("Round " + round + " started. Click the screen!");
            }, Math.random() * 3000 + 1000); // 1~4초 후 초록색으로 변경
        }

        function clickReaction(event) {
            // Prevent clicks on the start button from triggering reaction
            const startButton = document.getElementById("startButton");
            if (event.target === startButton) {
                return;
            }

            if (!isRoundInProgress) {
                return;
            }

            const reactionTime = new Date().getTime() - startTime;
            const roundScore = Math.max(0, 1000 - reactionTime);
            totalScore += roundScore;

            document.getElementById("score").innerText = "Score: " + totalScore;
            isRoundInProgress = false; // 라운드 진행 상태를 false로 설정

            // "라운드 시작" 버튼 다시 활성화
            document.getElementById("startButton").disabled = false;

            console.log("Round " + round + " reaction time: " + reactionTime + "ms, Score: " + roundScore);
            // 다음 라운드 시작
            startRound();
        }

        // 서버로 점수를 전송하는 함수
        function submitScore(gameId, userId, score) {
            $.ajax({
                url: '/MySite/submitScore.do', // 점수 제출 경로
                method: 'POST',
                data: {
                    gameId: gameId,
                    userId: userId,
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
    <h1>반응 속도 테스트</h1>
    <input type="hidden" id="userId" value="${userVO.id}"> <!-- 사용자 ID를 숨겨진 필드에 저장 -->
    <p id="score">Score: 0</p>
    <p id="round">Round: 0</p>
    <button id="startButton" onclick="startRound()">라운드 시작</button>
</body>
</html>
