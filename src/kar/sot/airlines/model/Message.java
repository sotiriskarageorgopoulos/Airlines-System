package kar.sot.airlines.model;

public class Message {
	private String senderId; 
	private String receiverId;
	private String messageId;
	private String subject;
	private String text;
	
	public Message(String senderId, String receiverId, String messageId, String subject, String text) {
		this.senderId = senderId;
		this.receiverId = receiverId;
		this.messageId = messageId;
		this.subject = subject;
		this.text = text;
	}
	
	public String getSenderId() {
		return this.senderId;
	}
	
	public String getReceiverId() {
		return this.receiverId;
	}
	
	public String getMessageId() {
		return this.messageId;
	}
	
	public String getSubject() {
		return this.subject;
	}
	
	public String getText() {
		return this.text;
	}
	
	public void setSenderId(String senderId) {
		this.senderId = senderId;
	}
	
	public void setReceiverId(String receiverId) {
		this.receiverId = receiverId;
	}
	
	public void setMessageId(String messageId) {
		this.messageId = messageId;
	}
	
	public void setSubject(String subject) {
		this.subject = subject;
	}
	
	public void setText(String text) {
		this.text = text;
	}
}
