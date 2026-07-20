<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
String user = (String) session.getAttribute("user");
String role = (String) session.getAttribute("role");

if (user == null || role == null || !"REP".equals(role)) {
    response.sendRedirect("index.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Customer Representative Dashboard</title>

<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    text-align: center;
    margin-top: 100px;
}

.container {
    background-color: white;
    width: 650px;
    margin: auto;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0px 0px 10px lightgray;
}

h2 {
    color: #337ab7;
}

a {
    display: inline-block;
    margin: 10px;
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

    <h2>Customer Representative Dashboard</h2>

    <p>Welcome, <strong><%= user %></strong>!</p>

    <p>Select a representative function below.</p>

    <a href="repQuestions.jsp">
        View Customer Questions
    </a>

    <a href="manageSchedules.jsp">
        Manage Train Schedules
    </a>

    <a href="stationSchedules.jsp">
        Find Schedules by Station
    </a>

    <a href="customersByLineDate.jsp">
        Find Customers by Transit Line and Date
    </a>

    <a href="logout.jsp">
        Logout
    </a>

</div>

</body>
</html>