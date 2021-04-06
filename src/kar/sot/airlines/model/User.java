package kar.sot.airlines.model;

import java.time.LocalDate;

public class User extends Person {

	public User(String personId, String name,String surname,String username,String email,String password
			,String phone,LocalDate birthDate, String nationality) {
		super(personId, name, surname, username, email, password, phone, birthDate, nationality);
	}
}
