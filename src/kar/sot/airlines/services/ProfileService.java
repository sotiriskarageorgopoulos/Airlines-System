package kar.sot.airlines.services;

import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.json.JSONObject;

import kar.sot.airlines.db.SQLConnection;
import kar.sot.airlines.security.Cryptography;

@Path("ProfileService")
public class ProfileService {
	
	private SQLConnection sqlCon = new SQLConnection();
	
	@GET 
	@Path("/get_profile_info/{id}/{category}")
	@Produces(MediaType.APPLICATION_JSON)
	public String getProfileInfo(@PathParam("id") String id,@PathParam("category") String category) throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		
		if(category.equals("user")) {
			PreparedStatement ps = con.prepareStatement("SELECT * FROM User WHERE userId = ?;");
			ps.setString(1,id);
			
			ResultSet profileInfo = ps.executeQuery();
			while(profileInfo.next()) {
				JSONObject profileInfoObj = new JSONObject();
				profileInfoObj.put("name", profileInfo.getString("name"));
				profileInfoObj.put("surname", profileInfo.getString("surname"));
				profileInfoObj.put("username", profileInfo.getString("username"));
				profileInfoObj.put("email", profileInfo.getString("email"));
				profileInfoObj.put("phone", profileInfo.getString("phone"));
				profileInfoObj.put("birthDate", profileInfo.getDate("birthDate"));
				profileInfoObj.put("nationality", profileInfo.getString("nationality"));
				return profileInfoObj.toString();
			}
		}
		else {
			PreparedStatement ps = con.prepareStatement("SELECT * FROM Admin WHERE adminId = ?;");
			ps.setString(1,id);
			
			ResultSet profileInfo = ps.executeQuery();
			while(profileInfo.next()) {
				JSONObject profileInfoObj = new JSONObject();
				profileInfoObj.put("name", profileInfo.getString("name"));
				profileInfoObj.put("surname", profileInfo.getString("surname"));
				profileInfoObj.put("username", profileInfo.getString("username"));
				profileInfoObj.put("email", profileInfo.getString("email"));
				profileInfoObj.put("phone", profileInfo.getString("phone"));
				profileInfoObj.put("birthDate", profileInfo.getDate("birthDate"));
				profileInfoObj.put("nationality", profileInfo.getString("nationality"));
				return profileInfoObj.toString();
			}
		}
		return new JSONObject().toString();
	}
	
	@PUT 
	@Path("/update_email/{id}/{email}/{category}") 
	@Produces(MediaType.TEXT_PLAIN)
	public String updateEmail(@PathParam("id") String id, @PathParam("email") String email,@PathParam("category") String category) throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		
		if(category.equals("user")) {
			PreparedStatement ps = con.prepareStatement("UPDATE User SET email = ? WHERE userId = ?;");
			ps.setString(1,email);
			ps.setString(2,id);
			ps.executeUpdate();
			ps.close();
		}
		else {
			PreparedStatement ps = con.prepareStatement("UPDATE Admin SET email = ? WHERE adminId = ?;");
			ps.setString(1,email);
			ps.setString(2,id);
			ps.executeUpdate();
			ps.close();
		}
		
		return "OK";
	}
	
	@PUT
	@Path("/update_password/{id}/{password}/{category}")
	@Produces(MediaType.TEXT_PLAIN)
	public String updatePassword(@PathParam("id") String id, @PathParam("password") String password, @PathParam("category") String category) throws SQLException, ClassNotFoundException, 
	InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException {
		Connection con = sqlCon.connectToDB();
		
		if(category.equals("user")) {
			PreparedStatement ps = con.prepareStatement("UPDATE User SET password = ? WHERE userId = ?;");
			String psw = Cryptography.encrypt(String.valueOf(password));
			ps.setString(1, psw);
			ps.setString(2, id);
			ps.executeUpdate();
			ps.close();
		}
		else {
			PreparedStatement ps = con.prepareStatement("UPDATE Admin SET password = ? WHERE adminId = ?;");
			String psw = Cryptography.encrypt(String.valueOf(password));
			ps.setString(1, psw);
			ps.setString(2, id);
			ps.executeUpdate();
			ps.close();
		}
		return "OK";
	}
	
	@PUT 
	@Path("/update_phone_number/{id}/{phoneNumber}/{category}")
	@Produces(MediaType.TEXT_PLAIN)
	public String updatePhoneNumber(@PathParam("id") String id, @PathParam("phoneNumber") String phoneNumber, @PathParam("category") String category) throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		if(category.equals("user")) {
			PreparedStatement ps = con.prepareStatement("UPDATE User SET phone = ? WHERE userId = ?;");
			ps.setString(1, phoneNumber);
			ps.setString(2, id);
			ps.executeUpdate();
			ps.close();
		}
		else {
			PreparedStatement ps = con.prepareStatement("UPDATE Admin SET phone = ? WHERE adminId = ?;");
			ps.setString(1, phoneNumber);
			ps.setString(2, id);
			ps.executeUpdate();
			ps.close();
		}
		return "OK";
	}
	

	@DELETE 
	@Path("/delete_account/{id}/{category}")
	@Produces(MediaType.TEXT_PLAIN)
	public String deleteAccount(@PathParam("id") String id, @PathParam("category") String category) throws SQLException, ClassNotFoundException {
		Connection con = sqlCon.connectToDB();
		if(category.equals("user")) {
			PreparedStatement psCCD = con.prepareStatement("DELETE FROM CreditCardDetails WHERE userId = ?");
			psCCD.setString(1,id);
			psCCD.executeUpdate();
			psCCD.close();
			
			PreparedStatement psAdminMsg = con.prepareStatement("DELETE FROM AdminMessage WHERE userId = ?");
			psAdminMsg.setString(1,id);
			psAdminMsg.executeUpdate();
			psAdminMsg.close();
			
			PreparedStatement psUserMsg = con.prepareStatement("DELETE FROM UserMessage WHERE userId = ?");
			psUserMsg.setString(1,id);
			psUserMsg.executeUpdate();
			psUserMsg.close();
			
			PreparedStatement psComment = con.prepareStatement("DELETE FROM Comment WHERE userId = ?");
			psComment.setString(1,id);
			psComment.executeUpdate();
			psComment.close();
			
			PreparedStatement psTicket = con.prepareStatement("DELETE FROM Ticket WHERE userId = ?");
			psTicket.setString(1,id);
			psTicket.executeUpdate();
			psTicket.close();
			
			PreparedStatement ps = con.prepareStatement("DELETE FROM User WHERE userId = ?");
			ps.setString(1,id);
			ps.executeUpdate();
			ps.close();
		}
		else {
			PreparedStatement psAdminMsg = con.prepareStatement("DELETE FROM AdminMessage WHERE adminId = ?");
			psAdminMsg.setString(1,id);
			psAdminMsg.executeUpdate();
			psAdminMsg.close();
			
			PreparedStatement ps = con.prepareStatement("DELETE FROM Admin WHERE adminId = ?");
			ps.setString(1,id);
			ps.executeUpdate();
			ps.close();
		}
		return "OK";
	}

}
