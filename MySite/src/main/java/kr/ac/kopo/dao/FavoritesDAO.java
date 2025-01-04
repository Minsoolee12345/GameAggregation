package kr.ac.kopo.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import kr.ac.kopo.vo.FavoritesVO;
import kr.ac.kopo.vo.GameVO;

public class FavoritesDAO
{
    private final SqlSessionFactory sqlSessionFactory;
    
    public FavoritesDAO(SqlSessionFactory sqlSessionFactory) {
        this.sqlSessionFactory = sqlSessionFactory;
    }

    // 즐겨찾기 추가
    public void addFavorite(String userId, int gameId) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            FavoritesVO favorite = new FavoritesVO(userId, gameId);
            session.insert("kr.ac.kopo.dao.FavoritesDAO.addFavorite", favorite);
            session.commit();
        }
    }

    // 즐겨찾기 제거
    public void removeFavorite(String userId, int gameId)
    {
        try (SqlSession session = sqlSessionFactory.openSession()) {
        	System.out.println("즐찾제거^^lqkf");
            FavoritesVO favorite = new FavoritesVO(userId, gameId);
            session.delete("kr.ac.kopo.dao.FavoritesDAO.removeFavorite", favorite);
            session.commit();
        }
    }


    // 특정 유저의 즐겨찾기 목록 조회
    public List<GameVO> getFavoriteGamesByUser(String userId) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
        	System.out.println("%^^lqkf");
            return session.selectList("kr.ac.kopo.dao.FavoritesDAO.getFavoriteGamesByUser", userId);
        }
    }
    
    // 특정 유저-게임 조합이 이미 즐겨찾기에 있는지 확인
    public boolean isFavoriteExists(String userId, int gameId) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            Integer count = session.selectOne("kr.ac.kopo.dao.FavoritesDAO.countFavoriteByUserAndGame", 
                        Map.of("userId", userId, "gameId", gameId));
            return count != null && count > 0;
        }
    }
}
