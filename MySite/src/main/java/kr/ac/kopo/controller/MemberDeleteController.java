package kr.ac.kopo.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.ac.kopo.dao.MemberDAO;
import java.io.IOException;

public class MemberDeleteController implements Controller
{
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws IOException
    {
        String id = request.getParameter("id");
        
        if (id == null || id.isEmpty())
        {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"message\": \"잘못된 요청입니다. 회원 아이디가 없습니다.\"}");
            return null;
        }
        
        MemberDAO memberDAO = new MemberDAO();
        try {
            memberDAO.deleteMember(id);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"message\": \"회원탈퇴가 완료되었습니다.\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"message\": \"회원탈퇴 중 오류가 발생했습니다.\"}");
            e.printStackTrace();
        }
        return null; // Ajax 응답으로만 처리하고 뷰 이름을 반환하지 않음
    }
}