<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Reservations</title>

<style>

body {
    font-family: Arial, sans-serif;
    background: #f4f4f4;
    margin: 0;
}

.container {
    width: 95%;
    max-width: 1300px;
    margin: 50px auto;
    padding: 30px;
    background: white;
    border-radius: 8px;
    box-shadow: 0 0 10px lightgray;
}

h1 {
    text-align: center;
    color: green;
}

h2 {
    margin-top: 35px;
    color: #cc0033;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 15px;
}

th {
    background: #cc0033;
    color: white;
    padding: 11px;
}

td {
    border: 1px solid #dddddd;
    padding: 10px;
    text-align: center;
}

tr:nth-child(even) {
    background: #f7f7f7;
}

.message {
    text-align: center;
    font-size: 18px;
    margin: 25px 0;
}

.section-message {
    padding: 20px;
    background: #f7f7f7;
    border-radius: 5px;
    text-align: center;
}

.button-area {
    text-align: center;
    margin-top: 30px;
}

.button {
    display: inline-block;
    margin: 5px;
    padding: 11px 20px;
    background: #cc0033;
    color: white;
    text-decoration: none;
    border-radius: 5px;
}

.button:hover {
    background: #a30029;
}

.cancel-button {
    display: inline-block;
    padding: 8px 12px;
    background: #cc0033;
    color: white;
    text-decoration: none;
    border-radius: 4px;
}

.cancel-button:hover {
    background: #a30029;
}

.cancelled {
    color: #cc0033;
    font-weight: bold;
}

</style>
</head>

<body>

<div class="container">

<h1>My Reservations</h1>

<%
String username =
    (String) session.getAttribute("user");

String message =
    request.getParameter("message");

String url =
    "jdbc:mysql://localhost:3306/railway_booking";

String dbUser = "root";
String dbPassword = "";

Connection con = null;

PreparedStatement currentPS = null;
PreparedStatement pastPS = null;

ResultSet currentRS = null;
ResultSet pastRS = null;

SimpleDateFormat dateFormatter =
    new SimpleDateFormat("MMM d, yyyy h:mm a");

SimpleDateFormat reservationFormatter =
    new SimpleDateFormat("MMM d, yyyy");
%>

<%
if (username == null) {
%>

<p class="message">
You must be logged in to view your reservations.
</p>

<div class="button-area">

    <a class="button" href="index.jsp">
        Go to Login
    </a>

</div>

<%
} else {

    if ("cancelled".equals(message)) {
%>

<p class="message">
Your reservation was cancelled successfully.
</p>

<%
    } else if ("error".equals(message)) {
%>

<p class="message">
The reservation could not be cancelled.
</p>

<%
    }

    try {

        Class.forName("com.mysql.cj.jdbc.Driver");

        con =
            DriverManager.getConnection(
                url,
                dbUser,
                dbPassword
            );

        String currentSql =
            "SELECT r.ReservationNumber, r.ReservationDate, " +
            "r.TotalFare, r.TicketType, r.DiscountType, " +
            "r.Status, r.ScheduleID, " +
            "s.TrainID, s.LineName, " +
            "s.DepartureDateTime, s.ArrivalDateTime, " +
            "originStation.StationName AS OriginName, " +
            "destinationStation.StationName AS DestinationName " +
            "FROM Reservation r " +
            "JOIN Schedule s " +
            "ON r.ScheduleID = s.ScheduleID " +
            "JOIN Station originStation " +
            "ON r.OriginStationID = originStation.StationID " +
            "JOIN Station destinationStation " +
            "ON r.DestinationStationID = destinationStation.StationID " +
            "WHERE r.Username = ? " +
            "AND s.DepartureDateTime >= NOW() " +
            "ORDER BY s.DepartureDateTime";

        currentPS =
            con.prepareStatement(currentSql);

        currentPS.setString(
            1,
            username
        );

        currentRS =
            currentPS.executeQuery();

        boolean currentFound = false;
%>

<h2>Current Reservations</h2>

<table>

<tr>
    <th>Reservation</th>
    <th>Reserved On</th>
    <th>Train</th>
    <th>Transit Line</th>
    <th>Origin</th>
    <th>Destination</th>
    <th>Departure</th>
    <th>Arrival</th>
    <th>Ticket</th>
    <th>Discount</th>
    <th>Fare</th>
    <th>Status</th>
    <th>Action</th>
</tr>

<%
while (currentRS.next()) {

    currentFound = true;

    String status =
        currentRS.getString("Status");
%>

<tr>

<td>
    <%= currentRS.getInt("ReservationNumber") %>
</td>

<td>
    <%= reservationFormatter.format(
            currentRS.getTimestamp("ReservationDate")
        ) %>
</td>

<td>
    <%= currentRS.getString("TrainID") %>
</td>

<td>
    <%= currentRS.getString("LineName") %>
</td>

<td>
    <%= currentRS.getString("OriginName") %>
</td>

<td>
    <%= currentRS.getString("DestinationName") %>
</td>

<td>
    <%= dateFormatter.format(
            currentRS.getTimestamp("DepartureDateTime")
        ) %>
</td>

<td>
    <%= dateFormatter.format(
            currentRS.getTimestamp("ArrivalDateTime")
        ) %>
</td>

<td>
    <%= currentRS.getString("TicketType") %>
</td>

<td>
    <%= currentRS.getString("DiscountType") %>
</td>

<td>
    $<%= currentRS.getBigDecimal("TotalFare") %>
</td>

<td>

<%
if ("Cancelled".equalsIgnoreCase(status)) {
%>

<span class="cancelled">
    Cancelled
</span>

<%
} else {
%>

<%= status %>

<%
}
%>

</td>

<td>

<%
if ("Current".equalsIgnoreCase(status)) {
%>

<a class="cancel-button"
   href="cancelReservation.jsp?reservationNumber=<%= currentRS.getInt("ReservationNumber") %>"
   onclick="return confirm('Are you sure you want to cancel this reservation?');">
    Cancel
</a>

<%
} else {
%>

No Action

<%
}
%>

</td>

</tr>

<%
}
%>

</table>

<%
if (!currentFound) {
%>

<div class="section-message">
    You do not have any current reservations.
</div>

<%
}

        String pastSql =
            "SELECT r.ReservationNumber, r.ReservationDate, " +
            "r.TotalFare, r.TicketType, r.DiscountType, " +
            "r.Status, r.ScheduleID, " +
            "s.TrainID, s.LineName, " +
            "s.DepartureDateTime, s.ArrivalDateTime, " +
            "originStation.StationName AS OriginName, " +
            "destinationStation.StationName AS DestinationName " +
            "FROM Reservation r " +
            "JOIN Schedule s " +
            "ON r.ScheduleID = s.ScheduleID " +
            "JOIN Station originStation " +
            "ON r.OriginStationID = originStation.StationID " +
            "JOIN Station destinationStation " +
            "ON r.DestinationStationID = destinationStation.StationID " +
            "WHERE r.Username = ? " +
            "AND s.DepartureDateTime < NOW() " +
            "ORDER BY s.DepartureDateTime DESC";

        pastPS =
            con.prepareStatement(pastSql);

        pastPS.setString(
            1,
            username
        );

        pastRS =
            pastPS.executeQuery();

        boolean pastFound = false;
%>

<h2>Past Reservations</h2>

<table>

<tr>
    <th>Reservation</th>
    <th>Reserved On</th>
    <th>Train</th>
    <th>Transit Line</th>
    <th>Origin</th>
    <th>Destination</th>
    <th>Departure</th>
    <th>Arrival</th>
    <th>Ticket</th>
    <th>Discount</th>
    <th>Fare</th>
    <th>Status</th>
</tr>

<%
while (pastRS.next()) {

    pastFound = true;
%>

<tr>

<td>
    <%= pastRS.getInt("ReservationNumber") %>
</td>

<td>
    <%= reservationFormatter.format(
            pastRS.getTimestamp("ReservationDate")
        ) %>
</td>

<td>
    <%= pastRS.getString("TrainID") %>
</td>

<td>
    <%= pastRS.getString("LineName") %>
</td>

<td>
    <%= pastRS.getString("OriginName") %>
</td>

<td>
    <%= pastRS.getString("DestinationName") %>
</td>

<td>
    <%= dateFormatter.format(
            pastRS.getTimestamp("DepartureDateTime")
        ) %>
</td>

<td>
    <%= dateFormatter.format(
            pastRS.getTimestamp("ArrivalDateTime")
        ) %>
</td>

<td>
    <%= pastRS.getString("TicketType") %>
</td>

<td>
    <%= pastRS.getString("DiscountType") %>
</td>

<td>
    $<%= pastRS.getBigDecimal("TotalFare") %>
</td>

<td>
    <%= pastRS.getString("Status") %>
</td>

</tr>

<%
}
%>

</table>

<%
if (!pastFound) {
%>

<div class="section-message">
    You do not have any past reservations.
</div>

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

            if (currentRS != null) {
                currentRS.close();
            }

            if (pastRS != null) {
                pastRS.close();
            }

            if (currentPS != null) {
                currentPS.close();
            }

            if (pastPS != null) {
                pastPS.close();
            }

            if (con != null) {
                con.close();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<div class="button-area">

    <a class="button" href="search.jsp">
        Search Trains
    </a>

    <a class="button" href="success.jsp">
        Customer Home
    </a>

</div>

<%
}
%>

</div>

</body>
</html>