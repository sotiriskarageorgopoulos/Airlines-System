package kar.sot.airlines.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.json.JSONObject;

import kar.sot.airlines.db.SQLConnection;

@Path("NotificationService")
public class NotificationService {
	private SQLConnection sqlCon = new SQLConnection();
	
	@GET
	@Path("/notifications/{userId}") 
	@Produces(MediaType.APPLICATION_JSON)
	public String getNotification(@PathParam("userId") String userId) throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) AS 'notifications'\n" + 
													"FROM Flight AS F\n" + 
													"INNER JOIN Ticket AS T\n" + 
													"ON F.flightNumber = T.flightNumber\n" + 
													"WHERE F.cancelled = 1 and T.userId = ?;");
		ps.setString(1, userId);
		ResultSet rs = ps.executeQuery();
		JSONObject obj = new JSONObject();
		while(rs.next()) {
			obj.put("notifications", rs.getInt("notifications"));
		}
		
		if(obj.getInt("notifications") > 0) {
			PreparedStatement psFlights = con.prepareStatement("SELECT F.flightNumber, T.ticketId \n" + 
																"FROM Flight AS F\n" + 
																"INNER JOIN Ticket AS T\n" + 
																"ON T.flightNumber = F.flightNumber\n" + 
																"WHERE F.cancelled = 1 AND T.userId = ?;");
			psFlights.setString(1, userId);
			ResultSet rsFlights = psFlights.executeQuery();
			List<String> flights = new ArrayList<>();
			while(rsFlights.next()) {
				flights.add(rsFlights.getString("flightNumber"));
				PreparedStatement psDelCreditCardDetails = con.prepareStatement("DELETE FROM CreditCardDetails WHERE ticketId = ?;");
				psDelCreditCardDetails.setString(1, rsFlights.getString("ticketId"));
				psDelCreditCardDetails.executeUpdate();
				psDelCreditCardDetails.close();
				
				PreparedStatement psDelTickets = con.prepareStatement("DELETE FROM Ticket WHERE ticketId = ?;");
				psDelTickets.setString(1, rsFlights.getString("ticketId"));
				psDelTickets.executeUpdate();
				psDelTickets.close();
			}
			obj.put("flights",flights);
			
		}
		return obj.toString();
	}

}
