let targetNumber;
let attempts = 0;

function startGame() {
    targetNumber = Math.floor(Math.random() * 100) + 1; // 1~100 사이의 랜덤 숫자
    attempts = 0;
    document.getElementById("message").textContent = "";
    document.getElementById("attempts").textContent = "시도 횟수: " + attempts;
    document.getElementById("guess").value = "";
    document.getElementById("restart").style.display = "none"; // "게임 다시 시작하기" 버튼 숨기기
}

function checkGuess() {
    const guess = parseInt(document.getElementById("guess").value);
    attempts++;

    if (isNaN(guess) || guess < 1 || guess > 100) {
        document.getElementById("message").textContent = "1과 100 사이의 숫자를 입력하세요.";
        return;
    }

    if (guess < targetNumber) {
        document.getElementById("message").textContent = "너무 낮아요! 더 높은 숫자를 시도해 보세요.";
    } else if (guess > targetNumber) {
        document.getElementById("message").textContent = "너무 높아요! 더 낮은 숫자를 시도해 보세요.";
    } else {
        document.getElementById("message").textContent = `축하합니다! 숫자를 맞추셨어요!`;
        document.getElementById("restart").style.display = "inline-block"; // "게임 다시 시작하기" 버튼 보이기
    }

    document.getElementById("attempts").textContent = "시도 횟수: " + attempts;
}

function restartGame() {
    startGame();
}

startGame(); // 게임 시작
