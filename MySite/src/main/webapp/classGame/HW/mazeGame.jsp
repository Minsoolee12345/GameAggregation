<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Maze Game</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
        }
        canvas {
            border: 1px solid black;
            margin-top: 20px;
        }
        #status, #score {
            margin-top: 10px;
            font-size: 16px;
        }
        #status {
            font-weight: bold;
        }
    </style>
</head>
<body>
    <h1>Maze Game</h1>
    <canvas id="mazeCanvas" width="500" height="500"></canvas>
    <p id="status">방향키를 눌러도 이동시켜보세요.</p>

    <script>
        const canvas = document.getElementById('mazeCanvas');
        const ctx = canvas.getContext('2d');

        // Define 5 unique and solvable maze structures
        const mazes = [
            [ // Level 1
                [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
                [1, 0, 0, 0, 1, 0, 0, 0, 0, 1],
                [1, 0, 1, 0, 1, 0, 1, 1, 0, 1],
                [1, 0, 1, 0, 0, 0, 0, 1, 0, 1],
                [1, 0, 1, 1, 1, 0, 1, 1, 0, 1],
                [1, 0, 0, 0, 0, 0, 1, 1, 0, 1],
                [1, 1, 1, 1, 0, 1, 1, 1, 0, 1],
                [1, 0, 0, 1, 0, 0, 0, 0, 0, 1],
                [1, 0, 1, 1, 1, 1, 1, 1, 2, 1],
                [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
            ],
            [ // Level 2
                [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
                [1, 0, 0, 1, 1, 0, 0, 0, 0, 1],
                [1, 0, 1, 1, 1, 0, 1, 1, 0, 1],
                [1, 0, 1, 0, 0, 0, 0, 1, 0, 1],
                [1, 0, 1, 1, 1, 1, 1, 1, 0, 1],
                [1, 0, 0, 0, 0, 0, 0, 1, 0, 1],
                [1, 1, 1, 1, 0, 1, 1, 1, 0, 1],
                [1, 0, 0, 1, 0, 0, 0, 0, 0, 1],
                [1, 0, 1, 1, 1, 1, 1, 1, 2, 1],
                [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
            ],
            [ // Level 3
                [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
                [1, 0, 0, 0, 0, 1, 1, 1, 0, 1],
                [1, 0, 1, 1, 0, 1, 0, 0, 0, 1],
                [1, 0, 1, 0, 0, 0, 0, 1, 0, 1],
                [1, 0, 0, 0, 1, 1, 0, 1, 0, 1],
                [1, 0, 1, 1, 1, 0, 0, 1, 0, 1],
                [1, 0, 0, 0, 0, 0, 1, 1, 0, 1],
                [1, 1, 1, 0, 0, 0, 0, 0, 0, 1],
                [1, 0, 0, 0, 1, 1, 1, 1, 2, 1],
                [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
            ],
            [ // Level 4
                [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
                [1, 0, 0, 1, 0, 0, 0, 0, 0, 1],
                [1, 1, 0, 1, 0, 1, 1, 1, 0, 1],
                [1, 0, 0, 1, 0, 0, 0, 0, 0, 1],
                [1, 0, 1, 1, 1, 1, 1, 1, 1, 1],
                [1, 0, 0, 0, 0, 0, 1, 1, 0, 1],
                [1, 1, 1, 0, 1, 0, 0, 0, 0, 1],
                [1, 0, 0, 0, 1, 0, 1, 1, 0, 1],
                [1, 0, 1, 1, 1, 1, 1, 1, 2, 1],
                [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
            ],
            [ // Level 5
                [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
                [1, 0, 0, 1, 0, 0, 1, 0, 0, 1],
                [1, 1, 0, 1, 0, 1, 1, 0, 1, 1],
                [1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
                [1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
                [1, 0, 0, 0, 0, 0, 1, 1, 0, 1],
                [1, 1, 1, 1, 1, 1, 0, 1, 0, 1],
                [1, 0, 0, 0, 1, 0, 0, 0, 0, 1],
                [1, 1, 1, 1, 1, 1, 1, 1, 2, 1],
                [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
            ]
        ];

        let currentLevel = 0;
        let player = { x: 1, y: 1 };
        let score = 0;

        const tileSize = 50;

        function drawMaze() {
            const maze = mazes[currentLevel];
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            for (let row = 0; row < maze.length; row++) {
                for (let col = 0; col < maze[row].length; col++) {
                    if (maze[row][col] === 1) {
                        ctx.fillStyle = 'black'; // Walls
                    } else if (maze[row][col] === 2) {
                        ctx.fillStyle = 'orange'; // Goal
                    } else {
                        ctx.fillStyle = 'white'; // Path
                    }
                    ctx.fillRect(col * tileSize, row * tileSize, tileSize, tileSize);
                    ctx.strokeRect(col * tileSize, row * tileSize, tileSize, tileSize);
                }
            }
            // Draw player
            ctx.fillStyle = 'blue';
            ctx.fillRect(player.x * tileSize, player.y * tileSize, tileSize, tileSize);
        }

        function movePlayer(dx, dy) {
            const maze = mazes[currentLevel];
            const newX = player.x + dx;
            const newY = player.y + dy;

            // Check boundaries
            if (newX < 0 || newX >= maze[0].length || newY < 0 || newY >= maze.length) {
                return;
            }

            if (maze[newY][newX] === 0 || maze[newY][newX] === 2) { // Check walkable or goal
                player.x = newX;
                player.y = newY;

                if (maze[newY][newX] === 2) { // Reached goal

                    if (currentLevel === mazes.length - 1) {
                        document.getElementById('status').textContent = '모두 클리어하셨습니다.';
                        document.removeEventListener('keydown', handleKeyPress);
                    } else {
                        document.getElementById('status').textContent = `Level ${currentLevel + 1} Complete!`;
                        currentLevel++;
                        player = { x: 1, y: 1 };
                        drawMaze();
                    }
                }
            }
        }

        function handleKeyPress(event) {
            switch (event.key) {
                case 'ArrowUp':
                    movePlayer(0, -1);
                    break;
                case 'ArrowDown':
                    movePlayer(0, 1);
                    break;
                case 'ArrowLeft':
                    movePlayer(-1, 0);
                    break;
                case 'ArrowRight':
                    movePlayer(1, 0);
                    break;
            }
            drawMaze();
        }

        function initGame() {
            document.addEventListener('keydown', handleKeyPress);
            drawMaze();

            document.getElementById('status').textContent = '방향키를 눌러 이동시켜보세요.';
        }
        initGame();
    </script>
</body>
</html>