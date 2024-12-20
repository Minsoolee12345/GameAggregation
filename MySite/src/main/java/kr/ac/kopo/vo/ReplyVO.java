package kr.ac.kopo.vo;

import java.util.ArrayList;
import java.util.List;

public class ReplyVO {
    private int replyNo;
    private int boardNo;
    private String writer;
    private String content;
    private String regDate;
    private Integer parentReplyNo;
    private List<ReplyVO> children = new ArrayList<>();

    public int getReplyNo() { return replyNo; }
    public void setReplyNo(int replyNo) { this.replyNo = replyNo; }

    public int getBoardNo() { return boardNo; }
    public void setBoardNo(int boardNo) { this.boardNo = boardNo; }

    public String getWriter() { return writer; }
    public void setWriter(String writer) { this.writer = writer; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getRegDate() { return regDate; }
    public void setRegDate(String regDate) { this.regDate = regDate; }

    public Integer getParentReplyNo() { return parentReplyNo; }
    public void setParentReplyNo(Integer parentReplyNo) { this.parentReplyNo = parentReplyNo; }

    public List<ReplyVO> getChildren() { return children; }
    public void setChildren(List<ReplyVO> children) { this.children = children; }
}
