package kar.sot.airlines.model;

import java.time.LocalDateTime;

public class Comment {
	private String userId;
	private LocalDateTime submissionDateTime;
	private String description;
	private String commentId;
	private int rating;
	private String airlineId;
	
	public Comment(String commentId,String userId,String airlineId,LocalDateTime submissionDateTime,  String description, int rating) {
		this.commentId = commentId;
		this.userId = userId;
		this.airlineId = airlineId;
		this.submissionDateTime = submissionDateTime;
		this.description = description;
		this.rating = rating;
	}
	public String getCommentId() {
		return this.commentId;
	}
	
	public String getUserId() {
		return this.userId;
	}
	
	public LocalDateTime getSubmissionDateTime() {
		return this.submissionDateTime;
	}
	
	public String getAirlineId() {
		return this.airlineId;
	}
	
	public int getRating() {
		return this.rating;
	}
	
	public String getDescription() {
		return this.description;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	public void setCommentId(String commentId) {
		this.commentId = commentId;
	}
	
	public void setAirlineId(String airlineId) {
		this.airlineId = airlineId;
	}
	
	public void setSubmissionDateTime(LocalDateTime submissionDateTime) {
		this.submissionDateTime = submissionDateTime;
	}
	
	public void setDescription(String description) {
		this.description = description;
	}
	
	public void setRating(int rating) {
		this.rating = rating;
	}
	
}
