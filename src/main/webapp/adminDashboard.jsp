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
<title>Admin Dashboard</title>

<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    text-align: center;
    margin-top: 100px;
}

.container {
    background-color: white;
    width: 500px;
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

    <h2>Admin Dashboard</h2>

    <p>Welcome, <strong><%= user %></strong>!</p>

    <p>Admin functions will be available here.</p>

    <a href="logout.jsp">Logout</a>

</div>

</body>
</html>