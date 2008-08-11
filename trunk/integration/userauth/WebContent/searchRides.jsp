<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*" %>

<%
//force the user to login to view the page
if (OpenIdFilter.getCurrentUser(request.getSession()) == null) {
	response.sendRedirect(request.getContextPath()+"/index.jsp");
}

boolean ridesExist = false;
String rideTable = "<p>No rides found.</p>";
CarPoolStore cps = new CarPoolStoreImpl();
RideListing rl = cps.getRideListing();
if (rl.next()) {
	ridesExist = true;
	rideTable = "<table class='rideDetails'> <tr> <th> Offered By </th> <th> From </th> <th> To </th> <th> Date </th> <th> Time </th> <th> Available Seats </th> </tr>";
	rideTable += "<tr> <td>"+ rl.getUsername() +"</td> ";
	rideTable += "<td> <a href='"+ request.getContextPath() +"/welcome.jsp?rideselect="+ rl.getRideID() +"'>"+ rl.getStartLocation() +"</a> </td> ";
	rideTable += "<td>"+ rl.getEndLocation() +"</td> ";
	rideTable += "<td>"+ rl.getRideDate() +"</td> ";
	rideTable += "<td> null </td> ";
	rideTable += "<td>"+ rl.getAvailableSeats() +"</td> </tr>";
}
while (rl.next()) {
	rideTable += "<tr> <td>"+ rl.getUsername() +"</td> ";	
	rideTable += "<td> <a href='"+ request.getContextPath() +"/welcome.jsp?rideselect="+ rl.getRideID() +"'>"+ rl.getStartLocation() +"</a> </td> ";
	rideTable += "<td>"+ rl.getEndLocation() +"</td> ";
	rideTable += "<td>"+ rl.getRideDate() +"</td> ";
	rideTable += "<td> null </td> ";
	rideTable += "<td>"+ rl.getAvailableSeats() +"</td> </tr>";
}
if (ridesExist) {
	rideTable += "</table>";
}
//int dbID = cps.getUserIdByURL(request.getParameter("user"));
%>

<HTML>
	<HEAD>
		<TITLE>Ride Search</TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

		<DIV class="content">
			<%=rideTable %>
		</DIV>

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</BODY>
</HTML>