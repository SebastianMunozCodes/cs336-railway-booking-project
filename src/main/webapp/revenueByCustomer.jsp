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
<title>Revenue by Customer</title>

<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 40px;
}

.container {
    background-color: white;
    max-width: 900px;
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

<h2>Revenue by Customer</h2>

<table>

<tr>
    <th>Customer</th>
    <th>Username</th>
    <th>Total Reservations</th>
    <th>Total Revenue</th>
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
        "c.FirstName, " +
        "c.LastName, " +
        "c.Username, " +
        "COUNT(r.ReservationNumber) AS ReservationCount, " +
        "COALESCE(SUM(CASE WHEN r.Status <> 'Cancelled' THEN r.TotalFare ELSE 0 END), 0) AS TotalRevenue " +
        "FROM Customer c " +
        "LEFT JOIN Reservation r " +
        "ON c.Username = r.Username " +
        "GROUP BY c.Username, c.FirstName, c.LastName " +
        "ORDER BY TotalRevenue DESC, c.LastName, c.FirstName";

    ps = con.prepareStatement(sql);

    rs = ps.executeQuery();

    boolean found = false;

    while (rs.next()) {

        found = true;
%>

<tr>

    <td>
        <%= rs.getString("FirstName") %>
        <%= rs.getString("LastName") %>
    </td>

    <td>
        <%= rs.getString("Username") %>
    </td>

    <td>
        <%= rs.getInt("ReservationCount") %>
    </td>

    <td>
        $<%= rs.getBigDecimal("TotalRevenue") %>
    </td>

</tr>

<%
    }

    if (!found) {
%>

<tr>
    <td colspan="4" style="text-align:center;">
        No customer revenue data found.
    </td>
</tr>

<%
    }

} catch (Exception e) {
%>

<tr>
    <td colspan="4">
        Error loading customer revenue:
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