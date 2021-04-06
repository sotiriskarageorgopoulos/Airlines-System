package kar.sot.airlines.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.json.JSONArray;
import org.json.JSONObject;

import kar.sot.airlines.db.SQLConnection;

@Path("MessageService")
public class MessageService {
	private SQLConnection sqlCon = new SQLConnection();
	
	@POST
	@Path("/send_message/{messageId}/{userId}/{subject}/{text}")
	@Produces(MediaType.TEXT_PLAIN)
	public String sendMessage(@PathParam("messageId") String messageId,@PathParam("userId") String userId, 
			@PathParam("subject") String subject, @PathParam("text") String text) throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement ps = con.prepareStatement("INSERT INTO UserMessage VALUES(?,?,?,?);");
		ps.setString(1, messageId);
		ps.setString(2, userId);
		ps.setString(3, subject);
		ps.setString(4, text);
		ps.executeUpdate();
		ps.close();
		return "DONE";
	}
	
	@POST 
	@Path("/send_message/{messageId}/{userId}/{adminId}/{subject}/{text}")
	@Produces(MediaType.TEXT_PLAIN)
	public String sendMessage(@PathParam("messageId") String messageId,@PathParam("userId") String userId, @PathParam("adminId") String adminId,
			@PathParam("subject") String subject, @PathParam("text") String text) throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement ps = con.prepareStatement("INSERT INTO AdminMessage VALUES (?,?,?,?,?);");
		ps.setString(1, messageId);
		ps.setString(2, adminId);
		ps.setString(3, userId);
		ps.setString(4, subject);
		ps.setString(5, text);
		ps.executeUpdate();
		ps.close();
		return "OK";
	}
	
	@GET 
	@Path("/user_messages")
	@Produces(MediaType.APPLICATION_JSON)
	public String getUserMessages() throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement ps = con.prepareStatement("SELECT * FROM UserMessage;");
		ResultSet rs = ps.executeQuery();
		JSONArray arr = new JSONArray();
		while(rs.next()) {
			JSONObject obj = new JSONObject();
			obj.put("messageId", rs.getString("messageId"));
			obj.put("userId", rs.getString("userId"));
			obj.put("subject", rs.getString("subject"));
			obj.put("text", rs.getString("textMessage"));
			arr.put(obj);
		}
		return arr.toString();
	}
	
	@GET 
	@Path("/admin_messages/{userId}")
	@Produces(MediaType.APPLICATION_JSON)
	public String getAdminMessages(@PathParam("userId") String userId) throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement ps = con.prepareStatement("SELECT * FROM AdminMessage WHERE userId = ?");
		ps.setString(1,userId);
		ResultSet rs = ps.executeQuery();
		JSONArray arr = new JSONArray();
		while(rs.next()) {
			JSONObject obj = new JSONObject();
			obj.put("messageId", rs.getString("messageId"));
			obj.put("adminId", rs.getString("adminId"));
			obj.put("userId", rs.getString("userId"));
			obj.put("subject", rs.getString("subject"));
			obj.put("text", rs.getString("textMessage"));
			arr.put(obj);
		}
		return arr.toString();
	}

}
