<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
    // 회원 정보를 가져오는 부분을 페이지 상단으로 이동
    String id = request.getParameter("id");
    if (id == null || id.isEmpty()) {
        out.println("<script>alert('회원 ID가 전달되지 않았습니다.'); history.back();</script>");
        return;
    }
    kr.ac.kopo.dao.MemberDAO memberDAO = new kr.ac.kopo.dao.MemberDAO();
    kr.ac.kopo.vo.MemberVO member = memberDAO.findById(id);
    request.setAttribute("member", member);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 정보</title>
<style>
    /* 기존 스타일 유지 */
    body {
        font-family: Arial, sans-serif;
        background-color: #f0f9e8;
        color: #333;
    }
    h1 {
        color: #4d774e;
        text-align: center;
    }
    table {
        width: 50%;
        margin: 20px auto;
        border-collapse: collapse;
        background-color: #ffffff;
    }
    th, td {
        border: 1px solid #d0e8c0;
        padding: 10px;
        text-align: left;
    }
    th {
        background-color: #a3d9a5;
        color: #ffffff;
        width: 30%;
    }
    tr:nth-child(even) {
        background-color: #e6f4ea;
    }
    .button-container {
        text-align: center;
        margin-top: 20px;
    }
    .button-container button {
        padding: 10px 20px;
        background-color: #a3d9a5;
        color: #fff;
        border: none;
        cursor: pointer;
    }
    .button-container button:hover {
        background-color: #4d774e;
    }
</style>
<!-- jQuery 추가 -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script>
    $(document).ready(function() {
        $("#deleteButton").click(function() {
            if (confirm("정말로 이 회원을 삭제하시겠습니까?")) {
                var memberId = "<c:out value='${member.id}' />";
                console.log("memberId:", memberId); // 디버깅용
                $.ajax({
                    type: "POST",
                    url: "/MySite/memberDelete.do",
                    data: { id: memberId },
                    dataType: "json",
                    success: function(response) {
                        alert(response.message);
                        if (response.message === "회원탈퇴가 완료되었습니다.") {
                        	window.location.href = "/MySite/admin.do"; // 컨트롤러를 통해 이동
                        }
                    },
                    error: function(xhr) {
                        alert("회원 삭제 중 오류가 발생했습니다.");
                        console.error("Status:", xhr.status);
                        console.error("Response:", xhr.responseText);
                    }
                });
            }
        });
    });
</script>
</head>
<body>
    <h1>회원 정보 상세보기</h1>
    <c:if test="${not empty member}">
        <table>
            <tr>
                <th>ID</th>
                <td>${member.id}</td>
            </tr>
            <tr>
                <th>이름</th>
                <td>${member.name}</td>
            </tr>
<!--             <tr> -->
<!--                 <th>이메일</th> -->
<%--                 <td>${member.emailId}@${member.emailDomain}</td> --%>
<!--             </tr> -->
<!--             <tr> -->
<!--                 <th>등록일</th> -->
<%--                 <td>${member.regDate}</td> --%>
<!--             </tr> -->
        </table>
        <!-- 삭제 버튼 추가 -->
        <div class="button-container">
            <button id="deleteButton">회원 삭제</button>
        </div>
    </c:if>
    <c:if test="${empty member}">
        <p style="text-align: center;">해당 ID의 회원이 존재하지 않습니다.</p>
    </c:if>
</body>
</html>
