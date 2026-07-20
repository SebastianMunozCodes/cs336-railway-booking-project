<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Train Stops</title>

<style>

body {
    font-family: Arial, sans-serif;
    background: #f4f4f4;
    margin: 0;
}

.container {
    width: 85%;
    max-width: 900px;
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

.schedule-info {
    text-align: center;
    margin-bottom: 25px;
    font-size: 17px;
    line-height: 1.6;
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

</style>
</head>

<body>

<div class="container">

<h2>Train Stops</h2>

<%
String scheduleIDText =
    request.getParameter("scheduleID");

String url =
    "jdbc:mysql://localhost:3306/railway_booking";

String dbUser = "root";
String dbPassword = "Smartie617";

Connection con = null;

PreparedStatement schedulePS = null;
PreparedStatement stopsPS = null;

ResultSet scheduleRS = null;
ResultSet stopsRS = null;

boolean foundStops = false;

SimpleDateFormat dateFormatter =
    new SimpleDateFormat("MMM d, yyyy h:mm a");

SimpleDateFormat timeFormatter =
    new SimpleDateFormat("h:mm a");
%>

<%
if (scheduleIDText == null ||
    scheduleIDText.trim().isEmpty()) {
%>

<p class="message">
No schedule was selected.
</p>

<%
} else {

    try {

        int scheduleID =
            Integer.parseInt(scheduleIDText);

        Class.forName("com.mysql.cj.jdbc.Driver");

        con = DriverManager.getConnection(
            url,
            dbUser,
            dbPassword
        );

        String scheduleSql =
            "SELECT s.ScheduleID, s.TrainID, s.LineName, " +
            "s.DepartureDateTime, s.ArrivalDateTime, " +
            "s.TravelTime, t.Fare " +
            "FROM Schedule s " +
            "JOIN TransitLine t " +
            "ON s.LineName = t.LineName " +
            "WHERE s.ScheduleID = ?";

        schedulePS =
            con.prepareStatement(scheduleSql);

        schedulePS.setInt(
            1,
            scheduleID
        );

        scheduleRS =
            schedulePS.executeQuery();

        if (scheduleRS.next()) {
%>

<div class="schedule-info">

<strong>Schedule ID:</strong>
<%= scheduleRS.getInt("ScheduleID") %>

<br>

<strong>Train:</strong>
<%= scheduleRS.getString("TrainID") %>

<br>

<strong>Transit Line:</strong>
<%= scheduleRS.getString("LineName") %>

<br>

<strong>Departure:</strong>
<%= dateFormatter.format(
        scheduleRS.getTimestamp("DepartureDateTime")
    ) %>

<br>

<strong>Arrival:</strong>
<%= dateFormatter.format(
        scheduleRS.getTimestamp("ArrivalDateTime")
    ) %>

<br>

<strong>Travel Time:</strong>
<%= scheduleRS.getInt("TravelTime") %> minutes

<br>

<strong>Full Route Fare:</strong>
$<%= scheduleRS.getBigDecimal("Fare") %>

</div>

<%
        } else {
%>

<p class="message">
The selected schedule was not found.
</p>

<%
        }

        String stopsSql =
            "SELECT st.StopNumber, " +
            "station.StationName, " +
            "station.City, " +
            "station.State, " +
            "st.ArrivalTime, " +
            "st.DepartureTime " +
            "FROM Stop st " +
            "JOIN Station station " +
            "ON st.StationID = station.StationID " +
            "WHERE st.ScheduleID = ? " +
            "ORDER BY st.StopNumber";

        stopsPS =
            con.prepareStatement(stopsSql);

        stopsPS.setInt(
            1,
            scheduleID
        );

        stopsRS =
            stopsPS.executeQuery();
%>

<table>

<tr>
    <th>Stop Number</th>
    <th>Station</th>
    <th>City</th>
    <th>State</th>
    <th>Arrival Time</th>
    <th>Departure Time</th>
</tr>

<%
while (stopsRS.next()) {

    foundStops = true;

    Time arrivalTime =
        stopsRS.getTime("ArrivalTime");

    Time departureTime =
        stopsRS.getTime("DepartureTime");
%>

<tr>

<td>
<%= stopsRS.getInt("StopNumber") %>
</td>

<td>
<%= stopsRS.getString("StationName") %>
</td>

<td>
<%= stopsRS.getString("City") %>
</td>

<td>
<%= stopsRS.getString("State") %>
</td>

<td>
<%
if (arrivalTime == null) {
    out.print("Route begins here");
} else {
    out.print(timeFormatter.format(arrivalTime));
}
%>
</td>

<td>
<%
if (departureTime == null) {
    out.print("Final destination");
} else {
    out.print(timeFormatter.format(departureTime));
}
%>
</td>

</tr>

<%
}
%>

</table>

<%
if (!foundStops) {
%>

<p class="message">
No stops have been added for this schedule.
</p>

<%
}

    } catch (NumberFormatException e) {
%>

<p class="message">
Invalid schedule number.
</p>

<%
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

            if (stopsRS != null) {
                stopsRS.close();
            }

            if (scheduleRS != null) {
                scheduleRS.close();
            }

            if (stopsPS != null) {
                stopsPS.close();
            }

            if (schedulePS != null) {
                schedulePS.close();
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

<a class="button" href="javascript:history.back()">
Back to Search Results
</a>

</div>

</div>

</body>
</html>