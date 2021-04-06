package kar.sot.airlines.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.json.JSONObject;

import kar.sot.airlines.db.SQLConnection;

@Path("RatingService")
public class RatingService {
	private SQLConnection sqlCon = new SQLConnection();
	
	@GET
	@Path("/avgRating/{airlineId}") 
	@Produces(MediaType.APPLICATION_JSON)
	public String avgRating(@PathParam("airlineId") String airlineId) throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement psAvg = con.prepareStatement("SELECT AVG(rating) AS 'rating average'\n" + 
														"FROM Comment \n" + 
														"WHERE airlineId = ?;");
	   psAvg.setString(1, airlineId);
	   ResultSet rs = psAvg.executeQuery();
	   double avg = 0;
	   while(rs.next()) {
		    avg = rs.getDouble("rating average");
	   }
	   psAvg.close();
	   
	   return new JSONObject().put("average", avg).toString();
	}
	
	
	
	@POST
	@Path("/airline/rate/{commentId}/{airlineId}/{userId}/{submissionDateTime}/{review}/{rating}")
	@Produces(MediaType.TEXT_PLAIN)
	public String rateAirline(@PathParam("commentId") String commentId,@PathParam("airlineId") String airlineId,@PathParam("userId") String userId, 
			@PathParam("submissionDateTime") String submissionDateTime,@PathParam("review") String review, @PathParam("rating") int rating) 
					throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement ps = con.prepareStatement("INSERT INTO Comment VALUES(?,?,?,?,?,?);");
		ps.setString(1,commentId);
		ps.setString(2,airlineId);
		ps.setString(3,userId);
		ps.setString(4,submissionDateTime);
		ps.setString(5,review);
		ps.setDouble(6,rating);
		ps.executeUpdate();
		ps.close();
		return "OK";
	}
	
	@PUT 
	@Path("/airline_rating_upd/{airlineId}/{rating}")
	@Produces(MediaType.TEXT_PLAIN)
	public String updateAirlineRating(@PathParam("airlineId") String airlineId, @PathParam("rating") double rating) throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement ps = con.prepareStatement("UPDATE Airline SET rating = ? WHERE airlineId = ?;");
		ps.setDouble(1, rating);
		ps.setString(2, airlineId);
		ps.executeUpdate();
		ps.close();
		return "OK";
	}
	

}
