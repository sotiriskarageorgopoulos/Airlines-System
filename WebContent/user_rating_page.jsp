<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.sun.jersey.api.client.Client" %>
<%@ page import="com.sun.jersey.api.client.ClientResponse" %>
<%@ page import="com.sun.jersey.api.client.WebResource" %>    
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %> 
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="kar.sot.airlines.model.Comment" %>
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
    	final String ENDPOINT_URL_RATING = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/RatingService/";
       	final String ENDPOINT_URL_AIRLINE = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/AirlineService/";
       	
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
                <form method="POST" class="mt-4 mb-4">
                    <h2>Rate Airlines</h2>
                    <label for="airlineId" class="form-label">Airlines: </label>
                    <select name="airlineId" id="airlineId" class="form-control" required>
                        <option value="">Select...</option>
                        <% 
                           Client clientAirline = Client.create();
                           String params = "get_airlines";
                           WebResource webResource = clientAirline.resource(ENDPOINT_URL_AIRLINE+params);
                           ClientResponse resAirlines = webResource.accept("application/json").get(ClientResponse.class);
                           String airlineString = resAirlines.getEntity(String.class);
                           JSONArray airlines = new JSONArray(airlineString);
                           for(int i=0; i < airlines.length();i++) {
                        %>
                        <option value="<%=airlines.getJSONObject(i).getString("airlineId") %>"><%=airlines.getJSONObject(i).getString("name") %></option>
                        <% } %>
                    </select>
                    <label for="review" class="form-label">Review: </label>
                    <textarea name="review" rows="6" id="review" placeholder="Text here..." class="form-control" required></textarea>
                    <h3>Rating</h3>
                    <div class="display-flex flex-column">
                        <label for="one">1</label>
                        <input type="checkbox" name="one" onclick="disableOrEnableCheckBoxes()" id="one" value="1" required>
                    </div>
                    <div class="display-flex flex-column">
                        <label for="two">2</label>
                        <input type="checkbox" name="two" onclick="disableOrEnableCheckBoxes()" id="two" value="2" required>
                    </div>
                    <div class="display-flex flex-column">
                        <label for="three">3</label>
                        <input type="checkbox" name="three" onclick="disableOrEnableCheckBoxes()" id="three" value="3" required>
                    </div>
                    <div class="display-flex flex-column">
                        <label for="four">4</label>
                        <input type="checkbox" name="four" onclick="disableOrEnableCheckBoxes()" id="four" value="4" required>
                    </div>
                    <div class="display-flex flex-column">
                        <label for="five">5</label>
                        <input type="checkbox" name="five" onclick="disableOrEnableCheckBoxes()" id="five" value="5" required>
                    </div>
                    <button type="submit" name="rating-btn" class="mt-3 btn btn-dark">Rate</button>
                </form>
                <%
                	if(request.getParameter("rating-btn") != null) {
                		DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
                		String commentId = UUID.randomUUID().toString();
                		String airlineId = request.getParameter("airlineId");
                		String review = request.getParameter("review").replaceAll(" ","_");
                		String one = request.getParameter("one");
                		String two = request.getParameter("two");
                		String three = request.getParameter("three");
                		String four = request.getParameter("four");
                		String five = request.getParameter("five");
                		LocalDateTime dateTime = LocalDateTime.now();
                		
                		int rating = 0;
                		
                		if(one != null) rating = Integer.valueOf(one);
                		if(two != null) rating = Integer.valueOf(two);
                		if(three != null) rating = Integer.valueOf(three);
                		if(four != null) rating = Integer.valueOf(four);
                		if(five != null) rating = Integer.valueOf(five);
                		
                		Client clientRating = Client.create();
                		Comment c = new Comment(commentId,userId,airlineId,dateTime,review,rating);
                		String paramsRating = "airline/rate/"+c.getCommentId()+"/"+c.getAirlineId()+"/"+c.getUserId()+"/"+c.getSubmissionDateTime().format(formatter)+"/"+c.getDescription()+"/"+c.getRating();
                		WebResource webResourceRating = clientRating.resource(ENDPOINT_URL_RATING+paramsRating);
                		ClientResponse resComment = webResourceRating.accept("text/plain").post(ClientResponse.class);
                		
                		Client clientAvg = Client.create();
                		String paramsAvg = "avgRating/"+airlineId;
                		WebResource webResourceAvg = clientAvg.resource(ENDPOINT_URL_RATING+paramsAvg);
                		ClientResponse res = webResourceAvg.accept("application/json").get(ClientResponse.class);
                		String avgString = res.getEntity(String.class);
                		JSONObject avgObj = new JSONObject(avgString);
                		double avg = avgObj.getDouble("average");
                		
                		Client clientUpdRating = Client.create();
                		String paramsUpdRating = "airline_rating_upd/"+c.getAirlineId()+"/"+avg;
                		WebResource webResourceUpdRating = clientUpdRating.resource(ENDPOINT_URL_RATING+paramsUpdRating);
                		ClientResponse resUpdRating = webResourceUpdRating.accept("text/plain").put(ClientResponse.class);
                	}
                %>
            </div>
        </div>
        <div class="col-sm-4"></div>
    </section>
    <footer class="mt-5 row user-footer-message-to-admin">
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