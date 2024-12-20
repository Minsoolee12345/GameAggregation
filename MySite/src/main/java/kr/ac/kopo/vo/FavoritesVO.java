package kr.ac.kopo.vo;

public class FavoritesVO 
{
    private int id;         // 즐겨찾기 ID (옵션: 필요에 따라 제거 가능)
    private String userId;  // 사용자 ID
    private int gameId;     // 게임 ID

    // 기본 생성자
    public FavoritesVO() {
    }

	public FavoritesVO(String userId, int gameId)
	{
		this.userId = userId;
		this.gameId = gameId;
	}

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

	public int getGameId() {
		return gameId;
	}

	public void setGameId(int gameId) {
		this.gameId = gameId;
	}

	@Override
	public String toString() {
		return "FavoritesVO [id=" + id + ", userId=" + userId + ", gameId=" + gameId + "]";
	}
}
