package kr.ac.kopo.controller;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.ac.kopo.dao.GameApplicationDAO;
import kr.ac.kopo.vo.GameApplicationVO;
import kr.ac.kopo.vo.MemberVO;

public class GameApplicationManagementController implements Controller {
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 관리자 로그인 상태 확인
        HttpSession session = request.getSession(false);
        MemberVO user = (MemberVO) session.getAttribute("userVO");

        // 관리자 자격 검증: ID가 "admin"인지 확인
        if (user == null || !"admin".equals(user.getId())) {
            // 관리자 권한이 없는 경우 접근 금지
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "접근 권한이 없습니다.");
            return null;
        }

        // 게임 신청서 조회
        GameApplicationDAO dao = new GameApplicationDAO();
        List<GameApplicationVO> pendingApplications = dao.getPendingApplications();

        // JSP에 데이터 전달
        request.setAttribute("pendingApplications", pendingApplications);

        return "/jsp/gameRegi/gameApplicationManagement.jsp";
    }
}