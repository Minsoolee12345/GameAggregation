<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"> <!-- 문자 인코딩 -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> <!-- 반응형 웹 설정 -->
    <title>Snake Game</title> <!-- 페이지 제목 -->
    <style>
        body {
            display: flex; /* 화면 중앙에 콘텐츠 배치를 위해 flexbox 사용 */
            justify-content: center; /* 수평 가운데 정렬 */
            align-items: center; /* 수직 가운데 정렬 */
            height: 100vh; /* 화면 높이를 100%로 설정 */
            margin: 0;  /* 기본 여백 제거 */
            background-color: #000; /* 배경색 검정색 */
        }
        canvas {
            border: 2px solid #ffffff; /* 캔버스 테두리 흰색 */
        }
        #scoreBoard {
            color: #fff; /* 점수판 텍스트 흰색 */
            font-size: 20px; /* 점수판 글꼴 크기 */
            position: absolute; /* 점수판 위치 고정 */
            top: 18px; /* 화면 위쪽에서 10px 떨어짐 */
            left: 50%; /* 수평 가운데 정렬 */
            transform: translateX(-50%); /* 수평 가운데 정렬을 정확하게 하기 위해 변환 */
        }
    </style>
</head>
<body>
    <div id="scoreBoard">Score: 0</div> <!-- 점수 표시 -->
    <canvas id="gameCanvas" width="1400" height="900"></canvas> <!-- 게임 캔버스 -->
    <script>
        const canvas = document.getElementById('gameCanvas'); // 캔버스 요소 가져오기
        const ctx = canvas.getContext('2d'); // 2D 렌더링 컨텍스트 가져오기
        const scoreBoard = document.getElementById('scoreBoard'); // 점수판 요소 가져오기

        const gridSize = 20; // 그리드 크기
        const tileCountX = Math.floor(canvas.width / gridSize); // X축 타일 개수
        const tileCountY = Math.floor(canvas.height / gridSize); // Y축 타일 개수

        let snake = [{ x: 10, y: 10 }]; // 뱀의 초기 위치
        let velocity = { x: 0, y: 0 }; // 뱀의 초기 속도
        let apple = { x: 5, y: 5 }; // 사과의 초기 위치
        let score = 0; // 초기 점수
        let speed = 100; // 게임 속도

        // 장애물 제거
        let obstacles = []; // 현재 사용하지 않음

        // 유닛 추가 (게임 내 움직이는 요소들)
        let units = [
            { x: 20, y: 20, velocity: { x: 1, y: 1 } }, // 유닛 1 
            { x: 25, y: 25, velocity: { x: -1, y: 1 } }, // 유닛 2 
            { x: 30, y: 30, velocity: { x: 1, y: -1 } }, // 유닛 3 
            { x: 35, y: 35, velocity: { x: -1, y: -1 } }, // 유닛 4 
            { x: 40, y: 40, velocity: { x: 1, y: 1 } }, // 유닛 5 
            { x: 45, y: 45, velocity: { x: 1, y: -1 } }, // 유닛 6 
           
        ];

        function gameLoop() {
            update(); // 게임 상태 업데이트
            draw(); // 게임 화면 그리기
            setTimeout(gameLoop, speed); // 일정 시간 후에 gameLoop 재실행
        }

        function update() {
            const head = { x: snake[0].x + velocity.x, y: snake[0].y + velocity.y }; // 뱀 머리 새로운 위치 계산
            snake.unshift(head); // 뱀 배열에 새로운 머리 추가

            if (head.x === apple.x && head.y === apple.y) { // 사과를 먹었을 때
                score++; // 점수 증가
                speed = Math.max(50, speed - 5); // 속도 증가 (최대 50까지 감소)
                placeApple(); // 새로운 사과 배치
            } else {
                snake.pop(); // 사과를 먹지 못하면 꼬리 제거
            }

            // 유닛 이동 업데이트
            units.forEach(unit => {
                unit.x += unit.velocity.x; // 유닛의 x 좌표 업데이트
                unit.y += unit.velocity.y; // 유닛의 y 좌표 업데이트

                // 경계 밖으로 나가면 반대 방향으로 이동
                if (unit.x < 0 || unit.x >= tileCountX) {
                    unit.velocity.x *= -1; // x 방향 반전
                }
                if (unit.y < 0 || unit.y >= tileCountY) {
                    unit.velocity.y *= -1; // y 방향 반전
                }
            });

            scoreBoard.textContent = `Score: ${score}`; // 점수판 업데이트

            if (head.x < 0 || head.x >= tileCountX || head.y < 0 || head.y >= tileCountY || snakeCollision(head)) {
                resetGame(); // 벽이나 유닛과 충돌 시 게임 리셋
            }
        }

        function draw() {
            ctx.fillStyle = '#000'; /* 배경색 검정색 */
            ctx.fillRect(0, 0, canvas.width, canvas.height); // 캔버스 전체를 검정색으로 칠하기

            ctx.fillStyle = '#ffffff'; /* 뱀 색상 흰색 */
            snake.forEach(segment => {
                ctx.fillRect(segment.x * gridSize, segment.y * gridSize, gridSize, gridSize); // 뱀 각 segment 그리기
            });

            ctx.fillStyle = '#ffff00'; /* 사과 색상 노란색 */
            ctx.fillRect(apple.x * gridSize, apple.y * gridSize, gridSize, gridSize); // 사과 그리기

            ctx.fillStyle = '#ff69b4'; /* 유닛 색상 핑크색 */
            units.forEach(unit => {
                ctx.fillRect(unit.x * gridSize, unit.y * gridSize, gridSize, gridSize); // 유닛 그리기
            });
        }

        function placeApple() {
            apple.x = Math.floor(Math.random() * tileCountX); // 새로운 사과 x 좌표
            apple.y = Math.floor(Math.random() * tileCountY); // 새로운 사과 y 좌표
        }

        function snakeCollision(head) {
            // 유닛과의 충돌 검사(머리끼리 정면으로 충돌해야만 죽는데 왜그런지 모르겠음;;)
            for (let unit of units) {
                if (unit.x === head.x && unit.y === head.y) {
                    resetGame(); // 유닛과 충돌 시 게임 리셋
                    return true;
                }
            }
            return false; // 충돌이 없으면 false 반환
        }

        function resetGame() {
            alert(`Game Over! Your score was: ${score}`); // 게임 오버 메시지 표시
            snake = [{ x: 10, y: 10 }]; // 뱀 초기 위치 리셋
            velocity = { x: 0, y: 0 }; // 뱀 속도 리셋
            score = 0; // 점수 리셋
            speed = 100; // 속도 초기화
            placeApple(); // 사과 재배치
        }

        window.addEventListener('keydown', (event) => {
            switch (event.key) {
                case 'ArrowUp':
                    if (velocity.y === 0) velocity = { x: 0, y: -1 }; // 위쪽 화살표로 위로 이동
                    break;
                case 'ArrowDown':
                    if (velocity.y === 0) velocity = { x: 0, y: 1 }; // 아래쪽 화살표로 아래로 이동
                    break;
                case 'ArrowLeft':
                    if (velocity.x === 0) velocity = { x: -1, y: 0 }; // 왼쪽 화살표로 왼쪽 이동
                    break;
                case 'ArrowRight':
                    if (velocity.x === 0) velocity = { x: 1, y: 0 }; // 오른쪽 화살표로 오른쪽 이동
                    break;
            }
        });

        gameLoop(); // 게임 루프 시작
    </script>
</body>
</html>
