package kr.ac.kopo.dao;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import kr.ac.kopo.mybatis.MyConfig;
import kr.ac.kopo.vo.GameApplicationVO;

public class GameApplicationDAO {
    private SqlSession session;

    public GameApplicationDAO() {
        MyConfig config = new MyConfig();
        session = config.getInstance();
    }

    /**
     * 게임 신청서 삽입
     * @param application - 게임 신청 정보
     * @return int - 삽입 결과
     */
    public int insertGameApplication(GameApplicationVO application) {
        int result = session.insert("kr.ac.kopo.dao.GameApplicationDAO.insertGameApplication", application);
        session.commit();
        return result;
    }

    /**
     * 상태가 'pending'인 모든 게임 신청서 조회
     * @return List<GameApplicationVO>
     */
    public List<GameApplicationVO> getPendingApplications() {
        return session.selectList("kr.ac.kopo.dao.GameApplicationDAO.getPendingApplications");
    }

    /**
     * 특정 게임 신청서 조회 by ID
     * @param id - 신청서 ID
     * @return GameApplicationVO - 신청서 정보
     */
    public GameApplicationVO selectApplicationById(int id) {
        return session.selectOne("kr.ac.kopo.dao.GameApplicationDAO.selectApplicationById", id);
    }

    /**
     * 게임 신청서 승인
     * @param applicationId - 신청서 ID
     * @return int - 승인 결과
     */
    public int approveGameApplication(int applicationId) {
        // 게임 신청서 조회
        GameApplicationVO application = selectApplicationById(applicationId);
        if (application == null) {
            return 0;
        }

        // 게임 테이블에 추가
        GameDAO gameDAO = new GameDAO();
        gameDAO.insertGame(application.getGameUrl(), application.getGameTitle(), application.getGameIntro());

        // 신청서 상태 업데이트
        int updateResult = session.update("kr.ac.kopo.dao.GameApplicationDAO.updateApplicationStatus", applicationId);
        session.commit();
        return updateResult;
    }

    /**
     * 게임 신청서 거절
     * @param applicationId - 신청서 ID
     * @return int - 거절 결과
     */
    public int rejectGameApplication(int applicationId) {
        int updateResult = session.update("kr.ac.kopo.dao.GameApplicationDAO.rejectApplication", applicationId);
        session.commit();
        return updateResult;
    }
}
