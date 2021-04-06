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

<body>
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
    	final String ENDPOINT_URL_NOTIFICATION = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/NotificationService/";
    	final String ENDPOINT_URL_FC = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/FlightCriteriaService/";
        Client clientNotifications = Client.create();
    	String userId = String.valueOf(session.getAttribute("id"));
    	String paramNotifications = "notifications/"+userId;
    	WebResource webResourceNotifications = clientNotifications.resource(ENDPOINT_URL_NOTIFICATION+paramNotifications);
    	ClientResponse resNotifications = webResourceNotifications.accept("application/json").get(ClientResponse.class);
    	String notificationString = resNotifications.getEntity(String.class);
    	JSONObject notificationObj = new JSONObject(notificationString);
    	%>
    	
        <a class="nav-link text-white" href="user_notification_page.jsp">
	        <i class="fa fa-bell" aria-hidden="true">
	        <% 
		    	if(notificationObj.getInt("notifications") != 0) {
		    	   session.setAttribute("notifications", notificationObj.getInt("notifications"));
		    	   session.setAttribute("flights", notificationObj.getJSONArray("flights"));
		    %>
	        	<span class='badge'><%=notificationObj.getInt("notifications") %></span>
	       	<% 
	    		} else {
	    			session.setAttribute("notifications", 0);
	    		}
	    	%>
	        </i>
        </a>
            <a class="nav-link text-white" href="login.jsp"><i class="fa fa-sign-in mr-2" aria-hidden="true"></i></a>
        </div>
    </nav>

    <section class="container-fluid">
        <div class="row">
            <div class="col-sm-4"></div>
            <div class="col-sm-4">
                <form method="POST" class="mt-5 mb-0">
                    <h2>Search Flights</h2>
                    <label for="depart1" class="form-label">Departure City: </label>
                    <input type="text" name="departure" id="depart1" class="form-control">
                    <label for="destination1" class="form-label">Destination City: </label>
                    <input type="text" name="destination" id="destination1" class="form-control">
                    <button type="submit" name="search-flights" class="mt-3 btn btn-primary">Search</button>
                </form>
                <%
            			if (request.getParameter("search-flights") != null) {
            				String departure = request.getParameter("departure");
            				String destination = request.getParameter("destination");
            				
    						Client client = Client.create();
    						String params = "search/flights/"+departure+"/"+destination;
    						WebResource webResource = client.resource(ENDPOINT_URL_FC+params);
    						ClientResponse res = webResource.accept("application/json").get(ClientResponse.class);
    						String flightString = res.getEntity(String.class);
    						JSONArray arr = new JSONArray(flightString); 
    			%>
    			<div class="mt-5">
				         <h2 style="margin-left: 40%;">Flights</h2>
				         <div class="list-group list-group-flush">
				         <% for (int i=0; i < arr.length(); i++) { 
				         		JSONObject obj = arr.getJSONObject(i);
				         %>
				              <div class="list-group-item list-of-available-flights">
				                   <h3><%=obj.getString("airline") %></h3>
				                   <p class="flight-info"><b>Flight Number:</b> <%=obj.getString("flightNumber") %></p>
				                   <p><b>From:</b> <%=obj.getString("depCountry") %>, <%=obj.getString("depCity") %> </p>
				                   <p><b>To:</b> <%=obj.getString("desCountry") %>, <%=obj.getString("desCity") %></p>
				                   <p><b>Price:</b> <%=obj.getDouble("price") %>&euro;</p>
				                   <p><b>Available Seats:</b> <%=obj.getInt("capacity") %></p>
				                   <button type="button" name="airline-reserve" onclick="goToPage('user_reserve_ticket.jsp?flightNumber=<%=obj.getString("flightNumber") %>')" class="btn-small btn-primary reserve-btn">Reserve</button>
				                   <button type="button" name="airline-info" onclick="goToPage('user_flight_info.jsp?flightNumber=<%=obj.getString("flightNumber") %>')" class="btn-small mt-3 btn-info reserve-btn">More Info</button>
				               </div>
				            <% } %>    
                   		  </div>
                 </div>     
    		    <% 				
            		}
            	%>
                <form method="POST" class="mt-5 mb-0">
                    <h2>Search Flights By Rating</h2>
                    <label for="depart2" class="form-label">Depart: </label>
                    <input type="text" name="departure" id="depart2" class="form-control">
                    <label for="destination2" class="form-label">Destination: </label>
                    <input type="text" name="destination" id="destination2" class="form-control">
                    <button type="submit" name="search-by-rating-flights" class="mt-3 btn btn-primary">Search</button>
                </form>
                
                <%
                	if(request.getParameter("search-by-rating-flights") != null) {
                		String departure = request.getParameter("departure");
        				String destination = request.getParameter("destination");
        				
        				Client client = Client.create();
        				String params = "rating/flight/search/"+departure+"/"+destination;
        				WebResource webResource = client.resource(ENDPOINT_URL_FC+params);
        				ClientResponse res = webResource.accept("application/json").get(ClientResponse.class);
        				String flightString = res.getEntity(String.class);
        				
        				JSONArray arr = new JSONArray(flightString); %>
        		<div class="mt-5">
				         <h2 style="margin-left: 40%;">Flights</h2>
				         <div class="list-group list-group-flush">
				         <% for (int i=0; i < arr.length(); i++) { 
				         		JSONObject obj = arr.getJSONObject(i);
				         %>
				              <div class="list-group-item list-of-available-flights">
				                   <h3><%=obj.getString("airline") %></h3>
				                   <p class="flight-info"><b>Flight Number:</b> <%=obj.getString("flightNumber") %></p>
				                   <p><b>From:</b> <%=obj.getString("depCountry") %>, <%=obj.getString("depCity") %> </p>
				                   <p><b>To:</b> <%=obj.getString("desCountry") %>, <%=obj.getString("desCity") %></p>
				                   <p><b>Price:</b> <%=obj.getDouble("price") %>&euro;</p>
				                   <p><b>Rating:</b> <%=obj.getDouble("rating") %></p>
				                   <p><b>Available Seats:</b> <%=obj.getInt("capacity") %></p>
				                   <button type="button" name="airline-reserve" onclick="goToPage('user_reserve_ticket.jsp?flightNumber=<%=obj.getString("flightNumber") %>')" class="btn-small btn-primary reserve-btn">Reserve</button>
				                   <button type="button" name="airline-info" onclick="goToPage('user_flight_info.jsp?flightNumber=<%=obj.getString("flightNumber") %>')" class="btn-small mt-3 btn-info reserve-btn">More Info</button>
				               </div>
				            <% } %>    
                   		  </div>
                 </div>  
        		<%		
                	}
                %>
            </div>
            <div class="col-sm-4"></div>
        </div>
    </section>
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