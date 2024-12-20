$(document).ready(function () {
  const canvas = $("#gameCanvas")[0];
  const ctx = canvas.getContext("2d");

  // 게임 설정
  const ballRadius = 10;
  const paddleHeight = 10;
  const paddleWidth = 75;
  const brickPadding = 10;
  const brickOffsetTop = 30;
  const brickOffsetLeft = 20;

  // 상태 변수
  let x, y, dx, dy, paddleX;
  let score = 0;
  let stage = 1;
  let brickRowCount, brickColumnCount, bricks;
  let brickWidth, brickHeight = 20;
  let gameStarted = false;

  // 키보드 입력 상태
  let rightPressed = false;
  let leftPressed = false;

  // 벽돌 초기화 함수
  function initBricks() {
    brickRowCount = 3 + stage;
    brickColumnCount = 5 + stage;
    brickWidth = (canvas.width - brickOffsetLeft * 2) / brickColumnCount - brickPadding;
    bricks = [];
    for (let c = 0; c < brickColumnCount; c++) {
      bricks[c] = [];
      for (let r = 0; r < brickRowCount; r++) {
        bricks[c][r] = { x: 0, y: 0, status: 1 };
      }
    }
  }

  // 게임 초기화 함수
  function initializeGame() {
    x = canvas.width / 2;
    y = canvas.height - 30;
    dx = (2 + stage * 0.5) * 1.1; // 10% 속도 증가
    dy = (-2 - stage * 0.5) * 1.1;
    paddleX = (canvas.width - paddleWidth) / 2;
    if (stage === 1) score = 0;
    $("#score").text(score);
    $("#stage").text(stage);
    initBricks();
  }

  // 키 이벤트 핸들링
  $(document).keydown(function (e) {
    if (e.key === "ArrowRight") rightPressed = true;
    else if (e.key === "ArrowLeft") leftPressed = true;
    else if (e.key === " ") {
      if (!gameStarted) {
        gameStarted = true;
        initializeGame();
        draw();
      }
    }
  });

  $(document).keyup(function (e) {
    if (e.key === "ArrowRight") rightPressed = false;
    else if (e.key === "ArrowLeft") leftPressed = false;
  });

  // 벽돌 충돌 감지
  function collisionDetection() {
    for (let c = 0; c < brickColumnCount; c++) {
      for (let r = 0; r < brickRowCount; r++) {
        const brick = bricks[c][r];
        if (brick.status === 1) {
          if (
            x > brick.x &&
            x < brick.x + brickWidth &&
            y > brick.y &&
            y < brick.y + brickHeight
          ) {
            dy = -dy;
            brick.status = 0;
            score++;
            $("#score").text(score);

            const totalBricks = brickRowCount * brickColumnCount;
            if (score === totalBricks + (stage - 1) * totalBricks) {
              stage++;
              alert(`축하합니다! 스테이지 ${stage - 1}을(를) 완료했습니다.`);
              initializeGame();
            }
          }
        }
      }
    }
  }

  // 공 그리기
  function drawBall() {
    ctx.beginPath();
    ctx.arc(x, y, ballRadius, 0, Math.PI * 2);
    ctx.fillStyle = "#0095DD";
    ctx.fill();
    ctx.closePath();
  }

  // 패들 그리기
  function drawPaddle() {
    ctx.beginPath();
    ctx.rect(paddleX, canvas.height - paddleHeight, paddleWidth, paddleHeight);
    ctx.fillStyle = "#0095DD";
    ctx.fill();
    ctx.closePath();
  }

  // 벽돌 그리기
  function drawBricks() {
    for (let c = 0; c < brickColumnCount; c++) {
      for (let r = 0; r < brickRowCount; r++) {
        if (bricks[c][r].status === 1) {
          const brickX = c * (brickWidth + brickPadding) + brickOffsetLeft;
          const brickY = r * (brickHeight + brickPadding) + brickOffsetTop;
          bricks[c][r].x = brickX;
          bricks[c][r].y = brickY;
          ctx.beginPath();
          ctx.rect(brickX, brickY, brickWidth, brickHeight);
          ctx.fillStyle = "#0095DD";
          ctx.fill();
          ctx.closePath();
        }
      }
    }
  }

  // 게임 루프
  function draw() {
    if (!gameStarted) return;
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    drawBricks();
    drawBall();
    drawPaddle();
    collisionDetection();

    if (x + dx > canvas.width - ballRadius || x + dx < ballRadius) dx = -dx;
    if (y + dy < ballRadius) dy = -dy;
    else if (y + dy > canvas.height - ballRadius) {
      if (x > paddleX && x < paddleX + paddleWidth) {
        dy = -dy;
      } else {
        alert("게임 오버! 다시 하려면 창을 닫고 스페이스바를 입력하세요");
        stage = 1;
        gameStarted = false;
      }
    }

    if (rightPressed && paddleX < canvas.width - paddleWidth) paddleX += 7;
    else if (leftPressed && paddleX > 0) paddleX -= 7;

    x += dx;
    y += dy;

    requestAnimationFrame(draw);
  }
});
