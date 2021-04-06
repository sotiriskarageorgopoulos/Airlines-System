package kar.sot.airlines.model;

import java.time.LocalDateTime;

public class Flight {
	private String flightNumber; 
	private double ticketPrice;
	private int duration;
	private boolean cancelled;
	private LocalDateTime departureDateTime;
	private LocalDateTime destinationDateTime;
	private String airlineId;
	private String depId;
	private String desId;
	private int capacity;
	
	public Flight(String flightNumber, String airlineId, String depId, String desId,  LocalDateTime departureDateTime, 
			LocalDateTime destinationDateTime,double ticketPrice,int duration, int capacity){
		this.flightNumber = flightNumber;
		this.departureDateTime = departureDateTime;
		this.destinationDateTime = destinationDateTime;
		this.airlineId = airlineId;
		this.depId = depId;
		this.desId = desId;
		this.duration = duration;
		this.ticketPrice = ticketPrice;
		this.capacity = capacity;
	}
	
	public int getCapacity() {
		return this.capacity;
	}
	
	public String getAirlineId() {
		return this.airlineId;
	}
	
	public String getDepId() {
		return this.depId;
	}
	
	public String getDesId() {
		return this.desId;
	}
	
	public String getFlightNumber() {
		return this.flightNumber;
	}
	
	public boolean getCancelled() {
		return this.cancelled;
	}
	
	public int getDuration() {
		return this.duration;
	}
	
	public double getTicketPrice() {
		return this.ticketPrice;
	}
	
	public LocalDateTime getDepartureDateTime() {
		return this.departureDateTime;
	} 
	
	public LocalDateTime getDestinationDateTime() {
		return this.destinationDateTime;
	}
	
	public void setDestinationDateTime(LocalDateTime destinationDateTime) {
		this.destinationDateTime = destinationDateTime;
	}
	
	public void setDepartureDateTime(LocalDateTime departureDateTime) {
		this.departureDateTime = departureDateTime;
	}
	
	public void setFlightNumber(String flightNumber) {
		this.flightNumber = flightNumber;
	}
	
	public void setDuration(int duration) {
		this.duration = duration;
	}
	
	public void setTicketPrice(double ticketPrice) {
		this.ticketPrice = ticketPrice;
	}
	
	public void setCancelled(boolean cancelled) {
		this.cancelled = cancelled;
	}
	
	public void setAirlineId(String airlineId) {
		this.airlineId = airlineId;
	}
	
	public void setDepId(String depId) {
		this.depId = depId;
	}
	
	public void setDesId(String desId) {
		this.desId = desId;
	}
	
	public void setCapacity(int capacity) {
		this.capacity = capacity;
	}
	
}
