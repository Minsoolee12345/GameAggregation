<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>세상에서 제일 어려운 게임</title>
    <style>
        /* 캔버스 스타일 설정 */
        canvas {
            background-color: #f0f0f0; /* 배경색 설정 */
            display: block; /* 블록 요소로 설정 */
            margin: 0 auto; /* 가운데 정렬 */
            border: 1px solid #000; /* 검은색 테두리 */
        }
        /* 게임 메시지 스타일 설정 */
        #gameMessage {
            text-align: center; /* 가운데 정렬 */
            font-size: 24px; /* 폰트 크기 설정 */
            display: none; /* 초기에는 보이지 않도록 설정 */
        }
        /* 타이머 바 스타일 설정 */
        #timerBarContainer {
            position: relative;
            width: 800px;
            height: 20px;
            background-color: #ccc; /* 바 배경색 */
            margin: 0 auto;
            margin-top: 10px;
            border: 1px solid #000;
        }
        #timerBar {
            width: 100%;
            height: 100%;
            background-color: red; /* 타이머 바 색상 */
        }
    </style>
</head>
<body>

<!-- 타이머 바 컨테이너 -->
<div id="timerBarContainer">
    <div id="timerBar"></div>
</div>

<!-- 게임 캔버스 -->
<canvas id="gameCanvas" width="800" height="600"></canvas>
<!-- 게임 메시지를 표시할 div -->
<div id="gameMessage"></div>

<!-- jQuery 라이브러리 추가 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(function() {
    // 캔버스 및 컨텍스트 가져오기
    var canvas = $('#gameCanvas')[0]
    var ctx = canvas.getContext('2d')

    // 현재 레벨 인덱스 초기화
    var currentLevel = 0
    // 레벨 데이터 배열
    var levels = [
        // 레벨 1 데이터
        {
            // 플레이어 시작 위치
                       playerStart: { x: 50, y: 550 },
            // 목표 지점 정보
            goal: { x: 750, y: 280, width: 30, height: 40, color: 'green' },
            // 적 캐릭터들 정보
            enemies: [
                { x: 200, y: 200, width: 20, height: 20, color: 'blue', speed: 4, direction: 1 },
                { x: 500, y: 250, width: 20, height: 20, color: 'blue', speed: 3, direction: 1 },
                { x: 300, y: 290, width: 20, height: 20, color: 'blue', speed: 5, direction: 1 },
                { x: 300, y: 380, width: 20, height: 20, color: 'blue', speed: 5, direction: -1 },
                { x: 400, y: 330, width: 20, height: 20, color: 'blue', speed: 5, direction: 1 },
                
                { x: 400, y: 200, width: 20, height: 20, color: 'blue', speed: 5, direction: 1 },
                { x: 300, y: 250, width: 20, height: 20, color: 'blue', speed: 5, direction: 1 },
                { x: 400, y: 290, width: 20, height: 20, color: 'blue', speed: 4, direction: 1 },
                { x: 500, y: 380, width: 20, height: 20, color: 'blue', speed: 4, direction: -1 },
                { x: 600, y: 330, width: 20, height: 20, color: 'blue', speed: 4, direction: 1 },
                
                { x: 600, y: 200, width: 20, height: 20, color: 'blue', speed: 3, direction: 1 },
                { x: 100, y: 250, width: 20, height: 20, color: 'blue', speed: 4, direction: 1 },
                { x: 700, y: 290, width: 20, height: 20, color: 'blue', speed: 3, direction: 1 },
                { x: 700, y: 380, width: 20, height: 20, color: 'blue', speed: 3, direction: -1 },
                { x: 200, y: 330, width: 20, height: 20, color: 'blue', speed: 3, direction: 1 },
            ],
            // 장애물 정보 추가
            obstacles: [
                { x: 150, y: 150, width: 800, height: 20, color: 'grey' },
                { x: 150, y: 430, width: 800, height: 20, color: 'grey' },
                { x: 150, y: 200, width: 20, height: 250, color: 'grey' },
                { x: 200, y: 150, width: 20, height: 250, color: 'grey' },
                { x: 250, y: 200, width: 20, height: 250, color: 'grey' },
                { x: 300, y: 150, width: 20, height: 250, color: 'grey' },
                { x: 350, y: 200, width: 20, height: 250, color: 'grey' },
                { x: 400, y: 150, width: 20, height: 250, color: 'grey' },
                { x: 450, y: 200, width: 20, height: 250, color: 'grey' },
                { x: 500, y: 150, width: 20, height: 250, color: 'grey' },
                { x: 550, y: 200, width: 20, height: 250, color: 'grey' },
                { x: 600, y: 150, width: 20, height: 250, color: 'grey' },
                { x: 650, y: 200, width: 20, height: 250, color: 'grey' }
            ],
            timeLimit: 60
        },
        // 레벨 2 데이터
        {
            playerStart: { x: 50, y: 50 },
            goal: { x: 750, y: 550, width: 30, height: 40, color: 'green' },
            enemies: [
                { x: 200, y: 0, width: 20, height: 20, color: 'blue', speed: 5, direction: 1 },
                { x: 400, y: 600, width: 20, height: 20, color: 'blue', speed: 3, direction: -1 },
                { x: 600, y: 0, width: 20, height: 20, color: 'blue', speed: 4, direction: 1 },
            ],
            obstacles: [
                { x: 100, y: 100, width: 600, height: 20, color: 'grey' },
                { x: 100, y: 480, width: 600, height: 20, color: 'grey' },
                { x: 400, y: 120, width: 20, height: 360, color: 'grey' }
            ],
            timeLimit: 45
        }
    ]

    // 플레이어 객체 생성
    var player = {
        x: levels[currentLevel].playerStart.x, // 플레이어 시작 x 좌표
        y: levels[currentLevel].playerStart.y, // 플레이어 시작 y 좌표
        width: 20, // 플레이어 너비
        height: 20, // 플레이어 높이
        color: 'red', // 플레이어 색상
        speed: 5 // 플레이어 이동 속도
    }

    var enemies = [] // 적 배열 초기화
    var obstacles = [] // 장애물 배열 초기화
    var goal = levels[currentLevel].goal // 현재 레벨의 목표 지점 설정
    var keys = {} // 키 입력 상태를 저장할 객체
    var gameOver = false // 게임 종료 여부
    var timer = levels[currentLevel].timeLimit // 남은 시간 (초)
    var timerInterval // 타이머 인터벌 변수
    var timerBarWidth = 800 // 타이머 바의 전체 너비
    var timeElapsed = 0 // 경과 시간

    // 레벨 초기화 함수
    function initLevel(levelIndex) {
        currentLevel = levelIndex // 현재 레벨 업데이트
        var levelData = levels[currentLevel] // 해당 레벨 데이터 가져오기
        player.x = levelData.playerStart.x // 플레이어 시작 위치 설정
        player.y = levelData.playerStart.y
        enemies = [] // 적 배열 초기화
        levelData.enemies.forEach(function(enemyData) {
            var enemy = $.extend({}, enemyData) // 적 데이터 복사
            enemies.push(enemy) // 적 배열에 추가
        })
        obstacles = [] // 장애물 배열 초기화
        levelData.obstacles.forEach(function(obstacleData) {
            var obstacle = $.extend({}, obstacleData) // 장애물 데이터 복사
            obstacles.push(obstacle) // 장애물 배열에 추가
        })
        goal = levelData.goal // 목표 지점 설정
        keys = {} // 키 입력 상태 초기화
        gameOver = false // 게임 오버 상태 초기화
        timer = levelData.timeLimit // 타이머 초기화
        timeElapsed = 0 // 경과 시간 초기화
        $('#timerBar').css('width', '100%') // 타이머 바 초기화
        clearInterval(timerInterval) // 이전 타이머 인터벌 제거
        startTimer() // 타이머 시작
    }

    // 타이머 시작 함수
    function startTimer() {
        timerInterval = setInterval(function() {
            timeElapsed += 0.1 // 경과 시간 증가
            var timeRatio = (levels[currentLevel].timeLimit - timeElapsed) / levels[currentLevel].timeLimit
            var barWidth = timeRatio * timerBarWidth
            $('#timerBar').css('width', barWidth + 'px')
            if (timeElapsed >= levels[currentLevel].timeLimit) {
                clearInterval(timerInterval)
                gameOver = true
                setTimeout(function() {
                    alert('시간 초과! 레벨을 다시 시작합니다.')
                    resetLevel()
                }, 10)
            }
        }, 100) // 0.1초마다 업데이트
    }

    // 키보드 입력 처리: 키 눌렀을 때
    $(document).keydown(function(e) {
        keys[e.which] = true // 해당 키 코드를 true로 설정
    })

    // 키보드 입력 처리: 키 뗐을 때
    $(document).keyup(function(e) {
        delete keys[e.which] // 해당 키 코드 삭제
    })

    // 게임 업데이트 함수
    function update() {
        if (gameOver) return // 게임 종료 시 업데이트 중단

        var prevX = player.x // 이전 x 위치 저장
        var prevY = player.y // 이전 y 위치 저장

        // 플레이어 이동 처리
        if (37 in keys) player.x -= player.speed // 왼쪽 화살표 키
        if (39 in keys) player.x += player.speed // 오른쪽 화살표 키
        if (38 in keys) player.y -= player.speed // 위쪽 화살표 키
        if (40 in keys) player.y += player.speed // 아래쪽 화살표 키

        // 플레이어가 캔버스 밖으로 나가지 않도록 제한
        player.x = Math.max(0, Math.min(canvas.width - player.width, player.x))
        player.y = Math.max(0, Math.min(canvas.height - player.height, player.y))

        // 플레이어와 장애물의 충돌 체크
        var collided = false
        obstacles.forEach(function(obstacle) {
            if (collision(player, obstacle)) {
                collided = true
            }
        })
        if (collided) {
            // 충돌 시 이전 위치로 복귀
            player.x = prevX
            player.y = prevY
        }

        // 적 캐릭터들 이동 및 충돌 처리
        enemies.forEach(function(enemy) {
            enemy.x += enemy.speed * enemy.direction // 적 이동
            // 적이 캔버스 경계에 도달하면 방향 변경
            if (enemy.x <= 0 || enemy.x + enemy.width >= canvas.width) {
                enemy.direction *= -1 // 이동 방향 반전
            }

            // 플레이어와 적의 충돌 체크
            if (collision(player, enemy)) {
                // 충돌 시 처리
                gameOver = true
                clearInterval(timerInterval)
                setTimeout(function() {
                    alert('충돌했습니다! 레벨을 다시 시작합니다.') // 알림 표시
                    resetLevel() // 레벨 재시작
                }, 10) // 약간의 지연을 두어 키 입력 처리 시간 확보
            }
        })

        // 플레이어와 목표 지점의 충돌 체크
        if (collision(player, goal)) {
            gameOver = true
            clearInterval(timerInterval)
            if (currentLevel < levels.length - 1) {
                // 마지막 레벨이 아닐 경우 다음 레벨로 이동
                setTimeout(function() {
                    alert('레벨 클리어! 다음 레벨로 이동합니다.') // 알림 표시
                    initLevel(currentLevel + 1) // 다음 레벨 초기화
                }, 10)
            } else {
                // 마지막 레벨 클리어 시 게임 종료 처리
                setTimeout(function() {
                    alert('게임 클리어! 축하합니다!') // 알림 표시
                    $('#gameMessage').text('게임 클리어! 축하합니다!').show() // 메시지 표시
                }, 10)
            }
        }
    }

    // 게임 그리기 함수
    function draw() {
        ctx.clearRect(0, 0, canvas.width, canvas.height) // 캔버스 초기화

        // 장애물 그리기
        obstacles.forEach(function(obstacle) {
            ctx.fillStyle = obstacle.color // 장애물 색상 설정
            ctx.fillRect(obstacle.x, obstacle.y, obstacle.width, obstacle.height) // 장애물 그리기
        })

        // 플레이어 그리기
        ctx.fillStyle = player.color // 플레이어 색상 설정
        ctx.fillRect(player.x, player.y, player.width, player.height) // 플레이어 사각형 그리기

        // 적 캐릭터들 그리기
        enemies.forEach(function(enemy) {
            ctx.fillStyle = enemy.color // 적 색상 설정
            ctx.fillRect(enemy.x, enemy.y, enemy.width, enemy.height) // 적 사각형 그리기
        })

        // 목표 지점 그리기
        ctx.fillStyle = goal.color // 목표 지점 색상 설정
        ctx.fillRect(goal.x, goal.y, goal.width, goal.height) // 목표 지점 사각형 그리기
    }

    // 게임 루프 함수
    function gameLoop() {
        update() // 게임 상태 업데이트
        draw() // 화면 그리기
        if (!gameOver) {
            requestAnimationFrame(gameLoop) // 다음 프레임 요청
        }
    }

    // 사각형 간의 충돌 체크 함수
    function collision(rect1, rect2) {
        return rect1.x < rect2.x + rect2.width &&
               rect1.x + rect1.width > rect2.x &&
               rect1.y < rect2.y + rect2.height &&
               rect1.y + rect1.height > rect2.y
    }

    // 레벨 재시작 함수
    function resetLevel() {
        initLevel(currentLevel) // 현재 레벨 초기화
        gameLoop() // 게임 루프 재시작
    }

    // 게임 시작 시 첫 번째 레벨 초기화 및 게임 루프 시작
    initLevel(0)
    gameLoop()
})
</script>

</body>
</html>
