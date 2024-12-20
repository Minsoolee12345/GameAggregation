package kr.ac.kopo.controller;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.ac.kopo.dao.BoardDAO;
import kr.ac.kopo.dao.GameDAO;
import kr.ac.kopo.dao.ReplyDAO;
import kr.ac.kopo.vo.BoardVO;
import kr.ac.kopo.vo.MemberVO;
import kr.ac.kopo.vo.ReplyVO;

public class BoardDetailController implements Controller {
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String noParam = request.getParameter("no");
        if (noParam == null || noParam.isEmpty()) {
            request.setAttribute("errorMessage", "잘못된 요청입니다. 게시글 번호가 없습니다.");
            return "/jsp/error/error.jsp";
        }

        int no;
        try {
            no = Integer.parseInt(noParam);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "게시글 번호 형식이 잘못되었습니다.");
            return "/jsp/error/error.jsp";
        }

        BoardDAO boardDAO = new BoardDAO();
        // 조회수 증가
        boardDAO.incrementViewCount(no);

        // 게시글 정보 가져오기
        BoardVO board = boardDAO.selectBoardByNo(no);
        if (board == null) {
            request.setAttribute("errorMessage", "해당 게시글이 존재하지 않습니다.");
            return "/jsp/error/error.jsp";
        }

        // gameId가 존재하는 경우 게임 타이틀 조회
        if (board.getGameId() != null) {
            GameDAO gameDAO = new GameDAO();
            String gameTitle = gameDAO.getGameTitleByBoardNo(no);
            board.setGameTitle(gameTitle);
        }

        // 댓글 조회
        ReplyDAO replyDAO = new ReplyDAO();
        List<ReplyVO> commentList = replyDAO.selectByBoardNo(no);
        request.setAttribute("commentList", commentList);

        // 게시글 정보를 request에 저장
        request.setAttribute("board", board);

        HttpSession session = request.getSession();
        MemberVO user = (MemberVO) session.getAttribute("userVO");
        if (user != null) {
            request.setAttribute("currentUser", user);
        }

        return "/jsp/board/detail.jsp";
    }
}
