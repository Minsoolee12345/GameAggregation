package kr.ac.kopo.controller;

import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.ac.kopo.dao.MemberDAO;
import kr.ac.kopo.vo.MemberVO;

public class KakaoCallbackController implements Controller {

    // 카카오 REST API 키 (재발급 받은 키로 교체하세요)
    private static final String CLIENT_ID = "30ad46852bb269b6bc0ebf51f5df3ad8"; // 보안상 안전하게 관리하세요
    private static final String REDIRECT_URI = "http://localhost:8080/MySite/login/oauth2/code/kakao.do"; // 카카오 개발자 콘솔에 등록한 Redirect URI

    private MemberDAO memberDAO;

    public KakaoCallbackController() {
        memberDAO = new MemberDAO(); // DAO 초기화 방법에 따라 조정
    }

    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // CSRF 방지를 위한 state 검증
        HttpSession httpSession = request.getSession();
        String sessionState = (String) httpSession.getAttribute("oauth2_state");
        String requestState = request.getParameter("state");

        if (sessionState == null || !sessionState.equals(requestState)) {
            response.sendRedirect("/MySite/jsp/login.jsp?error=State 검증 실패");
            return null;
        }

        // state 제거
        httpSession.removeAttribute("oauth2_state");

        // 카카오로부터 받은 인증 코드
        String code = request.getParameter("code");
        if (code == null || code.isEmpty()) {
            response.sendRedirect("/MySite/jsp/login.jsp?error=인증코드가 없습니다.");
            return null;
        }

        // Step 1: 액세스 토큰 요청
        String tokenUrl = "https://kauth.kakao.com/oauth/token";
        URL url = new URL(tokenUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);

        String params = "grant_type=authorization_code"
                + "&client_id=" + CLIENT_ID
                + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, "UTF-8")
                + "&code=" + code;
        // client_secret이 필요한 경우 추가
        // + "&client_secret=" + URLEncoder.encode(CLIENT_SECRET, "UTF-8")

        conn.getOutputStream().write(params.getBytes());
        conn.getOutputStream().flush();
        conn.getOutputStream().close();

        int responseCodeToken = conn.getResponseCode();
        java.io.BufferedReader brToken;
        if (responseCodeToken == 200) { // 정상
            brToken = new java.io.BufferedReader(new java.io.InputStreamReader(conn.getInputStream()));
        } else { // 에러
            brToken = new java.io.BufferedReader(new java.io.InputStreamReader(conn.getErrorStream()));
        }

        StringBuilder responseStrToken = new StringBuilder();
        String lineToken;
        while ((lineToken = brToken.readLine()) != null) {
            responseStrToken.append(lineToken);
        }
        brToken.close();

        if (responseCodeToken != 200) {
            response.sendRedirect("/MySite/jsp/login.jsp?error=토큰 요청 실패");
            return null;
        }

        // Step 2: access_token 추출 (간단한 문자열 조작)
        String accessToken = extractValue(responseStrToken.toString(), "access_token");
        if (accessToken == null) {
            response.sendRedirect("/MySite/jsp/login.jsp?error=access_token 추출 실패");
            return null;
        }

        // Step 3: 사용자 정보 요청
        String userInfoUrl = "https://kapi.kakao.com/v2/user/me";
        URL userUrl = new URL(userInfoUrl);
        HttpURLConnection userConn = (HttpURLConnection) userUrl.openConnection();
        userConn.setRequestMethod("GET");
        userConn.setRequestProperty("Authorization", "Bearer " + accessToken);

        int userResponseCode = userConn.getResponseCode();
        java.io.BufferedReader brUser;
        if (userResponseCode == 200) { // 정상
            brUser = new java.io.BufferedReader(new java.io.InputStreamReader(userConn.getInputStream()));
        } else { // 에러
            brUser = new java.io.BufferedReader(new java.io.InputStreamReader(userConn.getErrorStream()));
        }

        StringBuilder responseStrUser = new StringBuilder();
        String lineUser;
        while ((lineUser = brUser.readLine()) != null) {
            responseStrUser.append(lineUser);
        }
        brUser.close();

        if (userResponseCode != 200) {
            response.sendRedirect("/MySite/jsp/login.jsp?error=사용자 정보 요청 실패");
            return null;
        }

        // Step 4: 사용자 정보 추출 (간단한 문자열 조작)
        String userInfo = responseStrUser.toString();
        long kakaoId = extractLongValue(userInfo, "id");
        String nickname = extractValue(userInfo, "nickname");
        String email = extractValue(userInfo, "email");

        // 사용자 정보 확인
        System.out.println("Extracted kakaoId: " + kakaoId);
        System.out.println("Extracted nickname: " + nickname);
        System.out.println("Extracted email: " + email);

        // 사용자 정보 추출 확인
        if (kakaoId == -1) {
            response.sendRedirect("/MySite/jsp/login.jsp?error=kakaoId 추출 실패");
            return null;
        }
        if (nickname == null) {
            nickname = "카카오 사용자";
        }
        if (email == null || email.trim().isEmpty()) {
            email = "noemail@noemail.com"; // 기본 이메일 설정
        }

        // 회원 정보 조회
        String memberId = "kakao_" + kakaoId;
        MemberVO member = memberDAO.findById(memberId);
        if (member == null) {
            // 새 사용자 등록
            member = new MemberVO();
            member.setId(memberId);
            member.setName(nickname);
            member.setPassword("oauth_dummy_password"); // 더미 비밀번호 설정
            member.setType("oauth"); // 사용자 유형 설정
            member.setRegDate(java.time.LocalDateTime.now().toString()); // regDate를 String으로 설정 (예시)

            if (email.contains("@")) {
                String[] emailParts = email.split("@");
                member.setEmailId(emailParts[0]);
                member.setEmailDomain(emailParts[1]);
            } else {
                // 이메일이 없거나 형식이 올바르지 않을 경우 기본값 설정
                member.setEmailId("noemail");
                member.setEmailDomain("noemail.com");
            }

            // 새 사용자 등록 전에 로그 출력
            System.out.println("Inserting new member:");
            System.out.println("ID: " + member.getId());
            System.out.println("Name: " + member.getName());
            System.out.println("Password: " + member.getPassword());
            System.out.println("Email ID: " + member.getEmailId());
            System.out.println("Email Domain: " + member.getEmailDomain());
            System.out.println("Type: " + member.getType());
            System.out.println("RegDate: " + member.getRegDate());

            memberDAO.insertMember(member);
        }

        // 세션에 사용자 정보 설정
        httpSession.setAttribute("userVO", member);

        // 메인 페이지로 리다이렉트
        response.sendRedirect("/MySite/index.do");

        return null; // 리다이렉트 완료 후 JSP 포워딩 없음
    }

    /**
     * 간단하게 JSON 문자열에서 key의 값을 추출하는 메서드.
     * 이 메서드는 매우 단순한 방식이며, 실제 JSON 구조에 맞게 수정이 필요할 수 있습니다.
     *
     * @param json JSON 문자열
     * @param key  추출할 키
     * @return 키에 해당하는 값, 없을 경우 null
     */
    private String extractValue(String json, String key) {
        String searchKey = "\"" + key + "\":";
        int index = json.indexOf(searchKey);
        if (index == -1) {
            return null;
        }
        index += searchKey.length();

        // 공백 건너뛰기
        while (index < json.length() && (json.charAt(index) == ' ' || json.charAt(index) == '\"')) {
            if (json.charAt(index) == '\"') {
                index++;
                break;
            }
            index++;
        }

        // 값 추출
        StringBuilder value = new StringBuilder();
        while (index < json.length() && json.charAt(index) != '\"' && json.charAt(index) != ',' && json.charAt(index) != '}') {
            value.append(json.charAt(index));
            index++;
        }

        return value.toString();
    }

    /**
     * JSON 문자열에서 key의 long 값을 추출하는 메서드.
     *
     * @param json JSON 문자열
     * @param key  추출할 키
     * @return 키에 해당하는 long 값, 없을 경우 -1
     */
    private long extractLongValue(String json, String key) {
        String searchKey = "\"" + key + "\":";
        int index = json.indexOf(searchKey);
        if (index == -1) {
            return -1;
        }
        index += searchKey.length();

        // 공백 건너뛰기
        while (index < json.length() && (json.charAt(index) == ' ')) {
            index++;
        }

        // 숫자 추출
        StringBuilder value = new StringBuilder();
        while (index < json.length() && Character.isDigit(json.charAt(index))) {
            value.append(json.charAt(index));
            index++;
        }

        try {
            return Long.parseLong(value.toString());
        } catch (NumberFormatException e) {
            return -1;
        }
    }
}