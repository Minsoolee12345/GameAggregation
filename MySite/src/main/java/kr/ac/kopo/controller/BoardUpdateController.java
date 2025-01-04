package kr.ac.kopo.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.ac.kopo.dao.BoardDAO;
import kr.ac.kopo.vo.BoardVO;
import kr.ac.kopo.vo.MemberVO;

public class BoardUpdateController implements Controller 
{
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception 
    {
        // 게시글 번호, 제목, 내용 파라미터 가져오기
        String noParam = request.getParameter("no");
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        if (noParam == null || noParam.isEmpty() || title == null || title.isEmpty() || content == null || content.isEmpty()) 
        {
            request.setAttribute("errorMessage", "필수 입력값이 누락되었습니다.");
            return "/jsp/error/error.jsp";
        }

        int no;
        try {
            no = Integer.parseInt(noParam);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "게시글 번호 형식이 잘못되었습니다.");
            return "/jsp/error/error.jsp";
        }

        // 세션에서 사용자 정보 가져오기
        MemberVO user = (MemberVO) request.getSession().getAttribute("userVO");
        if (user == null)
        {
            response.sendRedirect("/MySite/login.do");
            return null;
        }

        BoardDAO boardDAO = new BoardDAO();
        BoardVO board = boardDAO.selectBoardByNo(no);

        if (board == null) 
        {
            request.setAttribute("errorMessage", "해당 게시글이 존재하지 않습니다.");
            return "/jsp/error/error.jsp";
        }

        // 현재 사용자가 작성자인지 확인
        if (!user.getId().equals(board.getWriter())) 
        {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "수정 권한이 없습니다.");
            return null;
        }

        // 게시글 정보 업데이트
        board.setTitle(title);
        board.setContent(content);
        boardDAO.updateBoard(board);

        // 수정 후 상세보기 페이지로 리디렉션
        response.sendRedirect("/MySite/board/detail.do?no=" + no);
        return null;
    }
}