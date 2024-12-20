package kr.ac.kopo.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.ac.kopo.dao.ReplyDAO;
import kr.ac.kopo.vo.ReplyVO;
import kr.ac.kopo.vo.MemberVO;

import java.util.List;

public class ReplyController implements Controller {
	private ReplyDAO replyDAO;

	public ReplyController() {
		replyDAO = new ReplyDAO();
	}

	// 댓글 추가 처리
	private String addComment(HttpServletRequest request, HttpServletResponse response) throws Exception {
	    String boardNoParam = request.getParameter("boardNo");
	    String content = request.getParameter("content");
	    String parentReplyNoParam = request.getParameter("parentReplyNo"); // 필요 시 부모 댓글 번호

	    if (boardNoParam == null || boardNoParam.isEmpty() || content == null || content.trim().isEmpty()) {
	        request.setAttribute("errorMessage", "필수 입력값이 누락되었습니다.");
	        return "/jsp/error/error.jsp";
	    }

	    int boardNo;
	    try {
	        boardNo = Integer.parseInt(boardNoParam);
	    } catch (NumberFormatException e) {
	        request.setAttribute("errorMessage", "게시글 번호 형식이 잘못되었습니다.");
	        return "/jsp/error/error.jsp";
	    }

	    Integer parentReplyNo = null;
	    if (parentReplyNoParam != null && !parentReplyNoParam.isEmpty()) {
	        try {
	            parentReplyNo = Integer.parseInt(parentReplyNoParam);
	        } catch (NumberFormatException e) {
	            request.setAttribute("errorMessage", "부모 댓글 번호 형식이 잘못되었습니다.");
	            return "/jsp/error/error.jsp";
	        }
	    }

	    // 세션에서 사용자 정보 가져오기
	    MemberVO user = (MemberVO) request.getSession().getAttribute("userVO");
	    if (user == null) {
	        response.sendRedirect(request.getContextPath() + "/jsp/login/login.jsp");
	        return null;
	    }

	    ReplyVO reply = new ReplyVO();
	    reply.setBoardNo(boardNo);
	    reply.setWriter(user.getId());
	    reply.setContent(content);
	    reply.setParentReplyNo(parentReplyNo); // 부모 댓글이 있는 경우 설정

	    replyDAO.insertReply(reply);

	    // 댓글 작성 후 해당 게시글 상세보기 페이지로 리디렉션
	    response.sendRedirect(request.getContextPath() + "/board/detail.do?no=" + boardNo);
	    return null; // 리디렉션 후 반환값 없음
	}

	
	@Override
	public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uri = request.getRequestURI();
		String contextPath = request.getContextPath();
		String action = uri.substring(contextPath.length());

		switch (action) {
		case "/reply/replyList.do":
			return replyList(request, response);
		case "/reply/replyWriteForm.do":
			return replyWriteForm(request, response);
		case "/reply/replyWrite.do":
			return replyWrite(request, response);
		case "/reply/replyUpdateForm.do":
			return replyUpdateForm(request, response);
		case "/reply/replyUpdate.do":
			return replyUpdate(request, response);
		case "/reply/replyDelete.do":
			return replyDelete(request, response);
	    case "/reply/addComment.do": // 새로 추가된 케이스
	        return addComment(request, response);
		default:
			return null;
		}
	}

	// 특정 게시글의 모든 답글 조회
	private String replyList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String boardNoParam = request.getParameter("boardNo");
		if (boardNoParam == null || boardNoParam.isEmpty()) {
			request.setAttribute("errorMessage", "잘못된 요청입니다. 게시글 번호가 없습니다.");
			return "/jsp/error/error.jsp";
		}

		int boardNo;
		try {
			boardNo = Integer.parseInt(boardNoParam);
		} catch (NumberFormatException e) {
			request.setAttribute("errorMessage", "게시글 번호 형식이 잘못되었습니다.");
			return "/jsp/error/error.jsp";
		}

		List<ReplyVO> replyList = replyDAO.selectByBoardNo(boardNo);
		request.setAttribute("replyList", replyList);
		request.setAttribute("boardNo", boardNo);
		return "/jsp/reply/Replylist.jsp";
	}

	// 답글 작성 폼으로 이동
	private String replyWriteForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String boardNoParam = request.getParameter("boardNo");
		if (boardNoParam == null || boardNoParam.isEmpty()) {
			request.setAttribute("errorMessage", "게시글 번호가 필요합니다.");
			return "/jsp/error/error.jsp";
		}

		int boardNo;
		try {
			boardNo = Integer.parseInt(boardNoParam);
		} catch (NumberFormatException e) {
			request.setAttribute("errorMessage", "게시글 번호 형식이 잘못되었습니다.");
			return "/jsp/error/error.jsp";
		}

		String parentReplyNoStr = request.getParameter("parentReplyNo");
		Integer parentReplyNo = null;
		if (parentReplyNoStr != null && !parentReplyNoStr.isEmpty()) {
			try {
				parentReplyNo = Integer.parseInt(parentReplyNoStr);
			} catch (NumberFormatException e) {
				request.setAttribute("errorMessage", "부모 답글 번호 형식이 잘못되었습니다.");
				return "/jsp/error/error.jsp";
			}
		}

		request.setAttribute("boardNo", boardNo);
		request.setAttribute("parentReplyNo", parentReplyNo);
		return "/jsp/reply/writeForm.jsp";
	}

	// 답글 작성 처리
	private String replyWrite(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String boardNoParam = request.getParameter("boardNo");
		String content = request.getParameter("content");

		if (boardNoParam == null || boardNoParam.isEmpty() || content == null || content.trim().isEmpty()) {
			request.setAttribute("errorMessage", "필수 입력값이 누락되었습니다.");
			return "/jsp/error/error.jsp";
		}

		int boardNo;
		try {
			boardNo = Integer.parseInt(boardNoParam);
		} catch (NumberFormatException e) {
			request.setAttribute("errorMessage", "게시글 번호 형식이 잘못되었습니다.");
			return "/jsp/error/error.jsp";
		}

		// 세션에서 사용자 정보 가져오기
		MemberVO user = (MemberVO) request.getSession().getAttribute("userVO");
		if (user == null) {
			response.sendRedirect(request.getContextPath() + "/jsp/login/login.jsp");
			return null;
		}

		ReplyVO reply = new ReplyVO();
		reply.setBoardNo(boardNo);
		reply.setWriter(user.getId());
		reply.setContent(content);

		replyDAO.insertReply(reply);

		// 댓글 작성 후 해당 게시글 상세보기 페이지로 리디렉션
		response.sendRedirect(request.getContextPath() + "/board/detail.do?no=" + boardNo);
		return null; // 리디렉션 후 반환값 없음
	}

	// 답글 수정 폼으로 이동
	private String replyUpdateForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String replyNoParam = request.getParameter("replyNo");
		if (replyNoParam == null || replyNoParam.isEmpty()) {
			request.setAttribute("errorMessage", "답글 번호가 필요합니다.");
			return "/jsp/error/error.jsp";
		}

		int replyNo;
		try {
			replyNo = Integer.parseInt(replyNoParam);
		} catch (NumberFormatException e) {
			request.setAttribute("errorMessage", "답글 번호 형식이 잘못되었습니다.");
			return "/jsp/error/error.jsp";
		}

		ReplyVO reply = replyDAO.selectByReplyNo(replyNo);
		if (reply == null) {
			request.setAttribute("errorMessage", "해당 답글이 존재하지 않습니다.");
			return "/jsp/error/error.jsp";
		}

		// 현재 사용자와 답글 작성자 일치 여부 확인
		MemberVO user = (MemberVO) request.getSession().getAttribute("userVO");
		if (user == null || !user.getId().equals(reply.getWriter())) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN, "수정 권한이 없습니다.");
			return null;
		}

		request.setAttribute("reply", reply);
		return "/jsp/reply/updateForm.jsp";
	}

	// 답글 수정 처리
	private String replyUpdate(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String replyNoParam = request.getParameter("replyNo");
		String boardNoParam = request.getParameter("boardNo");
		String content = request.getParameter("content");
		String parentReplyNoStr = request.getParameter("parentReplyNo");

		if (replyNoParam == null || replyNoParam.isEmpty() || boardNoParam == null || boardNoParam.isEmpty()
				|| content == null || content.trim().isEmpty()) {
			request.setAttribute("errorMessage", "필수 입력값이 누락되었습니다.");
			return "/jsp/error/error.jsp";
		}

		int replyNo, boardNo;
		try {
			replyNo = Integer.parseInt(replyNoParam);
			boardNo = Integer.parseInt(boardNoParam);
		} catch (NumberFormatException e) {
			request.setAttribute("errorMessage", "번호 형식이 잘못되었습니다.");
			return "/jsp/error/error.jsp";
		}

		Integer parentReplyNo = null;
		if (parentReplyNoStr != null && !parentReplyNoStr.isEmpty()) {
			try {
				parentReplyNo = Integer.parseInt(parentReplyNoStr);
			} catch (NumberFormatException e) {
				request.setAttribute("errorMessage", "부모 답글 번호 형식이 잘못되었습니다.");
				return "/jsp/error/error.jsp";
			}
		}

		// 세션에서 로그인한 사용자 정보 가져오기
		MemberVO user = (MemberVO) request.getSession().getAttribute("userVO");
		if (user == null) {
			response.sendRedirect(request.getContextPath() + "/jsp/login/login.jsp");
			return null;
		}

		// 현재 사용자와 답글 작성자 일치 여부 확인
		ReplyVO existingReply = replyDAO.selectByReplyNo(replyNo);
		if (existingReply == null || !user.getId().equals(existingReply.getWriter())) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN, "수정 권한이 없습니다.");
			return null;
		}

		existingReply.setContent(content);
		existingReply.setParentReplyNo(parentReplyNo);

		replyDAO.updateReply(existingReply);

		// 리디렉션을 통해 새로운 요청을 생성
		response.sendRedirect(request.getContextPath() + "/jsp/board/detail.do?no=" + boardNo);
		return null;
	}

	// 답글 삭제 처리
	private String replyDelete(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String replyNoParam = request.getParameter("replyNo");
		String boardNoParam = request.getParameter("boardNo");

		if (replyNoParam == null || replyNoParam.isEmpty() || boardNoParam == null || boardNoParam.isEmpty()) {
			request.setAttribute("errorMessage", "필수 입력값이 누락되었습니다.");
			return "/jsp/error/error.jsp";
		}

		int replyNo, boardNo;
		try {
			replyNo = Integer.parseInt(replyNoParam);
			boardNo = Integer.parseInt(boardNoParam);
		} catch (NumberFormatException e) {
			request.setAttribute("errorMessage", "번호 형식이 잘못되었습니다.");
			return "/jsp/error/error.jsp";
		}

		// 세션에서 로그인한 사용자 정보 가져오기
		MemberVO user = (MemberVO) request.getSession().getAttribute("userVO");
		if (user == null) {
			response.sendRedirect(request.getContextPath() + "/jsp/login/login.jsp");
			return null;
		}

		ReplyVO reply = replyDAO.selectByReplyNo(replyNo);
		if (reply == null || !user.getId().equals(reply.getWriter())) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN, "삭제 권한이 없습니다.");
			return null;
		}

		replyDAO.deleteReply(replyNo);

		// 리디렉션을 통해 새로운 요청을 생성
		response.sendRedirect(request.getContextPath() + "/board/detail.do?no=" + boardNo);
		return null;
	}
}