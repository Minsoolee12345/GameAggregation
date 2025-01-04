package kr.ac.kopo.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.ac.kopo.dao.GameApplicationDAO;

public class RejectGameApplicationController implements Controller {
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // POST 요청인지 확인
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "허용되지 않은 요청 방식입니다.");
            return null;
        }

        String applicationIdParam = request.getParameter("applicationId");
        int applicationId = 0;
        try {
            applicationId = Integer.parseInt(applicationIdParam);
        } catch (NumberFormatException e) {
            // 유효하지 않은 applicationId
            request.setAttribute("messageType", "error");
            request.setAttribute("message", "잘못된 신청서 ID입니다.");
            return "/jsp/gameRegi/gameApplicationManagement.jsp";
        }

        // 신청서 거절 처리
        GameApplicationDAO dao = new GameApplicationDAO();
        int result = dao.rejectGameApplication(applicationId);

        // 거절 결과에 따라 메시지 설정
        if (result > 0) {
            // 거절 성공
            request.setAttribute("messageType", "success");
            request.setAttribute("message", "게임 신청이 거절되었습니다.");
        } else {
            // 거절 실패
            request.setAttribute("messageType", "error");
            request.setAttribute("message", "게임 신청 거절에 실패했습니다.");
        }

        // 관리자 게임 신청 관리 페이지로 포워딩
        return "/jsp/gameRegi/gameApplicationManagement.jsp";
    }
}