package kr.ac.kopo.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.ac.kopo.dao.MemberDAO;

public class CheckIdController implements Controller 
{
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception
    {
        String id = request.getParameter("id");
        MemberDAO dao = new MemberDAO();

        boolean isUsable = dao.isIdUsable(id);

        response.setContentType("text/plain");
        response.getWriter().write(isUsable ? "usable" : "unusable");
        return null; // Ajax 응답만 처리
    }
}
