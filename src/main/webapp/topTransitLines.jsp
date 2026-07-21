<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
String user = (String) session.getAttribute("user");
String role = (String) session.getAttribute("role");

if (user == null || role == null || !"ADMIN".equals(role)) {
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
<title>Top Five Transit Lines</title>

<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 40px;
}

.container {
    background-color: white;
    max-width: 850px;
    margin: auto;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0px 0px 10px lightgray;
}

h2 {
    text-align: center;
    color: #5cb85c;
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
    background-color: #5cb85c;
    color: white;
}

a {
    display: inline-block;
    margin-top: 25px;
    text-decoration: none;
    color: white;
    background-color: #5cb85c;
    padding: 10px 18px;
    border-radius: 5px;
}

a:hover {
    background-color: #449d44;
}

.back {
    text-align: center;
}
</style>

</head>

<body>

<div class="container">

<h2>Top Five Transit Lines</h2>

<table>

<tr>
    <th>Rank</th>
    <th>Transit Line</th>
    <th>Total Reservations</th>
</tr>

<%
try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    con =
        DriverManager.getConnection(
            url,
            dbUser,
            dbPassword
        );

    String sql =
        "SELECT " +
        "s.LineName, " +
        "COUNT(r.ReservationNumber) AS ReservationCount " +
        "FROM Schedule s " +
        "LEFT JOIN Reservation r " +
        "ON s.ScheduleID = r.ScheduleID " +
        "AND r.Status <> 'Cancelled' " +
        "GROUP BY s.LineName " +
        "ORDER BY ReservationCount DESC, s.LineName " +
        "LIMIT 5";

    ps = con.prepareStatement(sql);

    rs = ps.executeQuery();

    boolean found = false;
    int rank = 1;

    while (rs.next()) {

        found = true;
%>

<tr>

    <td>
        <%= rank %>
    </td>

    <td>
        <%= rs.getString("LineName") %>
    </td>

    <td>
        <%= rs.getInt("ReservationCount") %>
    </td>

</tr>

<%
        rank++;
    }

    if (!found) {
%>

<tr>
    <td colspan="3" style="text-align:center;">
        No transit line reservation data found.
    </td>
</tr>

<%
    }

} catch (Exception e) {
%>

<tr>
    <td colspan="3">
        Error loading top transit lines:
        <%= e.getMessage() %>
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

    <a href="adminReports.jsp">
        Back to Reports
    </a>

</div>

</div>

</body>
</html>