package kar.sot.airlines.services;

import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import kar.sot.airlines.db.SQLConnection;
import kar.sot.airlines.security.Cryptography;

@Path("RegisterService")
public class RegisterService {
	private SQLConnection sqlCon = new SQLConnection();
	
	@POST
	@Path("/user_reg/{userId}/{name}/{surname}/{username}/{email}/{psw}/{tel}/{birthDate}/{nationality}")
	@Produces(MediaType.TEXT_PLAIN)
	public String registerUser(@PathParam("userId") String userId ,@PathParam("name") String name, @PathParam("surname") String surname, 
			@PathParam("username") String username,@PathParam("email") String email, 
			@PathParam("psw") String psw, @PathParam("tel") String tel,
			@PathParam("birthDate") String birthDate,@PathParam("nationality") String nationality) 
	throws ClassNotFoundException, SQLException, InvalidKeyException,
	NoSuchAlgorithmException, NoSuchPaddingException, IllegalBlockSizeException, 
	BadPaddingException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement ps = con.prepareStatement("INSERT INTO User VALUES(?,?,?,?,?,?,?,?,?)");
		String password = Cryptography.encrypt(psw);
		
		ps.setString(1, userId);
		ps.setString(2, username);
		ps.setString(3, name);
		ps.setString(4, surname);
		ps.setString(5, email);
		ps.setString(6, password);
		ps.setString(7, tel);
		ps.setDate(8, Date.valueOf(birthDate));
		ps.setString(9, nationality);
		ps.executeUpdate();
		ps.close();
		
		return "OK";
	}
	
	@POST
	@Path("/admin_register/{userId}/{name}/{surname}/{username}/{email}/{psw}/{tel}/{birthDate}/{nationality}")
	@Produces(MediaType.TEXT_PLAIN)
	public String registerAdmin(@PathParam("userId") String userId ,@PathParam("name") String name, @PathParam("surname") String surname, 
			@PathParam("username") String username,@PathParam("email") String email, 
			@PathParam("psw") String psw, @PathParam("tel") String tel,
			@PathParam("birthDate") String birthDate,@PathParam("nationality") String nationality) 
		throws ClassNotFoundException, SQLException, InvalidKeyException, NoSuchAlgorithmException, 
		NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement ps = con.prepareStatement("INSERT INTO Admin VALUES(?,?,?,?,?,?,?,?,?)");
		
		String password = Cryptography.encrypt(psw);
		
		ps.setString(1, userId);
		ps.setString(2, username);
		ps.setString(3, name);
		ps.setString(4, surname);
		ps.setString(5, email);
		ps.setString(6, password);
		ps.setString(7, tel);
		ps.setDate(8, Date.valueOf(birthDate));
		ps.setString(9, nationality);
		ps.executeUpdate();
		ps.close();
		
		return "OK";
	}
	
}
