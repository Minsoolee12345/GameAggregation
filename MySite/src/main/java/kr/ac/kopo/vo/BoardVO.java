package kr.ac.kopo.vo;

import java.util.List;

public class BoardVO {
    private int no;
    private String title;
    private String writer;
    private String content;
    private int viewCnt;
    private String regDate;
    private List<ReplyVO> comments;
    private String gameTitle; // 추가한 필드
    private Integer gameId;   // 게시글에 연결된 게임 ID (nullable)

    public int getNo() { return no; }
    public void setNo(int no) { this.no = no; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getWriter() { return writer; }
    public void setWriter(String writer) { this.writer = writer; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public int getViewCnt() { return viewCnt; }
    public void setViewCnt(int viewCnt) { this.viewCnt = viewCnt; }

    public String getRegDate() { return regDate; }
    public void setRegDate(String regDate) { this.regDate = regDate; }

    public List<ReplyVO> getComments() { return comments; }
    public void setComments(List<ReplyVO> comments) { this.comments = comments; }

    public String getGameTitle() { return gameTitle; }
    public void setGameTitle(String gameTitle) { this.gameTitle = gameTitle; }

    public Integer getGameId() { return gameId; }
    public void setGameId(Integer gameId) { this.gameId = gameId; }
}