package kr.ac.kopo.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.ac.kopo.dao.MemberDAO;
import kr.ac.kopo.vo.MemberVO;

public class LoginController implements Controller 
{
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception
    {
        if(request.getMethod().equalsIgnoreCase("GET")) 
        {
            // GET 요청 시 로그인 폼 페이지로 이동
            return "/MySite/jsp/login/login.jsp";
        } 
        else if (request.getMethod().equalsIgnoreCase("POST"))
        {
            // POST 요청 시 로그인 처리
            String id = request.getParameter("id");
            String password = request.getParameter("password");

            // 입력값 검증
            if(id == null || id.trim().isEmpty()) {
                request.setAttribute("errorMessage", "ID를 입력하세요.");
                return "/jsp/login/login.jsp";
            }

            if(password == null || password.trim().isEmpty()) {
                request.setAttribute("errorMessage", "PASSWORD를 입력하세요.");
                return "/jsp/login/login.jsp";
            }

            // admin 계정인지 확인
            if("admin".equals(id) && "12345".equals(password)) {
                // admin 로그인 성공 처리
                HttpSession session = request.getSession();
                MemberVO adminMember = new MemberVO();
                adminMember.setId(id);
                adminMember.setName("Administrator"); // 필요에 따라 추가 속성 설정
                adminMember.setType("admin"); // 사용자 유형 설정
                session.setAttribute("userVO", adminMember);

                // 디버그 출력: 현재 로그인한 사용자 ID
                System.out.println("로그인 성공 - 현재 로그인 중인 사용자 ID: " + adminMember.getId());

                // admin.jsp로 리다이렉트
                response.sendRedirect("/MySite/admin.do");
                return null; // 뷰 이름을 null로 반환하여 리다이렉트 처리
            }

            // 일반 사용자 로그인 처리
            MemberDAO dao = new MemberDAO();
            MemberVO member = dao.login(id, password);
            if(member != null)
            {
                // 로그인 성공
                // OAuth 사용자인지 확인
                if("oauth".equals(member.getType())) {
                    // 일반 로그인으로 OAuth 사용자는 접근 불가
                    System.out.println("로그인 실패 - OAuth 사용자는 일반 로그인으로 접근할 수 없습니다. 입력된 ID: " + id);
                    request.setAttribute("errorMessage", "OAuth 사용자는 일반 로그인으로 접근할 수 없습니다.");
                    return "/jsp/login/login.jsp";
                }

                // 일반 사용자
                HttpSession session = request.getSession();
                session.setAttribute("userVO", member);

                // 디버그 출력: 현재 로그인한 사용자 ID
                System.out.println("로그인 성공 - 현재 로그인 중인 사용자 ID: " + member.getId());

                // 메인 페이지로 리다이렉트
                response.sendRedirect(request.getContextPath() + "/index.do");
                return null; // 뷰 이름을 null로 반환
            }

            else
            {
                // 로그인 실패
                System.out.println("로그인 실패 - 아이디 또는 비밀번호가 올바르지 않습니다. 입력된 ID: " + id);
                request.setAttribute("errorMessage", "아이디 또는 비밀번호가 올바르지 않습니다.");
                return "/jsp/login/login.jsp";
            }
        }
        // 기타 경우 로그인 실패 처리
        System.out.println("로그인 실패 - 요청 방식이 잘못되었습니다.");
        request.setAttribute("errorMessage", "아이디 또는 비밀번호가 올바르지 않습니다.");
        return "/jsp/login/login.jsp";
    }
}