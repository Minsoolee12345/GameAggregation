package kr.ac.kopo.controller;

import java.math.BigInteger;
import java.net.URLEncoder;
import java.security.SecureRandom;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class KakaoLoginController implements Controller 
{
    // 카카오 REST API 키 (재발급 받은 키로 교체하세요)
    private static final String CLIENT_ID = "30ad46852bb269b6bc0ebf51f5df3ad8"; // 보안상 안전하게 관리하세요
    private static final String REDIRECT_URI = "http://localhost:8080/MySite/login/oauth2/code/kakao.do"; // 카카오 개발자 콘솔에 등록한 Redirect URI

    private SecureRandom secureRandom = new SecureRandom();

    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception 
    {
        // state 생성
        String state = new BigInteger(130, secureRandom).toString(32);
        HttpSession session = request.getSession();
        session.setAttribute("oauth2_state", state);

        String kakaoAuthUrl = "https://kauth.kakao.com/oauth/authorize?"
                + "client_id=" + CLIENT_ID
                + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, "UTF-8")
                + "&response_type=code"
                + "&scope=account_email,profile_nickname"
                + "&state=" + state; // state 파라미터 추가

        response.sendRedirect(kakaoAuthUrl);
        return null; // 리다이렉트 완료 후 JSP 포워딩 없음
    }
}