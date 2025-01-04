package kr.ac.kopo.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.util.List;

import kr.ac.kopo.dao.BoardDAO;
import kr.ac.kopo.dao.GameDAO;
import kr.ac.kopo.vo.BoardVO;
import kr.ac.kopo.vo.GameVO;
import kr.ac.kopo.vo.MemberVO;

public class BoardWriteController implements Controller {
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        if (request.getMethod().equalsIgnoreCase("GET")) {
            // GET 요청 시 작성 폼 페이지로 이동하기 전에 게임 목록 가져오기
            GameDAO gameDAO = new GameDAO();
            List<GameVO> gameList = gameDAO.selectAllGames();
            request.setAttribute("gameList", gameList);

            return "/jsp/board/write.jsp";
        } else if (request.getMethod().equalsIgnoreCase("POST")) {
            // POST 요청 시 폼 데이터 처리 및 게시글 등록

            // 파라미터 인코딩 설정 (필요하다면)
            request.setCharacterEncoding("UTF-8");

            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String gameIdParam = request.getParameter("gameId");

            // 세션에서 로그인한 사용자 정보 가져오기
            HttpSession session = request.getSession();
            MemberVO user = (MemberVO) session.getAttribute("userVO");
            if (user == null) {
                // 로그인하지 않은 경우 로그인 페이지로 리다이렉트
                response.sendRedirect(request.getContextPath() + "/login.do");
                return null;
            }

            String writer = user.getId();

            // BoardVO 객체 생성 및 폼 데이터 설정
            BoardVO board = new BoardVO();
            board.setTitle(title);
            board.setWriter(writer);
            board.setContent(content);
            board.setViewCnt(0); // 기본값

            // gameId 설정
            if (gameIdParam != null && !gameIdParam.isEmpty()) {
                try {
                    int gameId = Integer.parseInt(gameIdParam);
                    board.setGameId(gameId);
                } catch (NumberFormatException e) {
                    // gameId가 정수가 아닌 경우 처리
                    board.setGameId(null); // game_id를 설정하지 않음
                }
            }

            // 게시글 등록
            BoardDAO dao = new BoardDAO();
            dao.insertBoard(board);

            // 게시글 등록 후 목록 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/board/list.do");
            return null;
        }

        return null;
    }
}