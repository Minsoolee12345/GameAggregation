package kr.ac.kopo.controller;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.ac.kopo.dao.BoardDAO;
import kr.ac.kopo.dao.ReplyDAO;
import kr.ac.kopo.vo.BoardVO;
import kr.ac.kopo.vo.MemberVO;
import kr.ac.kopo.vo.ReplyVO;

public class BoardListController implements Controller {
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 로그인된 사용자 정보 가져오기
        HttpSession session = request.getSession();
        MemberVO user = (MemberVO) session.getAttribute("userVO");

        if (user == null) {
            // 로그인되지 않았을 경우
            request.setAttribute("loginRequired", true);
            return "/jsp/board/list.jsp"; // JSP에서 로그인 경고 처리
        }

        // 페이징 처리
        int pageSize = 5; // 한 페이지에 표시할 게시글 수
        int page = 1; // 기본 페이지 번호
        String pageParam = request.getParameter("page");

        if (pageParam != null && !pageParam.isEmpty()) {
            page = Integer.parseInt(pageParam);
        }

        // DAO 호출
        BoardDAO dao = new BoardDAO();
        List<BoardVO> boardList = dao.getPagedBoardList(page, pageSize); // 페이징된 게시글 가져오기
        int totalBoardCount = dao.getTotalBoardCount(); // 전체 게시글 수
        int totalPages = (int) Math.ceil((double) totalBoardCount / pageSize); // 총 페이지 수 계산

        // 댓글 트리 데이터 추가
        ReplyDAO replyDAO = new ReplyDAO();

        for (BoardVO board : boardList) {
            List<ReplyVO> commentList = replyDAO.selectRepliesTreeByBoardNo(board.getNo()); // 게시글에 해당하는 댓글 트리
            board.setComments(commentList); // BoardVO에 댓글 트리 저장
        }

        // JSP로 데이터 전달
        request.setAttribute("boardList", boardList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        return "/jsp/board/list.jsp"; // 게시글 목록 JSP로 포워딩
    }
}