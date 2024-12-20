package kr.ac.kopo.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.ac.kopo.dao.GameDAO;
import kr.ac.kopo.vo.MemberVO;

public class DeleteGameController implements Controller 
{
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception 
    {
        // 현재 세션 가져오기
        HttpSession session = request.getSession(false);

        // 세션이 없거나, 사용자 정보가 없거나, 사용자가 admin이 아닌 경우
        if (session == null || session.getAttribute("userVO") == null
                || !"admin".equals(((MemberVO) session.getAttribute("userVO")).getId())) 
        {
            // 로그인 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/jsp/login/login.jsp");
            return null;
        }

        // 삭제할 게임 ID 가져오기
        int gameId = Integer.parseInt(request.getParameter("gameId"));

        // GameDAO를 사용하여 게임 삭제
        GameDAO gameDAO = new GameDAO();
        gameDAO.deleteGame(gameId);

        // 게임 관리 페이지로 리다이렉트
        return "/gameManagement.do";
    }
}
