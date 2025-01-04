package kr.ac.kopo.vo;

import java.util.Date;

public class GameApplicationVO {
    private int id;
    private String gameUrl;
    private String gameTitle;
    private String gameIntro;
    private String status;
    private Date createdDate;

    // Getter and Setter methods
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getGameUrl() { return gameUrl; }
    public void setGameUrl(String gameUrl) { this.gameUrl = gameUrl; }

    public String getGameTitle() { return gameTitle; }
    public void setGameTitle(String gameTitle) { this.gameTitle = gameTitle; }

    public String getGameIntro() { return gameIntro; }
    public void setGameIntro(String gameIntro) { this.gameIntro = gameIntro; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getCreatedDate() { return createdDate; }
    public void setCreatedDate(Date createdDate) { this.createdDate = createdDate; }
}
