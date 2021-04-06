package kar.sot.airlines.services;

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

@Path("FlightCriteriaService")
public class FlightCriteriaService {
	private SQLConnection sqlCon = new SQLConnection();
	
	@GET
	@Path("/search/flights/{departure}/{destination}")
	@Produces(MediaType.APPLICATION_JSON)
	public String searchFlights(@PathParam("departure") String departure,@PathParam("destination") String destination) throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement ps = con.prepareStatement("SELECT A.name,F.flightNumber,F.seatCapacity,F.duration,F.desDateTime,F.depDateTime,\n" + 
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
				"ON FDes.desId = Des.desId\n" + 
				"INNER JOIN Airline AS A\n" + 
				"ON A.airlineId = F.airlineId\n" + 
				"WHERE Dep.cityOfCountry = ? AND Des.cityOfCountry = ? AND F.cancelled = 0;");
		ps.setString(1, departure);
		ps.setString(2, destination);
		ResultSet rs = ps.executeQuery();
		
		JSONArray arr = new JSONArray();
		while(rs.next()) {
			JSONObject obj = new JSONObject();
			obj.put("airline", rs.getString("name"));
			obj.put("capacity", rs.getInt("seatCapacity"));
			obj.put("flightNumber", rs.getString("flightNumber"));
			obj.put("price", rs.getDouble("ticketPrice"));
			obj.put("depCountry", rs.getString("Departure_Country"));
			obj.put("desCountry", rs.getString("Destination_Country"));
			obj.put("depCity", rs.getString("Departure_City"));
			obj.put("desCity", rs.getString("Destination_City"));
			arr.put(obj);
		}
		
		return arr.toString();
	}
	
	@GET
	@Path("/rating/flight/search/{departure}/{destination}")
	@Produces(MediaType.APPLICATION_JSON)
	public String searchFlightsByRating(@PathParam("departure") String departure,@PathParam("destination") String destination) throws SQLException, ClassNotFoundException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement ps = con.prepareStatement("SELECT A.name,A.rating,F.flightNumber,F.seatCapacity,F.duration,F.desDateTime,F.depDateTime,\n" + 
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
				"ON FDes.desId = Des.desId\n" + 
				"INNER JOIN Airline AS A\n" + 
				"ON A.airlineId = F.airlineId\n" + 
				"WHERE Dep.cityOfCountry = ? AND Des.cityOfCountry = ? AND F.cancelled = 0\n" + 
				"ORDER BY rating DESC;");
		ps.setString(1, departure);
		ps.setString(2, destination);
		ResultSet rs = ps.executeQuery();
		
		JSONArray arr = new JSONArray();
		while(rs.next()) {
			JSONObject obj = new JSONObject();
			obj.put("airline", rs.getString("name"));
			obj.put("rating", rs.getString("rating"));
			obj.put("capacity", rs.getInt("seatCapacity"));
			obj.put("flightNumber", rs.getString("flightNumber"));
			obj.put("price", rs.getDouble("ticketPrice"));
			obj.put("depCountry", rs.getString("Departure_Country"));
			obj.put("desCountry", rs.getString("Destination_Country"));
			obj.put("depCity", rs.getString("Departure_City"));
			obj.put("desCity", rs.getString("Destination_City"));
			arr.put(obj);
		}
		return arr.toString();
	}
}
