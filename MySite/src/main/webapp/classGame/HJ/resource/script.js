$(document).ready(function() { // 문서가 준비되면 실행
    const canvas = document.getElementById("gameCanvas"); // 캔버스 요소를 가져옴
    const ctx = canvas.getContext("2d"); // 캔버스의 2D 컨텍스트를 가져옴
    const boxSize = 20; // 한 블록의 크기
    let snake = [{ x: boxSize * 5, y: boxSize * 5 }]; // 뱀 초기 위치
    let direction = "RIGHT"; // 현재 이동 방향
    let nextDirection = direction; // 다음 이동 방향
    let score = 0; // 게임 점수
    let obstacles = []; // 장애물 배열
    let warningTimeouts = []; // 경고 타이머 배열
    let obstacleTimeouts = []; // 장애물 타이머 배열

    // 음식 초기화
    let food = generateFood(); // 음식 생성

    // 키 입력 이벤트 설정
    $(document).keydown((e) => { // 키가 눌릴 때
        if (e.key === "ArrowUp" && direction !== "DOWN") { // 방향 위
            nextDirection = "UP";
        }
        if (e.key === "ArrowDown" && direction !== "UP") { // 방향 아래
            nextDirection = "DOWN";
        }
        if (e.key === "ArrowLeft" && direction !== "RIGHT") { // 방향 왼쪽
            nextDirection = "LEFT";
        }
        if (e.key === "ArrowRight" && direction !== "LEFT") { // 방향 오른쪽
            nextDirection = "RIGHT";
        }
    });

    // 음식 생성 함수 - 뱀과 겹치지 않게 생성
    function generateFood() {
        let newFood; // 새 음식 위치
        while (true) { // 반복하여 위치를 찾음
            newFood = {
                x: Math.floor(Math.random() * canvas.width / boxSize) * boxSize, // 랜덤 x 좌표
                y: Math.floor(Math.random() * canvas.height / boxSize) * boxSize // 랜덤 y 좌표
            };
            if (!checkCollision(newFood, snake) && !checkCollision(newFood, obstacles)) break; // 뱀과 장애물에 겹치지 않으면 탈출
        }
        return newFood; // 생성된 음식 반환
    }

    // 음식 그리기
    function drawFood() {
        ctx.fillStyle = "red"; // 음식 색상 설정
        ctx.fillRect(food.x, food.y, boxSize, boxSize); // 음식 그리기
    }

    // 장애물 생성 함수
    function generateObstacle() {
        let newObstacle; // 새 장애물 위치
        while (true) { // 반복하여 위치를 찾음
            newObstacle = {
                x: Math.floor(Math.random() * canvas.width / boxSize) * boxSize, // 랜덤 x 좌표
                y: Math.floor(Math.random() * canvas.height / boxSize) * boxSize // 랜덤 y 좌표
            };
            if (!checkCollision(newObstacle, snake) && !checkCollision(newObstacle, obstacles) && !checkCollision(newObstacle, [food])) break; // 모든 요소와 겹치지 않으면 탈출
        }
        return newObstacle; // 생성된 장애물 반환
    }

    // 장애물 그리기
    function drawObstacles() {
        ctx.fillStyle = "black"; // 장애물 색상 설정
        for (let i = 0; i < obstacles.length; i++) { // 각 장애물에 대해
            ctx.fillRect(obstacles[i].x, obstacles[i].y, boxSize, boxSize); // 장애물 그리기
        }
    }

    // 경고 표시 그리기 (장애물이 생성될 위치)
    function drawWarning() {
        ctx.fillStyle = "gray"; // 경고 색상 설정
        for (let i = 0; i < warningTimeouts.length; i++) { // 각 경고 위치에 대해
            let warning = warningTimeouts[i];
            ctx.fillRect(warning.x, warning.y, boxSize, boxSize); // 경고 표시 그리기
        }
    }

    // 뱀 그리기
    function drawSnake() {
        ctx.clearRect(0, 0, canvas.width, canvas.height); // 캔버스를 지움
        for (let i = 0; i < snake.length; i++) { // 뱀 각 블록에 대해
            ctx.fillStyle = i === 0 ? "green" : "lightgreen"; // 머리는 초록색, 몸은 연두색
            ctx.fillRect(snake[i].x, snake[i].y, boxSize, boxSize); // 뱀 그리기
        }
        drawFood(); // 음식 그리기
        drawObstacles(); // 장애물 그리기
        drawWarning(); // 경고 그리기
    }

    // 뱀 이동
    function moveSnake() {
        direction = nextDirection; // 다음 방향으로 변경
        let head = { x: snake[0].x, y: snake[0].y }; // 현재 머리 위치

        if (direction === "UP") head.y -= boxSize; // 위로 이동
        if (direction === "DOWN") head.y += boxSize; // 아래로 이동
        if (direction === "LEFT") head.x -= boxSize; // 왼쪽으로 이동
        if (direction === "RIGHT") head.x += boxSize; // 오른쪽으로 이동

        // 벽 충돌 또는 자기 충돌 확인
        if (head.x < 0 || head.y < 0 || head.x >= canvas.width || head.y >= canvas.height || checkCollision(head, snake) || checkCollision(head, obstacles)) {
            alert("게임 오버! 최종 점수: " + score); // 충돌 시 게임 오버 알림
            window.location.href = `../index.jsp?score=${score}`; // 점수를 URL 파라미터로 넘기고 이동
            return; // 게임 종료
        }

        // 음식 먹기
        if (head.x === food.x && head.y === food.y) {
            score++; // 점수 증가
            $("#score").text(score); // 점수 표시
            food = generateFood(); // 새 음식 생성
        } else {
            snake.pop(); // 뱀 꼬리 제거
        }

        snake.unshift(head); // 새 머리를 추가
    }

    // 충돌 확인
    function checkCollision(head, array) {
        for (let i = 0; i < array.length; i++) { // 배열의 각 요소에 대해
            if (head.x === array[i].x && head.y === array[i].y) return true; // 충돌 시 true 반환
        }
        return false; // 충돌 없으면 false 반환
    }

    // 장애물 추가 (정기적으로)
    function addObstacle() {
        if (Math.random() < 0.05) { // 5% 확률로 장애물 생성
            let obstaclePos = generateObstacle(); // 장애물 위치 생성

            warningTimeouts.push(obstaclePos); // 경고 표시 추가

            setTimeout(() => { // 1초 후
                obstacles.push(obstaclePos); // 장애물 추가
                obstacleTimeouts.push(setTimeout(() => {
                    obstacles = obstacles.filter(ob => ob !== obstaclePos); // 5초 후 장애물 제거
                }, 5000));
            }, 1000);

            setTimeout(() => { // 1초 후 경고 제거
                warningTimeouts = warningTimeouts.filter(warning => warning !== obstaclePos);
            }, 1000);
        }
    }

    // 게임 초기화
    function resetGame() {
        snake = [{ x: boxSize * 5, y: boxSize * 5 }]; // 뱀 초기화
        direction = "RIGHT"; // 방향 초기화
        nextDirection = direction; // 다음 방향 초기화
        score = 0; // 점수 초기화
        obstacles = []; // 장애물 초기화
        warningTimeouts = []; // 경고 초기화
        $("#score").text(score); // 점수 표시 초기화
    }

    // 게임 루프 시작
    function gameLoop() {
        moveSnake(); // 뱀 이동
        addObstacle(); // 장애물 추가
        drawSnake(); // 뱀 그리기
        setTimeout(gameLoop, 100); // 일정 시간 간격으로 루프 반복
    }

    gameLoop(); // 게임 루프 시작
});
