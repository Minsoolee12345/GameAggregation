package kr.ac.kopo.controller;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.ac.kopo.dao.GameDAO;
import kr.ac.kopo.vo.GameVO;

public class IndexController implements Controller 
{
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception 
    {
        // GameDAO 인스턴스를 생성하여 게임 목록을 조회
        System.out.println("call?");
        
        GameDAO gameDAO = new GameDAO();
        List<GameVO> gameList = gameDAO.selectAllGames();

        // 조회한 게임 목록을 요청 객체에 추가하여 JSP에서 사용할 수 있도록 설정
        System.out.println("조회된 게임 수: " + gameList.size());
        request.setAttribute("gameList", gameList);
        return "/index.jsp"; // 포워딩할 JSP 경로

    }
}