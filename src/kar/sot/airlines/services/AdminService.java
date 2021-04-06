package kar.sot.airlines.services;

import javax.ws.rs.POST;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import kar.sot.airlines.db.SQLConnection;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.PreparedStatement;

@Path("AdminService")
public class AdminService {
	private SQLConnection sqlCon = new SQLConnection();
	
	@POST
	@Path("/dep_des_insert/{depId}/{desId}/{depCountry}/{depCity}/{desCountry}/{desCity}/{depWind}/{desWind}/{depTemp}/{desTemp}/{depHumidity}/{desHumidity}")
	@Produces(MediaType.TEXT_PLAIN)
	public String insertDepDes(@PathParam("depId") String depId, @PathParam("desId") String desId,
			@PathParam("depCountry") String depCountry, @PathParam("depCity") String depCity, 
			@PathParam("desCountry") String desCountry, @PathParam("desCity") String desCity,
			@PathParam("depWind") String depWind, @PathParam("desWind") String desWind, @PathParam("depTemp") String depTemp,
			@PathParam("desTemp") String desTemp, @PathParam("depHumidity") String depHumidity, @PathParam("desHumidity") String desHumidity) throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement psDep = con.prepareStatement("INSERT INTO Departure VALUES(?,?,?,?,?,?);");
		psDep.setString(1, depId);
		psDep.setString(2, depCountry);
		psDep.setString(3, depCity);
		psDep.setString(4, depWind);
		psDep.setString(5, depHumidity);
		psDep.setString(6, depTemp);
		psDep.executeUpdate(); 
		psDep.close();
		
		PreparedStatement psDes = con.prepareStatement("INSERT INTO Destination VALUES(?,?,?,?,?,?);");
		psDes.setString(1, desId);
		psDes.setString(2, desCountry);
		psDes.setString(3, desCity);
		psDes.setString(4, desWind);
		psDes.setString(5, desHumidity);
		psDes.setString(6, desTemp);
		psDes.executeUpdate(); 
		psDep.close();
		
		return "OK";
	}
	
	
	
}
