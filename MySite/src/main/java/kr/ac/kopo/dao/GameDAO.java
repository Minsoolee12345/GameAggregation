package kr.ac.kopo.dao;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import kr.ac.kopo.mybatis.MyConfig;
import kr.ac.kopo.vo.GameVO;

public class GameDAO {
    private SqlSession session;

    public GameDAO() {
        MyConfig config = new MyConfig();
        session = config.getInstance();
        System.out.println("GameDAO 생성했잖아!!!!!!!!!!");
    }

    /**
     * 모든 게임 조회
     * @return List<GameVO> - 모든 게임 리스트
     */
    public List<GameVO> selectAllGames() {
        System.out.println("버~그");
        List<GameVO> gameList = session.selectList("kr.ac.kopo.dao.GameDAO.selectAllGames");
        if (gameList == null || gameList.isEmpty()) {
            System.out.println("No games found.");
        } else {
            System.out.println("Number of games found: " + gameList.size());
        }
        return gameList;
    }

    /**
     * 게임 검색
     * @param query - 검색어
     * @return List<GameVO> - 검색된 게임 리스트
     */
    public List<GameVO> searchGames(String query) {
        System.out.println("게임 검색: " + query);
        List<GameVO> searchResults = session.selectList("kr.ac.kopo.dao.GameDAO.searchGames", query);
        if (searchResults == null || searchResults.isEmpty()) {
            System.out.println("검색된 게임이 없습니다.");
        } else {
            System.out.println("검색된 게임 수: " + searchResults.size());
        }
        return searchResults;
    }

    /**
     * 게임 추가
     * @param game - 추가할 게임 정보
     * @return int - 추가 결과 (성공 여부)
     */
    public int insertGame(GameVO game) {
        int result = session.insert("kr.ac.kopo.dao.GameDAO.insertGame", game);
        session.commit(); // 삽입 후 커밋
        return result;
    }

    public int insertGame(String gameUrl, String gameTitle, String gameIntro) {
        GameVO game = new GameVO();
        game.setGameUrl(gameUrl);
        game.setGameTitle(gameTitle);
        game.setGameIntro(gameIntro);
        return insertGame(game);
    }
    
    /**
     * 특정 게임 조회
     * @param gameId - 조회할 게임 ID
     * @return GameVO - 게임 정보
     */
    public GameVO selectGameById(int gameId) {
        return session.selectOne("kr.ac.kopo.dao.GameDAO.selectGameById", gameId);
    }

    /**
     * 게임 삭제
     * @param gameId - 삭제할 게임 ID
     * @return int - 삭제 결과 (성공 여부)
     */
    public int deleteGame(int gameId) {
        int result = session.delete("kr.ac.kopo.dao.GameDAO.deleteGame", gameId);
        session.commit(); // 삭제 후 커밋
        return result;
    }

    /**
     * 게시글 번호를 통해 연결된 게임 타이틀 조회
     * @param boardNo - 게시글 번호
     * @return String - 게임 타이틀 (없다면 null)
     */
    public String getGameTitleByBoardNo(int boardNo) {
        return session.selectOne("kr.ac.kopo.dao.GameDAO.selectGameTitleByBoardNo", boardNo);
    }
}
