<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.sun.jersey.api.client.Client" %>
<%@ page import="com.sun.jersey.api.client.ClientResponse" %>
<%@ page import="com.sun.jersey.api.client.WebResource" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>  
<%@ page import="kar.sot.airlines.model.Airplane" %>  
<%@ page import="kar.sot.airlines.model.Airline" %>    
<%@ page import="kar.sot.airlines.model.Flight" %>  
<%@ page import="kar.sot.airlines.model.Departure" %>  
<%@ page import="kar.sot.airlines.model.Destination" %>  
<%@ page import="kar.sot.airlines.model.Weather" %>  
<%@ page import="kar.sot.airlines.model.Location" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.text.DecimalFormat" %>
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
                <a class="nav-link nav-item-style" href="./admin_message_page.jsp">Messages</a>
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
    <div class="row p-3">
        <a class="nav-link text-white" href="login.jsp"><i class="fa fa-sign-in mr-2" aria-hidden="true"></i></a>
    </div>
</nav>

<body>
    <section class="container-fluid">
    	<div class="row">
    		<div class="col-sm-4"></div>
	    	<div class="col-sm-4">
	    		<%
	    		final String ENDPOINT_URL_ADMIN = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/AdminService/";
	    		final String ENDPOINT_URL_AIRPLANE = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/AirplaneService/";
	    		final String ENDPOINT_URL_AIRLINE = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/AirlineService/";
	    		final String ENDPOINT_URL_FLIGHT = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/FlightService/";
	    		final String ENDPOINT_URL_DESTINATION = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/DestinationService/";
	    		final String ENDPOINT_URL_DEPARTURE = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/DepartureService/";
	    		
	    		if(request.getParameter("insert-dep-des-btn") != null) {
	    			String depCountry = request.getParameter("depCountry");
            		String depCity = request.getParameter("depCity");
            		String desCountry = request.getParameter("destCountry");
            		String desCity = request.getParameter("destCity");
            		String depId = UUID.randomUUID().toString();
            		String desId = UUID.randomUUID().toString();
            		
            		Client weatherDepClient = Client.create();
            		WebResource webResourceDepWeather = weatherDepClient.resource("http://api.openweathermap.org/data/2.5/weather?q="+depCity+"&appid=1788bec7ef010c9feed2f6a078b5a582");
            		ClientResponse resDepWeather = webResourceDepWeather.accept("application/json").get(ClientResponse.class);
            		String depWeather = resDepWeather.getEntity(String.class);
            		JSONObject depWeatherObject = new JSONObject(depWeather);
            		String tempDep = String.valueOf(depWeatherObject.getJSONObject("main").getDouble("temp")-273.15); 
            		String humidityDep = String.valueOf(depWeatherObject.getJSONObject("main").getDouble("humidity")); 
            		String windSpeedDep = String.valueOf(depWeatherObject.getJSONObject("wind").getDouble("speed")); 
            		Weather wDep = new Weather(windSpeedDep,humidityDep,tempDep);
            		
            		Client weatherDesClient = Client.create();
            		WebResource webResourceDesWeather = weatherDesClient.resource("http://api.openweathermap.org/data/2.5/weather?q="+desCity+"&appid=1788bec7ef010c9feed2f6a078b5a582");
            		ClientResponse resDesWeather = webResourceDesWeather.accept("application/json").get(ClientResponse.class);
            		String desWeather = resDesWeather.getEntity(String.class);
            		JSONObject desWeatherObject = new JSONObject(desWeather);
            		String tempDes = String.valueOf(desWeatherObject.getJSONObject("main").getDouble("temp")-273.15); 
            		String humidityDes = String.valueOf(desWeatherObject.getJSONObject("main").getDouble("humidity")); 
            		String windSpeedDes = String.valueOf(desWeatherObject.getJSONObject("wind").getDouble("speed")); 
            		Weather wDes = new Weather(windSpeedDes,humidityDes,tempDes);
            		
            		Departure dep = new Departure(depId,depCountry,depCity,wDep);
	    			Destination des = new Destination(desId,desCountry,desCity,wDes);
	    		
	    			Client wsClient = Client.create();
	    			String params = "dep_des_insert/"+dep.getId()+"/"+des.getId()+"/"+dep.getNameOfCountry()+"/"+dep.getCityOfCountry()+"/"+des.getNameOfCountry()+"/"+des.getCityOfCountry()+"/"+dep.getWeather().getWind()+"/"+des.getWeather().getWind()+"/"+dep.getWeather().getTemperature()+"/"+des.getWeather().getTemperature()+"/"+dep.getWeather().getHumidity()+"/"+des.getWeather().getHumidity();
	    			WebResource webResource = wsClient.resource(ENDPOINT_URL_ADMIN+params);
	    			ClientResponse wsRes = webResource.accept("text/plain").post(ClientResponse.class);
	    		}
	    		%>
	    		<form method="POST" class="insert-form">
	    			<h1 class="mt-3 insert-header">Insert Departure & Destination</h1>
	    			<label for="depCountry" class="form-label">Departure Country: </label>
                    <input type="text" class="form-control" name="depCountry" id="depCountry" required>
                    <label for="depCity" class="form-label">Departure City: </label>
                    <input type="text" class="form-control" name="depCity" id="depCity" required>
                    <label for="destCountry" class="form-label">Destination Country: </label>
                    <input type="text" name="destCountry" id="destCountry" class="form-control" required>
                    <label for="destCity" class="form-label">Destination City: </label>
                    <input type="text" name="destCity" class="form-control" id="destCity" class="form-control" required>
                    <button type="submit" name="insert-dep-des-btn" class="btn btn-dark btn-submit">Submit</button>
	    		</form>
	    	</div>
	    	<div class="col-sm-4"></div>
    	</div>
    	<div class="row">
    		<div class="col-sm-4"></div>
	    	<div class="col-sm-4">
	    		<%
	    			if(request.getParameter("insert-airplane-btn") != null) {
	            		String airplane = request.getParameter("airplane");
	            		String airplaneType = request.getParameter("airplaneType");
	            		int seatCapacity = Integer.valueOf(request.getParameter("seatCapacity"));
	            		String airplaneId = UUID.randomUUID().toString();
	            		String airlineId = request.getParameter("airlineId");
	            		
	            		Client client = Client.create();
	            		String params = "airplane_insert/"+airplaneId+"/"+airplane+"/"+airplaneType+"/"+seatCapacity+"/"+airlineId;
	            		WebResource webResource = client.resource(ENDPOINT_URL_AIRPLANE+params);
	            		ClientResponse res = webResource.accept("text/plain").post(ClientResponse.class);
	    			}
	    		%>
	    		<form method="POST" class="insert-form">
	    			<h1 class="mt-3 insert-header">Insert Airplane</h1>
	    			<label for="airplane" class="form-label">Airplane: </label>
                    <input type="text" name="airplane" id="airplane" class="form-control" required>
                    <label for="airplaneType" class="form-label">Airplane Type: </label>
                    <input type="text" name="airplaneType" id="airplaneType" class="form-control" required>
                    <label for="seatCapacity" class="form-label">Seat Capacity: </label>
                    <input type="number" id="seatCapacity" name="seatCapacity" class="form-control" required>
                    <label for="airlineId" class="form-label">Airline: </label>
                    <%
                    	Client clientAirlines = Client.create();
                    	String paramAirline = "get_airlines";
                    	WebResource webResourceAirlines = clientAirlines.resource(ENDPOINT_URL_AIRLINE+paramAirline);
                    	ClientResponse resAirline = webResourceAirlines.accept("application/json").get(ClientResponse.class);
                    	String airlineString = resAirline.getEntity(String.class);
                    	JSONArray airlines = new JSONArray(airlineString);
                    %>
                    <select name="airlineId" id="airlineId" class="form-control">
                    	<% for(int i=0; i < airlines.length(); i++) { %>
                   		<option value="<%=airlines.getJSONObject(i).getString("airlineId") %>"><%=airlines.getJSONObject(i).getString("name") %></option>
                   		<% }%>
                    </select>
                    <button type="submit" name="insert-airplane-btn" class="btn btn-dark btn-submit">Submit</button>
	    		</form>
	    	</div>
	    	<div class="col-sm-4"></div>
    	</div>
    	<div class="row">
	    	<div class="col-sm-4"></div>
	    	<div class="col-sm-4">
	    		<%
	    			if(request.getParameter("insert-airline-btn") != null) {
	    				String airlineId = UUID.randomUUID().toString();
	    				String airline = request.getParameter("airline").replace(" ","_");
	    				
	    				Client client = Client.create();
	    				String params = "airline_insert/"+airlineId+"/"+airline;
	    				WebResource webResource = client.resource(ENDPOINT_URL_AIRLINE+params);
	    				ClientResponse res = webResource.accept("text/plain").post(ClientResponse.class);
	    			}
	    		%>
	    		<form method="POST" class="insert-form">
	    			<h1 class="mt-3 insert-header">Insert Airline</h1>
	    			<label for="airline" class="form-label">Airline: </label>
	                <input type="text" name="airline" id="airline" class="form-control" required>
	              	<button type="submit" name="insert-airline-btn" class="btn btn-dark btn-submit">Submit</button>
	    		</form>
	    	</div>
	    	<div class="col-sm-4"></div>
    	</div>
        <div class="row">
            <div class="col-sm-4"></div>
            <div class="col-sm-4">
             <% 
            	if(request.getParameter("insert-flight-btn") != null) {
            		DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
            		String flightNumber = request.getParameter("flightNumber");
            		LocalDateTime timeOfDeparture = LocalDateTime.parse(request.getParameter("timeOfDeparture"),formatter);
            		LocalDateTime timeOfDestination = LocalDateTime.parse(request.getParameter("timeOfDestination"),formatter);
            		int duration = Integer.valueOf(request.getParameter("duration"));
            		double ticketPrice = Double.valueOf(request.getParameter("ticketPrice"));
            		String airlineId = request.getParameter("airlineId");
            		String desId = request.getParameter("desId");
            		String depId = request.getParameter("depId");
            		int capacity = Integer.valueOf(request.getParameter("airplaneCapacity"));
            		
            		Flight f = new Flight(flightNumber,airlineId,depId,desId,timeOfDeparture,timeOfDestination,ticketPrice,duration,capacity);
            		
            		Client client = Client.create();
            		String params = "flight_insert/"+f.getFlightNumber()+"/"+String.valueOf(f.getDepartureDateTime())+"/"+String.valueOf(f.getDestinationDateTime())+"/"+f.getDuration()+"/"+f.getTicketPrice()+"/"+f.getDesId()+"/"+f.getDepId()+"/"+f.getAirlineId()+"/"+f.getCapacity();
            	    WebResource webResource = client.resource(ENDPOINT_URL_FLIGHT+params);
            	    ClientResponse res = webResource.accept("text/plain").post(ClientResponse.class);
            	}
            	%>
                <form method="POST" class="insert-form">
                    <h1 class="mt-3 insert-header">Insert a Flight</h1>
                    <label for="flight-number" class="form-label">Flight Number: </label>
                    <input type="text" name="flightNumber" id="flight-number" class="form-control" required>
                    <label for="timeOfDeparture" class="form-label">Departure Time: </label>
                    <input type="datetime-local" name="timeOfDeparture" id="timeOfDeparture" class="form-control" required>
                    <label for="timeOfDestination" class="form-label">Destination Time: </label>
                    <input type="datetime-local" name="timeOfDestination" id="timeOfDestination" class="form-control" required>
                    <label for="duration">Duration: </label>
                    <input type="number" id="duration" name="duration" class="form-control" required>
                    <label for="ticketPrice" class="form-label">Ticket Price: </label>
                    <input type="text" name="ticketPrice" class="form-control" id="ticketPrice" required>
                    <label for="airlineId" class="form-label">Airline: </label>
                    <select name="airlineId" id="airlineId" class="form-control">
                    	<% for(int i=0; i < airlines.length(); i++) { %>
                   		<option value="<%=airlines.getJSONObject(i).getString("airlineId") %>"><%=airlines.getJSONObject(i).getString("name") %></option>
                   		<% }%>
                    </select>
                    <%
                    	Client clientDes = Client.create();
                    	String paramDes = "destinations";
                    	WebResource webResourceDes = clientDes.resource(ENDPOINT_URL_DESTINATION+paramDes);
                    	ClientResponse resDes = webResourceDes.accept("application/json").get(ClientResponse.class);
                    	String jsonDestinationString = resDes.getEntity(String.class);
                    	JSONArray destinations = new JSONArray(jsonDestinationString);
                    %>
                    <label for="desId" class="form-label">Destinations: </label>
                   	<select id="desId" name="desId" class="form-control">
                   	<%for(int i=0; i < destinations.length(); i++) {%>
                    	<option value="<%=destinations.getJSONObject(i).getString("desId") %>"><%=destinations.getJSONObject(i).getString("country") %>, <%=destinations.getJSONObject(i).getString("city") %></option>
                    <% } %>
                    </select>
                    <%
                    	Client clientDep = Client.create();
                    	String paramDep = "departures";
                    	WebResource webResourceDep = clientDep.resource(ENDPOINT_URL_DEPARTURE+paramDep);
                    	ClientResponse resDep = webResourceDep.accept("application/json").get(ClientResponse.class);
                    	String jsonDepartureString = resDep.getEntity(String.class);
                    	JSONArray departures = new JSONArray(jsonDepartureString);
                    %>
                    <label for="depId" class="form-label">Departure: </label>
                   	<select id="depId" name="depId" class="form-control">
                   		<%for(int i=0; i < departures.length(); i++) { %>
                   			<option value="<%=departures.getJSONObject(i).getString("depId") %>"><%=departures.getJSONObject(i).getString("country") %>, <%=departures.getJSONObject(i).getString("city") %></option>
                   		<% } %>
                   	</select>
                   	<%
                   		Client clientAirplane = Client.create();
                   		String paramAirplane = "airplanes";
                   		WebResource webResourceAirplane = clientAirplane.resource(ENDPOINT_URL_AIRPLANE+paramAirplane);
                   		ClientResponse resAirplane = webResourceAirplane.accept("application/json").get(ClientResponse.class);
                   		String airplaneString = resAirplane.getEntity(String.class);
                   		JSONArray airplanes = new JSONArray(airplaneString);
                   	%>
                   	<label for="airplaneCapacity" class="form-label">Airplane: </label>
                   	<select id="airplaneCapacity" name="airplaneCapacity" class="form-control">
                   		<% for(int i=0; i < airplanes.length();i++) {%>
                   		<option value="<%=airplanes.getJSONObject(i).getInt("capacity") %>"><%=airplanes.getJSONObject(i).getString("name") %> - <%=airplanes.getJSONObject(i).getString("airline") %></option>
                   		<% } %>
                   	</select>
                    <button type="submit" name="insert-flight-btn" class="btn btn-dark btn-submit">Submit</button>
                </form>
            </div>
            <div class="col-sm-4"></div>
        </div>
    </section>
    <footer class="mt-4 row admin-footer-flight">
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