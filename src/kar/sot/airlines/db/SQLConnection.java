package kar.sot.airlines.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class SQLConnection {
	private  Connection con;
    private  String dbName;
    private  boolean existsDB;
    
    public SQLConnection() {
    	 con = null;
         dbName = "airlineDB";
         existsDB = false;
    }

    public Connection connectToDB() throws ClassNotFoundException, SQLException {
        DBConnection cdb = new DBConnection("com.mysql.jdbc.Driver","jdbc:mysql://localhost/?autoReconnect=false&useSSL=false&allowPublicKeyRetrieval=false","root","1k2A34567!");
        Class.forName(cdb.getJdbcDriver());
        System.out.println("Connecting to database...");
        con = DriverManager.getConnection(cdb.getDbUrl(),cdb.getUser(),cdb.getPass());
        checkDBExistance();
        cdb.setDbUrl("jdbc:mysql://localhost/"+dbName+"?autoReconnect=false&useSSL=false&allowPublicKeyRetrieval=false");
        Class.forName(cdb.getJdbcDriver());
        System.out.println("Connecting to database...");
        con = DriverManager.getConnection(cdb.getDbUrl(),cdb.getUser(),cdb.getPass());
        return con;
    }
    
    public void createDB(String dbName) throws SQLException {
        PreparedStatement ps = con.prepareStatement("CREATE DATABASE "+dbName);
        ps.executeUpdate();
        ps.close();
    }

    public void checkDBExistance() throws SQLException {
        ResultSet rs = con.getMetaData().getCatalogs();
        while (rs.next()) {
            String catalog = rs.getString(1);
            if(dbName.equals(catalog)){
                existsDB = true;
                break;
            }
        }
        if(!existsDB) createDB(dbName);
    }

}

