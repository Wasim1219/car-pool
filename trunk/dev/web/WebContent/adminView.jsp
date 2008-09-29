<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page contentType="text/html; charset=ISO-8859-1" import="java.util.*, java.text.*, org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*,car.pool.persistance.test.*, car.pool.locations.*"%>

<%
HttpSession s = request.getSession(false);

//force the user to login to view the page
if (OpenIdFilter.getCurrentUser(s) == null && s.getAttribute("signedin") == null) {
	response.sendRedirect(request.getContextPath()+"/index.jsp");
}
CarPoolStore cps = new CarPoolStoreImpl();
String[] locations = LocationImporter.importLocations();

if (request.getParameter("locations") != null) {
	String loc = request.getParameter("locations");	
	System.out.println(loc);	
	   //dosomething
	int region = -1;
	region = cps.addRegion("Palmerston North");	
			 cps.addLocation(region, loc);
			 System.out.println("street: "+loc);
}

String uName;
String uEmail;
String uPhone;
String uSignUpDate;
UserList nList = cps.getUserName();
UserList eList = cps.getUserEmail();
UserList pList = cps.getUserPhone();
UserList sList = cps.getUserSignUpDate();

String Table = "";
String userTable ="";
while (nList.next()){
	uName 	= nList.getUserName();
	uEmail 	= nList.getUserEmail();
	uPhone	= nList.getUserPhone();
	uSignUpDate 	= nList.getUserSignUpDate();
	Table += "<tr> <td>"+ uName +"</td> ";
	Table += "<td>"+ uEmail +"</td> ";
	Table += "<td>"+ uPhone +"</td> ";
	Table += "<td>"+ uSignUpDate +"</td> </tr>";
}
userTable = "<table class='rideDetailsSearch'> <tr> <th>User Name</th> <th>Email</th> <th>Phone</th>"+
"<th>Sign Up Date</th> </tr>"+ Table +"</table>";


ArrayList<Integer> avoidDuplicates = new ArrayList<Integer>();
String rideTable = "";
String userName;
UserList rList = cps.getUserName();
//String username = nList.getUserName();
boolean userExist = false;

while (rList.next()){
	userName = rList.getUserName();
if (userName != null)	{
	RideListing u = cps.searchRideListing(RideListing.searchUser, userName);
	
	while (u.next()) {
		if (!userExist) {
			rideTable = "";		//first time round get rid of unwanted text
		}
		userExist = true;
		
		String from = u.getEndLocation();
		String to = u.getStartLocation();

		if (!avoidDuplicates.contains(u.getRideID())){
			avoidDuplicates.add(u.getRideID());
			
			rideTable += "<tr> <td>"+ u.getUsername() +"</td> ";	
			rideTable += "<td>"+ from +"</td> ";
			rideTable += "<td>"+ to +"</td> ";
			rideTable += "<td>"+ u.getRideDate() +"</td> ";
			rideTable += "<td>"+ u.getTime() +"</td> ";
			rideTable += "<td>"+ u.getAvailableSeats() +"</td> ";
			rideTable += "<td> <a href='"+ request.getContextPath() +"/temp2.jsp?rideselect="+ u.getRideID() +"&userselect="+u.getUsername()+"'>"+ "Link to ride page" +"</a> </td> </tr>";					
		}
		else {
			rideTable = "";
		}

	}
	rideTable = "<table class='rideDetailsSearch'> <tr> <th>Ride Offered By</th> <th>Starting From</th> <th>Going To</th>"+
	"<th>Departure Date</th> <th>Departure Time</th> <th>Number of Available Seats</th> <th>More Info</th> </tr>"+ rideTable +"</table>";
}
else{
	rideTable = "No rides in the system";
}
}


%>
		

<%@page import="car.pool.persistance.test.AddLocations"%><HTML>
	<HEAD>
		<TITLE> Administration Tasks</TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
		<SCRIPT type="text/javascript">

		function FindProxyForURL(url, host)
		{
		  if (host == "localhost" || host == "127.0.0.1") {
		     return "DIRECT;";
		  }

		  if (host == "alb-lab-iis" || host == "alb-lab-iis.massey.ac.nz") {
		     return "DIRECT;";
		  }

		  if (host == "wel-lab-iis" || host == "wel-lab-iis.massey.ac.nz") {
		     return "DIRECT;";
		  }

		  if (host == "tur-lab-iis" || host == "tur-lab-iis.massey.ac.nz") {
		     return "DIRECT;";
		  }

		  if (host == "atlasv" || host == "atlasv.massey.ac.nz") {
		     return "DIRECT;";
		  }
		
		// EXCEPTIONS
		// Handle exceptions for sites in Massey DNS domain but outside Massey network
		  if ( host == "digitalcommons.massey.ac.nz" || host =="digitalcommons") {
		     ret = URLiphash(myIpAddress());
		     if ( (ret % 2) == 1 ) {
		        return "PROXY tur-cache1.massey.ac.nz:8080; PROXY tur-cache2.massey.ac.nz:8080";
		     } else  {
		        return "PROXY tur-cache2.massey.ac.nz:8080; PROXY tur-cache1.massey.ac.nz:8080";
		     }
		  }

		// EVERYONE ELSE
		
		// If you are going to a Massey site or you haven't appended a domain,then
		// you can go direct
		  if (isPlainHostName(host) || dnsDomainIs(host, ".massey.ac.nz") || dnsDomainIs(host, ".mass-e-mall.co.nz") || dnsDomainIs(host, ".mass-e-mall.com")) {
		     return "DIRECT;";
		  }

		//
		// Albany Network Block
		//
		  if (isInNet(myIpAddress(), "130.123.224.0", "255.255.224.0") || isInNet(myIpAddress(), "10.101.224.0", "255.255.254.0")) {
		     return "PROXY alb-cache.massey.ac.nz:8080; PROXY tur-cache1.massey.ac.nz:8080";
		  }

		//
		// Wellington Network Block
		//
		  if (isInNet(myIpAddress(), "130.123.192.0", "255.255.224.0")  || isInNet(myIpAddress(), "10.101.192.0", "255.255.254.0")) {
		     return "PROXY wel-cache.massey.ac.nz:8080; PROXY tur-cache2.massey.ac.nz:8080";
		  }

		//
		// Hokowhitu Network Block
		//
		  if (isInNet(myIpAddress(), "130.123.4.0", "255.255.252.0")) {
		     return "PROXY tur-cache1.massey.ac.nz:8080; PROXY alb-cache.massey.ac.nz:8080";
		  }
		//
		// Singapore
		//
		  if (isInNet(myIpAddress(), "130.123.16.0", "255.255.255.0")) {
		     return "DIRECT;";
		  }

		//
		// If you aren't in Albany, Hokowhitu or Wellington, use the caches at Turitea
		//
		  ret = URLiphash(myIpAddress());
		  if ( (ret % 2) == 1 ) {
		     return "PROXY tur-cache1.massey.ac.nz:8080; PROXY tur-cache2.massey.ac.nz:8080";
		  } else  {
		     return "PROXY tur-cache2.massey.ac.nz:8080; PROXY tur-cache1.massey.ac.nz:8080";
		  }
		}
		
		function URLiphash(myIP) {
		  var s,last_octet;
		  s = myIP.split(".");
		  last_octet = s[3];
		  return last_octet ;
		}
		
		</script>
		<%@include file="include/javascriptincludes.html" %>
		</HEAD>
	<BODY>
		<DIV class="content">
			<h1>Administrative functions below</h1>
			<FORM NAME="admin" action="#" method="post" >				
				<table>
					<tr><td>Add new locations to database?</td>
						<td><INPUT type="text" name="locations" value="Enter location here..." size="30"></td>
						<td>&nbsp;</td> <td><INPUT type="submit" value="Add Locations" size="25" onClick="<%AddLocations.addFromFile();%>" ></td>
					</tr>
				</table>
			</FORM>
			<%//=locations.length %>
			&nbsp;	

			<FORM NAME="admin2" action="#">				
				<table>
					<tr><td>Add locations in database?</td>						
						<td>&nbsp;</td> <td><INPUT type="submit" value="Add Locations" size="25" onClick="<%AddLocations.addFromFile();%>"></td>
					</tr>
				</table>
			</FORM>
			<%//=locations.length %>
			&nbsp;	
			<FORM NAME="delComment" action="delAComment.jsp" method="post" >
				<table>
					<tr><td>Delete a comment</td>
						<td><INPUT type="text" name="idComment" value="Enter comment number here..." size="30"></td>
						<td>&nbsp;</td> <td><INPUT type="submit" value="Delete Comment" size="25"></td>
					</tr>
				</table>
			</FORM>

			<FORM NAME="resultFrm" id="result">	
				<TABLE class="rideSearch">
					<tr><td>All users in the system</td></tr>					
					<tr><td><%=userTable%></td></tr>					
					<tr><td>All rides in the system</td></tr>
					<%=rideTable %>					
				</TABLE>
			</FORM>
		</DIV>
	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</BODY>
</HTML>