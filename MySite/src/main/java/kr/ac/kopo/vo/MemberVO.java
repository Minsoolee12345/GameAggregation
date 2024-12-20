package kr.ac.kopo.vo;

public class MemberVO {
    private String id;
    private String name;
    private String password;
    private String emailId;
    private String emailDomain;
    private String type; // 사용자 유형 추가
    private String regDate;

    public MemberVO() {}

	public MemberVO(String id, String name, String password, String emailId, String emailDomain, String type,
			String regDate) {
		super();
		this.id = id;
		this.name = name;
		this.password = password;
		this.emailId = emailId;
		this.emailDomain = emailDomain;
		this.type = type;
		this.regDate = regDate;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getEmailId() {
		return emailId;
	}

	public void setEmailId(String emailId) {
		this.emailId = emailId;
	}

	public String getEmailDomain() {
		return emailDomain;
	}

	public void setEmailDomain(String emailDomain) {
		this.emailDomain = emailDomain;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	@Override
	public String toString() {
		return "MemberVO [id=" + id + ", name=" + name + ", password=" + password + ", emailId=" + emailId
				+ ", emailDomain=" + emailDomain + ", type=" + type + ", regDate=" + regDate + "]";
	}
}