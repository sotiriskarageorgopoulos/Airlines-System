package kar.sot.airlines.model;

public class Airline {
	private String airlineId;
	private String name;
	private int rating;
	private Comment comment;
	
	Airline(String airlineId, String name, int rating, Comment comment) {
		this.airlineId = airlineId;
		this.name = name;
		this.rating = rating;
		this.comment = comment;
	}
	
	public String getAirlineId() {
		return this.airlineId;
	}
	
	public String getName() {
		return this.name;
	}
	
	public int getRating() {
		return this.rating;
	}
	
	public Comment getComment() {
		return this.comment;
	}
	
	public void setAirlineId(String airlineId) {
		this.airlineId = airlineId;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public void setRating(int rating) {
		this.rating = rating;
	}
	
	public void setComment(Comment comment) {
		this.comment = comment;
	}
}
