<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<style>
	
	.txt {
		text-align : center;
	}
	
	#main {
		background-image : url('contents/odd-one-out.jpg');
		background-image: no-repeat; /*배경 이미지 반복 안 함 */
		background-size: 100% 100%;
		height : 250px;
		margin : 100px;
		color : yellow;
	}
	
</style>
<script src = "./Jquery/jquery-3.7.1.min.js"></script>
<script>
	$(document).ready(() => {
		$("#startBtn").click(() => {
			location.href = "stages/OddOneOut.jsp"
		})
	})
</script>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	
		<div class = "txt" id = "main">
			<h1>틀린 그림 찾기</h1>
		</div>	
		<div class = "txt">
			<button id = "startBtn">
				시작
			</button>
		</div>
</body>
</html>