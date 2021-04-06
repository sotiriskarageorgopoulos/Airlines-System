package kar.sot.airlines.model;

public class Location {

	private String id;
	private String nameOfCountry;
	private String cityOfCountry;
	private Weather weather;
	
	Location(String id,String nameOfCountry, String cityOfCountry,Weather weather) {
		this.id = id;
		this.nameOfCountry = nameOfCountry;
		this.cityOfCountry = cityOfCountry;
		this.weather = weather;
	}
	
	public String getId() {
		return this.id;
	}
	
	public String getNameOfCountry() {
		return this.nameOfCountry;
	}
	
	public String getCityOfCountry() {
		return this.cityOfCountry;
	}
	
	public Weather getWeather() {
		return this.weather;
	}
	
	public void setNameOfCountry(String nameOfCountry) {
		this.nameOfCountry = nameOfCountry;
	}
	
	public void setCityOfCountry(String cityOfCountry) {
		this.cityOfCountry = cityOfCountry;
	}
	
	public void setWeather(Weather weather) {
		this.weather = weather;
	}
}
