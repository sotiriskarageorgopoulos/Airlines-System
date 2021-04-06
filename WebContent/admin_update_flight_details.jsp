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
        <div class="row p-3">
        	<a class="nav-link text-white" href="login.jsp"><i class="fa fa-sign-in mr-2" aria-hidden="true"></i></a>
    	</div>
    </div>
</nav>
<body>
<section class="container-fluid">
        <div class="row mt-5">
            <div class="col-sm-4"></div>
            <div class="col-sm-4">
            	<%
            		final String ENDPOINT_URL_DEPARTURE = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/DepartureService/";
            	    final String ENDPOINT_URL_DESTINATION = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/DestinationService/";
            	    final String ENDPOINT_URL_WEATHER = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/WeatherService/";
            		final String ENDPOINT_URL_FLIGHT = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/FlightService/";
   
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
            	
            		Client clientFlight = Client.create();
            		String paramFlight = "flight_info";
            		WebResource webResourceFlight = clientFlight.resource(ENDPOINT_URL_FLIGHT+paramFlight);
            		ClientResponse resFlightInfo = webResourceFlight.accept("application/json").get(ClientResponse.class);
            		String flightInfoString = resFlightInfo.getEntity(String.class);
            		JSONArray flightInfo = new JSONArray(flightInfoString);
            		for(int i=0; i < flightInfo.length();i++) {
            			JSONObject infoObj = flightInfo.getJSONObject(i);
            			
            			if(!infoObj.getBoolean("cancelled")) {
            			
            			Client thirdPartyClientDep = Client.create();
            		  	WebResource webResourceThirdPartyClientDep = thirdPartyClientDep.resource("https://restcountries.eu/rest/v2/name/"+infoObj.getString("depCountry"));
            		  	ClientResponse thirdPartyResDep = webResourceThirdPartyClientDep.accept("application/json").get(ClientResponse.class);
            		  	String jsonThirdPartyClientStringDep = thirdPartyResDep.getEntity(String.class);
            		  	JSONArray countryArrDep = new JSONArray(jsonThirdPartyClientStringDep);
            		  	JSONObject countryDep = countryArrDep.getJSONObject(0);
            		  
            		  	Client thirdPartyClientDes = Client.create();
            		  	WebResource webResourceThirdPartyClientDes = thirdPartyClientDes.resource("https://restcountries.eu/rest/v2/name/"+infoObj.getString("desCountry"));
            		  	ClientResponse thirdPartyResDes = webResourceThirdPartyClientDes.accept("application/json").get(ClientResponse.class);
            		  	String jsonThirdPartyClientStringDes = thirdPartyResDes.getEntity(String.class);
            		  	JSONArray countryArrDes = new JSONArray(jsonThirdPartyClientStringDes);
            		  	JSONObject countryDes = countryArrDes.getJSONObject(0);
            	%>
                <div class="card">
                    <div class="card-body">
                        <p class="flight-info"><b>Flight Number:</b> <%=infoObj.getString("flightNumber") %></p>
                        <p class="flight-info"><b>From:</b> <%=infoObj.getString("depCountry") %>, <%=infoObj.getString("depCity") %></p>
                        <p class="flight-info"><b>To:</b> <%=infoObj.getString("desCountry") %>, <%=infoObj.getString("desCity") %></p>
                        <p class="flight-info"><b>Price:</b> <%=infoObj.getDouble("ticketPrice") %>&euro;</p>
                        <p class="flight-info"><b>Departure Date/Time:</b> <%=infoObj.getString("depDateTime") %> <i class="fa fa-calendar"></i></p>
                        <p class="flight-info"><b>Destination Date/Time:</b> <%=infoObj.getString("desDateTime") %> <i class="fa fa-calendar"></i></p>
                        <p class="flight-info"><b>Duration:</b> <%=infoObj.getInt("duration") %> min. <i class="fa fa-clock"></i></p>
                        <h4><%=infoObj.getString("depCountry") %>, <%=infoObj.getString("depCity") %> <img src="<%=countryDep.getString("flag") %>" width="25" height="20"></h4>
                        <p class="flight-info"><b>Temprature:</b> <%=infoObj.getString("depTemp") %> &#8451;</p>
                        <p class="flight-info"><b>Humidity:</b> <%=infoObj.getString("depHumidity") %>&percnt;</p>
                        <p class="flight-info"><b>Wind:</b> <%=infoObj.getString("depWind") %> meter/sec <i class="fa fa-wind"></i></p>
                        <h4><%=infoObj.getString("desCountry") %>, <%=infoObj.getString("desCity") %>  <img src="<%=countryDes.getString("flag") %>" width="25" height="20"></h4>
                        <p class="flight-info"><b>Temprature:</b> <%=infoObj.getString("desTemp") %> &#8451;</p>
                        <p class="flight-info"><b>Humidity:</b> <%=infoObj.getString("desHumidity") %> &percnt;</p>
                        <p class="flight-info"><b>Wind:</b> <%=infoObj.getString("desWind") %> meter/sec <i class="fa fa-wind"></i></p>
                        <button type="button" onclick="goToPage('update_dep_time.jsp?flightNumber=<%=infoObj.getString("flightNumber") %>')" class="mt-3 btn-small btn btn-warning">Update Departure DateTime</button>
                        <button type="button" onclick="goToPage('update_des_time.jsp?flightNumber=<%=infoObj.getString("flightNumber") %>')" class="mt-3 btn-small btn btn-warning">Update Destination DateTime</button>
                        <%
                        	if(request.getParameter("del-flight-btn") != null) {
                        		String flightNumber = request.getParameter("flightNumber");
                        		String param = "cancel_flight/"+flightNumber;
                        		Client client = Client.create();
                        		WebResource webResource = client.resource(ENDPOINT_URL_FLIGHT+param);
                        		ClientResponse res = webResource.accept("text/plain").put(ClientResponse.class);
                        %>
                        <script>window.location.href = window.location.href</script>
                        <%
                        	}
                        %>
                        <form method="POST" class="no-form-style-del-account">
                        	<input type="hidden" name="flightNumber" value="<%=infoObj.getString("flightNumber") %>">
                        	<button type="submit" name="del-flight-btn" class="mt-3 btn-small btn btn-danger">Cancel Flight</button>
                        </form>
                    </div>
                </div>
               <% }
            			}%>
            </div>
            <div class="col-sm-4"></div>
        </div>
    </section>
	<footer class="mt-5 row admin-footer-flight">
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