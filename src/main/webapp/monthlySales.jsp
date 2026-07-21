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
<title>Monthly Sales Report</title>

<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 40px;
}

.container {
    background-color: white;
    max-width: 800px;
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

<h2>Monthly Sales Report</h2>

<table>

<tr>
    <th>Month</th>
    <th>Total Sales</th>
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
        "SELECT DATE_FORMAT(ReservationDate, '%Y-%m') AS SalesMonth, " +
        "SUM(TotalFare) AS TotalSales " +
        "FROM Reservation " +
        "WHERE Status <> 'Cancelled' " +
        "GROUP BY DATE_FORMAT(ReservationDate, '%Y-%m') " +
        "ORDER BY SalesMonth";

    ps = con.prepareStatement(sql);

    rs = ps.executeQuery();

    boolean found = false;

    while (rs.next()) {

        found = true;
%>

<tr>

    <td>
        <%= rs.getString("SalesMonth") %>
    </td>

    <td>
        $<%= rs.getBigDecimal("TotalSales") %>
    </td>

</tr>

<%
    }

    if (!found) {
%>

<tr>
    <td colspan="2" style="text-align:center;">
        No sales data found.
    </td>
</tr>

<%
    }

} catch (Exception e) {
%>

<tr>
    <td colspan="2">
        Error loading monthly sales:
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