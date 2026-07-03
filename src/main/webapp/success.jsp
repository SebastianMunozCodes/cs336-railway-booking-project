<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
String user = (String) session.getAttribute("user");

if (user == null) {
    response.sendRedirect("index.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login Successful</title>

<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    text-align: center;
    margin-top: 100px;
}

.container {
    background-color: white;
    width: 400px;
    margin: auto;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0px 0px 10px lightgray;
}

h2 {
    color: green;
}

a {
    display: inline-block;
    margin-top: 20px;
    text-decoration: none;
    color: white;
    background-color: #d9534f;
    padding: 10px 20px;
    border-radius: 5px;
}

a:hover {
    background-color: #c9302c;
}
</style>

</head>

<body>

<div class="container">

    <h2>Login Successful!</h2>

    <p>Welcome, <strong><%= user %></strong>!</p>

    <p>You have successfully logged into the Railway Booking System.</p>

    <a href="logout.jsp">Logout</a>

</div>

</body>
</html>