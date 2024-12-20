package kr.ac.kopo.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.ac.kopo.vo.LeaderboardVO;

public class LeaderboardDAO {
    private final SqlSession sqlSession;

    public LeaderboardDAO(SqlSession sqlSession) {
        this.sqlSession = sqlSession;
    }

    // 점수 기록 추가
    public void insertScore(LeaderboardVO leaderboard) {
        System.out.println("Inserting userId: " + leaderboard.getUserId());
        System.out.println("Inserting gameId: " + leaderboard.getGameId());
        System.out.println("Inserting score: " + leaderboard.getScore());
        sqlSession.insert("kr.ac.kopo.dao.LeaderboardDAO.insertScore", leaderboard);
        sqlSession.commit();
    }

    // 게임 ID로 게임 이름 조회
    public String getGameNameById(int gameId) {
        return sqlSession.selectOne("kr.ac.kopo.dao.LeaderboardDAO.getGameNameById", gameId);
    }

    // 특정 게임의 상위 점수 조회
    public List<LeaderboardVO> getTopScoresById(int gameId, int limit) {
    	sqlSession.clearCache();
        Map<String, Object> params = Map.of("gameId", gameId, "limit", limit);
        return sqlSession.selectList("kr.ac.kopo.dao.LeaderboardDAO.getTopScoresById", params);
    }
    
    // T_GAME에서 game_title을 사용해 game_id를 조회하는 메서드
    public Integer getGameIdByTitle(String gameTitle) {
        return sqlSession.selectOne("kr.ac.kopo.dao.LeaderboardDAO.getGameIdByTitle", gameTitle);
    }

}
