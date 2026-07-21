<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
String username = (String) session.getAttribute("user");
String role = (String) session.getAttribute("role");

if (username == null || role == null || !"CUSTOMER".equals(role)) {
    response.sendRedirect("index.jsp");
    return;
}
%>

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
    max-width: 1400px;
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
    font-weight: bold;
    margin: 25px 0;
}

.success-message {
    color: green;
}

.error-message {
    color: #cc0033;
}

.section-message {
    padding: 20px;
    margin-top: 10px;
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

.cancel-form {
    margin: 0;
}

.cancel-button {
    display: inline-block;
    padding: 8px 12px;
    background: #cc0033;
    color: white;
    border: none;
    text-decoration: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 14px;
}

.cancel-button:hover {
    background: #a30029;
}

.itinerary-button {
    display: inline-block;
    padding: 8px 12px;
    background: #337ab7;
    color: white;
    text-decoration: none;
    border-radius: 4px;
}

.itinerary-button:hover {
    background: #286090;
}

.cancelled {
    color: #cc0033;
    font-weight: bold;
}

.past-status {
    color: #555555;
    font-weight: bold;
}

</style>
</head>

<body>

<div class="container">

<h1>My Reservations</h1>

<%
String message = request.getParameter("message");

if ("cancelled".equals(message)) {
%>

<p class="message success-message">
    Your reservation was cancelled successfully.
</p>

<%
} else if ("notFound".equals(message)) {
%>

<p class="message error-message">
    The reservation could not be cancelled. It may have already departed,
    already been cancelled, or may not belong to your account.
</p>

<%
} else if ("error".equals(message)) {
%>

<p class="message error-message">
    An error occurred while cancelling the reservation.
</p>

<%
}

String url = "jdbc:mysql://localhost:3306/railway_booking";
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
try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(
        url,
        dbUser,
        dbPassword
    );

    /*
     * Current reservations:
     * 1. Belong to the logged-in customer
     * 2. Have not departed yet
     * 3. Have not been cancelled
     */
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
        "AND r.Status = 'Current' " +

        "ORDER BY s.DepartureDateTime";

    currentPS = con.prepareStatement(currentSql);
    currentPS.setString(1, username);

    currentRS = currentPS.executeQuery();

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
    <th>Itinerary</th>
    <th>Action</th>
</tr>

<%
while (currentRS.next()) {

    currentFound = true;
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
    Current
</td>

<td>

<a class="itinerary-button"
   href="viewStops.jsp?scheduleID=<%= currentRS.getInt("ScheduleID") %>">
    View Itinerary
</a>

</td>

<td>

<form class="cancel-form"
      action="cancelReservation.jsp"
      method="post"
      onsubmit="return confirm('Are you sure you want to cancel this reservation?');">

    <input type="hidden"
           name="reservationNumber"
           value="<%= currentRS.getInt("ReservationNumber") %>">

    <input class="cancel-button"
           type="submit"
           value="Cancel">

</form>

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

if (currentRS != null) {
    currentRS.close();
    currentRS = null;
}

if (currentPS != null) {
    currentPS.close();
    currentPS = null;
}

/*
 * Past reservations:
 * 1. The train already departed, or
 * 2. The reservation was cancelled
 */
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
    "AND (" +
        "s.DepartureDateTime < NOW() " +
        "OR r.Status = 'Cancelled'" +
    ") " +

    "ORDER BY s.DepartureDateTime DESC";

pastPS = con.prepareStatement(pastSql);
pastPS.setString(1, username);

pastRS = pastPS.executeQuery();

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
    <th>Itinerary</th>
</tr>

<%
while (pastRS.next()) {

    pastFound = true;

    String pastStatus =
        pastRS.getString("Status");
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

<%
if ("Cancelled".equalsIgnoreCase(pastStatus)) {
%>

<span class="cancelled">
    Cancelled
</span>

<%
} else {
%>

<span class="past-status">
    Past
</span>

<%
}
%>

</td>

<td>

<a class="itinerary-button"
   href="viewStops.jsp?scheduleID=<%= pastRS.getInt("ScheduleID") %>">
    View Itinerary
</a>

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

<p class="message error-message">
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
    } catch (SQLException e) {
        e.printStackTrace();
    }

    try {
        if (pastRS != null) {
            pastRS.close();
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    try {
        if (currentPS != null) {
            currentPS.close();
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    try {
        if (pastPS != null) {
            pastPS.close();
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    try {
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

    <a class="button" href="customerDashboard.jsp">
        Back to Dashboard
    </a>

</div>

</div>

</body>
</html>