package kr.ac.kopo.controller;

import org.apache.ibatis.session.SqlSession;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.ac.kopo.dao.LeaderboardDAO;
import kr.ac.kopo.mybatis.MyConfig;
import kr.ac.kopo.vo.LeaderboardVO;
import kr.ac.kopo.vo.MemberVO;

public class SubmitScoreController implements Controller {

    private LeaderboardDAO leaderboardDAO;

    public SubmitScoreController() {
        MyConfig config = new MyConfig();
        SqlSession sqlSession = config.getInstance();
        this.leaderboardDAO = new LeaderboardDAO(sqlSession);
    }

    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String gameTitle = request.getParameter("gameId"); // 전달된 게임 제목 (gameId 대신 사용됨)
        String scoreStr = request.getParameter("score");

        // 세션에서 userVO 객체 가져오기
        HttpSession session = request.getSession();
        MemberVO userVO = (MemberVO) session.getAttribute("userVO");

        // 유효성 검증
        if (userVO == null) {
            response.getWriter().write("점수 제출 실패: 로그인 정보가 없습니다.");
            return null;
        }

        String userId = userVO.getId(); // userVO에서 id 가져오기

        // 디버깅 로그
        System.out.println("Received gameTitle: " + gameTitle);
        System.out.println("Received userId: " + userId);
        System.out.println("Received score: " + scoreStr);

        if (gameTitle == null || scoreStr == null) {
            response.getWriter().write("점수 제출 실패: 게임 정보 또는 점수가 없습니다.");
            return null;
        }

        // gameTitle을 숫자 gameId로 변환
        Integer gameId = leaderboardDAO.getGameIdByTitle(gameTitle);

        if (gameId == null) {
            response.getWriter().write("점수 제출 실패: 유효하지 않은 게임 ID");
            return null;
        }

        int score = Integer.parseInt(scoreStr);

        LeaderboardVO leaderboardVO = new LeaderboardVO();
        leaderboardVO.setUserId(userId);
        leaderboardVO.setGameId(gameId); // 변환된 숫자 gameId 설정
        leaderboardVO.setScore(score);

        System.out.println("Inserting to leaderboard: " + leaderboardVO);

        leaderboardDAO.insertScore(leaderboardVO);
        response.getWriter().write("점수 제출 성공");

        return null;
    }
}
