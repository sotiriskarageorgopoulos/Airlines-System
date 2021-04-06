<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.sun.jersey.api.client.Client" %>
<%@ page import="com.sun.jersey.api.client.ClientResponse" %>
<%@ page import="com.sun.jersey.api.client.WebResource" %>
<%@ page import="kar.sot.airlines.model.Message" %>
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
        <div class="row mt-5">
            <div class="col-sm-4">
            	<%
            		final String ENDPOINT_URL_PROFILE = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/ProfileService/";
            	    final String ENDPOINT_URL_MESSAGE = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/MessageService/";
            			
            		Client client = Client.create();
            		String params = "user_messages";
            		WebResource webResource = client.resource(ENDPOINT_URL_MESSAGE+params);
            		ClientResponse res = webResource.accept("application/json").get(ClientResponse.class);
            		String messageString = res.getEntity(String.class);
            		if(!messageString.equals(" ")) {
	            		JSONArray arr = new JSONArray(messageString);
	            		for(int i=0; i < arr.length();i++) {
	            			JSONObject messageObj = arr.getJSONObject(i);
	            			Client clientUserInfo = Client.create();
	            			String paramUserInfo = "get_profile_info/"+messageObj.getString("userId")+"/user";
	            			WebResource webResourceUserInfo = clientUserInfo.resource(ENDPOINT_URL_PROFILE+paramUserInfo);
	            			ClientResponse resUserInfo = webResourceUserInfo.accept("application/json").get(ClientResponse.class);
	            			String userInfoString = resUserInfo.getEntity(String.class);
	            			JSONObject userObj = new JSONObject(userInfoString);
            	%>
                <div class="card text-center">
                    <div class="card-header">
                        <%=userObj.getString("username") %>
                    </div>
                    <div class="card-body">
                        <h5 class="card-title">Subject:  <%=messageObj.getString("subject").replaceAll("_", " ") %></h5>
                        <p class="card-text"> <%=messageObj.getString("text").replaceAll("_", " ") %></p>
                        <button type="button" name="answer-message" class="btn btn-dark" onclick="addMessageBox('<%=userObj.getString("username") %>','<%=messageObj.getString("userId") %>')">Answer</button>
                    </div>
                </div>
                <% }
                if(request.getParameter("message-btn") != null) {
             	   String messageId = UUID.randomUUID().toString();
             	   String adminId = String.valueOf(session.getAttribute("id"));
             	   String subject = request.getParameter("subject").replaceAll(" ", "_");
             	   String message = request.getParameter("message").replaceAll(" ", "_");
             	   String userId = request.getParameter("userId");
             	   
             	   Message m = new Message(adminId,userId,messageId,subject,message);
             	   String paramMessage = "send_message/"+m.getMessageId()+"/"+m.getReceiverId()+"/"+m.getSenderId()+"/"+m.getSubject()+"/"+m.getText();
             	   Client clientMessageToUser = Client.create();
             	   WebResource webResourceMessageToUser = clientMessageToUser.resource(ENDPOINT_URL_MESSAGE+paramMessage);
             	   ClientResponse resMessageToUser = webResourceMessageToUser.accept("text/plain").post(ClientResponse.class);
             	   
                }  
	            		
            		  }
                %>
            </div>
            <div class="col-sm-4">
                <div id="message-box"></div>
            </div>
            <div class="col-sm-4"></div>
        </div>
    </section>
    <footer class="mt-5 row admin-footer-discounts">
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