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

String url = "jdbc:mysql://localhost:3306/railway_booking";
String dbUser = "root";
String dbPassword = "";

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Train Schedules</title>

<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 40px;
}

.container {
    background-color: white;
    max-width: 1200px;
    margin: auto;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0px 0px 10px lightgray;
}

h2 {
    text-align: center;
    color: #337ab7;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 25px;
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

a {
    display: inline-block;
    text-decoration: none;
    color: white;
    background-color: #337ab7;
    padding: 8px 14px;
    margin: 3px;
    border-radius: 5px;
}

a:hover {
    background-color: #286090;
}

.delete {
    background-color: #d9534f;
}

.delete:hover {
    background-color: #c9302c;
}

.back {
    text-align: center;
    margin-top: 25px;
}
</style>

</head>

<body>

<div class="container">

<h2>Manage Train Schedules</h2>

<table>

<tr>
    <th>Schedule ID</th>
    <th>Train</th>
    <th>Transit Line</th>
    <th>Departure</th>
    <th>Arrival</th>
    <th>Travel Time</th>
    <th>Actions</th>
</tr>

<%
try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(url, dbUser, dbPassword);

    String sql =
        "SELECT ScheduleID, TrainID, LineName, " +
        "DepartureDateTime, ArrivalDateTime, TravelTime " +
        "FROM Schedule " +
        "ORDER BY DepartureDateTime";

    ps = con.prepareStatement(sql);
    rs = ps.executeQuery();

    boolean found = false;

    while (rs.next()) {

        found = true;

        int scheduleID = rs.getInt("ScheduleID");
        String trainID = rs.getString("TrainID");
        String lineName = rs.getString("LineName");
        Timestamp departure = rs.getTimestamp("DepartureDateTime");
        Timestamp arrival = rs.getTimestamp("ArrivalDateTime");
        int travelTime = rs.getInt("TravelTime");
%>

<tr>

    <td><%= scheduleID %></td>

    <td><%= trainID %></td>

    <td><%= lineName %></td>

    <td><%= departure %></td>

    <td><%= arrival %></td>

    <td><%= travelTime %> minutes</td>

    <td>

        <a href="editSchedule.jsp?scheduleID=<%= scheduleID %>">
            Edit
        </a>

        <a class="delete"
           href="deleteSchedule.jsp?scheduleID=<%= scheduleID %>"
           onclick="return confirm('Are you sure you want to delete this schedule?');">
            Delete
        </a>

    </td>

</tr>

<%
    }

    if (!found) {
%>

<tr>
    <td colspan="7" style="text-align:center;">
        No train schedules found.
    </td>
</tr>

<%
    }

} catch (Exception e) {
%>

<tr>
    <td colspan="7">
        Error loading schedules: <%= e.getMessage() %>
    </td>
</tr>

<%
} finally {

    try {
        if (rs != null) rs.close();
    } catch (SQLException e) {}

    try {
        if (ps != null) ps.close();
    } catch (SQLException e) {}

    try {
        if (con != null) con.close();
    } catch (SQLException e) {}
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