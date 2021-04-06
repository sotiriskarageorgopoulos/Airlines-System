package kar.sot.airlines.model;

public class Weather {
	private String wind;
	private String humidity;
	private String temperature;
	
	public Weather(String wind,String humidity,String temperature) {
		this.humidity = humidity;
		this.temperature = temperature;
		this.wind = wind;
	}
	
	public String getHumidity() {
		return this.humidity;
	}
	
	public String getTemperature() {
		return this.temperature;
	}
	
	public String getWind() {
		return this.wind;
	}
	
	public void setHumidity(String humidity) {
		this.humidity = humidity;
	}
	
	public void setTemperature(String temperature) {
		this.temperature = temperature;
	}
	
	public void setWind(String wind) {
		this.wind = wind;
	} 
}
