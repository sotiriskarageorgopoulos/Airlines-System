<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.sun.jersey.api.client.Client" %>
<%@ page import="com.sun.jersey.api.client.ClientResponse" %>
<%@ page import="com.sun.jersey.api.client.WebResource" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>   
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="./css/app.css" type="text/css">
    <title>Airlines Ticket Reservation</title>
</head>
<%
	final String ENDPOINT_URL_LOGIN = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/LoginService/login/";
	final String ENDPOINT_URL_FLIGHT = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/FlightService/";
	
	Client clientCancelOldFlights = Client.create();
	WebResource webResourceCancelOldFlights = clientCancelOldFlights.resource(ENDPOINT_URL_FLIGHT+"/cancel_old_flights");
	ClientResponse resCancelOldFlights = webResourceCancelOldFlights.accept("text/plain").put(ClientResponse.class);
	
	if(request.getParameter("login-btn") != null) {
		String email = request.getParameter("email");
		String password = request.getParameter("pass");
		String params = email+"/"+password;
		
		Client client = Client.create();
		WebResource webResource = client.resource(ENDPOINT_URL_LOGIN+params);
		ClientResponse res = webResource.accept("application/json").post(ClientResponse.class);
		
		String jsonString = res.getEntity(String.class);
		JSONObject loginObj = new JSONObject(jsonString);
		
		boolean isLogin = loginObj.getBoolean("login");
		
	    if(isLogin){
	    	String category = loginObj.getString("category");
	    	session.setAttribute("id",loginObj.getString("id"));
	    	session.setAttribute("category",category);
	    	session.setAttribute("password",loginObj.getString("password"));
	    	if(category.equals("user")) response.sendRedirect("http://localhost:8080/AirlineTicketReservationSystem/user_main_page.jsp");
	    	else if(category.equals("admin")) response.sendRedirect("http://localhost:8080/AirlineTicketReservationSystem/admin_main_page.jsp");
	    }  
	}
%>
<body class="container-fluid">
    <section class="row">
        <div class="col-sm-4"></div>
        <div class="col-sm-4">
            <h1 class="mt-2 login-header text-white">Airlines Ticket Reservation System</h1>
            <form method="POST">
                <label for="email" class="form-label">Email:</label>
                <input type="email" class="form-control" id="email" name="email" required>
                <label for="psw" class="form-label">Password:</label>
                <input type="password" class="form-control" id="psw" name="pass" required>
                <a class="register-link" href="./register.jsp"><i class="fa fa-registered"></i></a>
                <button type="submit" name="login-btn" class="login-btn btn btn-info text-white">Login</button>
            </form>
        </div>
        <div class="col-sm-4"></div>
    </section>
    <footer class="row login-footer">
        <div class="col-sm-4">
            <p>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Sapiente eos laborum nostrum blanditiis praesentium aspernatur iste quaerat. Aperiam quaerat voluptatum obcaecati reiciendis quae dolore odio deserunt aliquid. Non, libero ipsa!</p>
        </div>
        <div class="col-sm-4">
            &copy;Copyright
            <script>
                document.write(new Date().getFullYear())
            </script>
        </div>
        <div class="col-sm-4">
            <div class="col-auto" style="text-align:center">
                <a class="btn btn-social-icon btn-facebook" href="http://www.facebook.com/profile.php?id=">
                    <i class="fa fa-facebook"></i></a>
                <a class="btn btn-social-icon btn-linkedin" href="http://www.linkedin.com/in/">
                    <i class="fa fa-linkedin"></i></a>
                <a class="btn btn-social-icon btn-twitter" href="http://twitter.com/">
                    <i class="fa fa-twitter"></i></a>
                <a class="btn btn-social-icon" href="mailto:">
                    <i class="fa fa-envelope-o"></i></a>
                <a class="btn btn-social-icon btn-instagram" href="http://instagram.com/">
                    <i class="fa fa-instagram"></i>
                </a>
            </div>
        </div>
    </footer>
</body>
<script src="https://kit.fontawesome.com/1573b68e82.js"></script>

</html>