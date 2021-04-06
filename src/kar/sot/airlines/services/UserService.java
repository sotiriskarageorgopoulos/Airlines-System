package kar.sot.airlines.services;

import javax.ws.rs.GET;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import org.json.JSONObject;
import kar.sot.airlines.db.SQLConnection;

@Path("UserService")
public class UserService {
	private SQLConnection sqlCon = new SQLConnection();
	
	@GET
	@Path("/flight_info/{flightNumber}")
	@Produces(MediaType.APPLICATION_JSON)
	public String getFlight(@PathParam("flightNumber") String flightNumber) throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement ps = con.prepareStatement("SELECT A.name,A.rating,F.duration,F.seatCapacity,F.ticketPrice,Dep.nameOfCountry AS 'Departure_Country',Dep.cityOfCountry AS 'Departure_City',\n" + 
				"Des.nameOfCountry AS 'Destination_Country',Des.cityOfCountry AS 'Destination_City',F.depDateTime,F.desDateTime, Dep.depId, Des.desId,"
				+ "Dep.wind AS 'Departure_Wind',Dep.humidity AS 'Departure_Humidity',Dep.temperature AS 'Departure_Temp',"
				+ "Des.wind AS 'Destination_Wind', Des.humidity AS 'Destination_Humidity',Des.temperature AS 'Destination_Temp'\n" + 
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
				"WHERE F.flightNumber = ?;");
		ps.setString(1, flightNumber);
		ResultSet rs = ps.executeQuery();
		JSONObject obj = new JSONObject();
		while(rs.next()) {
			obj.put("depId", rs.getString("depId"));
			obj.put("desId", rs.getString("desId"));
			obj.put("rating", rs.getDouble("rating"));
			obj.put("airline", rs.getString("name"));
			obj.put("price", rs.getDouble("ticketPrice"));
			obj.put("capacity", rs.getInt("seatCapacity"));
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
			obj.put("depDateTime", rs.getString("depDateTime"));
			obj.put("desDateTime", rs.getString("desDateTime"));
			obj.put("duration", rs.getInt("duration"));
		}
		return obj.toString();
	}	
	
}
