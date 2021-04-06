package kar.sot.airlines.services;

import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;

import org.json.JSONArray;
import org.json.JSONObject;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import kar.sot.airlines.db.SQLConnection;

@Path("AirlineService")
public class AirlineService {
	private SQLConnection sqlCon = new SQLConnection();
	
	@GET
	@Path("/get_airlines")
	@Produces(MediaType.APPLICATION_JSON)
	public String getAirlines() throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement ps = con.prepareStatement("SELECT airlineId,name FROM Airline;");
		ResultSet res = ps.executeQuery();
		JSONArray arr = new JSONArray();
		while(res.next()) {
			JSONObject obj = new JSONObject();
			obj.put("airlineId", res.getString("airlineId"));
			obj.put("name", res.getString("name"));
			arr.put(obj);
		}
		res.close();
		ps.close();
		
		return arr.toString();
	}
	
	@POST
	@Path("/airline_insert/{id}/{name}") 
	@Produces(MediaType.TEXT_PLAIN) 
	public String insertAirline(@PathParam("id") String id, @PathParam("name") String name) throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement ps = con.prepareStatement("INSERT INTO Airline VALUES(?,?,?);");
		ps.setString(1, id);
		ps.setString(2, name.replace("_"," "));
		ps.setDouble(3, 0);
		ps.executeUpdate();
		ps.close();
		
		return "OK";
	}
	
}
