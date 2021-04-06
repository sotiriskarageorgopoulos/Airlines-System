<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.sun.jersey.api.client.Client" %>
<%@ page import="com.sun.jersey.api.client.ClientResponse" %>
<%@ page import="com.sun.jersey.api.client.WebResource" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="java.util.UUID" %> 
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
    <a class="navbar-brand p-3" href="user-main-page.html">Airlines Ticket Reservation System</a>
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
    	final String ENDPOINT_URL_USER = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/UserService/";
        final String ENDPOINT_URL_RESERVATION = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/ReservationService/";
        final String ENDPOINT_URL_TRANSACTION = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/TransactionService/";
        final String ENDPOINT_URL_PROFILE = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/ProfileService/";
        
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
    <section class="container-fluid">
        <div class="row">
            <div class="col-sm-4"></div>
            <div class="col-sm-4">
            <%
            	final String AIRLINE_ENDPOINT_URL = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/AirlineService/";
            	
            	Client clientTicketDetails = Client.create();
            	String flightNumber = request.getParameter("flightNumber");
            	String params = "flight_info/"+flightNumber;
            	WebResource webResourceTicketDetails = clientTicketDetails.resource(ENDPOINT_URL_USER+params);
            	ClientResponse resTicketDetails = webResourceTicketDetails.accept("application/json").get(ClientResponse.class);
            	String ticketDetailString = resTicketDetails.getEntity(String.class);
            	JSONObject obj = new JSONObject(ticketDetailString);
            	
            	Client clientUserInfo = Client.create();
            	String category = String.valueOf(session.getAttribute("category"));
            	String paramUserInfo = "get_profile_info/"+userId+"/"+category;
            	WebResource webResourceUserInfo = clientUserInfo.resource(ENDPOINT_URL_PROFILE+paramUserInfo);
            	ClientResponse resUserInfo = webResourceUserInfo.accept("application/json").get(ClientResponse.class);
            	String userInfoString = resUserInfo.getEntity(String.class);
            	JSONObject userInfoObj = new JSONObject(userInfoString);
            	
            	Client clientSeatsNumber = Client.create();
            	String paramSeatsNumber = "reserved_seats/"+flightNumber;
            	WebResource webResourceSeatsNumber = clientSeatsNumber.resource(ENDPOINT_URL_RESERVATION+paramSeatsNumber);
            	ClientResponse resSeatsNumber = webResourceSeatsNumber.accept("application/json").get(ClientResponse.class);
            	String seatsNumbersString = resSeatsNumber.getEntity(String.class);
            	JSONArray seatsNumbers = new JSONArray(seatsNumbersString);
            	
            	if(request.getParameter("buy-ticket-btn") != null) {
            		String ticketId = UUID.randomUUID().toString();
            		String depId = request.getParameter("depId");
            		String desId = request.getParameter("desId");
            		double price = Double.valueOf(request.getParameter("price"));
            		int seatNumber = Integer.valueOf(request.getParameter("seatNumber"));
            		String cardType = request.getParameter("typeOfCard");
            		String cardNumber = request.getParameter("creditCardNumber");
            		String cardHolderName = request.getParameter("cardHolderName").replaceAll(" ","_");
            		String cvc = request.getParameter("cvc");
            		
            		Client clientReserveTicket = Client.create();
            		String paramReserveTicket = "buy_ticket/"+flightNumber+"/"+ticketId+"/"+userId+"/"+depId+"/"+desId+"/"+seatNumber+"/"+price+"/"+cardType+"/"+cardNumber+"/"+cardHolderName+"/"+cvc;
            		WebResource webResourceReserveTicket = clientReserveTicket.resource(ENDPOINT_URL_TRANSACTION+paramReserveTicket);
            		ClientResponse res = webResourceReserveTicket.accept("text/plain").post(ClientResponse.class);
            	}
            %>
                <form method="POST" class="mb-2 mt-5">
                    <h2>Ticket Details</h2>
                   	<p class="flight-info"><b>Name: </b><%=userInfoObj.getString("name") %></p>
                   	<p class="flight-info"><b>Surname: </b><%=userInfoObj.getString("surname") %></p>
                   	<p class="flight-info"><b>Airline: </b><%=obj.getString("airline") %></p>
                    <p class="flight-info"><b>Flight Number: </b><%=flightNumber %></p>
                    <p class="flight-info"><b>From:</b> <%=obj.getString("depCountry") %>, <%=obj.getString("depCity") %></p>
                    <p class="flight-info"><b>To:</b> <%=obj.getString("desCountry") %>, <%=obj.getString("desCity") %></p>
                    <p class="flight-info"><b>Price:</b> <%=obj.getDouble("price") %>&euro;</p>
                    <p class="flight-info"><b>Departure DateTime:</b> <%=obj.getString("depDateTime") %> </p>
                    <p class="flight-info"><b>Destination DateTime:</b> <%=obj.getString("desDateTime") %> </p>
                    <input type="hidden" name="desId" value="<%=obj.getString("desId") %>">
                    <input type="hidden" name="depId" value="<%=obj.getString("depId") %>">
                    <input type="hidden" name="price" value="<%=obj.getDouble("price") %>">
                    <label for="seatNumber" class="form-label"><b class="flight-info">Seat Number:</b></label>
	                <select id="seatNumber" name="seatNumber" style="width:15%;" class="form-control">
	                <% 
	                int length = seatsNumbers.length();
	                int counter = 0;
	                
	                for(int i=1;i <= obj.getInt("capacity");i++) { 
	                	if(counter < length && seatsNumbers.getJSONObject(counter).getInt("seatNumber") == i) { 
	                		counter++;
	                		continue;
	                	  }
	                %>
	                    <option value="<%=i %>"><%=i %></option>
	                <% } %>
	                </select>
                    <h2>Credit Card Details</h2>
                    <label for="typeOfCard" class="form-label">Card Type: </label>
                    <select id="typeOfCard" name="typeOfCard" class="form-control" required>
                        <option value="">Select...</option>
                        <option value="visa">Visa</option>
                        <option value="mastercard">mastercard</option>
                        <option value="maestro">maestro</option>
                    </select>
                    <label for="credit-card-num" class="form-label">Credit Card Number: </label>
                    <input type="text" name="creditCardNumber" maxlength="16" id="credit-card-num" class="form-control" required>
                    <label for="cardholdername" class="form-label">Cardholder name: </label>
                    <input type="text" name="cardHolderName" id="cardholdername" class="form-control" required>
                    <label for="cvc" class="form-label">CVC Code: </label>
                    <input type="text" name="cvc" name="cvc" maxlength="3" class="form-control" required>
                    <button type="submit" name="buy-ticket-btn" class="btn btn-success mt-3">Buy Ticket</button>
                </form>
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

</html>