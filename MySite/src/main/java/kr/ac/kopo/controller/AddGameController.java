package kr.ac.kopo.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.ac.kopo.dao.GameDAO;
import kr.ac.kopo.vo.GameVO;
import kr.ac.kopo.vo.MemberVO;

public class AddGameController implements Controller {
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

        // 요청 파라미터에서 게임 정보를 가져오기
        String gameUrl = request.getParameter("gameUrl");
        String gameTitle = request.getParameter("gameTitle");
        String gameIntro = request.getParameter("gameIntro");

        // GameVO 객체 생성 및 설정
        GameVO game = new GameVO();
        game.setGameUrl(gameUrl);
        game.setGameTitle(gameTitle);
        game.setGameIntro(gameIntro);

        // GameDAO를 사용하여 게임 추가
        GameDAO gameDAO = new GameDAO();
        gameDAO.insertGame(game);

        // 리다이렉트 처리
        response.sendRedirect(request.getContextPath() + "/gameManagement.do");
        return null; // 리다이렉트 후 컨트롤러 처리를 중단
    }
}
