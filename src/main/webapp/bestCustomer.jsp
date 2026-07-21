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
<title>Best Customer</title>

<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 40px;
}

.container {
    background-color: white;
    max-width: 750px;
    margin: auto;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0px 0px 10px lightgray;
}

h2 {
    text-align: center;
    color: #5cb85c;
}

.best-customer {
    text-align: center;
    padding: 25px;
    margin-top: 25px;
    background-color: #f8f8f8;
    border-radius: 8px;
}

.best-customer h3 {
    color: #5cb85c;
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

<h2>Best Customer</h2>

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
        "c.FirstName, " +
        "c.LastName, " +
        "c.Username, " +
        "COUNT(r.ReservationNumber) AS ReservationCount, " +
        "SUM(r.TotalFare) AS TotalRevenue " +
        "FROM Customer c " +
        "JOIN Reservation r " +
        "ON c.Username = r.Username " +
        "WHERE r.Status <> 'Cancelled' " +
        "GROUP BY c.Username, c.FirstName, c.LastName " +
        "ORDER BY TotalRevenue DESC " +
        "LIMIT 1";

    ps = con.prepareStatement(sql);

    rs = ps.executeQuery();

    if (rs.next()) {
%>

<div class="best-customer">

    <h3>
        <%= rs.getString("FirstName") %>
        <%= rs.getString("LastName") %>
    </h3>

    <p>
        <strong>Username:</strong>
        <%= rs.getString("Username") %>
    </p>

    <p>
        <strong>Total Reservations:</strong>
        <%= rs.getInt("ReservationCount") %>
    </p>

    <p>
        <strong>Total Revenue:</strong>
        $<%= rs.getBigDecimal("TotalRevenue") %>
    </p>

</div>

<%
    } else {
%>

<p style="text-align:center;">
    No customer reservation data found.
</p>

<%
    }

} catch (Exception e) {
%>

<p>
    Error loading best customer:
    <%= e.getMessage() %>
</p>

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

<div class="back">

    <a href="adminReports.jsp">
        Back to Reports
    </a>

</div>

</div>

</body>
</html>