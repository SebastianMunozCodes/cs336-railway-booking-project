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

String scheduleIDParam = request.getParameter("scheduleID");

if (scheduleIDParam == null) {
    response.sendRedirect("manageSchedules.jsp");
    return;
}

int scheduleID;

try {
    scheduleID = Integer.parseInt(scheduleIDParam);
} catch (NumberFormatException e) {
    response.sendRedirect("manageSchedules.jsp");
    return;
}

String url = "jdbc:mysql://localhost:3306/railway_booking";
String dbUser = "root";
String dbPassword = "";

String trainID = "";
String lineName = "";
String departureDateTime = "";
String arrivalDateTime = "";
String travelTime = "";

String message = null;
boolean updatedSuccessfully = false;

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {

    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection(url, dbUser, dbPassword);

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        trainID = request.getParameter("trainID");
        lineName = request.getParameter("lineName");
        departureDateTime = request.getParameter("departureDateTime");
        arrivalDateTime = request.getParameter("arrivalDateTime");
        travelTime = request.getParameter("travelTime");

        String updateSql =
            "UPDATE Schedule " +
            "SET TrainID=?, LineName=?, DepartureDateTime=?, " +
            "ArrivalDateTime=?, TravelTime=? " +
            "WHERE ScheduleID=?";

        ps = con.prepareStatement(updateSql);

        ps.setString(1, trainID);
        ps.setString(2, lineName);
        ps.setString(3, departureDateTime.replace("T", " ") + ":00");
        ps.setString(4, arrivalDateTime.replace("T", " ") + ":00");
        ps.setInt(5, Integer.parseInt(travelTime));
        ps.setInt(6, scheduleID);

        int rowsUpdated = ps.executeUpdate();

        ps.close();

        if (rowsUpdated > 0) {
            message = "Schedule updated successfully.";
            updatedSuccessfully = true;
        } else {
            message = "No schedule was updated.";
        }

    } else {

        String selectSql =
            "SELECT TrainID, LineName, DepartureDateTime, " +
            "ArrivalDateTime, TravelTime " +
            "FROM Schedule WHERE ScheduleID=?";

        ps = con.prepareStatement(selectSql);
        ps.setInt(1, scheduleID);

        rs = ps.executeQuery();

        if (rs.next()) {

            trainID = rs.getString("TrainID");
            lineName = rs.getString("LineName");

            Timestamp departure =
                rs.getTimestamp("DepartureDateTime");

            Timestamp arrival =
                rs.getTimestamp("ArrivalDateTime");

            departureDateTime =
                departure.toLocalDateTime().toString().substring(0, 16);

            arrivalDateTime =
                arrival.toLocalDateTime().toString().substring(0, 16);

            travelTime =
                String.valueOf(rs.getInt("TravelTime"));

        } else {
            response.sendRedirect("manageSchedules.jsp");
            return;
        }
    }

} catch (Exception e) {

    message = "Error: " + e.getMessage();

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

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Train Schedule</title>

<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    text-align: center;
    margin-top: 60px;
}

.container {
    background-color: white;
    width: 550px;
    margin: auto;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0px 0px 10px lightgray;
}

label {
    display: block;
    text-align: left;
    margin-top: 15px;
    font-weight: bold;
}

input {
    width: 95%;
    padding: 10px;
    margin-top: 5px;
}

button, a {
    display: inline-block;
    margin: 12px;
    text-decoration: none;
    color: white;
    background-color: #337ab7;
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

button:hover, a:hover {
    background-color: #286090;
}

.message {
    margin: 20px 0;
    font-weight: bold;
}
</style>

</head>

<body>

<div class="container">

<% if (updatedSuccessfully) { %>

    <h2>Schedule Updated</h2>

    <div class="message">
        <%= message %>
    </div>

    <a href="manageSchedules.jsp">
        Back to Manage Schedules
    </a>

<% } else { %>

    <h2>Edit Train Schedule</h2>

    <% if (message != null) { %>

        <div class="message">
            <%= message %>
        </div>

    <% } %>

    <form method="post"
          action="editSchedule.jsp?scheduleID=<%= scheduleID %>">

        <label for="trainID">
            Train ID
        </label>

        <input
            type="text"
            id="trainID"
            name="trainID"
            value="<%= trainID %>"
            required>

        <label for="lineName">
            Transit Line
        </label>

        <input
            type="text"
            id="lineName"
            name="lineName"
            value="<%= lineName %>"
            required>

        <label for="departureDateTime">
            Departure Date/Time
        </label>

        <input
            type="datetime-local"
            id="departureDateTime"
            name="departureDateTime"
            value="<%= departureDateTime %>"
            required>

        <label for="arrivalDateTime">
            Arrival Date/Time
        </label>

        <input
            type="datetime-local"
            id="arrivalDateTime"
            name="arrivalDateTime"
            value="<%= arrivalDateTime %>"
            required>

        <label for="travelTime">
            Travel Time (minutes)
        </label>

        <input
            type="number"
            id="travelTime"
            name="travelTime"
            value="<%= travelTime %>"
            min="1"
            required>

        <button type="submit">
            Save Changes
        </button>

    </form>

    <a href="manageSchedules.jsp">
        Cancel
    </a>

<% } %>

</div>

</body>
</html>