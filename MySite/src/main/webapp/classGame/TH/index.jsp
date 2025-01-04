<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Card Flipping Game</title>
    <style>
        /* 스타일 설정 */
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 20px; }
        .game-board { display: grid; grid-template-columns: repeat(4, 100px); grid-gap: 10px; justify-content: center; }
        .card { width: 100px; height: 100px; perspective: 1000px; }
        .card-inner { width: 100%; height: 100%; position: relative; transform-style: preserve-3d; transition: transform 0.6s; }
        .card.flipped .card-inner { transform: rotateY(180deg); }
        .card-front, .card-back { position: absolute; width: 100%; height: 100%; backface-visibility: hidden; display: flex; justify-content: center; align-items: center; border-radius: 5px; }
        .card-front { background-color: #007BFF; color: white; }
        .card-back { background-color: #28A745; color: black; transform: rotateY(180deg); font-size: 24px; font-weight: bold; }
        .score, #countdown { margin-top: 20px; font-size: 24px; color: black; }
        #restart {
            display: block;
            margin: 20px auto;
            padding: 10px 20px;
            font-size: 18px;
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        #restart:hover { background-color: #0056b3; }
    </style>
</head>
<body>
    <h1>카드 뒤집기 게임</h1>
    <button id="start">게임 시작</button>
    <div id="game" style="display: none;">
        <div id="countdown">5</div>
        <div class="game-board" id="board"></div>
        <div class="score">점수: <span id="score">0</span></div>
        <button id="restart" style="display: none;">다시하기</button>
    </div>
    <script>
        // DOM 요소 가져오기
        const startButton = document.getElementById("start"), restartButton = document.getElementById("restart"),
              board = document.getElementById("board"), scoreDisplay = document.getElementById("score"),
              gameContainer = document.getElementById("game"), countdownDisplay = document.getElementById("countdown");

        let cards = [], flippedCards = [], score = 0;

        // 카드 섞기
        function shuffle(array) {
            for (let i = array.length - 1; i > 0; i--) {
                const j = Math.floor(Math.random() * (i + 1));
                [array[i], array[j]] = [array[j], array[i]];
            }
            return array;
        }

        // 게임 보드 생성
        function createBoard() {
            board.innerHTML = ""; // 카드 초기화
            cards = shuffle([...Array(8).keys(), ...Array(8).keys()]); // 8개 숫자 카드 두 번씩 생성
            cards.forEach((number) => {
                const card = document.createElement("div"), cardInner = document.createElement("div"),
                      cardFront = document.createElement("div"), cardBack = document.createElement("div");
                card.classList.add("card");
                cardInner.classList.add("card-inner");
                cardFront.classList.add("card-front"); cardFront.innerText = "Card";
                cardBack.classList.add("card-back"); cardBack.innerText = number;
                cardInner.append(cardFront, cardBack); card.appendChild(cardInner);
                card.dataset.number = number;
                card.addEventListener("click", flipCard); // 카드 클릭 이벤트 추가
                board.appendChild(card);
            });
        }

        // 카드 뒤집기
        function flipCard() {
            if (this.classList.contains("flipped") || this.classList.contains("matched") || flippedCards.length === 2) return;
            this.classList.add("flipped"); // 뒤집기
            flippedCards.push(this); // 뒤집은 카드 추가
            score++; // 점수 증가
            scoreDisplay.innerText = score;
            if (flippedCards.length === 2) checkMatch(); // 두 카드가 뒤집혔으면 같은지 확인
        }

        // 두 카드가 같은지 비교
        function checkMatch() {
            const [card1, card2] = flippedCards;
            if (card1.dataset.number === card2.dataset.number) {
                card1.classList.add("matched");
                card2.classList.add("matched");
                flippedCards = []; // 매칭된 카드 초기화
                // 모든 카드가 매칭되었으면 게임 종료
                if (document.querySelectorAll(".matched").length === cards.length) setTimeout(() => restartButton.style.display = "block", 500);
            } else {
                setTimeout(() => {
                    card1.classList.remove("flipped");
                    card2.classList.remove("flipped");
                    flippedCards = []; // 매칭되지 않으면 다시 뒤집음
                }, 1000);
            }
        }

        // 5초 카운트다운 시작
        function startCountdown(callback) {
            let timeLeft = 5;
            countdownDisplay.style.display = "block";
            countdownDisplay.innerText = timeLeft;
            const timer = setInterval(() => {
                timeLeft--;
                countdownDisplay.innerText = timeLeft;
                if (timeLeft <= 0) { clearInterval(timer); countdownDisplay.style.display = "none"; callback(); }
            }, 1000);
        }

        // 시작 버튼 이벤트
        startButton.addEventListener("click", () => {
            startButton.style.display = "none"; // 시작 버튼 숨기기
            gameContainer.style.display = "block"; // 게임 화면 보이기
            createBoard(); // 보드 생성
            document.querySelectorAll(".card").forEach(card => card.classList.add("flipped"));
            startCountdown(() => document.querySelectorAll(".card").forEach(card => card.classList.remove("flipped"))); // 카운트다운 시작
        });

        // 다시 시작 버튼 이벤트
        restartButton.addEventListener("click", () => {
            score = 0; // 점수 초기화
            scoreDisplay.innerText = score;
            restartButton.style.display = "none"; // 다시하기 버튼 숨기기
            createBoard(); // 보드 새로 생성
            document.querySelectorAll(".card").forEach(card => card.classList.add("flipped"));
            startCountdown(() => document.querySelectorAll(".card").forEach(card => card.classList.remove("flipped"))); // 카운트다운 시작
        });
    </script>
</body>
</html>
