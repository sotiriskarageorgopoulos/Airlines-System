package kar.sot.airlines.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.json.JSONArray;
import org.json.JSONObject;

import kar.sot.airlines.db.SQLConnection;

@Path("CommentService")
public class CommentService {
	private SQLConnection sqlCon = new SQLConnection();
	
	@DELETE
	@Path("/delete_comment/{commentId}") 
	@Produces(MediaType.TEXT_PLAIN)
	public String deleteComment(@PathParam("commentId") String commentId) throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement ps = con.prepareStatement("DELETE FROM Comment WHERE commentId = ?;");
		ps.setString(1, commentId);
		ps.executeUpdate();
		ps.close();
		return "OK";
	}
	
	@GET
	@Path("/get_user_comments")
	@Produces(MediaType.APPLICATION_JSON)
	public String getComments() throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement ps = con.prepareStatement("SELECT A.name,C.commentId,C.submissionDate,C.description,C.rating,U.username \n" + 
													"FROM Comment AS C \n" + 
													"INNER JOIN User AS U \n" + 
													"ON C.userId = U.userId \n" + 
													"INNER JOIN Airline AS A \n" + 
													"ON C.airlineId = A.airlineId;");
		ResultSet rs = ps.executeQuery();
		JSONArray arr = new JSONArray();
		while(rs.next()) {
			 JSONObject obj = new JSONObject();
			 obj.put("airline", rs.getString("name"));
			 obj.put("commentId",rs.getString("commentId"));
			 obj.put("submissionDate", rs.getString("submissionDate"));
			 obj.put("description", rs.getString("description"));
			 obj.put("username", rs.getString("username"));
			 arr.put(obj);
		}
		
		return arr.toString();
	}

}
