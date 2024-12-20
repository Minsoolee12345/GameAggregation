$(document).ready(function() {
    let stage = 1;
    const stageData = [
        { playerStart: { x: 20, y: 20 }, goal: { x: 400, y: 400 }, obstacles: [{ x: 100, y: 100, dx: 0, dy: 2 }] },
        { playerStart: { x: 20, y: 20 }, goal: { x: 450, y: 450 }, obstacles: [{ x: 150, y: 150, dx: 2, dy: 0 }] },
        // 나머지 스테이지 추가 가능
    ];

    const $player = $('#player');
    const $goal = $('.goal');
    let playerPos = { x: 20, y: 20 };
    let playerVelocity = { x: 0, y: 0 };
    let movingInterval;
    let obstacleIntervals = [];
    const speed = 2; // 플레이어 이동 속도

    function initStage() {
        // 스테이지 초기화
        const data = stageData[stage - 1];
        playerPos = { ...data.playerStart };
        $player.css({ left: playerPos.x, top: playerPos.y });
        $goal.css({ left: data.goal.x, top: data.goal.y });

        // 장애물 초기화
        $('.obstacle').remove();
        obstacleIntervals.forEach(clearInterval);
        obstacleIntervals = [];

        data.obstacles.forEach(obstacleData => {
            const $obstacle = $('<div class="obstacle"></div>').appendTo('#gameContainer');
            $obstacle.css({ left: obstacleData.x, top: obstacleData.y });

            const interval = setInterval(() => {
                obstacleData.x += obstacleData.dx;
                obstacleData.y += obstacleData.dy;

                // 장애물이 컨테이너 경계를 벗어나지 않도록 반대로 이동
                if (obstacleData.x <= 0 || obstacleData.x >= $('#gameContainer').width() - 20) {
                    obstacleData.dx *= -1;
                }
                if (obstacleData.y <= 0 || obstacleData.y >= $('#gameContainer').height() - 20) {
                    obstacleData.dy *= -1;
                }
                $obstacle.css({ left: obstacleData.x, top: obstacleData.y });
            }, 30);
            obstacleIntervals.push(interval);
        });

        if (movingInterval) clearInterval(movingInterval);
        movingInterval = setInterval(updatePlayerPosition, 10); // 플레이어 위치 업데이트
    }

    function updatePlayerPosition() {
        playerPos.x = Math.max(0, Math.min($('#gameContainer').width() - 20, playerPos.x + playerVelocity.x));
        playerPos.y = Math.max(0, Math.min($('#gameContainer').height() - 20, playerPos.y + playerVelocity.y));
        $player.css({ left: playerPos.x, top: playerPos.y });
        checkCollision();
    }

    function checkCollision() {
        // 장애물 충돌 검사
        let collided = false;
        $('.obstacle').each(function() {
            const ox = $(this).position().left;
            const oy = $(this).position().top;

            // 충돌 판정을 조금 더 명확하게 수정
            if (Math.abs(ox - playerPos.x) < 18 && Math.abs(oy - playerPos.y) < 18) {
                collided = true;
            }
        });

        if (collided) {
            alert('장애물에 닿았습니다! 스테이지 처음부터 시작합니다.');
            playerVelocity.x = 0;
            playerVelocity.y = 0;
            initStage();
        }

        // 도착 지점 도달 확인
        const gx = $goal.position().left;
        const gy = $goal.position().top;

        // 도착 지점에 도달할 때의 판정 기준
        if (Math.abs(gx - playerPos.x) < 20 && Math.abs(gy - playerPos.y) < 20) {
            alert(`스테이지 ${stage} 클리어!`);
            playerVelocity.x = 0;
            playerVelocity.y = 0;
            stage++;

            if (stage > stageData.length) {
                alert("모든 스테이지를 클리어했습니다!");
            } else {
                initStage();
            }
        }
    }

    $(document).on('keydown', function(e) {
        switch (e.key) {
            case 'ArrowUp':
                playerVelocity.y = -speed;
                break;
            case 'ArrowDown':
                playerVelocity.y = speed;
                break;
            case 'ArrowLeft':
                playerVelocity.x = -speed;
                break;
            case 'ArrowRight':
                playerVelocity.x = speed;
                break;
        }
    });

    $(document).on('keyup', function(e) {
        switch (e.key) {
            case 'ArrowUp':
            case 'ArrowDown':
                playerVelocity.y = 0;
                break;
            case 'ArrowLeft':
            case 'ArrowRight':
                playerVelocity.x = 0;
                break;
        }
    });

    initStage();
});
