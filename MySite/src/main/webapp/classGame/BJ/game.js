$(document).ready(function () {
    const $paddle = $('#paddle');
    const $ball = $('#ball');
    const $gameContainer = $('#gameContainer');
    const paddleSpeed = 20;
    let ballPos = { x: 290, y: 340 };
    let ballVelocity = { x: 3, y: -3 };
    let ballMovingInterval;

    // 벽돌 생성
    function createBricks() {
        for (let i = 0; i < 5; i++) {
            for (let j = 0; j < 8; j++) {
                const $brick = $('<div class="brick"></div>');
                $brick.css({ top: i * 30 + 20, left: j * 75 + 5 });
                $gameContainer.append($brick);
            }
        }
    }

    // 게임 초기화
    function initGame() {
        // 벽돌 새로 생성
        $('.brick').remove();
        createBricks();

        ballPos = { x: 290, y: 340 };
        ballVelocity = { x: 3, y: -3 };
        $ball.css({ left: ballPos.x, top: ballPos.y });

        if (ballMovingInterval) clearInterval(ballMovingInterval);
        ballMovingInterval = setInterval(updateBallPosition, 10);
    }

    // 공의 위치 업데이트
    function updateBallPosition() {
        ballPos.x += ballVelocity.x;
        ballPos.y += ballVelocity.y;

        // 벽에 부딪힐 경우 반사
        if (ballPos.x <= 0 || ballPos.x >= $gameContainer.width() - $ball.width()) {
            ballVelocity.x *= -1;
        }
        if (ballPos.y <= 0) {
            ballVelocity.y *= -1;
        }

        // 패들에 부딪힐 경우 반사
        const paddlePos = $paddle.position();
        if (
            ballPos.y + $ball.height() >= paddlePos.top &&
            ballPos.x + $ball.width() >= paddlePos.left &&
            ballPos.x <= paddlePos.left + $paddle.width()
        ) {
            ballVelocity.y *= -1;
        }

        // 벽돌에 부딪힐 경우
        $('.brick').each(function () {
            const $brick = $(this);
            const brickPos = $brick.position();
            if (
                ballPos.x + $ball.width() > brickPos.left &&
                ballPos.x < brickPos.left + $brick.width() &&
                ballPos.y + $ball.height() > brickPos.top &&
                ballPos.y < brickPos.top + $brick.height()
            ) {
                $brick.remove();
                ballVelocity.y *= -1;
                return false; // 하나의 벽돌만 부숴야 하므로 루프 종료
            }
        });

        // 게임 오버 처리
        if (ballPos.y >= $gameContainer.height() - $ball.height()) {
            alert('Game Over!');
            clearInterval(ballMovingInterval);
            initGame();
        }

        // 공 위치 업데이트
        $ball.css({ left: ballPos.x, top: ballPos.y });
    }

    // 패들 이동
    $(document).on('keydown', function (e) {
        const paddlePos = $paddle.position();
        if (e.key === 'ArrowLeft' && paddlePos.left > 0) {
            $paddle.css('left', paddlePos.left - paddleSpeed);
        } else if (e.key === 'ArrowRight' && paddlePos.left < $gameContainer.width() - $paddle.width()) {
            $paddle.css('left', paddlePos.left + paddleSpeed);
        }
    });

    initGame();
});
