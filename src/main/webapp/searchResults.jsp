<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.net.URLEncoder" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Search Results</title>

<style>

body {
    font-family: Arial, sans-serif;
    background: #f4f4f4;
    margin: 0;
}

.container {
    width: 95%;
    max-width: 1300px;
    margin: 70px auto;
    padding: 30px;
    background: white;
    border-radius: 8px;
    box-shadow: 0 0 10px lightgray;
}

h2 {
    text-align: center;
    color: green;
}

.search-info {
    text-align: center;
    margin-bottom: 25px;
    font-size: 18px;
}

table {
    width: 100%;
    border-collapse: collapse;
}

th {
    background: #cc0033;
    color: white;
    padding: 12px;
}

td {
    border: 1px solid #ddd;
    padding: 12px;
    text-align: center;
}

tr:nth-child(even) {
    background: #f7f7f7;
}

.message {
    text-align: center;
    margin-top: 30px;
    font-size: 18px;
}

.button-area {
    text-align: center;
}

.button {
    display: inline-block;
    margin-top: 25px;
    padding: 12px 25px;
    background: #cc0033;
    color: white;
    text-decoration: none;
    border-radius: 5px;
}

.button:hover {
    background: #a30029;
}

.small-button {
    display: inline-block;
    padding: 8px 12px;
    background: #cc0033;
    color: white;
    text-decoration: none;
    border-radius: 4px;
    white-space: nowrap;
}

.small-button:hover {
    background: #a30029;
}

</style>

</head>
<body>

<div class="container">

<h2>Train Schedule Search Results</h2>

<%
String origin = request.getParameter("origin");
String destination = request.getParameter("destination");
String travelDate = request.getParameter("travelDate");
String sortBy = request.getParameter("sortBy");

if (origin != null) {
    origin = origin.trim();
}

if (destination != null) {
    destination = destination.trim();
}


String orderBy = "s.DepartureDateTime";

if ("arrival".equals(sortBy)) {
    orderBy = "s.ArrivalDateTime";
} else if ("fare".equals(sortBy)) {
    orderBy = "t.Fare";
}

String sortLabel = "Departure Time";

if ("arrival".equals(sortBy)) {
    sortLabel = "Arrival Time";
} else if ("fare".equals(sortBy)) {
    sortLabel = "Fare";
}

String url = "jdbc:mysql://localhost:3306/railway_booking";
String dbUser = "root";
String dbPassword = "";

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

boolean found = false;

SimpleDateFormat formatter =
    new SimpleDateFormat("MMM d, yyyy h:mm a");
%>

<div class="search-info">

<strong>Origin:</strong>
<%= origin %>

&nbsp;&nbsp;|&nbsp;&nbsp;

<strong>Destination:</strong>
<%= destination %>

&nbsp;&nbsp;|&nbsp;&nbsp;

<strong>Date:</strong>
<%= travelDate %>

&nbsp;&nbsp;|&nbsp;&nbsp;

<strong>Sorted By:</strong>
<%= sortLabel %>

</div>

<%
if (origin == null ||
    destination == null ||
    travelDate == null ||
    origin.isEmpty() ||
    destination.isEmpty() ||
    travelDate.isEmpty()) {
%>

<p class="message">
Please provide an origin, destination, and travel date.
</p>

<%
} else {

    try {

        Class.forName("com.mysql.cj.jdbc.Driver");

        con = DriverManager.getConnection(
            url,
            dbUser,
            dbPassword
        );

        String sql =
            "SELECT s.ScheduleID, s.TrainID, s.DepartureDateTime, " +
            "s.ArrivalDateTime, s.TravelTime, t.LineName, t.Fare " +
            "FROM Schedule s " +
            "JOIN TransitLine t ON s.LineName = t.LineName " +
            "JOIN Station originStation " +
            "ON t.OriginID = originStation.StationID " +
            "JOIN Station destinationStation " +
            "ON t.DestinationID = destinationStation.StationID " +
            "WHERE originStation.StationName = ? " +
            "AND destinationStation.StationName = ? " +
            "AND DATE(s.DepartureDateTime) = ? " +
            "ORDER BY " + orderBy;

        ps = con.prepareStatement(sql);

        ps.setString(1, origin);
        ps.setString(2, destination);
        ps.setString(3, travelDate);

        rs = ps.executeQuery();
%>

<table>

<tr>
    <th>Schedule ID</th>
    <th>Train</th>
    <th>Transit Line</th>
    <th>Departure</th>
    <th>Arrival</th>
    <th>Travel Time</th>
    <th>Fare</th>
    <th>Stops</th>
    <th>Reservation</th>
</tr>

<%
while (rs.next()) {

    found = true;

    int scheduleID =
        rs.getInt("ScheduleID");

    Timestamp departure =
        rs.getTimestamp("DepartureDateTime");

    Timestamp arrival =
        rs.getTimestamp("ArrivalDateTime");

    String encodedOrigin =
        URLEncoder.encode(origin, "UTF-8");

    String encodedDestination =
        URLEncoder.encode(destination, "UTF-8");
%>

<tr>

<td>
    <%= scheduleID %>
</td>

<td>
    <%= rs.getString("TrainID") %>
</td>

<td>
    <%= rs.getString("LineName") %>
</td>

<td>
    <%= formatter.format(departure) %>
</td>

<td>
    <%= formatter.format(arrival) %>
</td>

<td>
    <%= rs.getInt("TravelTime") %> minutes
</td>

<td>
    $<%= rs.getBigDecimal("Fare") %>
</td>

<td>
    <a class="small-button"
       href="viewStops.jsp?scheduleID=<%= scheduleID %>">
        View Stops
    </a>
</td>

<td>
    <a class="small-button"
       href="makeReservation.jsp?scheduleID=<%= scheduleID %>&origin=<%= encodedOrigin %>&destination=<%= encodedDestination %>">
        Reserve
    </a>
</td>

</tr>

<%
}
%>

</table>

<%
if (!found) {
%>

<p class="message">
No matching train schedules were found.
</p>

<%
}

    } catch (Exception e) {
%>

<p class="message">
Error:
<br><br>
<%= e.getMessage() %>
</p>

<%
    } finally {

        try {

            if (rs != null) {
                rs.close();
            }

            if (ps != null) {
                ps.close();
            }

            if (con != null) {
                con.close();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
%>

<div class="button-area">

<a class="button" href="search.jsp">
    Search Again
</a>

</div>

</div>

</body>
</html>