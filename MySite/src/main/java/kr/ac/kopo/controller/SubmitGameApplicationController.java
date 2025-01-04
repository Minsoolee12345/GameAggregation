package kr.ac.kopo.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.ac.kopo.dao.GameApplicationDAO;
import kr.ac.kopo.vo.GameApplicationVO;
import kr.ac.kopo.vo.MemberVO;

public class SubmitGameApplicationController implements Controller 
{
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception 
    {
        // 사용자 로그인 상태 확인
        HttpSession session = request.getSession();
        MemberVO user = (MemberVO) session.getAttribute("userVO");
        if (user == null)
        {
            // 로그인하지 않은 경우 로그인 페이지로 포워딩
            request.setAttribute("messageType", "error");
            request.setAttribute("message", "로그인이 필요합니다.");
            return "./jsp/login/login.jsp"; // 로그인 JSP 페이지로 포워딩
        }

        // POST 요청 처리
        if ("POST".equalsIgnoreCase(request.getMethod())) 
        {
            request.setCharacterEncoding("UTF-8");

            String gameUrl = request.getParameter("gameUrl");
            String gameTitle = request.getParameter("gameTitle");
            String gameIntro = request.getParameter("gameIntro");

            // 기본 유효성 검사
            if (gameUrl == null || gameUrl.trim().isEmpty() ||
                gameTitle == null || gameTitle.trim().isEmpty() ||
                gameIntro == null || gameIntro.trim().isEmpty()) 
            {
                request.setAttribute("messageType", "error");
                request.setAttribute("message", "모든 필드를 채워주세요.");
                return "/jsp/error/error.jsp"; // 에러 JSP 페이지로 포워딩
            }

            // 게임 신청서 VO 생성
            GameApplicationVO application = new GameApplicationVO();
            application.setGameUrl(gameUrl);
            application.setGameTitle(gameTitle);
            application.setGameIntro(gameIntro);
            // status와 createdDate는 DB 기본값으로 처리됨

            // DB에 신청서 삽입
            GameApplicationDAO dao = new GameApplicationDAO();
            int insertResult = dao.insertGameApplication(application);

            if (insertResult > 0) 
            {
                // 신청 성공 후 확인 페이지로 포워딩
                request.setAttribute("messageType", "success");
                request.setAttribute("message", "게임 신청이 성공적으로 제출되었습니다.");
                return "/jsp/gameRegi/gameApplicationSuccess.jsp"; // 성공 JSP 페이지로 포워딩
            } 
            else 
            {
                // 신청 실패 시 에러 메시지 설정 후 에러 페이지로 포워딩
                request.setAttribute("messageType", "error");
                request.setAttribute("message", "게임 신청 제출에 실패했습니다. 다시 시도해주세요.");
                return "/jsp/error/error.jsp"; // 에러 JSP 페이지로 포워딩
            }
        }

        // GET 요청 시 신청서 제출 폼으로 포워딩
        return "/jsp/gameRegi/submitGameApplication.jsp";
    }
}