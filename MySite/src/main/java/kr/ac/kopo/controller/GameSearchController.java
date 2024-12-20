package kr.ac.kopo.controller;

import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.ac.kopo.dao.GameDAO;
import kr.ac.kopo.vo.GameVO;

public class GameSearchController implements Controller {
    private GameDAO gameDAO = new GameDAO();

    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String query = request.getParameter("query"); // 검색어
        System.out.println("Query: " + query);
        List<GameVO> games = gameDAO.searchGames(query);

        // JSON 문자열 직접 생성
        StringBuilder jsonBuilder = new StringBuilder();
        jsonBuilder.append("[");

        for (int i = 0; i < games.size(); i++) {
            GameVO game = games.get(i);
            jsonBuilder.append("{");
            jsonBuilder.append("\"gameId\":").append(game.getGameId()).append(",");
            jsonBuilder.append("\"gameUrl\":\"").append(game.getGameUrl()).append("\",");
            jsonBuilder.append("\"gameTitle\":\"").append(game.getGameTitle()).append("\",");
            jsonBuilder.append("\"gameIntro\":\"").append(game.getGameIntro()).append("\"");
            jsonBuilder.append("}");
            if (i < games.size() - 1) {
                jsonBuilder.append(",");
            }
        }

        jsonBuilder.append("]");

        // JSON 응답 처리
        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write(jsonBuilder.toString());

        // 이 컨트롤러는 별도의 페이지로 포워딩하지 않으므로 null 반환
        return null;
    }
}