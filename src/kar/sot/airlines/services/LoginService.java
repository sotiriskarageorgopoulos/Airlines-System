package kar.sot.airlines.services;

import javax.ws.rs.POST;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import org.json.JSONObject;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import kar.sot.airlines.db.SQLConnection;
import kar.sot.airlines.security.Cryptography;

@Path("LoginService")
public class LoginService {
	private SQLConnection sqlCon = new SQLConnection();
	
	@POST
	@Path("/login/{email}/{password}")
	@Produces(MediaType.APPLICATION_JSON)
	public String login(@PathParam("email") String email, @PathParam("password") String password) 
			throws ClassNotFoundException, SQLException, InvalidKeyException, NoSuchAlgorithmException,
			NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException {
		Connection con = sqlCon.connectToDB();
		
		PreparedStatement findUser = con.prepareStatement("SELECT * FROM User WHERE email = ?;");
		findUser.setString(1,email);
		ResultSet user = findUser.executeQuery();
		
		PreparedStatement findAdmin = con.prepareStatement("SELECT * FROM Admin WHERE email = ?;"); 
		findAdmin.setString(1,email);
		ResultSet admin = findAdmin.executeQuery();
		
		while(user.next()) {
			if(user.getString("password") != null) {
				String decryptedPassword = Cryptography.decrypt(user.getString("password"));
				boolean isEqual = password.equals(decryptedPassword)? true : false;
				if(isEqual) {
					JSONObject loginObj = new JSONObject();
					loginObj.put("id", user.getString("userId"));
					loginObj.put("password",decryptedPassword);
					loginObj.put("category","user");
					loginObj.put("login",isEqual);
					return loginObj.toString();
				}
			}
		}
		
		while(admin.next()) {
			if(admin.getString("password") != null) {
				String decryptedPassword = Cryptography.decrypt(admin.getString("password"));
				boolean isEqual = password.equals(decryptedPassword)? true : false;
				if(isEqual) {
					JSONObject loginObj = new JSONObject();
					loginObj.put("id", admin.getString("adminId"));
					loginObj.put("password",decryptedPassword);
					loginObj.put("category","admin");
					loginObj.put("login",isEqual);
					return loginObj.toString();
				}
			}
		}
		return new JSONObject().put("login", false).toString();
	}

}
