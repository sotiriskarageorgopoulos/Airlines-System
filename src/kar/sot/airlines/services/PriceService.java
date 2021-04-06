package kar.sot.airlines.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import kar.sot.airlines.db.SQLConnection;

@Path("PriceService")
public class PriceService {
	private SQLConnection sqlCon = new SQLConnection();
	
	@PUT 
	@Path("/price_update/{flightNumber}/{discount}")
	@Produces(MediaType.TEXT_PLAIN)
	public String updatePrice(@PathParam("flightNumber") String flightNumber, 
			@PathParam("discount") double discount) throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement psOldPrice = con.prepareStatement("SELECT ticketPrice FROM Flight WHERE flightNumber = ?");
		psOldPrice.setString(1, flightNumber);
		ResultSet rsOldPrice = psOldPrice.executeQuery();
		double oldPrice = 0;
		
		while(rsOldPrice.next()) {
			oldPrice = rsOldPrice.getDouble("ticketPrice");
		} 
		
		double newPrice = oldPrice - oldPrice*(discount/100);
		
		PreparedStatement psUpdFlight = con.prepareStatement("UPDATE Flight SET ticketPrice = ? WHERE flightNumber = ?;");
		psUpdFlight.setDouble(1, newPrice);
		psUpdFlight.setString(2, flightNumber);
		psUpdFlight.executeUpdate();
		psUpdFlight.close();
		
		PreparedStatement psUpdTicket = con.prepareStatement("UPDATE Ticket SET price = ? WHERE flightNumber = ?;");
		psUpdTicket.setDouble(1, newPrice);
		psUpdTicket.setString(2, flightNumber);
		psUpdTicket.executeUpdate();
		psUpdTicket.close();
		return "OK";
	}

}
