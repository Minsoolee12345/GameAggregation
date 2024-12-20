package kr.ac.kopo.controller;

import java.io.InputStream;
import java.util.List;

import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.ac.kopo.dao.FavoritesDAO;
import kr.ac.kopo.vo.GameVO;
import kr.ac.kopo.vo.MemberVO;

public class FavoritesController implements Controller
{

    private static final String CONFIG_PATH = "mybatis-config.xml";
    private SqlSessionFactory sqlSessionFactory;

    public FavoritesController() 
    {
        try (InputStream inputStream = Thread.currentThread().getContextClassLoader().getResourceAsStream(CONFIG_PATH))
        {
            this.sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("MyBatis 설정 파일 로드 실패", e);
        }
    }

    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
        MemberVO userVO = (MemberVO) request.getSession().getAttribute("userVO");
        
        System.out.println("^^qkf?");
        if (userVO == null)
        {
            return "/jsp/login/login.jsp";
        }

        String action = request.getParameter("action");
        String gameIdStr = request.getParameter("gameId");

        // JSON 응답 시 Content-Type 지정
        response.setContentType("application/json");
        
        FavoritesDAO favoritesDAO = new FavoritesDAO(sqlSessionFactory);

        if (action != null && (action.equals("add") || action.equals("remove"))) 
        {
            if (gameIdStr == null || gameIdStr.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"message\":\"게임 ID가 제공되지 않았습니다.\"}");
                return null;
            }

            int gameId;
            try {
                gameId = Integer.parseInt(gameIdStr);
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"message\":\"게임 ID 형식이 잘못되었습니다.\"}");
                return null;
            }

            try {
                if ("add".equals(action))
                {
                    // INSERT 전 중복 체크
                    if (favoritesDAO.isFavoriteExists(userVO.getId(), gameId)) 
                    {
                        response.getWriter().write("{\"message\":\"이미 즐겨찾기에 등록된 게임입니다.\"}");
                    } 
                    else
                    {
                        favoritesDAO.addFavorite(userVO.getId(), gameId);
                        response.getWriter().write("{\"message\":\"즐겨찾기에 추가되었습니다.\"}");
                    }
                    return null;
                } 
                else if ("remove".equals(action))
                {
                	System.out.println("^^qkf?????");
                    favoritesDAO.removeFavorite(userVO.getId(), gameId);
                    response.getWriter().write("{\"message\":\"즐겨찾기에서 제거되었습니다.\"}");
                    return null;
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().write("{\"message\":\"처리 중 오류가 발생했습니다.\"}");
                return null;
            }

        } 
        

        // action이 없을 경우, 해당 유저의 즐겨찾기 목록 페이지로 이동
        List<GameVO> favoritesList = favoritesDAO.getFavoriteGamesByUser(userVO.getId());
        request.setAttribute("favoritesList", favoritesList);

        // JSON 설정을 기본화면으로 돌아갈 때 해제
        response.setContentType("text/html; charset=UTF-8");
        return "/jsp/option/myFavorites.jsp";
    }
}