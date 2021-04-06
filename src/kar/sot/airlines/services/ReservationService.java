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

@Path("ReservationService")
public class ReservationService {
	private SQLConnection sqlCon = new SQLConnection();
	
	@GET 
	@Path("/reserved_seats/{flightNumber}")
	@Produces(MediaType.APPLICATION_JSON)
	public String reservedSeats(@PathParam("flightNumber") String flightNumber) throws SQLException, ClassNotFoundException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement ps = con.prepareStatement("SELECT seatNumber FROM Ticket WHERE flightNumber = ?;");
		ps.setString(1,flightNumber);
		
		ResultSet rs = ps.executeQuery();
		JSONArray arr = new JSONArray();
		
		while(rs.next()) {
			JSONObject obj = new JSONObject();
			obj.put("seatNumber", rs.getInt("seatNumber"));
			arr.put(obj);
		}
		if(arr.length() == 0) return new JSONArray().toString();
		return arr.toString();
	}
	
	@DELETE 
	@Path("/cancel_reservation/{ticketId}")
	@Produces(MediaType.TEXT_PLAIN)
	public String cancelReservation(@PathParam("ticketId") String ticketId) throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement psCreditCardDetails = con.prepareStatement("DELETE FROM CreditCardDetails WHERE ticketId = ?;");
		psCreditCardDetails.setString(1, ticketId);
		psCreditCardDetails.executeUpdate();
		psCreditCardDetails.close();
		
		PreparedStatement psTicket = con.prepareStatement("DELETE FROM Ticket WHERE ticketId = ?;");
		psTicket.setString(1, ticketId);
		psTicket.executeUpdate();
		psTicket.close();
		return "OK";
	}
	
	@GET
	@Path("/info_reserved_ticket/{ticketId}")
	@Produces(MediaType.APPLICATION_JSON)
	public String getTicket(@PathParam("ticketId") String ticketId) throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement ps = con.prepareStatement("SELECT Des.nameOfCountry AS 'Destination Country', Des.cityOfCountry AS 'Destination City', \n" + 
													"Dep.nameOfCountry AS 'Departure Country', Dep.cityOfCountry AS 'Departure City', F.depDateTime\n" + 
													"FROM Flight AS F\n" + 
													"INNER JOIN Ticket AS T\n" + 
													"ON T.flightNumber = F.flightNumber\n" + 
													"INNER JOIN Departure AS Dep\n" + 
													"ON Dep.depId = T.depId\n" + 
													"INNER JOIN Destination AS Des\n" + 
													"ON Des.desId = T.desId\n" + 
													"INNER JOIN Airline AS A\n" + 
													"ON A.airlineId = F.airlineId\n" + 
													"WHERE T.ticketId = ?;");
		ps.setString(1, ticketId);	
		ResultSet rs = ps.executeQuery();
		JSONObject obj = new JSONObject();
		
		while(rs.next()) {
			obj.put("desCountry", rs.getString("Destination Country"));
			obj.put("desCity", rs.getString("Destination City"));
			obj.put("depCountry", rs.getString("Departure Country"));
			obj.put("depCity", rs.getString("Departure City"));
			obj.put("depDateTime", rs.getString("depDateTime"));
		}
		return obj.toString();
	}

}
