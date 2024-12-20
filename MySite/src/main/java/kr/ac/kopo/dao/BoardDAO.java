package kr.ac.kopo.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.ac.kopo.vo.BoardVO;

public class BoardDAO 
{
    private SqlSession session;

    public BoardDAO() 
    {
        MyConfig config = new MyConfig();
        session = config.getInstance();
    }

    /**
     * 게시판 목록 조회
     * @return List<BoardVO> - 모든 게시글 리스트
     */
    public List<BoardVO> selectAll() 
    {
        return session.selectList("kr.ac.kopo.dao.BoardDAO.selectAll");
    }

    /**
     * 게시글 번호로 조회
     * @param no - 게시글 번호
     * @return BoardVO - 게시글 정보
     */
    public BoardVO selectBoardByNo(int no) 
    {
        return session.selectOne("kr.ac.kopo.dao.BoardDAO.selectBoardByNo", no);
    }

    /**
     * 게시글 삽입
     * @param boardVO - 삽입할 게시글 정보
     * @return int - 삽입 결과 (성공 여부)
     */
    public int insertBoard(BoardVO boardVO) 
    {
        int result = session.insert("kr.ac.kopo.dao.BoardDAO.insertBoard", boardVO);
        session.commit(); // 삽입 후 커밋
        return result;
    }

    /**
     * 게시글 수정
     * @param boardVO - 수정할 게시글 정보
     * @return int - 수정 결과 (성공 여부)
     */
    public int updateBoard(BoardVO boardVO) 
    {
        int result = session.update("kr.ac.kopo.dao.BoardDAO.updateBoard", boardVO);
        session.commit(); // 수정 후 커밋
        return result;
    }

    /**
     * 게시글 삭제
     * @param no - 삭제할 게시글 번호
     * @return int - 삭제 결과 (성공 여부)
     */
    public int deleteBoard(int no) 
    {
        int result = session.delete("kr.ac.kopo.dao.BoardDAO.deleteBoard", no);
        session.commit(); // 삭제 후 커밋
        return result;
    }
    
    /**
     * 페이징된 게시판 목록 조회
     * @param page - 현재 페이지 번호
     * @param pageSize - 한 페이지당 게시글 수
     * @return List<BoardVO> - 페이징된 게시글 리스트
     */
    public List<BoardVO> getPagedBoardList(int page, int pageSize) 
    {
        int startRow = (page - 1) * pageSize + 1; // 시작 행 번호 계산
        int endRow = page * pageSize; // 끝 행 번호 계산

        Map<String, Integer> params = new HashMap<>();
        params.put("startRow", startRow);
        params.put("endRow", endRow);

        return session.selectList("kr.ac.kopo.dao.BoardDAO.getPagedBoardList", params);
    }

    /**
     * 전체 게시글 개수 조회
     * @return int - 게시글 총 개수
     */
    public int getTotalBoardCount() 
    {
    	 return session.selectOne("kr.ac.kopo.dao.BoardDAO.getTotalBoardCount");
    }
    
    /**
     * 조회수 증가
     * @param no - 게시글 번호
     */
    public void incrementViewCount(int no) 
    {
        session.update("kr.ac.kopo.dao.BoardDAO.incrementViewCount", no);
        session.commit(); // 업데이트 후 커밋
    }
}