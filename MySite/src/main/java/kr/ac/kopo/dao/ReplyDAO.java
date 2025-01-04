package kr.ac.kopo.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.ac.kopo.vo.ReplyVO;

public class ReplyDAO {
	private SqlSession session;

	public ReplyDAO() {
		MyConfig config = new MyConfig();
		session = config.getInstance();
	}

	/**
	 * 특정 게시글의 모든 댓글을 조회
	 * 
	 * @param boardNo 게시글 번호
	 * @return 댓글 리스트
	 */
	public List<ReplyVO> selectByBoardNo(int boardNo) {
		return session.selectList("kr.ac.kopo.dao.ReplyDAO.selectRepliesByBoardNo", boardNo);
	}

	/**
	 * 특정 댓글 번호로 댓글을 조회
	 * 
	 * @param replyNo 댓글 번호
	 * @return 해당 댓글
	 */
	public ReplyVO selectByReplyNo(int replyNo) {
		return session.selectOne("kr.ac.kopo.dao.ReplyDAO.selectReplyByNo", replyNo);
	}

	/**
	 * 새로운 댓글을 삽입
	 * 
	 * @param reply 삽입할 댓글 정보
	 */
	public void insertReply(ReplyVO reply) {
		try {
			session.insert("kr.ac.kopo.dao.ReplyDAO.insertReply", reply);
			session.commit();
		} catch (Exception e) {
			session.rollback();
			throw e;
		}
	}

	/**
	 * 기존 댓글을 업데이트
	 * 
	 * @param reply 업데이트할 댓글 정보
	 */
	public void updateReply(ReplyVO reply) {
		try {
			session.update("kr.ac.kopo.dao.ReplyDAO.updateReply", reply);
			session.commit();
		} catch (Exception e) {
			session.rollback();
			throw e;
		}
	}

	/**
	 * 특정 댓글을 삭제
	 * 
	 * @param replyNo 삭제할 댓글 번호
	 */
	public void deleteReply(int replyNo) {
		try {
			session.delete("kr.ac.kopo.dao.ReplyDAO.deleteReply", replyNo);
			session.commit();
		} catch (Exception e) {
			session.rollback();
			throw e;
		}
	}

	/**
	 * 특정 게시글의 댓글 트리 구조 반환
	 */
	public List<ReplyVO> selectRepliesTreeByBoardNo(int boardNo) {
		// 평면 댓글 리스트 가져오기
		List<ReplyVO> flatList = session.selectList("kr.ac.kopo.dao.ReplyDAO.selectRepliesByBoardNo", boardNo);

		// 댓글을 Map으로 변환하여 부모-자식 관계를 쉽게 관리
		Map<Integer, ReplyVO> replyMap = new HashMap<>();
		List<ReplyVO> treeList = new ArrayList<>();

		for (ReplyVO reply : flatList) {
			reply.setChildren(new ArrayList<>()); // 자식 댓글 리스트 초기화
			replyMap.put(reply.getReplyNo(), reply);
		}

		for (ReplyVO reply : flatList) {
			if (reply.getParentReplyNo() == null) {
				// 부모 댓글
				treeList.add(reply);
			} else {
				// 대댓글
				ReplyVO parent = replyMap.get(reply.getParentReplyNo());
				if (parent != null) {
					parent.getChildren().add(reply); // 부모 댓글의 자식 리스트에 추가
				}
			}
		}
		return treeList;
	}
}