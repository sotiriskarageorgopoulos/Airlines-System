package kar.sot.airlines.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import javax.ws.rs.GET;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.json.JSONArray;
import org.json.JSONObject;

import kar.sot.airlines.db.SQLConnection;

@Path("DestinationService")
public class DestinationService {
	private SQLConnection sqlCon = new SQLConnection();
	
	@PUT
	@Path("/des_datetime_update/{flightNumber}/{desDateTime}")
	@Produces(MediaType.TEXT_PLAIN)
	public String updateFlightDesDateTime(@PathParam("flightNumber") String flightNumber,
			@PathParam("desDateTime") String desDateTime) throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		
		PreparedStatement psGet = con.prepareStatement("SELECT depDateTime FROM Flight WHERE flightNumber = ?;");
		psGet.setString(1, flightNumber);
		ResultSet rs = psGet.executeQuery();
		
		DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
		String depDateTime = "";
		while(rs.next()) {
			depDateTime = rs.getString("depDateTime").replaceAll(" ","T");
		}
		LocalDateTime departure = LocalDateTime.parse(depDateTime,formatter);
		LocalDateTime destination = LocalDateTime.parse(desDateTime,formatter);
		
		int hours = destination.getHour() - departure.getHour();
		int minutes = destination.getMinute() - departure.getMinute();
		int duration = 60*hours + minutes;
		
		PreparedStatement psUpd = con.prepareStatement("UPDATE Flight SET desDateTime = ?, duration = ? WHERE flightNumber = ?;");
		psUpd.setString(1, desDateTime);
		psUpd.setInt(2, duration);
		psUpd.setString(3, flightNumber);
		psUpd.executeUpdate();
		psUpd.close();
		
		return "OK";
	}
	
	@GET 
	@Path("/destinations")
	@Produces(MediaType.APPLICATION_JSON)
	public String getDestinations() throws ClassNotFoundException, SQLException{
		Connection con = sqlCon.connectToDB();
		PreparedStatement ps = con.prepareStatement("SELECT desId,nameOfCountry,cityOfCountry FROM Destination;");
		ResultSet res = ps.executeQuery();
		JSONArray arr = new JSONArray();
		while(res.next()) {
			JSONObject obj = new JSONObject();
			obj.put("desId", res.getString("desId"));
			obj.put("country", res.getString("nameOfCountry"));
			obj.put("city", res.getNString("cityOfCountry"));
			arr.put(obj);
		}
		res.close();
		ps.close();
		
		return arr.toString();
	}
	
}
