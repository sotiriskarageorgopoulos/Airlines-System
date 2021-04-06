package kar.sot.airlines.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import kar.sot.airlines.db.SQLConnection;

@Path("WeatherService")
public class WeatherService {
	private SQLConnection sqlCon = new SQLConnection();
	
	@PUT 
	@Path("/weather_update/{id}/{category}/{temp}/{wind}/{humidity}")
	@Produces(MediaType.TEXT_PLAIN)
	public String updateWeather(@PathParam("id") String id, @PathParam("category") String category,
			@PathParam("temp") String temp,@PathParam("wind") String wind, @PathParam("humidity") String humidity)
			throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		if(category.equals("destination")) {
			PreparedStatement psDes = con.prepareStatement("UPDATE Destination \n" + 
														"SET wind = ?, humidity = ?, temperature = ?\n" + 
														"WHERE desId = ?");
			psDes.setString(1, wind);
			psDes.setString(2, humidity);
			psDes.setString(3, temp);
			psDes.setString(4, id);
			psDes.executeUpdate();
			psDes.close();
		}
		else if(category.equals("departure")){
			PreparedStatement psDep = con.prepareStatement("UPDATE Departure \n" + 
														"SET wind = ?, humidity = ?, temperature = ?\n" + 
														"WHERE depId = ?;");
			psDep.setString(1, wind);
			psDep.setString(2, humidity);
			psDep.setString(3, temp);
			psDep.setString(4, id);
			psDep.executeUpdate();
			psDep.close();
		}
		
		return "OK";
	}

}
