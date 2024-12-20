package kr.ac.kopo.controller;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.ac.kopo.dao.LeaderboardDAO;
import kr.ac.kopo.mybatis.MyConfig;
import kr.ac.kopo.vo.LeaderboardVO;
import org.apache.ibatis.session.SqlSession;

public class LeaderboardController implements Controller {

    private SqlSession sqlSession;

    public LeaderboardController() {
        MyConfig config = new MyConfig();
        this.sqlSession = config.getInstance();
    }

    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String gameTitle = request.getParameter("gameId"); // gameId 대신 실제 게임 제목을 받음
        System.out.println("Received gameTitle: " + gameTitle); // 디버깅 로그

        if (gameTitle == null || gameTitle.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "게임 제목이 제공되지 않았습니다.");
            return null;
        }

        // gameTitle을 기반으로 gameId 조회
        LeaderboardDAO dao = new LeaderboardDAO(sqlSession);
        Integer gameId = dao.getGameIdByTitle(gameTitle);

        if (gameId == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "해당 게임을 찾을 수 없습니다.");
            return null;
        }

        List<LeaderboardVO> topScores = dao.getTopScoresById(gameId, 10);

        // 게임 이름 조회
        String gameName = dao.getGameNameById(gameId);
        if (gameName == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "해당 게임을 찾을 수 없습니다.");
            return null;
        }

        request.setAttribute("topScores", topScores);
        request.setAttribute("gameName", gameName);

        return "/jsp/board/leaderboard.jsp";
    }
}
