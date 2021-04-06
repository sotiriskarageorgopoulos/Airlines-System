package kar.sot.airlines.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.json.JSONArray;
import org.json.JSONObject;

import kar.sot.airlines.db.SQLConnection;

@Path("AirplaneService")
public class AirplaneService {
	private SQLConnection sqlCon = new SQLConnection();
	
	@POST
	@Path("/airplane_insert/{id}/{name}/{type}/{seatCapacity}/{airlineId}")
	@Produces(MediaType.TEXT_PLAIN)
	public String insertAirplane(@PathParam("id") String id, @PathParam("name") String name, 
			@PathParam("type") String type, @PathParam("seatCapacity") int seatCapacity, @PathParam("airlineId") String airlineId) throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement ps = con.prepareStatement("INSERT INTO Airplane VALUES(?,?,?,?,?)");
		ps.setString(1, id);
		ps.setString(2, name);
		ps.setString(3, type);
		ps.setInt(4, seatCapacity);
		ps.setString(5, airlineId);
		ps.executeUpdate();
		ps.close();
		
		return "OK";
	}
	
	@GET 
	@Path("/airplanes")
	@Produces(MediaType.APPLICATION_JSON)
	public String getAirplanes() throws ClassNotFoundException, SQLException {
		Connection con = sqlCon.connectToDB();
		PreparedStatement ps = con.prepareStatement("SELECT A.name AS 'airline',AP.name,AP.seatCapacity \n" + 
													"FROM Airplane AS AP\n" + 
													"INNER JOIN Airline AS A \n" + 
													"ON AP.airlineId = A.airlineId;");
		ResultSet rs = ps.executeQuery();
		JSONArray arr = new JSONArray();
		while(rs.next()) {
			JSONObject obj = new JSONObject();
			obj.put("airline", rs.getString("airline"));
			obj.put("capacity", rs.getInt("seatCapacity"));
			obj.put("name", rs.getString("name"));
			arr.put(obj);
		}
		return arr.toString();
	}
}
