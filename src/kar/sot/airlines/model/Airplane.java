package kar.sot.airlines.model;

public class Airplane {
	private String airplaneId;
	private String name;
	private String type;
	private int seatCapacity;
	
	Airplane(String airplaneId,String name,String type,int seatCapacity) {
		this.airplaneId = airplaneId;
		this.name = name;
		this.type = type;
		this.seatCapacity = seatCapacity;
	}
	
	public String getAirplaneId() {
		return this.airplaneId;
	}
	
	public String getName() {
		return this.name;
	}
	
	public String getType() {
		return this.type;
	}
	
	public int getSeatCapacity() {
		return this.seatCapacity;
	}
	
	public void setAirplaneId(String airplaneId) {
		this.airplaneId = airplaneId;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public void setType(String type) {
		this.type = type;
	}
	
	public void setSeatCapacity(int seatCapacity) {
		this.seatCapacity = seatCapacity;
	}
}

