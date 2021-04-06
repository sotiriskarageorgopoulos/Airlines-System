<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.sun.jersey.api.client.Client" %>
<%@ page import="com.sun.jersey.api.client.ClientResponse" %>
<%@ page import="com.sun.jersey.api.client.WebResource" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="kar.sot.airlines.model.Message" %>
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
    	final String ENDPOINT_URL_MESSAGE = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/MessageService/";
        int notifications = Integer.valueOf(String.valueOf(session.getAttribute("notifications")));
    	String userId = String.valueOf(session.getAttribute("id"));
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
        <div class="row">
            <div class="col-sm-4">
               <% 
               		Client clientAdminMessage = Client.create();
               		String paramAdminMessage = "admin_messages/"+userId;
               		WebResource webResourceAdminMessage = clientAdminMessage.resource(ENDPOINT_URL_MESSAGE+paramAdminMessage);
               		ClientResponse resAdminMessage = webResourceAdminMessage.accept("application/json").get(ClientResponse.class);
               		String adminMessageString = resAdminMessage.getEntity(String.class);
               		if(!adminMessageString.equals(" ")) {
	               		JSONArray arr = new JSONArray(adminMessageString);
	               		for(int i=0;i<arr.length();i++) {
	               			JSONObject obj = arr.getJSONObject(i);
               %>
            	<div class="card text-center mt-5">
                    <div class="card-header">
                        Admin
                    </div>
                    <div class="card-body">
                        <h5 class="card-title">Subject:  <%=obj.getString("subject").replaceAll("_"," ") %></h5>
                        <p class="card-text"> <%=obj.getString("text").replaceAll("_"," ") %></p>
                    </div>
                </div>
                <% }} %>
            </div>
            <div class="col-sm-4">
            <%
            	if(request.getParameter("send-message") != null) {
            		String messageId = UUID.randomUUID().toString();
            		String subject = request.getParameter("subject").replaceAll(" ","_");
            		String desc = request.getParameter("description").replaceAll(" ","_");
            		
            		Client client = Client.create();
            		String params = "send_message/"+messageId+"/"+userId+"/"+subject+"/"+desc;
            		WebResource webResource = client.resource(ENDPOINT_URL_MESSAGE+params);
            		ClientResponse res = webResource.accept("text/plain").post(ClientResponse.class);
            	} 
            %>
                <form method="POST" class="mt-5">
                    <h2>Message to Admin</h2>
                    <label for="subject" class="form-label">Subject: </label>
                    <input type="text" name="subject" id="subject" class="form-control" required>
                    <label for="description" class="form-label">Description: </label>
                    <textarea name="description" rows="6" id="description" class="form-control" placeholder="Text here..."></textarea>
                    <button type="submit" name="send-message" class="mt-3 btn btn-dark">Send</button>
                </form>
            </div>
            <div class="col-sm-4"></div>
        </div>
    </div>
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

</html>