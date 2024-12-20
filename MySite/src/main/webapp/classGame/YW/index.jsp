<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YoonGame</title>
    <style>
        body {
            margin: 0;
            overflow: hidden;
            background-color: black;
        }

        #gameArea {
            position: relative;
            width: 100vw;
            height: 100vh;
            background-color: black;
        }

        .player {
            position: absolute;
            bottom: 20px;
            /* left: 50%; */ /* 제거 */
            /* transform: translateX(-50%); */ /* 제거 */
            width: 50px;
            height: 50px;
            background: red;
            border-radius: 50%;
        }

        .bullet {
            position: absolute;
            width: 5px;
            height: 20px;
            background: yellow;
        }

        .enemy {
            position: absolute;
            width: 50px;
            height: 50px;
            background: green;
            border-radius: 50%;
        }

        #scoreBoard {
            position: absolute;
            top: 10px;
            left: 10px;
            color: white;
            font-size: 20px;
        }

        #levelBoard {
            position: absolute;
            top: 10px;
            right: 10px;
            color: white;
            font-size: 20px;
        }

        #gameOver {
            display: none;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: white;
            font-size: 40px;
            text-align: center;
        }

        #restart {
            margin-top: 20px;
            padding: 10px 20px;
            font-size: 20px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div id="gameArea">
        <div id="scoreBoard">Score: <span id="score">0</span></div>
        <div id="levelBoard">Level: <span id="level">1</span></div>
        <div id="gameOver">Game Over<br><button id="restart">Restart</button></div>
        <div class="player"></div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script>
        $(document).ready(function () {
            const $gameArea = $('#gameArea');
            const $player = $('.player');
            const $scoreBoard = $('#score');
            const $levelBoard = $('#level');
            const $gameOver = $('#gameOver');
            const playerSpeed = 15;
            let isGameOver = false;
            let score = 0;
            let level = 1;

            // Interval IDs
            let spawnEnemyIntervalId;
            let detectCollisionsIntervalId;
            let movePlayerIntervalId;

            // Array to store enemy intervals
            let enemyIntervals = [];

            // Initialize player position
            function initializePlayer() {
                const gameWidth = $gameArea.width();
                const playerWidth = $player.width();
                $player.css('left', (gameWidth - playerWidth) / 2 + 'px'); // 픽셀 단위로 설정
            }
            initializePlayer();

            // Move the player with key press
            const keysPressed = {};

            $(document).keydown(function (e) {
                if (isGameOver) return;
                keysPressed[e.code] = true;
            });

            $(document).keyup(function (e) {
                keysPressed[e.code] = false;
            });

            function movePlayer() {
                const playerPos = $player.position();
                const gameWidth = $gameArea.width();
                const playerWidth = $player.width();

                // 왼쪽 이동
                if (keysPressed['ArrowLeft'] || keysPressed['KeyA']) {
                    if (playerPos.left > 0) {
                        $player.css('left', Math.max(playerPos.left - playerSpeed, 0) + 'px');
                    }
                }
                // 오른쪽 이동
                if (keysPressed['ArrowRight'] || keysPressed['KeyD']) {
                    if (playerPos.left + playerWidth < gameWidth) {
                        $player.css('left', Math.min(playerPos.left + playerSpeed, gameWidth - playerWidth) + 'px');
                    }
                }
            }

            movePlayerIntervalId = setInterval(movePlayer, 20); // Update player movement every 20ms

            // Shoot bullet
            function shootBullet() {
                const bullet = $('<div class="bullet"></div>');
                const playerPos = $player.position();
                bullet.css({
                    left: playerPos.left + $player.width() / 2 - 2.5 + 'px',
                    top: playerPos.top - 20 + 'px' // Adjusted to appear above the player
                });
                $gameArea.append(bullet);

                const bulletInterval = setInterval(function () {
                    const bulletPos = bullet.position();
                    if (bulletPos.top <= 0) {
                        bullet.remove();
                        clearInterval(bulletInterval);
                    } else {
                        bullet.css('top', bulletPos.top - 10 + 'px');
                    }
                }, 20);
            }

            $(document).keydown(function (e) {
                if (e.code === 'Space' && !isGameOver) {
                    shootBullet();
                }
            });

            // Spawn enemies
            function spawnEnemy() {
                const enemy = $('<div class="enemy"></div>');
                const gameWidth = $gameArea.width();
                const randomX = Math.random() * (gameWidth - 50);
                enemy.css({
                    left: randomX + 'px',
                    top: '0px'
                });
                $gameArea.append(enemy);

                // Adjust enemy speed based on level
                const enemySpeed = 3 + (level - 1) * 0.5; // Increase speed with level

                const enemyInterval = setInterval(function () {
                    const enemyPos = enemy.position();
                    if (enemyPos.top >= $gameArea.height()) {
                        gameOver();
                        clearInterval(enemyInterval);
                    } else {
                        enemy.css('top', enemyPos.top + enemySpeed + 'px');
                    }
                }, 20);

                // Store enemy interval to manage later
                enemyIntervals.push(enemyInterval);
            }

            // Collision detection
            function detectCollisions() {
                $('.bullet').each(function () {
                    const bullet = $(this);
                    const bulletPos = bullet.position();
                    const bulletWidth = bullet.width();
                    const bulletHeight = bullet.height();

                    $('.enemy').each(function () {
                        const enemy = $(this);
                        const enemyPos = enemy.position();
                        const enemyWidth = enemy.width();
                        const enemyHeight = enemy.height();

                        // 간단한 AABB 충돌 감지
                        if (
                            bulletPos.left < enemyPos.left + enemyWidth &&
                            bulletPos.left + bulletWidth > enemyPos.left &&
                            bulletPos.top < enemyPos.top + enemyHeight &&
                            bulletPos.top + bulletHeight > enemyPos.top
                        ) {
                            // 총알과 적 제거
                            bullet.remove();
                            enemy.remove();

                            // 해당 적의 interval 클리어
                            const index = enemyIntervals.indexOf(enemy.data('intervalId'));
                            if (index > -1) {
                                clearInterval(enemyIntervals[index]);
                                enemyIntervals.splice(index, 1);
                            }

                            // 점수 업데이트
                            score += 10;
                            $scoreBoard.text(score);

                            // 레벨업 조건 (예: 100점마다 레벨 상승)
                            if (score % 100 === 0) {
                                level += 1;
                                $levelBoard.text(level);
                                // 레벨업 시 추가 로직 (예: 적 속도 증가, 적 생성 빈도 증가 등)
                                // 예를 들어, 적 생성 간격을 조정할 수 있습니다.
                            }
                        }
                    });
                });
            }

            // Game over
            function gameOver() {
                isGameOver = true;
                $gameOver.show();

                // 모든 적의 interval 클리어
                enemyIntervals.forEach(function (intervalId) {
                    clearInterval(intervalId);
                });
                enemyIntervals = [];

                // 추가로 게임이 종료된 후 생성되는 적 방지
                clearInterval(spawnEnemyIntervalId);
                clearInterval(detectCollisionsIntervalId);
            }

            // Restart game
            $('#restart').click(function () {
                // 상태 초기화
                isGameOver = false;
                score = 0;
                level = 1;
                $scoreBoard.text('0');
                $levelBoard.text('1');
                $gameOver.hide();

                // 모든 적과 총알 제거
                $('.enemy, .bullet').remove();

                // 모든 적의 interval 클리어
                enemyIntervals.forEach(function (intervalId) {
                    clearInterval(intervalId);
                });
                enemyIntervals = [];

                // 플레이어 위치 초기화
                initializePlayer();

                // 적 생성 및 충돌 감지 interval 다시 시작
                spawnEnemyIntervalId = setInterval(spawnEnemy, Math.max(2000 - (level - 1) * 100, 500)); // 최소 500ms
                detectCollisionsIntervalId = setInterval(detectCollisions, 50);
            });

            // Start enemy spawning and collision detection
            spawnEnemyIntervalId = setInterval(spawnEnemy, 2000);
            detectCollisionsIntervalId = setInterval(detectCollisions, 50); // Check collisions every 50ms
        });
    </script>
</body>
</html>
