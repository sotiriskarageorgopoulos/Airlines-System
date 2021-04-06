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
    	final String ENDPOINT_URL_RESERVATION = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/ReservationService/";
        final String ENDPOINT_URL_TICKET = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/TicketService/";
        final String ENDPOINT_URL_TRANSACTION = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/TransactionService/";
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
        <div class="row mt-5">
            <div class="col-sm-4"></div>
            <div class="col-sm-4">
            <%
            	Client clientTicket = Client.create();
            	String ticketId = request.getParameter("ticketId");
            	String paramTicket = "info_reserved_ticket/"+ticketId;
            	WebResource webResourceTicket = clientTicket.resource(ENDPOINT_URL_RESERVATION+paramTicket);
            	ClientResponse resTicket = webResourceTicket.accept("application/json").get(ClientResponse.class);
            	String ticketString = resTicket.getEntity(String.class);
            	JSONObject ticketObj = new JSONObject(ticketString);
            	
            	String depCountry = ticketObj.getString("depCountry");
            	String depCity = ticketObj.getString("depCity");
            	String desCountry = ticketObj.getString("desCountry");
            	String desCity = ticketObj.getString("desCity");
            	String depDateTime = ticketObj.getString("depDateTime").replaceAll(" ","_");
            	
            	Client clientNewTickets = Client.create();
            	String paramNewTickets = "tickets_by_criteria/"+depCountry+"/"+depCity+"/"+desCountry+"/"+desCity+"/"+depDateTime;
            	WebResource webResourceNewTickets = clientNewTickets.resource(ENDPOINT_URL_TICKET+paramNewTickets);
            	ClientResponse resNewTickets = webResourceNewTickets.accept("application/json").get(ClientResponse.class);
            	String newTicketString = resNewTickets.getEntity(String.class);
            	JSONArray newTickets = new JSONArray(newTicketString);
            	for(int i=0;i < newTickets.length();i++) {
            		JSONObject newTicket = newTickets.getJSONObject(i);
            %>
                <div class="list-group list-group-flush">
                    <div class="list-group-item list-of-available-flights">
                        <h2>Ticket Details</h2>
                        <p class="flight-info"><b><%=newTicket.getString("airline") %></b></p>
                        <p class="flight-info"><b>Flight Number: </b><%=newTicket.getString("flightNumber") %></p>
                        <p class="flight-info"><b>From:</b> <%=newTicket.getString("depCountry") %>, <%=newTicket.getString("depCity") %></p>
                        <p class="flight-info"><b>To:</b> <%=newTicket.getString("desCountry") %>, <%=newTicket.getString("desCity") %></p>
                        <p class="flight-info"><b>Price: </b><%=newTicket.getDouble("price") %></p>
                        <p class="flight-info"><b>Duration:</b> <%=newTicket.getInt("duration") %> min. <i class="fa fa-clock"></i></p>
                        <p class="flight-info"><b>Departure DateTime:</b> <%=newTicket.getString("depDateTime") %> <i class="fa fa-calendar"></i></p>
                        <form method="POST" class="no-form-style">
                            <input type="hidden" name="flightNumber" value="<%=newTicket.getString("flightNumber") %>">
                            <input type="hidden" name="depId" value="<%=newTicket.getString("depId") %>">
                            <input type="hidden" name="desId" value="<%=newTicket.getString("desId") %>">
                            <input type="hidden" name="price" value="<%=newTicket.getDouble("price") %>">
                            <%
                            Client clientSeatsNumber = Client.create();
                        	String paramSeatsNumber = "reserved_seats/"+newTicket.getString("flightNumber");
                        	WebResource webResourceSeatsNumber = clientSeatsNumber.resource(ENDPOINT_URL_RESERVATION+paramSeatsNumber);
                        	ClientResponse resSeatsNumber = webResourceSeatsNumber.accept("application/json").get(ClientResponse.class);
                        	String seatsNumbersString = resSeatsNumber.getEntity(String.class);
                        	JSONArray seatsNumbers = new JSONArray(seatsNumbersString);
                            %>
                            <label for="seatNumber" class="form-label"><b class="flight-info">Seat Number:</b></label>
	                		<select id="seatNumber" name="seatNumber" style="width:15%;" class="form-control">
			                <% 
			                int length = seatsNumbers.length();
			                int counter = 0;
			                
			                for(int j=1; j <=newTicket.getInt("capacity");j++) { 
			                	if(counter < length && seatsNumbers.getJSONObject(counter).getInt("seatNumber") == j) { 
			                		counter++;
			                		continue;
			                	  }
			                %>
			                    <option value="<%=j %>"><%=j %></option>
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
                            <input type="hidden" name="nameOfBtn" value="change-btn-<%=i%>">
                            <button type="submit" class="btn btn-warning mt-4" name="change-btn-<%=i%>">Change</button>
                        </form>
                    </div>
                </div>
                <% 
            	}
                if(request.getParameter("nameOfBtn") != null) {
              	  Client clientCancelRes = Client.create();
               	  String paramCancelRes = "cancel_reservation/"+ticketId;
               	  WebResource webResourceCancelRes = clientCancelRes.resource(ENDPOINT_URL_RESERVATION+paramCancelRes);
               	  ClientResponse resCancelRes = webResourceCancelRes.accept("text/plain").delete(ClientResponse.class); 
                 
               	  String newTicketId = UUID.randomUUID().toString();
               	  String flightNumber = request.getParameter("flightNumber");
               	  String depId = request.getParameter("depId");
               	  String desId = request.getParameter("desId");
               	  int seatNumber = Integer.valueOf(request.getParameter("seatNumber"));
               	  double price = Double.valueOf(request.getParameter("price"));
	              String cardType = request.getParameter("typeOfCard");
	        	  String cardNumber = request.getParameter("creditCardNumber");
	        	  String cardHolderName = request.getParameter("cardHolderName").replaceAll(" ","_");
	        	  String cvc = request.getParameter("cvc");
	              Client clientReserveTicket = Client.create();
	           	  String paramReserveTicket = "buy_ticket/"+flightNumber+"/"+newTicketId+"/"+userId+"/"+depId+"/"+desId+"/"+seatNumber+"/"+price+"/"+cardType+"/"+cardNumber+"/"+cardHolderName+"/"+cvc;
	           	  WebResource webResourceReserveTicket = clientReserveTicket.resource(ENDPOINT_URL_TRANSACTION+paramReserveTicket);
	           	  ClientResponse res = webResourceReserveTicket.accept("text/plain").post(ClientResponse.class);
                 } %>
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