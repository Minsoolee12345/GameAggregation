package kr.ac.kopo.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import kr.ac.kopo.dao.GameDAO;
import kr.ac.kopo.vo.GameVO;

public class GameListController implements Controller {
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // GameDAO를 사용하여 모든 게임 목록 조회
        GameDAO gameDAO = new GameDAO();
        List<GameVO> gameList = gameDAO.selectAllGames();

        // 조회된 게임 목록을 request에 저장
        request.setAttribute("gameList", gameList);

        // 이 컨트롤러는 이제 /game/list.do로 접근할 경우 게임 목록을 보여주는 페이지로 포워딩할 수 있음
        // 필요에 따라 JSP를 변경하거나 해당 컨트롤러의 목적에 맞게 활용하십시오.
        return "/jsp/board/list.jsp";
    }
}
