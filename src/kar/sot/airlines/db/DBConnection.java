package kar.sot.airlines.db;

public class DBConnection {
	private String jdbcDriver = "com.mysql.jdbc.Driver";
    private String dbUrl = "jdbc:mysql://localhost/?autoReconnect=false&useSSL=false&allowPublicKeyRetrieval=false";
    private String user = "root";
    private String pass = "1k2A34567!";

    public DBConnection(String jdbcDriver, String dbUrl, String user, String pass) {
        this.jdbcDriver = jdbcDriver;
        this.dbUrl = dbUrl;
        this.user = user;
        this.pass = pass;
    }

    public String getJdbcDriver() {
        return jdbcDriver;
    }

    public String getPass() {
        return pass;
    }

    public String getUser() {
        return user;
    }

    public String getDbUrl() {
        return dbUrl;
    }

    public void setDbUrl(String dbUrl) {
        this.dbUrl = dbUrl;
    }

    public void setJdbcDriver(String jdbcDriver) {
        this.jdbcDriver = jdbcDriver;
    }

    public void setPass(String pass) {
        this.pass = pass;
    }

    public void setUser(String user) {
        this.user = user;
    }
}
