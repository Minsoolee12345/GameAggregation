<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src = "../Jquery/jquery-3.7.1.min.js"></script>
<script>
	
	$(document).ready(() => {
		$("#re").click(() => {
			location.href = "OddOneOut.jsp";
		})
	})
	
</script>
</head>
<body>
	<div align = "center">
		<button id = "re">다시하기</button>
	</div>
</body>
</html>