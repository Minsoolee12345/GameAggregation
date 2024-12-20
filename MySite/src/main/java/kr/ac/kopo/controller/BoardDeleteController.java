package kr.ac.kopo.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.ac.kopo.dao.BoardDAO;
import kr.ac.kopo.vo.BoardVO;
import kr.ac.kopo.vo.MemberVO;

public class BoardDeleteController implements Controller
{
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception 
    {
        String noParam = request.getParameter("no");
        if (noParam == null || noParam.isEmpty()) 
        {
            request.setAttribute("errorMessage", "삭제할 게시글 번호가 없습니다.");
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

        // 현재 사용자가 작성자인지 확인 또는 관리자 권한 확인
        if (!user.getId().equals(board.getWriter()) && !(user.getId().equals("admin") && user.getPassword().equals("12345")))
        {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "삭제 권한이 없습니다.");
            return null;
        }

        // 게시글 삭제
        boardDAO.deleteBoard(no);

        // 삭제 후 목록 페이지로 리디렉션
        response.sendRedirect("/MySite/board/list.do");
        return null;
    }
}