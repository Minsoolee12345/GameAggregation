package kr.ac.kopo.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.ac.kopo.vo.MemberVO;

public class MemberDAO 
{
    private SqlSession session;

    public MemberDAO() 
    {
        MyConfig config = new MyConfig();
        session = config.getInstance();
    }

    /**
     * 사용자 인증을 위한 메서드
     * @param id - 입력된 사용자 ID
     * @param password - 입력된 비밀번호
     * @return MemberVO - 인증된 사용자 정보 (없으면 null)
     */
    public MemberVO login(String id, String password) 
    {
        Map<String, String> params = new HashMap<>();
        params.put("id", id);
        params.put("password", password);
        return session.selectOne("kr.ac.kopo.dao.MemberDAO.login", params);
    }
    

    /**
     * 회원 정보를 데이터베이스에 저장하는 메서드
     * @param member - 저장할 회원 정보
     */
    public void insertMember(MemberVO member) 
    {
        session.insert("kr.ac.kopo.dao.MemberDAO.insertMember", member);
        session.commit(); // 변경사항 반영
    }
    
    /**
     * 회원 정보를 업데이트하는 메서드
     * @param member - 업데이트할 회원 정보
     */
    public void updateMember(MemberVO member)
    {
        session.update("kr.ac.kopo.dao.MemberDAO.updateMember", member);
        session.commit(); // 변경사항 반영
    }

    /**
     * 회원 탈퇴를 처리하는 메서드
     * @param id - 탈퇴할 회원의 ID
     */
    public void deleteMember(String id) 
    {
    	session.clearCache();
        session.delete("kr.ac.kopo.dao.MemberDAO.deleteMember", id);
        session.commit(); // 변경사항 반영
    }
    
    
    /**
     * 모든 회원 목록을 조회하는 메서드
     * @return List<MemberVO> - 모든 회원의 정보 리스트
     */
    public List<MemberVO> selectAllMembers() 
    {
        return session.selectList("kr.ac.kopo.dao.MemberDAO.selectAllMembers");
    }
    
    
    
    /**
     * 아이디 중복 체크를 위한 메서드
     * @param id - 중복 체크할 아이디
     * @return boolean - true: 사용 가능, false: 중복
     */
    public boolean isIdUsable(String id) 
    {
        int count = session.selectOne("kr.ac.kopo.dao.MemberDAO.countById", id);
        return count == 0; // 중복이 없으면 true 반환
    }
    
    
    /**
     * 아이디로 회원 정보 조회
     * @param id - 조회할 회원의 ID
     * @return MemberVO - 회원 정보
     */
    public MemberVO findById(String id) 
    {
        return session.selectOne("kr.ac.kopo.dao.MemberDAO.findById", id);
    }
}