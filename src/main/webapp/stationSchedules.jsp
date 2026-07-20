<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
String user = (String) session.getAttribute("user");
String role = (String) session.getAttribute("role");

if (user == null || role == null || !"REP".equals(role)) {
    response.sendRedirect("index.jsp");
    return;
}

String stationIDParam = request.getParameter("stationID");

String url = "jdbc:mysql://localhost:3306/railway_booking";
String dbUser = "root";
String dbPassword = "";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Schedules by Station</title>

<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 40px;
}

.container {
    background-color: white;
    max-width: 1100px;
    margin: auto;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0px 0px 10px lightgray;
}

h2, h3 {
    text-align: center;
    color: #337ab7;
}

.search-box {
    text-align: center;
    margin-bottom: 30px;
}

select {
    padding: 10px;
    min-width: 300px;
    margin: 5px;
}

button, a {
    display: inline-block;
    text-decoration: none;
    color: white;
    background-color: #337ab7;
    padding: 10px 18px;
    margin: 5px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

button:hover, a:hover {
    background-color: #286090;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin: 20px 0 35px 0;
}

th, td {
    border: 1px solid #ddd;
    padding: 10px;
    text-align: left;
}

th {
    background-color: #337ab7;
    color: white;
}

.message {
    text-align: center;
    margin: 20px 0;
}

.back {
    text-align: center;
    margin-top: 25px;
}
</style>

</head>

<body>

<div class="container">

<h2>Find Train Schedules by Station</h2>

<div class="search-box">

<form method="get" action="stationSchedules.jsp">

    <label for="stationID">
        Select Station:
    </label>

    <select name="stationID" id="stationID" required>

        <option value="">
            -- Select Station --
        </option>

<%
Connection stationCon = null;
PreparedStatement stationPs = null;
ResultSet stationRs = null;

try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    stationCon =
        DriverManager.getConnection(url, dbUser, dbPassword);

    stationPs =
        stationCon.prepareStatement(
            "SELECT StationID, StationName, City, State " +
            "FROM Station " +
            "ORDER BY StationName"
        );

    stationRs = stationPs.executeQuery();

    while (stationRs.next()) {

        int stationID =
            stationRs.getInt("StationID");

        String selected = "";

        if (
            stationIDParam != null &&
            stationIDParam.equals(String.valueOf(stationID))
        ) {
            selected = "selected";
        }
%>

        <option
            value="<%= stationID %>"
            <%= selected %>>

            <%= stationRs.getString("StationName") %>
            -
            <%= stationRs.getString("City") %>,
            <%= stationRs.getString("State") %>

        </option>

<%
    }

} catch (Exception e) {
%>

        <option disabled>
            Error loading stations
        </option>

<%
} finally {

    try {
        if (stationRs != null) {
            stationRs.close();
        }
    } catch (SQLException e) {}

    try {
        if (stationPs != null) {
            stationPs.close();
        }
    } catch (SQLException e) {}

    try {
        if (stationCon != null) {
            stationCon.close();
        }
    } catch (SQLException e) {}
}
%>

    </select>

    <button type="submit">
        Search
    </button>

</form>

</div>

<%
if (stationIDParam != null && !stationIDParam.trim().isEmpty()) {

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {

        int stationID =
            Integer.parseInt(stationIDParam);

        Class.forName("com.mysql.cj.jdbc.Driver");

        con =
            DriverManager.getConnection(
                url,
                dbUser,
                dbPassword
            );

        String stationName = null;

        ps =
            con.prepareStatement(
                "SELECT StationName " +
                "FROM Station " +
                "WHERE StationID=?"
            );

        ps.setInt(1, stationID);

        rs = ps.executeQuery();

        if (rs.next()) {

            stationName =
                rs.getString("StationName");

        } else {

            stationName =
                "Selected Station";
        }

        rs.close();
        ps.close();

        rs = null;
        ps = null;
%>

<h3>
Schedules Where <%= stationName %> Is the Origin
</h3>

<table>

<tr>
    <th>Schedule ID</th>
    <th>Train</th>
    <th>Transit Line</th>
    <th>Departure</th>
    <th>Arrival</th>
    <th>Travel Time</th>
    <th>Fare</th>
</tr>

<%
        String originSql =
            "SELECT s.ScheduleID, s.TrainID, s.LineName, " +
            "s.DepartureDateTime, s.ArrivalDateTime, " +
            "s.TravelTime, t.Fare " +
            "FROM Schedule s " +
            "JOIN TransitLine t " +
            "ON s.LineName = t.LineName " +
            "WHERE t.OriginID=? " +
            "ORDER BY s.DepartureDateTime";

        ps =
            con.prepareStatement(originSql);

        ps.setInt(1, stationID);

        rs = ps.executeQuery();

        boolean originFound = false;

        while (rs.next()) {

            originFound = true;
%>

<tr>
    <td>
        <%= rs.getInt("ScheduleID") %>
    </td>

    <td>
        <%= rs.getString("TrainID") %>
    </td>

    <td>
        <%= rs.getString("LineName") %>
    </td>

    <td>
        <%= rs.getTimestamp("DepartureDateTime") %>
    </td>

    <td>
        <%= rs.getTimestamp("ArrivalDateTime") %>
    </td>

    <td>
        <%= rs.getInt("TravelTime") %> minutes
    </td>

    <td>
        $<%= rs.getBigDecimal("Fare") %>
    </td>
</tr>

<%
        }

        if (!originFound) {
%>

<tr>
    <td colspan="7" style="text-align:center;">
        No schedules found with this station as origin.
    </td>
</tr>

<%
        }

        rs.close();
        ps.close();

        rs = null;
        ps = null;
%>

</table>

<h3>
Schedules Where <%= stationName %> Is the Destination
</h3>

<table>

<tr>
    <th>Schedule ID</th>
    <th>Train</th>
    <th>Transit Line</th>
    <th>Departure</th>
    <th>Arrival</th>
    <th>Travel Time</th>
    <th>Fare</th>
</tr>

<%
        String destinationSql =
            "SELECT s.ScheduleID, s.TrainID, s.LineName, " +
            "s.DepartureDateTime, s.ArrivalDateTime, " +
            "s.TravelTime, t.Fare " +
            "FROM Schedule s " +
            "JOIN TransitLine t " +
            "ON s.LineName = t.LineName " +
            "WHERE t.DestinationID=? " +
            "ORDER BY s.DepartureDateTime";

        ps =
            con.prepareStatement(destinationSql);

        ps.setInt(1, stationID);

        rs = ps.executeQuery();

        boolean destinationFound = false;

        while (rs.next()) {

            destinationFound = true;
%>

<tr>
    <td>
        <%= rs.getInt("ScheduleID") %>
    </td>

    <td>
        <%= rs.getString("TrainID") %>
    </td>

    <td>
        <%= rs.getString("LineName") %>
    </td>

    <td>
        <%= rs.getTimestamp("DepartureDateTime") %>
    </td>

    <td>
        <%= rs.getTimestamp("ArrivalDateTime") %>
    </td>

    <td>
        <%= rs.getInt("TravelTime") %> minutes
    </td>

    <td>
        $<%= rs.getBigDecimal("Fare") %>
    </td>
</tr>

<%
        }

        if (!destinationFound) {
%>

<tr>
    <td colspan="7" style="text-align:center;">
        No schedules found with this station as destination.
    </td>
</tr>

<%
        }

    } catch (NumberFormatException e) {
%>

<p class="message">
    Invalid station selected.
</p>

<%
    } catch (Exception e) {
%>

<p class="message">
    Error loading schedules:
    <%= e.getMessage() %>
</p>

<%
    } finally {

        try {
            if (rs != null) {
                rs.close();
            }
        } catch (SQLException e) {}

        try {
            if (ps != null) {
                ps.close();
            }
        } catch (SQLException e) {}

        try {
            if (con != null) {
                con.close();
            }
        } catch (SQLException e) {}
    }
}
%>

</table>

<div class="back">

    <a href="repDashboard.jsp">
        Back to Representative Dashboard
    </a>

</div>

</div>

</body>
</html>