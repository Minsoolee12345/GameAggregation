package kr.ac.kopo.vo;

import java.util.Date;

public class LeaderboardVO {
    private int id;
    private String userId;
    private int gameId; // String -> int로 변경
    private int score;
    private Date recordedAt;

    // Getter & Setter
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public int getGameId() { // Getter 수정
        return gameId;
    }

    public void setGameId(int gameId) { // Setter 수정
        this.gameId = gameId;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public Date getRecordedAt() {
        return recordedAt;
    }

	public void setRecordedAt(Date recordedAt) {
	    this.recordedAt = recordedAt;
	}
}