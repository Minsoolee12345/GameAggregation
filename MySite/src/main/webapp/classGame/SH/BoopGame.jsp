<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>톡 피하기 게임</title>
    <style>
        body {
            text-align: center; /* 화면 가운데 정렬 */
            background-color: #f0f0f0; /* 배경색을 연한 회색으로 설정 */
        }
        canvas {
            background-color: #87ceeb; /* 게임 화면의 배경을 하늘색으로 설정 */
            border: 1px solid #000; /* 검은색 테두리를 설정 */
        }
    </style>
</head>
<body>
    <h2 id="levelIndicator">레벨: 1</h2> <!-- 현재 레벨을 표시하는 제목 -->
    <canvas id="gameCanvas" width="400" height="600"></canvas> <!-- 게임 화면이 그려질 캔버스 -->
    <script>
        const canvas = document.getElementById('gameCanvas'); // 캔버스를 불러와 변수에 저장
        const ctx = canvas.getContext('2d'); // 2D 그래픽을 그릴 수 있는 context를 불러옴

        // 플레이어 설정
        let player = {
            x: 180, // 플레이어의 초기 x 위치
            y: 500, // 플레이어의 초기 y 위치
            width: 40, // 플레이어의 너비
            height: 40, // 플레이어의 높이
            speed: 5, // 플레이어가 움직이는 속도
            image: new Image() // 플레이어 이미지 객체 생성
        };
        player.image.src = 'images/man.png'; // 플레이어 이미지 파일 경로 설정

        // 똥 설정
        let poops = [];
        let initialPoopSpeed = 3; // 똥의 초기 속도
        let rightPressed = false; // 오른쪽 키가 눌렸는지 여부
        let leftPressed = false; // 왼쪽 키가 눌렸는지 여부
        let level = 1; // 초기 레벨 설정

        // 똥 생성 함수
        function createPoops() {
            poops = []; // 기존 똥 초기화
            for (let i = 0; i < level + 1; i++) { // 레벨에 따라 똥의 개수가 증가함
                let poop = {
                    x: Math.random() * (canvas.width - 30), // 캔버스 너비 내 랜덤한 위치에 똥 생성
                    y: Math.random() * -canvas.height, // 캔버스 밖 위쪽에서 랜덤한 위치에 똥 생성
                    width: 30, // 똥의 너비
                    height: 30, // 똥의 높이
                    speed: initialPoopSpeed, // 똥의 속도
                    image: new Image() // 똥 이미지 객체 생성
                };
                poop.image.src = 'images/dong.png'; // 똥 이미지 파일 경로 설정
                poops.push(poop); // 똥을 배열에 추가
            }
        }

        // 키보드 입력 이벤트 설정
        document.addEventListener('keydown', (e) => {
            if (e.key === 'ArrowRight') {
                rightPressed = true; // 오른쪽 키가 눌리면 true
            } else if (e.key === 'ArrowLeft') {
                leftPressed = true; // 왼쪽 키가 눌리면 true
            }
        });

        document.addEventListener('keyup', (e) => {
            if (e.key === 'ArrowRight') {
                rightPressed = false; // 오른쪽 키가 떼어지면 false
            } else if (e.key === 'ArrowLeft') {
                leftPressed = false; // 왼쪽 키가 떼어지면 false
            }
        });

        // 게임 상태 업데이트 함수
        function update() {
            document.getElementById('levelIndicator').innerText = '레벨: ' + level; // 현재 레벨을 화면에 표시
            if (rightPressed && player.x < canvas.width - player.width) {
                player.x += player.speed; // 오른쪽 키가 눌렸고 캔버스를 벗어나지 않으면 플레이어 이동
            } else if (leftPressed && player.x > 0) {
                player.x -= player.speed; // 왼쪽 키가 눌렸고 캔버스를 벗어나지 않으면 플레이어 이동
            }

            poops.forEach(poop => {
                poop.y += poop.speed; // 똥이 아래로 떨어짐
                if (poop.y > canvas.height) { // 똥이 화면 아래로 넘어가면
                    poop.y = Math.random() * -canvas.height; // 다시 위쪽에서 나타남
                    poop.x = Math.random() * (canvas.width - poop.width); // 위치를 랜덤으로 설정
                    poop.speed += 0.7; // 속도를 더 빠르게 함
                }

                // 플레이어와 똥의 충돌 체크
                if (
                    player.x < poop.x + poop.width &&
                    player.x + player.width > poop.x &&
                    player.y < poop.y + poop.height &&
                    player.y + player.height > poop.y
                ) {
                    alert('게임 오버! 현재 레벨: ' + level); // 충돌 시 게임 오버 메시지
                    document.location.reload(); // 페이지를 다시 로드하여 게임 재시작
                }
            });

            // 모든 똥이 화면 아래로 넘어갔으면 다음 레벨로 넘어감
            if (poops.every(poop => poop.y > canvas.height)) {
                nextLevel();
            }
        }

        // 게임 화면 그리기 함수
        function draw() {
            ctx.clearRect(0, 0, canvas.width, canvas.height); // 이전 그림을 지움
            ctx.drawImage(player.image, player.x, player.y, player.width, player.height); // 플레이어 그리기

            poops.forEach(poop => {
                ctx.drawImage(poop.image, poop.x, poop.y, poop.width, poop.height); // 똥 그리기
            });
        }

        // 게임 루프 함수
        function gameLoop() {
            update(); // 게임 상태 업데이트
            draw(); // 게임 화면 그리기
            requestAnimationFrame(gameLoop); // 애니메이션 루프 계속 호출
        }

        // 다음 레벨로 넘어가는 함수
        function nextLevel() {
            level++; // 레벨 증가
            alert('새로운 레벨이 시작됩니다! 현재 레벨: ' + level); // 다음 레벨 알림
            initialPoopSpeed += 2; // 똥의 속도 증가
            createPoops(); // 새로운 똥 생성
        }

        // 초기 똥 생성 및 게임 시작
        createPoops();
        gameLoop();
    </script>
</body>
</html>
