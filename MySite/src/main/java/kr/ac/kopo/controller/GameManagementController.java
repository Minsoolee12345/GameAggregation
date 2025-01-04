package kr.ac.kopo.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.util.List;

import kr.ac.kopo.dao.GameDAO;
import kr.ac.kopo.vo.GameVO;
import kr.ac.kopo.vo.MemberVO;

public class GameManagementController implements Controller {
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 현재 세션 가져오기
        HttpSession session = request.getSession(false);
        
        // 세션이 없거나, 사용자 정보가 없거나, 사용자가 admin이 아닌 경우
        if (session == null || session.getAttribute("userVO") == null
                || !"admin".equals(((MemberVO) session.getAttribute("userVO")).getId())) {
            // 로그인 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/jsp/login/login.jsp");
            return null;
        }

        // GameDAO를 사용하여 모든 게임 목록 조회
        GameDAO gameDAO = new GameDAO();
        List<GameVO> gameList = gameDAO.selectAllGames();

        // 조회된 게임 목록을 request에 저장
        request.setAttribute("gameList", gameList);

        // 게임 관리 JSP 페이지로 포워딩
        return "/jsp/admin/game_man.jsp";
    }
}