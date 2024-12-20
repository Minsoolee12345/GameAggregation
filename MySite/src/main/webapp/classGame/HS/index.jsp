<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>카드 짝 맞추기 게임</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    <h1>카드 짝 맞추기 게임</h1>
    <div id="game-board"></div>
    <button onclick="resetGame()">게임 재시작</button>

    <script>
        const SIZE = 4;
        const cards = ["A", "B", "C", "D", "E", "F", "G", "H"];
        let board = [];
        let revealed = [];
        let firstCard = null;
        let secondCard = null;
        let matchedPairs = 0;

        // 게임 보드 초기화
        function initializeBoard() {
            board = [...cards, ...cards]; // 카드 2세트 생성
            board.sort(() => 0.5 - Math.random()); // 셔플
            revealed = Array(SIZE * SIZE).fill(false);

            const gameBoard = document.getElementById("game-board");
            gameBoard.innerHTML = "";

            for (let i = 0; i < SIZE * SIZE; i++) {
                const button = document.createElement("button");
                button.className = "card";
                button.onclick = () => revealCard(i);
                button.innerText = "?";
                gameBoard.appendChild(button);
            }
        }

        // 카드 뒤집기
        function revealCard(index) {
            if (revealed[index] || firstCard !== null && secondCard !== null) return;

            const buttons = document.getElementsByClassName("card");
            buttons[index].innerText = board[index];
            revealed[index] = true;

            if (firstCard === null) {
                firstCard = index;
            } else {
                secondCard = index;
                checkMatch();
            }
        }

        // 카드 일치 여부 확인
        function checkMatch() {
            const buttons = document.getElementsByClassName("card");
            if (board[firstCard] === board[secondCard]) {
                matchedPairs++;
                firstCard = null;
                secondCard = null;

                if (matchedPairs === (SIZE * SIZE) / 2) {
                    alert("모든 짝을 맞췄습니다!");
                }
            } else {
                setTimeout(() => {
                    buttons[firstCard].innerText = "?";
                    buttons[secondCard].innerText = "?";
                    revealed[firstCard] = false;
                    revealed[secondCard] = false;
                    firstCard = null;
                    secondCard = null;
                }, 1000);
            }
        }

        // 게임 재시작
        function resetGame() {
            matchedPairs = 0;
            firstCard = null;
            secondCard = null;
            initializeBoard();
        }

        window.onload = initializeBoard;
    </script>
</body>
</html>
