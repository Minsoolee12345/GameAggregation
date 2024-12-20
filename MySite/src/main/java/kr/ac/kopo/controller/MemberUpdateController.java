package kr.ac.kopo.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.ac.kopo.dao.MemberDAO;
import kr.ac.kopo.vo.MemberVO;

public class MemberUpdateController implements Controller 
{
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception 
    {
        if(request.getMethod().equalsIgnoreCase("POST")) 
        {
            String id = request.getParameter("id");
            String password = request.getParameter("password");
            String emailId = request.getParameter("emailId");
            String emailDomain = request.getParameter("emailDomain");

            MemberVO member = new MemberVO();
            member.setId(id);
            member.setPassword(password);
            member.setEmailId(emailId);
            member.setEmailDomain(emailDomain);

            MemberDAO dao = new MemberDAO();
            dao.updateMember(member);

            // 세션 무효화 처리
            request.getSession().invalidate();

            // 로그인 페이지로 리다이렉트
            response.sendRedirect("/MySite/jsp/login/login.jsp");
        }
        return null;
    }
}