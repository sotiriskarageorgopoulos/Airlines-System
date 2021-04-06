<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.sun.jersey.api.client.Client" %>
<%@ page import="com.sun.jersey.api.client.ClientResponse" %>
<%@ page import="com.sun.jersey.api.client.WebResource" %>
<%@ page import="java.text.DecimalFormat" %>
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
    	final String ENDPOINT_URL_DEPARTURE = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/DepartureService/";
        final String ENDPOINT_URL_DESTINATION = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/DestinationService/";
        final String ENDPOINT_URL_WEATHER = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/WeatherService/";
        final String ENDPOINT_URL_USER = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/UserService/";
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
                <div class="card">
                	<%
                		
                		DecimalFormat df = new DecimalFormat("0.00");  	
                		
                		Client clientDep = Client.create();
                		String paramDep = "departures";
                		WebResource webResourceDep = clientDep.resource(ENDPOINT_URL_DEPARTURE+paramDep);
                		ClientResponse resDep = webResourceDep.accept("application/json").get(ClientResponse.class);
                		String depString = resDep.getEntity(String.class);
                		JSONArray depArray = new JSONArray(depString);
                		for(int i=0; i < depArray.length(); i++) {
                			String depId = depArray.getJSONObject(i).getString("depId");
                			String depCity = depArray.getJSONObject(i).getString("city");
                			
                			Client weatherDepClient = Client.create();
                    		WebResource webResourceDepWeather = weatherDepClient.resource("http://api.openweathermap.org/data/2.5/weather?q="+depCity+"&appid=1788bec7ef010c9feed2f6a078b5a582");
                    		ClientResponse resDepWeather = webResourceDepWeather.accept("application/json").get(ClientResponse.class);
                    		String depWeather = resDepWeather.getEntity(String.class);
                    		JSONObject depWeatherObject = new JSONObject(depWeather);
                    		String tempDep = String.valueOf(df.format(depWeatherObject.getJSONObject("main").getDouble("temp")-273.15)); 
                    		String humidityDep = String.valueOf(depWeatherObject.getJSONObject("main").getDouble("humidity")); 
                    		String windSpeedDep = String.valueOf(depWeatherObject.getJSONObject("wind").getDouble("speed")); 
                			
                			Client updDepWeatherClient = Client.create();
                			String depParams = "weather_update/"+depId+"/departure"+"/"+tempDep+"/"+windSpeedDep+"/"+humidityDep;
                			WebResource webResourceUpdWeather = updDepWeatherClient.resource(ENDPOINT_URL_WEATHER+depParams);
                			ClientResponse resWeatherDep = webResourceUpdWeather.accept("text/plain").put(ClientResponse.class);
                		}
                		
                		Client clientDes = Client.create();
                		String paramDes = "destinations";
                		WebResource webResourceDes = clientDes.resource(ENDPOINT_URL_DESTINATION+paramDes);
                		ClientResponse resDes = webResourceDes.accept("application/json").get(ClientResponse.class);
                		String desString = resDes.getEntity(String.class);
                		JSONArray desArray = new JSONArray(desString);
                		
                		for(int i=0; i < desArray.length(); i++) {
                			String desId = desArray.getJSONObject(i).getString("desId");
                			String desCity = desArray.getJSONObject(i).getString("city");
                			
                			Client weatherDesClient = Client.create();
                    		WebResource webResourceDesWeather = weatherDesClient.resource("http://api.openweathermap.org/data/2.5/weather?q="+desCity+"&appid=1788bec7ef010c9feed2f6a078b5a582");
                    		ClientResponse resDesWeather = webResourceDesWeather.accept("application/json").get(ClientResponse.class);
                    		String desWeather = resDesWeather.getEntity(String.class);
                    		JSONObject desWeatherObject = new JSONObject(desWeather);
                    		String tempDes = String.valueOf(df.format(desWeatherObject.getJSONObject("main").getDouble("temp")-273.15)); 
                    		String humidityDes = String.valueOf(desWeatherObject.getJSONObject("main").getDouble("humidity")); 
                    		String windSpeedDes = String.valueOf(desWeatherObject.getJSONObject("wind").getDouble("speed")); 
                    		
                    		Client updDesWeatherClient = Client.create();
                    		String desParams = "weather_update/"+desId+"/destination"+"/"+tempDes+"/"+humidityDes+"/"+windSpeedDes;
                    		WebResource webResourceUpdWeather = updDesWeatherClient.resource(ENDPOINT_URL_WEATHER+desParams);
                    		ClientResponse resWeatherDes = webResourceUpdWeather.accept("text/plain").put(ClientResponse.class);
                		}
                	
                		Client client = Client.create();
                		String flightNumber = request.getParameter("flightNumber");
                		String params = "flight_info/"+flightNumber;
                		WebResource webResource = client.resource(ENDPOINT_URL_USER+params);
                		ClientResponse res = webResource.accept("application/json").get(ClientResponse.class);
                		String flightInfoString = res.getEntity(String.class);
                		JSONObject obj = new JSONObject(flightInfoString);
                	%>
                    <div class="card-body">
                        <h1><%=obj.getString("airline") %></h1>
                        <% 
                        double rating = obj.getDouble("rating");
                        if(rating >= 0 && rating < 1) { %>
                        <p class="flight-info"><b>Rating:</b> <%=obj.getDouble("rating") %> </p>
                        <% } else if(rating >= 1 && rating < 2) {%>
                        <p class="flight-info"><b>Rating:</b> <%=obj.getDouble("rating") %> <i class="fa fa-star"></i></p>
                        <% } else if(rating >= 2 && rating < 3) {%>
                        <p class="flight-info"><b>Rating:</b> <%=obj.getDouble("rating") %> <i class="fa fa-star"></i><i class="fa fa-star"></i></p>
                        <% } else if(rating >=3 && rating < 4) { %>
                        <p class="flight-info"><b>Rating:</b> <%=obj.getDouble("rating") %> <i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i></p>
                        <% } else if(rating >= 4 && rating < 5) { %>
                        <p class="flight-info"><b>Rating:</b> <%=obj.getDouble("rating") %> <i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i></p>
                        <% } else { %>
                        <p class="flight-info"><b>Rating:</b> <%=obj.getDouble("rating") %> <i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i></p>
                        <% } %>
                        <p class="flight-info"><b>From:</b> <%=obj.getString("depCountry") %>, <%=obj.getString("depCity") %></p>
                        <p class="flight-info"><b>To:</b> <%=obj.getString("desCountry") %>, <%=obj.getString("desCity") %></p>
                        <p class="flight-info"><b>Price:</b> <%=obj.getDouble("price") %>&euro;</p>
                        <p class="flight-info"><b>Available Seats:</b> <%=obj.getInt("capacity") %></p>
                        <p class="flight-info"><b>Departure DateTime:</b> <%=obj.getString("depDateTime") %> <i class="fa fa-calendar"></i></p>
                        <p class="flight-info"><b>Destination DateTime:</b> <%=obj.getString("desDateTime") %> <i class="fa fa-calendar"></i></p>
                        <p class="flight-info"><b>Duration:</b> <%=obj.getInt("duration") %> min. <i class="fa fa-clock"></i></p>
                        <p class="flight-info"><b>Departure Temprature: </b><%=obj.getString("depTemp") %> &#8451;</p>
                        <p class="flight-info"><b>Departure Humidity: </b> <%=obj.getString("depHumidity") %>&percnt;</p>
                        <p class="flight-info"><b>Departure Wind: </b><%=obj.getString("depWind") %>  m/s <i class="fa fa-wind"></i></p>
                        <p class="flight-info"><b>Destination Temprature: </b> <%=obj.getString("desTemp") %> &#8451;</p>
                        <p class="flight-info"><b>Destination Humidity: </b>  <%=obj.getString("desHumidity") %>&percnt;</p>
                        <p class="flight-info"><b>Destination Wind: </b> <%=obj.getString("desWind") %> m/s <i class="fa fa-wind"></i></p>
                        <button type="button" onclick="goToPage('user_main_page.jsp')" class="btn-small mt-3 btn-dark reserve-btn">Back</button>
                    </div>
                </div>
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

