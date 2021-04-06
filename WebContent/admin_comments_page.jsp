<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.sun.jersey.api.client.Client" %>
<%@ page import="com.sun.jersey.api.client.ClientResponse" %>
<%@ page import="com.sun.jersey.api.client.WebResource" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<!DOCTYPE html>
<html lang="en">
<%
	final String ENDPOINT_URL = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/CommentService/";
	String paramComment = "get_user_comments";
	Client clientComments = Client.create();
	WebResource webResourceComments = clientComments.resource(ENDPOINT_URL+paramComment);
	ClientResponse res = webResourceComments.accept("application/json").get(ClientResponse.class);
	String commentString = res.getEntity(String.class);
	JSONArray arr = new JSONArray(commentString);
%>
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
        <div class="mt-5 row">
            <div class="col-sm-4"></div>
            <div class="col-sm-4">
                <h2 class="mb-3 insert-header">Comments of Users</h2>
             	<% 
                	if(request.getParameter("delComment") != null) {
                		String commentId = request.getParameter("commentId");
                		String paramDel = "delete_comment/"+commentId;
                		Client clientDel = Client.create();
                	    WebResource webResourceDel = clientDel.resource(ENDPOINT_URL+paramDel);
                	    ClientResponse resDel = webResourceDel.accept("text/plain").delete(ClientResponse.class); 
               %>
                <script>window.location.href=window.location.href</script>
                <% 
                	}
                	for(int i=0; i < arr.length();i++) {
                %>
                <div class="card text-center mt-4">
                    <div class="card-header">
                        <%=arr.getJSONObject(i).getString("username") %>
                    </div>
                    <div class="card-body">
                        <h5 class="card-title"><%=arr.getJSONObject(i).getString("airline") %></h5>
                        <p class="card-text"><%=arr.getJSONObject(i).getString("description").replaceAll("_", " ") %></p>
                        <form method="POST" class="no-form-style">
                        	<input type="hidden" name="commentId" value="<%=arr.getJSONObject(i).getString("commentId") %>">
                        	<button type="submit" name="delComment" class="btn btn-danger">Delete Comment</button>
                        </form>	
                    </div>
                    <div class="card-footer text-muted">
                        <%=arr.getJSONObject(i).getString("submissionDate") %>
                    </div>
                </div>
                <% } %>
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

</html>