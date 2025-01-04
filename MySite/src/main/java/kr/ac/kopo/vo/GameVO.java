package kr.ac.kopo.vo;

public class GameVO {
    private Integer gameId;
    private String gameUrl;
    private String gameTitle;
    private String gameIntro;

    public GameVO() {}

    public GameVO(Integer gameId, String gameUrl, String gameTitle, String gameIntro) {
        this.gameId = gameId;
        this.gameUrl = gameUrl;
        this.gameTitle = gameTitle;
        this.gameIntro = gameIntro;
    }

    public Integer getGameId() { return gameId; }
    public void setGameId(Integer gameId) { this.gameId = gameId; }

    public String getGameUrl() { return gameUrl; }
    public void setGameUrl(String gameUrl) { this.gameUrl = gameUrl; }

    public String getGameTitle() { return gameTitle; }
    public void setGameTitle(String gameTitle) { this.gameTitle = gameTitle; }

    public String getGameIntro() { return gameIntro; }
    public void setGameIntro(String gameIntro) { this.gameIntro = gameIntro; }
}