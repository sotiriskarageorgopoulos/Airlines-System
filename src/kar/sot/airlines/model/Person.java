package kar.sot.airlines.model;
import java.time.LocalDate;

public class Person {
	private String personId; 
	private String name;
	private String surname;
	private String username;
	private String email;
	private String password;
	private String phone;
	private LocalDate birthDate;
	private String nationality;
	
	Person(String personId, String name,String surname,String username,String email,String password
			,String phone,LocalDate birthDate, String nationality) {
		this.personId = personId;
		this.name = name;
		this.surname = surname;
		this.username = username;
		this.email = email;
		this.password = password;
		this.phone = phone;
		this.birthDate = birthDate;
		this.nationality = nationality;
	}
	
	public String getPersonId() {
		return this.personId;
	}
	
	public String getName() {
		return this.name;
	}
	
	public String getSurname() {
		return this.surname;
	}
	
	public String getUsername() {
		return this.username;
	}
	
	public String getEmail() {
		return this.email;
	}
	
	public String getPassword() {
		return this.password;
	}
	
	public String getPhone() {
		return this.phone;
	}
	
	public LocalDate getBirthDate() {
		return this.birthDate;
	}
	
	public String getNationality() {
		return this.nationality;
	}
	
	public void setId(String personId) {
		this.personId = personId;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public void setSurname(String surname) {
		this.surname = surname;
	}
	
	public void setUsername(String username) {
		this.username = username;
	}
	
	public void setEmail(String email) {
		this.email = email;
	}
	
	public void setPassword(String password) {
		this.password = password;
	}
	
	public void setPhone(String phone) {
		this.phone = phone;
	}
	
	public void setBirthDate(LocalDate birthDate) {
		this.birthDate = birthDate;
	}
	
	public void setNationality(String nationality) {
		this.nationality = nationality;
	}
}
