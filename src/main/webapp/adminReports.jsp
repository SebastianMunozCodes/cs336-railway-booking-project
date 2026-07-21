<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
String user = (String) session.getAttribute("user");
String role = (String) session.getAttribute("role");

if (user == null || role == null || !"ADMIN".equals(role)) {
    response.sendRedirect("index.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Reports</title>

<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    text-align: center;
    margin-top: 80px;
}

.container {
    background-color: white;
    width: 700px;
    margin: auto;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0px 0px 10px lightgray;
}

h2 {
    color: #5cb85c;
}

a {
    display: inline-block;
    margin: 10px;
    text-decoration: none;
    color: white;
    background-color: #5cb85c;
    padding: 10px 20px;
    border-radius: 5px;
}

a:hover {
    background-color: #449d44;
}
</style>

</head>

<body>

<div class="container">

    <h2>Admin Reports</h2>

    <a href="monthlySales.jsp">
        Monthly Sales
    </a>

    <a href="reservationsByLine.jsp">
        Reservations by Transit Line
    </a>

    <a href="reservationsByCustomer.jsp">
        Reservations by Customer
    </a>

    <a href="revenueByLine.jsp">
        Revenue by Transit Line
    </a>

    <a href="revenueByCustomer.jsp">
        Revenue by Customer
    </a>

    <a href="bestCustomer.jsp">
        Best Customer
    </a>

    <a href="topTransitLines.jsp">
        Top Five Transit Lines
    </a>

    <br>

    <a href="adminDashboard.jsp">
        Back to Admin Dashboard
    </a>

</div>

</body>
</html>