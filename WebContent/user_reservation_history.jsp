<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.sun.jersey.api.client.Client" %>
<%@ page import="com.sun.jersey.api.client.ClientResponse" %>
<%@ page import="com.sun.jersey.api.client.WebResource" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
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
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <a class="navbar-brand p-3" href="">Airlines Ticket Reservation System</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav">
        	<li class="nav-item active">
                <a class="nav-link nav-item-style" href="./user_main_page.jsp">Main Page</a>
            </li>
            <li class="nav-item active">
                <a class="nav-link nav-item-style" href="./user_reservation_history.jsp">Reservation History</a>
            </li>
            <li class="nav-item">
                <a class="nav-link nav-item-style" href="./user_rating_page.jsp">Rate</a>
            </li>
            <li class="nav-item">
                <a class="nav-link nav-item-style" href="./update_profile.jsp">Update Profile</a>
            </li>
            <li class="nav-item">
                <a class="nav-link nav-item-style" href="./user_message_to_admin.jsp">Help</a>
            </li>
        </ul>
    </div>
    <div class="row p-3">
    	<% 
    	final String ENDPOINT_URL_TICKET = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/TicketService/";
    	final String ENDPOINT_URL_RESERVATION = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/ReservationService/";
    	
    	String userId = String.valueOf(session.getAttribute("id"));
    	int notifications = Integer.valueOf(String.valueOf(session.getAttribute("notifications")));
    	%>
    	
        <a class="nav-link text-white" href="user_notification_page.jsp">
	        <i class="fa fa-bell" aria-hidden="true">
	        <% 
		    	if(notifications != 0) {
		    %>
	        	<span class='badge'><%=notifications %></span>
	       	<% 
	    		}
	    	%>
	        </i>
        </a>
        <a class="nav-link text-white" href="login.jsp"><i class="fa fa-sign-in mr-2" aria-hidden="true"></i></a>
    </div>
</nav>

<body>
    <div class="container-fluid">
        <div class="row mt-5">
            <div class="col-sm-4"></div>
            <div class="col-sm-4">
                <%
                	Client clientTicket = Client.create();
                	String paramTicket = "user/tickets/"+userId;
                    WebResource webResourceTicket = clientTicket.resource(ENDPOINT_URL_TICKET+paramTicket);
                    ClientResponse res = webResourceTicket.accept("application/json").get(ClientResponse.class);
                    String ticketString = res.getEntity(String.class);
                    JSONArray arr = new JSONArray(ticketString);
                    for(int i=0; i < arr.length();i++) {
                    	if(arr.getJSONObject(i).getBoolean("digitalSignatureVerified")) {
                %>
                <form method="POST" class="no-form-style">
                    <h2>Ticket Details</h2>
                    <p class="flight-info"><b>Ticket ID: </b> <%=arr.getJSONObject(i).getString("ticketId") %></p>
                    <p class="flight-info"><b><%=arr.getJSONObject(i).getString("airline") %></b></p>
                    <p class="flight-info"><b>Flight Number: </b><%=arr.getJSONObject(i).getString("flightNumber") %></p>
                    <p class="flight-info"><b>From: </b> <%=arr.getJSONObject(i).getString("depCountry") %>, <%=arr.getJSONObject(i).getString("depCity") %></p>
                    <p class="flight-info"><b>To: </b> <%=arr.getJSONObject(i).getString("desCountry") %>, <%=arr.getJSONObject(i).getString("desCity") %></p>
                    <p class="flight-info"><b>Price: </b> <%=arr.getJSONObject(i).getDouble("price") %>&euro;</p>
                    <p class="flight-info"><b>Duration: </b> <%=arr.getJSONObject(i).getInt("duration") %> min. <i class="fa fa-clock"></i></p>
                    <p class="flight-info"><b>Departure DateTime: </b> <%=arr.getJSONObject(i).getString("depDateTime") %> <i class="fa fa-calendar"></i></p>
                    <input type="hidden" name="ticketId" value="<%=arr.getJSONObject(i).getString("ticketId") %>">
                    <button type="button" class="btn btn-primary" onclick="printTicket('<%=i%>')">Print Ticket</button>
                    <% 
                    DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
                    LocalDateTime now = LocalDateTime.now();
                    LocalDateTime dateTimeFlight = LocalDateTime.parse(arr.getJSONObject(i).getString("depDateTime").replaceAll(" ", "T"));  
                    if(now.isBefore(dateTimeFlight)){
                    %>
                    <button type="button" onclick="goToPage('user_change_datetime.jsp?ticketId=<%=arr.getJSONObject(i).getString("ticketId") %>')" class="btn btn-warning">Change Datetime</button>
                    <button type="submit" name="cancel-reservation" class="btn btn-danger">Cancel Reservation</button>
               		<% } %>
                </form>
                <%  }
                     } 
                  if(request.getParameter("cancel-reservation") != null) {
                	  String ticketId = request.getParameter("ticketId");
                	  Client clientCancelRes = Client.create();
                	  String paramCancelRes = "cancel_reservation/"+ticketId;
                	  WebResource webResourceCancelRes = clientCancelRes.resource(ENDPOINT_URL_RESERVATION+paramCancelRes);
                	  ClientResponse resCancelRes = webResourceCancelRes.accept("text/plain").delete(ClientResponse.class); 
                 %>
                 <script>window.location.href=window.location.href</script>
                 <%
                  }   
                 %>
            </div>
            <div class="col-sm-4"></div>
        </div>
    </div>
    <footer class="mt-5 row user-footer">
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
<script src="./js/functionality.js"></script>

</html>