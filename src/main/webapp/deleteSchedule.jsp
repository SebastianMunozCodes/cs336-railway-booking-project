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

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

String message = null;
boolean deletedSuccessfully = false;

try {

    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection(url, dbUser, dbPassword);

    // Confirm the schedule exists
    String checkSql =
        "SELECT ScheduleID FROM Schedule WHERE ScheduleID=?";

    ps = con.prepareStatement(checkSql);
    ps.setInt(1, scheduleID);

    rs = ps.executeQuery();

    if (!rs.next()) {
        message = "Schedule not found.";
    } else {

        rs.close();
        ps.close();

        // Try to delete the schedule
        String deleteSql =
            "DELETE FROM Schedule WHERE ScheduleID=?";

        ps = con.prepareStatement(deleteSql);
        ps.setInt(1, scheduleID);

        int rowsDeleted = ps.executeUpdate();

        if (rowsDeleted > 0) {
            message = "Schedule deleted successfully.";
            deletedSuccessfully = true;
        } else {
            message = "Schedule could not be deleted.";
        }
    }

} catch (SQLIntegrityConstraintViolationException e) {

    message =
        "This schedule cannot be deleted because one or more reservations reference it.";

} catch (Exception e) {

    message = "Error deleting schedule: " + e.getMessage();

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
<title>Delete Schedule</title>

<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    text-align: center;
    margin-top: 100px;
}

.container {
    background-color: white;
    width: 550px;
    margin: auto;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0px 0px 10px lightgray;
}

h2 {
    color: <%= deletedSuccessfully ? "green" : "#d9534f" %>;
}

a {
    display: inline-block;
    margin-top: 20px;
    text-decoration: none;
    color: white;
    background-color: #337ab7;
    padding: 10px 20px;
    border-radius: 5px;
}

a:hover {
    background-color: #286090;
}
</style>

</head>

<body>

<div class="container">

    <h2>
        <%= deletedSuccessfully ? "Schedule Deleted" : "Unable to Delete Schedule" %>
    </h2>

    <p>
        <%= message %>
    </p>

    <a href="manageSchedules.jsp">
        Back to Manage Schedules
    </a>

</div>

</body>
</html>