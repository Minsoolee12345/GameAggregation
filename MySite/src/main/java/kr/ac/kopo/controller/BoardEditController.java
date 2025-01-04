package kr.ac.kopo.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.ac.kopo.dao.BoardDAO;
import kr.ac.kopo.vo.BoardVO;
import kr.ac.kopo.vo.MemberVO;

public class BoardEditController implements Controller
{
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception
    {
        String noParam = request.getParameter("no");
        if (noParam == null || noParam.isEmpty()) 
        {
            request.setAttribute("errorMessage", "수정할 게시글 번호가 없습니다.");
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

        // 게시글 정보를 request에 저장하여 수정 페이지로 전달
        request.setAttribute("board", board);

        return "/jsp/board/edit.jsp"; // 수정 페이지로 포워딩
    }
}