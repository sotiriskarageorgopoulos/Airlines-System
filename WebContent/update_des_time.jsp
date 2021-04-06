<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.sun.jersey.api.client.Client" %>
<%@ page import="com.sun.jersey.api.client.ClientResponse" %>
<%@ page import="com.sun.jersey.api.client.WebResource" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="./css/app.css" type="text/css">
    <title>Airlines Ticket Reservation</title>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <a class="navbar-brand p-3" href="#">Airlines Ticket Reservation System</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav">
       	    <li class="nav-item active">
                <a class="nav-link nav-item-style" href="./admin_main_page.jsp">Main Page</a>
            </li>
            <li class="nav-item active">
                <a class="nav-link nav-item-style" href="./admin_main_page.jsp">Messages</a>
            </li>
            <li class="nav-item">
                <a class="nav-link nav-item-style" href="./admin_discounts_page.jsp">Discounts</a>
            </li>
            <li class="nav-item">
                <a class="nav-link nav-item-style" href="./admin_comments_page.jsp">Comments</a>
            </li>
            <li class="nav-item">
                <a class="nav-link nav-item-style" href="./admin_update_flight_details.jsp">Update Flights</a>
            </li>
            <li class="nav-item">
                <a class="nav-link nav-item-style" href="./update_profile.jsp">Update Profile</a>
            </li>
        </ul>
    </div>
</nav>
<section class="container-fluid">
     <div class="row mt-5">
        <div class="col-sm-4"></div>
        <div class="col-sm-4">
        	<%
        		final String ENDPOINT_URL_DESTINATION = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/DestinationService/";
        		if(request.getParameter("upd-datetime") != null) {
        			DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
        			Client client = Client.create();
        			String flightNumber = request.getParameter("flightNumber");
        			LocalDateTime desDateTime = LocalDateTime.parse(request.getParameter("timeOfDestination"),formatter);
        			String param = "des_datetime_update/"+flightNumber+"/"+String.valueOf(desDateTime);
        			WebResource webResource = client.resource(ENDPOINT_URL_DESTINATION+param);
        			ClientResponse res = webResource.accept("text/plain").put(ClientResponse.class);
        		}
        	%>
        	<form method="POST" class="upd-form">
                <h1 class="mt-3 del-header">Update Destination Time</h1>
                <label for="timeOfDestination" class="form-label">Destination time: </label>
                <input type="datetime-local" name="timeOfDestination" id="timeOfDestination" class="form-control" required>
                <button type="submit" name="upd-datetime" class="btn btn-dark btn-submit">Submit</button>
            </form>
        </div>
        <div class="col-sm-4"></div>
     </div>
</section>
<footer class="mt-5 row user-footer-flight-info">
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
<script src="https://kit.fontawesome.com/1573b68e82.js"></script>
</body>
</html>