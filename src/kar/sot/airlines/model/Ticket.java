package kar.sot.airlines.model;

public class Ticket {

	private String ticketId; 
	private String userId; 
	private String flightNumber; 
	private String departureId;
	private String destinationId;
	private int seatNumber;
	private double price;
	private String digitalSignature;
	
	public Ticket(String ticketId, String userId ,String flightNumber,
			String departureId, String destinationId, int seatNumber, double price,
			String digitalSignature) {
		this.ticketId = ticketId;
		this.userId = userId;
		this.flightNumber = flightNumber;
		this.departureId = departureId;
		this.destinationId = destinationId;
		this.seatNumber = seatNumber;
		this.price = price;
		this.digitalSignature = digitalSignature;
	}
	
	public String getTicketId() {
		return this.ticketId;
	}
	
	public String getUserId() {
		return this.userId;
	}
	
	public String getFlightNumber() {
		return this.flightNumber;
	}
	
	public String getDepartureId() {
		return this.departureId;
	}
	
	public String getDestinationId() {
		return this.destinationId;
	}
	
	public int getSeatNumber() {
		return this.seatNumber;
	}
	
	public double getPrice() {
		return this.price;
	}
	
	public String getDigitalSignature() {
		return this.digitalSignature;
	}
	
	public void setTicketId(String ticketId) {
		this.ticketId = ticketId;
	}
	
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	public void setFlightNumber(String flightNumber) {
		this.flightNumber = flightNumber;
	}
	
	public void setDepartureId(String departureId) {
		this.departureId = departureId;
	}
	
	public void setDestinationId(String destinationId) {
		this.destinationId = destinationId;
	}
	
	public void setSeatNumber(int seatNumber) {
		this.seatNumber = seatNumber;
	}
	
	public void setPrice(double price) {
		this.price = price;
	}
	
	public void setDigitalSignature(String digitalSignature) {
		this.digitalSignature = digitalSignature;
	}
}
