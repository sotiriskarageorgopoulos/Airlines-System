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

import org.json.JSONArray;
import org.json.JSONObject;

import kar.sot.airlines.db.SQLConnection;

@Path("FlightService")
public class FlightService {
	private SQLConnection sqlCon = new SQLConnection();
	
	@PUT
	@Path("/cancel_old_flights")
	@Produces(MediaType.TEXT_PLAIN)
	public String cancelOldFlights() throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement ps = con.prepareStatement("UPDATE Flight SET cancelled = 1 WHERE NOW() > depDateTime;");
		ps.executeUpdate();
		ps.close();
		return "OK";
	}
	
	@GET
	@Path("/flight_info")
	@Produces(MediaType.APPLICATION_JSON)
	public String getFlights() throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement ps = con.prepareStatement("SELECT F.flightNumber,F.duration,F.desDateTime,F.depDateTime,F.cancelled,\n" + 
				"F.ticketPrice,Dep.nameOfCountry AS 'Departure_Country',Dep.cityOfCountry AS 'Departure_City',\n" + 
				"Dep.wind AS 'Departure_Wind',Dep.humidity AS 'Departure_Humidity',Dep.temperature AS 'Departure_Temp',\n" + 
				"Des.nameOfCountry AS 'Destination_Country',Des.cityOfCountry AS 'Destination_City',Des.wind AS 'Destination_Wind',\n" + 
				"Des.humidity AS 'Destination_Humidity',Des.temperature AS 'Destination_Temp'\n" + 
				"FROM Flight AS F \n" + 
				"INNER JOIN Flight_Departure AS FDep\n" + 
				"ON  F.flightNumber = FDep.flightNumber\n" + 
				"INNER JOIN Departure AS Dep\n" + 
				"ON FDep.depId = Dep.depId\n" + 
				"INNER JOIN Flight_Destination AS FDes\n" + 
				"ON F.flightNumber = FDes.flightNumber\n" + 
				"INNER JOIN Destination AS Des\n" + 
				"ON FDes.desId = Des.desId;");
		
		ResultSet rs = ps.executeQuery();
		JSONArray arr = new JSONArray();
		while(rs.next()) {
			JSONObject obj = new JSONObject();
			obj.put("flightNumber",rs.getNString("flightNumber"));
			obj.put("duration", rs.getString("duration"));
			obj.put("desDateTime", rs.getString("desDateTime"));
			obj.put("depDateTime", rs.getString("depDateTime"));
			obj.put("ticketPrice", rs.getString("ticketPrice"));
			obj.put("depCountry", rs.getString("Departure_Country"));
			obj.put("depCity", rs.getString("Departure_City"));
			obj.put("depWind", rs.getString("Departure_Wind"));
			obj.put("depHumidity", rs.getString("Departure_Humidity"));
			obj.put("depTemp", rs.getString("Departure_Temp"));
			obj.put("desCountry", rs.getString("Destination_Country"));
			obj.put("desCity", rs.getString("Destination_City"));
			obj.put("desWind", rs.getString("Destination_Wind"));
			obj.put("desHumidity", rs.getString("Destination_Humidity"));
			obj.put("desTemp", rs.getString("Destination_Temp"));
			obj.put("cancelled", rs.getBoolean("cancelled"));
			arr.put(obj);
		}
	
		return arr.toString();
	}
	
	@POST
	@Path("/flight_insert/{flightNumber}/{depDateTime}/{desDateTime}/{duration}/{ticketPrice}/{desId}/{depId}/{airlineId}/{capacity}")
	@Produces(MediaType.TEXT_PLAIN)
	public String insertFlight(@PathParam("flightNumber") String flightNumber, 
	@PathParam("depDateTime") String depDateTime, @PathParam("desDateTime") String desDateTime,
	@PathParam("duration") int duration, @PathParam("ticketPrice") double ticketPrice, @PathParam("desId") String desId,
	@PathParam("depId") String depId, @PathParam("airlineId") String airlineId, @PathParam("capacity") int capacity) throws SQLException, ClassNotFoundException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement psFlight = con.prepareStatement("INSERT INTO Flight VALUES(?,?,?,?,?,?,?,?);");
		psFlight.setString(1, flightNumber);
		psFlight.setString(2, String.valueOf(airlineId));
		psFlight.setInt(3, duration);
		psFlight.setString(4, desDateTime);
		psFlight.setString(5, depDateTime);
		psFlight.setDouble(6, ticketPrice);
		psFlight.setInt(7, capacity);
		psFlight.setBoolean(8, false);
		psFlight.executeUpdate();
		psFlight.close();
		
		PreparedStatement psFlightDes = con.prepareStatement("INSERT INTO Flight_Destination VALUES(?,?);");
		psFlightDes.setString(1, desId);
		psFlightDes.setString(2, flightNumber);
		psFlightDes.executeUpdate();
		psFlightDes.close();
		
		PreparedStatement psFlightDep = con.prepareStatement("INSERT INTO Flight_Departure VALUES(?,?);");
		psFlightDep.setString(1, depId);
		psFlightDep.setString(2, flightNumber);
		psFlightDep.executeUpdate();
		psFlightDep.close();
		
		return "OK";
	}

	@PUT
	@Path("/cancel_flight/{flightNumber}")
	@Produces(MediaType.TEXT_PLAIN)
	public String cancelFlight(@PathParam("flightNumber") String flightNumber) 
			throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		
		PreparedStatement psFlight = con.prepareStatement("UPDATE Flight SET cancelled = ? WHERE flightNumber = ?;");
		psFlight.setBoolean(1, true);
		psFlight.setString(2,flightNumber);
		psFlight.executeUpdate();
		psFlight.close();
		
		return "OK";
	}
}
