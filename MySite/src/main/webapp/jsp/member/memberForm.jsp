<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회원 가입</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f0f9e8; /* 부드러운 연두색 배경 */
        color: #333;
        text-align: center;
    }
    h1 {
        color: #4d774e;
    }
    form {
        width: 50%;
        margin: 0 auto;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 20px;
        background-color: #ffffff;
    }
    th, td {
        padding: 10px;
        border: 1px solid #d0e8c0;
        text-align: left;
    }
    th {
        background-color: #a3d9a5; /* 연한 녹색 */
        color: #ffffff;
    }
    tr:nth-child(even) {
        background-color: #e6f4ea;
    }
    button {
        background-color: #4d774e;
        color: white;
        border: none;
        padding: 10px 20px;
        cursor: pointer;
        margin-top: 10px;
    }
    button:hover {
        background-color: #3e625b;
    }
    #cancelBtn {
        background-color: #d9534f;
    }
    #cancelBtn:hover {
        background-color: #c9302c;
    }
</style>
<script>
	$(document).ready(function() {
		$('#cancelBtn').click(function() {
			location.href = '/MySite/jsp/login/login.jsp';
		});

		$('#idCheckBtn').click(function() {
			let userId = $('#userId').val().trim();

			if (userId === '') {
				alert('아이디를 입력하세요.');
				return;
			}

			$.ajax({
				type : 'POST',
				url : '/MySite/checkId.do',
				data : {
					id : userId
				},
				success : function(response) {
					if (response === 'usable') {
						alert('사용 가능한 아이디입니다.');
					} else {
						alert('이미 사용 중인 아이디입니다.');
					}
				},
				error : function() {
					alert('아이디 중복 체크 중 오류가 발생했습니다.');
				}
			});
		});
	});
</script>
</head>
<body>
	<div>
		<br>
		<h1>회원 가입</h1>
		<hr>
		<br>
		<c:if test="${not empty errorMessage}">
			<p style="color: red;">${errorMessage}</p>
		</c:if>
		<form action="/MySite/register.do" method="post" onsubmit="return validateForm()">
			<table border="1" style="width: 80%">
				<tr>
					<th width="23%">아이디</th>
					<td>
						<input type="text" name="id" id="userId" required>
						<button type="button" id="idCheckBtn">중복 체크</button>
					</td>
				</tr>
				<tr>
					<th width="23%">이름</th>
					<td><input type="text" name="name" required></td>
				</tr>
				<tr>
					<th width="23%">비밀번호</th>
					<td><input type="password" name="password" required></td>
				</tr>
				<tr>
					<th width="23%">이메일</th>
					<td><input type="text" name="emailId" required>@<input type="text" name="emailDomain" required></td>
				</tr>
			</table>
			<button type="submit">회원 등록</button>
		</form>
		<button type="button" id="cancelBtn">취소</button>
	</div>
</body>
</html>