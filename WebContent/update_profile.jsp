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
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <a class="navbar-brand p-3" href="#">Airlines Ticket Reservation System</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <%
    	String category = (String)session.getAttribute("category"); 
    	if (category.equals("user")){
    %>
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
		 <a class="nav-link text-white" href="user_notification_page.jsp">
			        <i class="fa fa-bell" aria-hidden="true">
			        <% 
			        	int notifications = Integer.valueOf(String.valueOf(session.getAttribute("notifications")));
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
    <%} else if (category.equals("admin")) { %>
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
    <% } %>
</nav>

<body>
    <section class="container-fluid">
        <div class="row">
        	<% 
        	  final String ENDPOINT_URL_PROFILE = "http://localhost:8080/AirlineTicketReservationSystem/airlines_reservation_sys/ProfileService/";
        	  Client client = Client.create();
        	  String id = (String) session.getAttribute("id");
        	  String password = (String) session.getAttribute("password");
        	  String params = "get_profile_info/"+id+"/"+category;
			  WebResource webResource = client.resource(ENDPOINT_URL_PROFILE+params);
  		  	  ClientResponse profileInfoRes = webResource.accept("application/json").get(ClientResponse.class);
  		  	  String jsonProfileInfoString = profileInfoRes.getEntity(String.class);
  		  	  JSONObject profileInfo = new JSONObject(jsonProfileInfoString);
  		  	  
  		  	  Client thirdPartyClient = Client.create();
  		  	  WebResource webResourceThirdPartyClient = thirdPartyClient.resource("https://restcountries.eu/rest/v2/alpha/"+profileInfo.getString("nationality"));
  		  	  ClientResponse thirdPartyRes = webResourceThirdPartyClient.accept("application/json").get(ClientResponse.class);
  		  	  String jsonThirdPartyClientString = thirdPartyRes.getEntity(String.class);
  		  	  JSONObject country = new JSONObject(jsonThirdPartyClientString);
        	%>
            <div class="col-sm-4 admin-info-box">
                <h4>Profile's Information</h4>
                <p><b>ID:</b> <%=id %></p>
                <p><b>Name:</b> <%=profileInfo.getString("name") %></p>
                <p><b>Surname:</b> <%=profileInfo.getString("surname") %></p>
                <p><b>Username:</b> <%=profileInfo.getString("username") %></p>
                <p><b>Email:</b> <%=profileInfo.getString("email") %></p>
                <p><b>Password:</b> <%=password %></p>
                <p><b>Phone Number:</b> <%=profileInfo.getString("phone") %></p>
                <p><b>Nationality:</b> <img src="<%=country.getString("flag") %>" width="25" height="20"> <%=country.getString("name") %></p>
                <p><b>Birth Date:</b> <%=profileInfo.getString("birthDate") %></p>
            </div>
            <div class="col-sm-4">
            	<%
            		if(request.getParameter("update-btn-email") != null) {
            			String email = request.getParameter("email");
            			String paramsEmail = "update_email/"+id+"/"+email+"/"+category;
            			Client clientUpdEmail = Client.create();
            			WebResource webResourceEmail = clientUpdEmail.resource(ENDPOINT_URL_PROFILE+paramsEmail);
            			ClientResponse resUpdEmail = webResourceEmail.accept("text/plain").put(ClientResponse.class);%>
            		<script>window.location.href =  window.location.href</script>		
            	<%
            		}
            	%>
                <form method="POST" class="update-email-form">
                    <h2>Update email</h2>
                    <label for="email" class="label-form">Email: </label>
                    <input type="email" name="email" id="email" class="form-control">
                    <button type="submit" name="update-btn-email" class="btn btn-dark btn-submit">Submit</button>
                </form>
                <%
                	if(request.getParameter("update-btn-password") != null) {
                		String psw = request.getParameter("psw");
                		String paramsPass = "update_password/"+id+"/"+psw+"/"+category;
                		Client clientUpdPass = Client.create();
                		WebResource webResourcePass = clientUpdPass.resource(ENDPOINT_URL_PROFILE+paramsPass);
                		ClientResponse resUpdPass = webResourcePass.accept("text/plain").put(ClientResponse.class);
                		session.setAttribute("password",psw);
                	%>
                	<script>window.location.href =  window.location.href</script>		
                	<%			
                	}
                %>
                <form method="POST" class="update-psw-form">
                    <h2>Update Password</h2>
                    <label for="psw" class="form-label">Password: </label>
                    <input type="password" name="psw" id="psw" class="form-control">
                    <button type="submit" name="update-btn-password" class="btn btn-dark btn-submit">Submit</button>
                </form>
                <%
                 if(request.getParameter("update-btn-phone") != null) {
                	 String phoneNumber = request.getParameter("phoneNumber");
                	 String paramsPhone = "update_phone_number/"+id+"/"+phoneNumber+"/"+category;
                	 Client clientUpdPhone = Client.create();
                	 WebResource webResourcePhone = clientUpdPhone.resource(ENDPOINT_URL_PROFILE+paramsPhone);
                	 ClientResponse resUpdPhone = webResourcePhone.accept("text/plain").put(ClientResponse.class);
                %>
                <script>window.location.href =  window.location.href</script>
                <%
                 }
                %>
                <form method="POST" class="update-phone-num-form">
                    <h2>Update Phone Number</h2>
                    <label for="phoneNumber" class="form-label">Phone Number: </label>
                    <input type="tel" name="phoneNumber" id="phoneNumber" class="form-control">
                    <button type="submit" name="update-btn-phone" class="btn btn-dark btn-submit">Submit</button>
                </form>
            </div>
            <div class="col-sm-4">
            	<%
            	 if(request.getParameter("delete-account-btn") != null) {
            		 String paramDel = "delete_account/"+id+"/"+category;
            		 Client clientDelAccount = Client.create();
            		 WebResource webResourceDelAccount = clientDelAccount.resource(ENDPOINT_URL_PROFILE+paramDel);
            		 ClientResponse resDelAccount = webResourceDelAccount.accept("text/plain").delete(ClientResponse.class);
            		 response.sendRedirect("http://localhost:8080/AirlineTicketReservationSystem/login.jsp");
            	 }
            	%>
                <form method="POST" class="no-form-style-del-account mt-5">
                    <button type="submit" name="delete-account-btn" class="btn btn-danger mt-5">Delete Account</button>
                </form>
            </div>
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