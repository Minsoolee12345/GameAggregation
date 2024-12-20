<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String score = request.getParameter("score");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>지렁이 메인</title>
    <link rel="stylesheet" href="resource/style.css">
</head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
    // "설명" 버튼 클릭 시 descr.jsp의 내용을 불러와서 #description에 삽입
    $("#btn02").click(function() {
        if ($("#description").html() !== "") {
            $("#description").html("");  // 내용을 지움
        } else {
            $.ajax({
                url: "jsp/descr.jsp", // descr.jsp 파일 경로
                method: "GET",
                success: function(response) {
                    $("#description").html(response);
                },
                error: function() {
                    $("#description").html("설명을 불러오는 데 실패했습니다.");
                }
            });
        }
    });

    // 넘어온 score 값 가져오기
    const score = "<%=score != null ? score : "0"%>";

    // 현재 점수를 화면에 표시
    document.getElementById("currentScore").innerText = score;

    // 로컬 스토리지에서 최고 점수 가져오기
    let highScore = localStorage.getItem("highScore") || 0;

    // 최고 점수보다 현재 점수가 높으면 로컬 스토리지 업데이트
    if (parseInt(score) > parseInt(highScore)) {
        highScore = score;
        localStorage.setItem("highScore", highScore);
    }

    // 최고 점수를 화면에 표시
    document.getElementById("highScore").innerText = highScore;

    // 난이도 관련 변수 설정
    let snakeSpeed = 150; // 기본값 (보통 난이도)
    let obstacleP = 0.05; // 기본 장애물 확률 (보통)

    // 
    const savedDifficulty = localStorage.getItem("difficultyLevel") || "보통";

    // 
    $("#difficultyLevel").text(savedDifficulty);

    // 
    if (savedDifficulty === "쉬움") {
        snakeSpeed = 300;
        obstacleP = 0.05;
    } else if (savedDifficulty === "어려움") {
        snakeSpeed = 100;
        obstacleP = 0.4;
    }

    // 설정 버튼 클릭 시 난이도 버튼 생성
    $("#btn03").click(function() {
        if ($("#setting").html() !== "") {
            $("#setting").html("");  // 내용을 지움
        } else {
            $.ajax({
                url: "jsp/options.jsp", // 난이도 옵션 버튼을 생성할 페이지
                success: function() {
                    // 난이도 버튼 생성
                    $("#setting").html(`
                        <button class="difficultyBtn" data-speed="250" data-level="쉬움" data-obstacle="0.05" style="background-color:blue">쉬움</button>
                        <button class="difficultyBtn" data-speed="150" data-level="보통" data-obstacle="0.05" style="background-color:grey">보통</button>
                        <button class="difficultyBtn" data-speed="100" data-level="어려움" data-obstacle="0.3" style="background-color:red">어려움</button>
                    `);
                    
                    // 난이도 버튼 클릭 이벤트 핸들러
                    $(".difficultyBtn").click(function() {
                        // 선택한 난이도의 속도와 레벨 가져오기
                        const level = $(this).data("level");
                        snakeSpeed = $(this).data("speed");
                        obstacleP = $(this).data("obstacle");

                        // 화면에 난이도 표시
                        $("#difficultyLevel").text(level);

                        // Save the selected difficulty level to localStorage
                        localStorage.setItem("difficultyLevel", level);
                    });
                }
            });
        }
    });

    // 게임 시작 버튼 클릭 시
    $("#btn01").click(function() {
        location.href = `jsp/play.jsp?snakeSpeed=\${snakeSpeed}&obstacleP=\${obstacleP}`;
    });
});
</script>
<body>
    <h1>지렁이 게임 (Snake Game)</h1>
    <div>
        최종 점수: <span id="currentScore"></span>
    </div>
    <div>
        최고 점수: <span id="highScore"></span>
    </div>
    <div>
        난이도: <span id="difficultyLevel">보통</span>
    </div>
    <button id="btn01">게임 시작</button>
    <button id="btn02">설명</button>
    <div id="description"></div>
    <button id="btn03">설정</button>
    <div id="setting"></div>
</body>
</html>
