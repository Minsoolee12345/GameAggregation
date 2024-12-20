<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Mini-Game</title>
    <style>
        .container {
            display: flex; 
            flex-direction: column; /* 요소들을 위에서 아래로(열) 형식으로 정렬 */
            align-items: center; /* flexbox 속 요소들을 세로선 상에서 중앙 정렬*/
            justify-content: center; /* flexbox 속 요소들을 가로선 상에서 중앙 정렬 */
        }

        .pic {
            background-image: url("../contents/stage1.jpg"); /* 현재경로에서 이전 경로로, 이전 경로의 contents 폴더 속 stage1.jpg 파일에 접근*/
            width: 1100px;
            height: 600px;
            background-size: 100% 100%;
            position: relative; /*position 속성을 relative(상대적)로 설정하게 되면 요소를 원래 위치에서 벗어나게 배치할 수 있게 된다*/
        }

        .oddOne {
		position : relative;
		width : 100px;
		height : 100px;
		top : 320px;
		left : 660px;
		}

        .timer-bar {
            width: 100%;
            height: 20px;
            background-color: #ccc;
            margin-top: 20px;
            position: relative;
            
        }

        .timer-bar-inner {
            width: 100%;
            height: 100%;
            background-color: #4CAF50;
            position: absolute; /*position을 absolute로 설정하면 절대적으로 요소를 배치해주지 않는다*/
            top: 0;
            left: 0;
            
            /* 
            	transision, css에서 개체에 적용된 스타일을 대상으로 주어진 시간과 조건으로 부드럽게 상태를 변화시키는 기술이다.
            	길이를 1초 동안 변화시킨다.
             */
        }

        .stages {
            font-size: 24px;
            font-weight: bold;
            margin-top: 10px;
        }
        
    </style>
    <script src="../Jquery/jquery-3.7.1.min.js"></script>
    <script>
    	
 	/*
 		각각의 스테이지에 표시될 그림은 stage1, stage2, stage3 ... 이렇게 표시되어있음,
 		아래 stages 배열은 스테이지 변경을 위해 Jquery내 함수에서 백틱으로 포인터를 응용한 그림 바꾸기, 스테이지 목차 숫자 변경을 구현하기 위해 존재
 	*/
    	
        let stages = ['1', '2', '3', '4', '5'];  

        let coord = [ // 각 틀린 그림의 좌표가 적힌 키와 값을 담은 Js 객체들을 담은 배열
            {"top": "320px", "left": "660px"},
            {"top": "380px", "left": "240px"},
            {"top": "360px", "left": "880px"},
            {"top": "300px", "left": "180px"},
            {"top": "430px", "left": "870px"}
        ];

        let p = 0; // 현재 스테이지 번호
        let totalTime = 10;  // 타임어택 총 시간 (초)
        let remainingTime = totalTime;  // 남은 시간 (초)
        let timerInterval; // 함수 실행용 변수

        // 타이머 업데이트 함수
        function updateTimer() {
            $("#time-left").text(remainingTime); // time-left id를 가지고 있는 태그에 텍스트로 남은 시간을 표시
            let widthPercentage = (remainingTime / totalTime) * 100; 
            // 시간제한 바를 구현하기 위해 남은 시간과 총 시간을 나눈 후 100을 곱하여 남은 시간 비율을 구함
            
    		// timer-bar-inner class를 선택, css함수로 구한 비율을 width 속성에 넣어 길이변경, remainingTime의 값에 따라 바 색깔도 변경 
    		
    		if (remainingTime <= 10 && remainingTime > 6)  {// 남은 시간이 10초이하 6초 초과라면 
    			
    			$(".timer-bar-inner").css({ 
           		 'width': widthPercentage + '%' // 길이를 해당 비율로 바꿈
           		 ,'background-color' : '#4CAF50' // 바 색깔은 초록색으로
           		 ,'transition' : 'width 1s linear, background-color 0.5s' // 길이 바꾸기는 1초동안, 색 바꾸기는 0.5초의 시간동안 바뀜
    			});
    		}
    		else if (remainingTime <= 6 && remainingTime > 3) { // 남은 시간이 6초 이하 3초 초과라면
            	 $(".timer-bar-inner").css({ 
            		 'width': widthPercentage + '%' // 길이를 해당 비율로 바꿈
            		 ,'background-color' : 'yellow' // 바 색깔은 노란색으로
            		 ,'transition' : 'width 1s linear, background-color 5s' // 길이 바꾸기는 1초동안, 색 바꾸기는 10초의 시간동안 천천히 바뀜
            		 });
    		} else if (remainingTime <= 3) { // 남은 시간이 3초 이하라면
    			 $(".timer-bar-inner").css({
    				 'width': widthPercentage + '%' // 길이를 해당 비율로 바꿈
    				 ,'background-color' : 'red' // 바 색깔은 빨강으로
    				 ,'transition' : 'width 1s linear, background-color 5s'}); // 길이 바꾸기 1초, 바 색깔 바꾸기 5초
    		}
            
        }

        // 타임바 애니메이션 (시간에 맞춰 너비가 줄어듬)
        function startCountdown() {
            timerInterval = setInterval(function() { //setInterval, 1초 간격으로 다음 익명 함수를 연속해서 실행
            	
            	updateTimer(); // time-left 라는 id를 가진 속성에 text로 remainingTime을 넣음
            	 if (remainingTime < 0) {
                     clearInterval(timerInterval);
                     onTimeUp();
                 } else {
            		remainingTime--; // 1초 씩 감소하는 것을 표현
                 }
               
                
            }, 1000);
        }

        // 타임업 (시간이 끝났을 때 실행될 함수)
        function onTimeUp() {
            alert("타임업! 게임 종료");
            location.href = "GameOver.jsp";  // 게임 오버 페이지로 이동
        }

        $(document).ready(() => {
            // 게임을 시작하면 타임어택 시작
            startCountdown();

            $(".oddOne").click(() => { // 틀린 그림 클릭시
                p++; 
            	/*
	                포인터 증가, 이 포인터는 스테이지 목차에 적힐 숫자, 다음에 나올 그림의 img 파일 이름,
	                그리고 틀린그림 좌표를 담은 배열을 위한 포인터이기도 함
                */
                if (p == 5) { // 스테이지는 총 5개로 구성되어 있음, 포인터가 5를 가리킬시 클리어 페이지로 이동
                    location.href = "clear.jsp";
                } else {
                	// 틀린그림을 클릭 시 포인터를 이용하여 그림 변경
                	$(".pic").css("background-image", `url("../contents/stage\${stages[p]}.jpg\")`) 
                	// stages 클래스의 내용을 비우고
        			$(".stages").empty()
        			// stages 클래스의 내용을 다시 씀
        			$(".stages").append("<h1>stage " + stages[p] + "/5</h1>")
        			// oddOne class의 css 내용을 변경해주는 Jquery 함수로 좌표설정, oddOne의 위치 변경
                    $(".oddOne").css({"top": coord[p].top, "left": coord[p].left});
                    remainingTime = totalTime;  // 타이머 리셋
                    updateTimer();
                    clearInterval(timerInterval); // 이전 타이머를 중단
                    startCountdown(); // 새로운 타이머 시작
                }
            });
        });
    </script>
</head>
<body>
    <div class="container">
        <div class="stages">
            <h1>stage 1/5</h1>
        </div>
        <div class="pic">
            <div class="oddOne"></div>
        </div>
        <div class="timer-bar">
            <div class="timer-bar-inner"></div>
        </div>
        <div id="timer"><span id="time-left"></span></div>
    </div>
</body>
</html>
