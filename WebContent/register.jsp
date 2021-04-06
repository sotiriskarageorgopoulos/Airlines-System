<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.sun.jersey.api.client.Client" %>
<%@ page import="com.sun.jersey.api.client.ClientResponse" %>
<%@ page import="com.sun.jersey.api.client.WebResource" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>  
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.UUID" %>
<%@ page import="kar.sot.airlines.model.User" %>
<%@ page import="kar.sot.airlines.model.Admin" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="./css/app.css" type="text/css">
    <title>Airlines Ticket Reservation</title>
</head>

<body class="container-fluid">
    <section class="row">
        <div class="col-sm-4"></div>
        <div class="col-sm-4">
        	<%
        	  final String ENDPOINT_URL_REGISTER = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/RegisterService/";
        	  Client thirdPartyClient = Client.create();
        	  WebResource webResourceThirdPartyClient = thirdPartyClient.resource("https://restcountries.eu/rest/v2/all");
        	  ClientResponse resThirdPartyClient = webResourceThirdPartyClient.accept("application/json").get(ClientResponse.class);
				
        	  String jsonString = resThirdPartyClient.getEntity(String.class);
        	  JSONArray countries = new JSONArray(jsonString);
        	  
        	  
              if(request.getParameter("register-btn") != null) {
        		  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        		  
        		  String userId = UUID.randomUUID().toString();
        		  String name = request.getParameter("name");
        		  String surname = request.getParameter("surname");
        		  String username = request.getParameter("username");
        		  String email = request.getParameter("email");
        		  String password = request.getParameter("psw");
        		  String tel = request.getParameter("tel");
        		  LocalDate birthDate = LocalDate.parse(String.valueOf(request.getParameter("birthDate")), formatter);
        		  String nationality = request.getParameter("nationality");
        		  String category = request.getParameter("category");
        		  
        		  if(category.equals("user")) {
	        		  User user = new User(userId,name,surname,username,email,password,tel,birthDate,nationality);
	        		  
	        		  String params = "user_reg/"+user.getPersonId()+"/"+user.getName()+"/"+user.getSurname()+"/"
	        		  				 +user.getUsername()+"/"+user.getEmail()+"/"+user.getPassword()+"/"
	        		  				 +user.getPhone()+"/"+String.valueOf(user.getBirthDate())+"/"+user.getNationality();
	        		  Client client = Client.create();
	        		  WebResource webResource = client.resource(ENDPOINT_URL_REGISTER+params);
	        		  ClientResponse res = webResource.accept("text/plain").post(ClientResponse.class);
        		  }
        		  else if(category.equals("administrator")){
        			  Admin admin = new Admin(userId,name,surname,username,email,password,tel,birthDate,nationality);
        			  String params = "admin_register/"+admin.getPersonId()+"/"+admin.getName()+"/"+admin.getSurname()+"/"
     		  				 +admin.getUsername()+"/"+admin.getEmail()+"/"+admin.getPassword()+"/"
     		  				 +admin.getPhone()+"/"+String.valueOf(admin.getBirthDate())+"/"+admin.getNationality();
        			  Client client = Client.create();
        			  WebResource webResource = client.resource(ENDPOINT_URL_REGISTER+params);
	        		  ClientResponse res = webResource.accept("text/plain").post(ClientResponse.class);
        		  }
   	  		}
        	%>
            <h1 class="mt-2 register-header text-white">Airlines Ticket Reservation System</h1>
            <form method="POST">
                <label for="name" class="form-label">Name: </label>
                <input type="text" name="name" id="name" class="form-control" required>
                <label for="surname" class="form-label">Surname: </label>
                <input type="text" name="surname" id="surname" class="form-control" required>
                <label for="username" class="form-label">Username: </label>
                <input type="text" name="username" id="username" class="form-control" required>
                <label for="email" class="form-label">Email: </label>
                <input type="email" name="email" id="email" class="form-control" required>
                <label for="psw" class="form-label">Password: </label>
                <input type="password" id="psw" name="psw" class="form-control" required>
                <label for="tel" class="form-label">Phone: </label>
                <input type="tel" id="tel" name="tel" class="form-control">
                <label for="birthDate" class="form-label">Birth Date: </label>
                <input type="date" id="birthDate" name="birthDate" class="form-control" required>
                <label for="nationality" class="form-label">Nationality: </label>
                <select name="nationality" id="nationality" class="form-control" required>
                <% 
                 for(int i=0; i < countries.length();i++) {	
                %>
                    <option value="<%=countries.getJSONObject(i).getString("alpha3Code") %>"><%=countries.getJSONObject(i).getString("name") %></option>
                <% 
                 }
                %>
                </select>
                <label for="category" class="form-label">Category: </label>
                <select name="category" id="category" class="form-control">
                    <option value="administrator">Administrator</option>
                    <option value="user">User</option>
                </select>
                <a href="./login.jsp" class="login-link"><i class="fa fa-sign-in"></i></a>
                <button type="submit" name="register-btn" class="btn btn-secondary mt-3">Register</button>
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
    </footer>
</body>
<script src="https://kit.fontawesome.com/1573b68e82.js"></script>

</html>