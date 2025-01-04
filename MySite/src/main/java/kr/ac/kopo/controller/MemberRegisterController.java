package kr.ac.kopo.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.ac.kopo.dao.MemberDAO;
import kr.ac.kopo.vo.MemberVO;

public class MemberRegisterController implements Controller {
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (request.getMethod().equalsIgnoreCase("GET")) {
            // GET 요청 시 회원가입 폼 페이지로 이동
            return "/MySite/jsp/member/memberForm.jsp";
        }

        // POST 요청 처리 (회원가입)
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String password = request.getParameter("password");
        String emailId = request.getParameter("emailId");
        String emailDomain = request.getParameter("emailDomain");

        MemberDAO dao = new MemberDAO();

        // 아이디 중복 체크
        if (!dao.isIdUsable(id)) {
            // 중복된 아이디일 경우 에러 메시지 전달
            request.setAttribute("errorMessage", "이미 사용 중인 아이디입니다.");
            return "./jsp/member/memberForm.jsp";
        }

        // 회원 등록
        MemberVO member = new MemberVO();
        member.setId(id);
        member.setName(name);
        member.setPassword(password);
        member.setEmailId(emailId);
        member.setEmailDomain(emailDomain);

        dao.insertMember(member);

        // 회원가입 완료 후 로그인 페이지로 리다이렉트
        response.sendRedirect(request.getContextPath() + "/jsp/login/login.jsp");
        return null; // 리다이렉트 처리
    }
}