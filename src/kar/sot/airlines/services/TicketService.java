package kar.sot.airlines.services;

import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.SignatureException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.json.JSONArray;
import org.json.JSONObject;

import kar.sot.airlines.db.SQLConnection;
import kar.sot.airlines.security.DigitalSignature;

@Path("TicketService")
public class TicketService {
	private SQLConnection sqlCon = new SQLConnection();
	
	@GET
	@Path("/user/tickets/{userId}")
	@Produces(MediaType.APPLICATION_JSON) 
	public String getTicketsOfUser(@PathParam("userId") String userId) throws ClassNotFoundException, SQLException, InvalidKeyException, NoSuchAlgorithmException, SignatureException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement ps = con.prepareStatement("SELECT A.name,T.userId,T.ticketId,F.ticketPrice ,T.flightNumber, T.digitalSignature, F.duration, F.depDateTime, F.desDateTime, F.cancelled,\n" + 
													"Dep.nameOfCountry AS 'Departure_Country',Dep.cityOfCountry AS 'Departure_City', Des.nameOfCountry AS 'Destination_Country',Des.cityOfCountry AS 'Destination_City'\n" + 
													"FROM Ticket AS T\n" + 
													"INNER JOIN Flight AS F\n" + 
													"ON F.flightNumber = T.flightNumber\n" + 
													"INNER JOIN Destination AS Des\n" + 
													"ON T.desId = Des.desId\n" + 
													"INNER JOIN Departure AS Dep\n" + 
													"ON T.depId = Dep.depId\n" + 
													"INNER JOIN Airline AS A\n" + 
													"ON A.airlineId = F.airlineId\n" + 
													"WHERE T.userId = ?;");
		ps.setString(1, userId);
		ResultSet rs = ps.executeQuery();
		JSONArray arr = new JSONArray();
		while(rs.next()) {
			JSONObject obj = new JSONObject();
			
			obj.put("ticketId", rs.getString("ticketId"));
			obj.put("airline", rs.getString("name"));
			obj.put("price", rs.getDouble("ticketPrice"));
			obj.put("flightNumber", rs.getString("flightNumber"));
			obj.put("digitalSignatureVerified", DigitalSignature.verifyDigitalSignature(rs.getString("userId")));
			obj.put("duration", rs.getString("duration"));
			obj.put("depDateTime", rs.getString("depDateTime"));
			obj.put("desDateTime", rs.getString("desDateTime"));
			obj.put("cancelled", rs.getString("cancelled"));
			obj.put("depCountry", rs.getString("Departure_Country"));
			obj.put("depCity", rs.getString("Departure_City"));
			obj.put("desCountry", rs.getString("Destination_Country"));
			obj.put("desCity", rs.getString("Destination_City"));
			arr.put(obj);
		}
		
		return arr.toString();
	}
	
	@GET
	@Path("/tickets_by_criteria/{depCountry}/{depCity}/{desCountry}/{desCity}/{depDateTime}")
	@Produces(MediaType.APPLICATION_JSON)
	public String getTicketsByCriteria(@PathParam("depCountry") String depCountry,@PathParam("depCity") String depCity,
			@PathParam("desCountry") String desCountry, @PathParam("desCity") String desCity, @PathParam("depDateTime") String depDateTime) throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement ps = con.prepareStatement("SELECT Des.nameOfCountry AS 'Destination Country', Des.cityOfCountry AS 'Destination City', \n" + 
				"Dep.nameOfCountry AS 'Departure Country', Dep.cityOfCountry AS 'Departure City', F.depDateTime, F.flightNumber,\n" + 
				"F.duration, A.name,F.duration,F.seatCapacity,A.name,Dep.depId,Des.desId,F.ticketPrice\n" + 
				"FROM Flight AS F\n" + 
				"INNER JOIN Flight_Departure AS FDep\n" + 
				"ON F.flightNumber = FDep.flightNumber\n" + 
				"INNER JOIN Departure AS Dep\n" + 
				"ON Dep.depId = FDep.depId\n" + 
				"INNER JOIN Flight_Destination AS FDes\n" + 
				"ON F.flightNumber = FDes.flightNumber\n" + 
				"INNER JOIN Destination AS Des\n" + 
				"ON FDes.desId = Des.desId\n" + 
				"INNER JOIN Airline AS A\n" + 
				"ON A.airlineId = F.airlineId\n" + 
				"WHERE Des.nameOfCountry = ? AND Des.cityOfCountry = ? AND Dep.nameOfCountry = ? AND Dep.cityOfCountry = ? AND F.depDateTime > ?;");
		ps.setString(1,desCountry);
		ps.setString(2,desCity);
		ps.setString(3,depCountry);
		ps.setString(4,depCity);
		ps.setString(5,depDateTime.replaceAll("_"," "));
		
		ResultSet rs = ps.executeQuery();
		JSONArray arr = new JSONArray();
		while(rs.next()) {
			JSONObject obj = new JSONObject();
			obj.put("depCountry", rs.getString("Departure Country"));
			obj.put("depCity", rs.getString("Departure City"));
			obj.put("desCountry", rs.getString("Destination Country"));
			obj.put("desCity", rs.getString("Destination City"));
			obj.put("depDateTime", rs.getString("depDateTime"));
			obj.put("flightNumber", rs.getString("flightNumber"));
			obj.put("airline", rs.getString("name"));
			obj.put("depId", rs.getString("depId"));
			obj.put("desId", rs.getString("desId"));
			obj.put("duration", rs.getInt("duration"));
			obj.put("capacity", rs.getInt("seatCapacity"));
			obj.put("price", rs.getDouble("ticketPrice"));
			arr.put(obj);
		}
		return arr.toString();
	}

}
