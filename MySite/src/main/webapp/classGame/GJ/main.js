/**
 * Flappy Bird Game with Adjusted Pipe Gap
 */

var img1 = new Image();
img1.src = './resource/pipe.png'; // Pipe image
var img2 = new Image();
img2.src = './resource/0j.jpg'; // Bird image

var canvas = document.getElementById('canvas');
var ctx = canvas.getContext('2d'); /* getContext() for 2D rendering */

canvas.width = window.innerWidth - 100;
canvas.height = window.innerHeight - 100;

var bird;
var pipes;
var pipeTimer;
var score;
var animation;

function initializeGame() {
    bird = {
        x: 50,
        y: canvas.height / 2, // Bird starts in the middle
        width: 40,
        height: 40,
        gravity: 2,
        lift: -30,
        velocity: 0,
        draw() {
            ctx.drawImage(img2, this.x, this.y, this.width, this.height);
        },
        update() {
            this.velocity += this.gravity;
            this.y += this.velocity;
            if (this.y < 0) this.y = 0; // Prevent going above the canvas
            if (this.y + this.height > canvas.height) {
                this.y = canvas.height - this.height;
                this.velocity = 0;
            } // Prevent going below the canvas
        }
    };

    pipes = [];
    pipeTimer = 0;
    score = 0;
    cancelAnimationFrame(animation); // Stop any ongoing animation
    ctx.clearRect(0, 0, canvas.width, canvas.height); // Clear canvas
}

class Pipe {
    constructor() {
        this.x = canvas.width;
        this.y = Math.random() * (canvas.height - 200);
        this.width = 50;
        this.gap = 200; // Increased gap size
    }
    draw() {
        ctx.fillStyle = "green";
        ctx.fillRect(this.x, 0, this.width, this.y); // Top pipe
        ctx.fillRect(this.x, this.y + this.gap, this.width, canvas.height - this.y - this.gap); // Bottom pipe
    }
    update() {
        this.x -= 5; // Move pipes left
        if (this.x + this.width < 0) {
            score++;
            return true; // Remove pipe when it goes off screen
        }
        return false;
    }
    checkCollision(bird) {
        if (
            (bird.x < this.x + this.width && bird.x + bird.width > this.x &&
                (bird.y < this.y || bird.y + bird.height > this.y + this.gap)) ||
            bird.y + bird.height >= canvas.height
        ) {
            return true;
        }
        return false;
    }
}

function oneFrame() {
    animation = requestAnimationFrame(oneFrame);
    pipeTimer++;

    ctx.clearRect(0, 0, canvas.width, canvas.height);

    if (pipeTimer % 100 === 0) {
        pipes.push(new Pipe());
    }

    pipes = pipes.filter(pipe => {
        if (pipe.update()) {
            return false; // Remove pipe when it goes off screen
        }
        if (pipe.checkCollision(bird)) {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            cancelAnimationFrame(animation);
            showRestartButton();
            return false;
        }
        pipe.draw();
        return true;
    });

    bird.update();
    bird.draw();

    // Draw score
    ctx.fillStyle = 'black';
    ctx.font = '20px Arial';
    ctx.fillText(`Score: ${score}`, 10, 30);
}

function showStartButton() {
    const startButton = document.createElement('button');
    startButton.innerText = 'Start Game';
    startButton.style.position = 'absolute';
    startButton.style.top = '50%';
    startButton.style.left = '50%';
    startButton.style.transform = 'translate(-50%, -50%)';
    startButton.style.padding = '10px 20px';
    startButton.style.fontSize = '20px';
    document.body.appendChild(startButton);

    startButton.addEventListener('click', () => {
        document.body.removeChild(startButton);
        initializeGame();
        oneFrame();
    });
}

function showRestartButton() {
    const restartButton = document.createElement('button');
    restartButton.innerText = 'Restart Game';
    restartButton.style.position = 'absolute';
    restartButton.style.top = '50%';
    restartButton.style.left = '50%';
    restartButton.style.transform = 'translate(-50%, -50%)';
    restartButton.style.padding = '10px 20px';
    restartButton.style.fontSize = '20px';
    document.body.appendChild(restartButton);

    restartButton.addEventListener('click', () => {
        document.body.removeChild(restartButton);
        initializeGame();
        oneFrame();
    });
}

showStartButton();

document.addEventListener('keydown', function (e) {
    if (e.code === 'Space') {
        bird.velocity = bird.lift;
    }
});

/* Add CSS Styles for canvas and game aesthetics */
document.head.insertAdjacentHTML('beforeend', `
    <style>
        body {
            margin: 0;
            background-color: #87CEEB; /* Sky blue */
            font-family: Arial, sans-serif;
        }

        canvas {
            display: block;
            margin: auto;
            background-color: #e6e6e6;
            border: 2px solid #555;
        }

        button {
            cursor: pointer;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            box-shadow: 0 4px #2d6a31;
        }

        button:active {
            box-shadow: 0 2px #2d6a31;
            transform: translateY(2px);
        }
    </style>
`);
