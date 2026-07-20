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
<title>Manage Customer Representatives</title>

<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 40px;
}

.container {
    background-color: white;
    max-width: 1000px;
    margin: auto;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0px 0px 10px lightgray;
}

h2 {
    text-align: center;
    color: #5cb85c;
}

.top-actions {
    text-align: center;
    margin-bottom: 25px;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
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
    text-decoration: none;
    color: white;
    background-color: #5cb85c;
    padding: 8px 14px;
    margin: 3px;
    border-radius: 5px;
}

a:hover {
    background-color: #449d44;
}

.delete {
    background-color: #d9534f;
}

.delete:hover {
    background-color: #c9302c;
}

.back {
    text-align: center;
    margin-top: 25px;
}
</style>

</head>

<body>

<div class="container">

<h2>Manage Customer Representatives</h2>

<div class="top-actions">

    <a href="addRep.jsp">
        Add New Representative
    </a>

</div>

<table>

<tr>
    <th>SSN</th>
    <th>First Name</th>
    <th>Last Name</th>
    <th>Username</th>
    <th>Actions</th>
</tr>

<%
try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(url, dbUser, dbPassword);

    String sql =
        "SELECT SSN, FirstName, LastName, Username " +
        "FROM Employee " +
        "WHERE Role='REP' " +
        "ORDER BY LastName, FirstName";

    ps = con.prepareStatement(sql);
    rs = ps.executeQuery();

    boolean found = false;

    while (rs.next()) {

        found = true;

        String ssn = rs.getString("SSN");
%>

<tr>

    <td>
        <%= ssn %>
    </td>

    <td>
        <%= rs.getString("FirstName") %>
    </td>

    <td>
        <%= rs.getString("LastName") %>
    </td>

    <td>
        <%= rs.getString("Username") %>
    </td>

    <td>

        <a href="editRep.jsp?ssn=<%= ssn %>">
            Edit
        </a>

        <a class="delete"
           href="deleteRep.jsp?ssn=<%= ssn %>"
           onclick="return confirm('Are you sure you want to delete this representative?');">
            Delete
        </a>

    </td>

</tr>

<%
    }

    if (!found) {
%>

<tr>
    <td colspan="5" style="text-align:center;">
        No customer representatives found.
    </td>
</tr>

<%
    }

} catch (Exception e) {
%>

<tr>
    <td colspan="5">
        Error loading representatives:
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

    <a href="adminDashboard.jsp">
        Back to Admin Dashboard
    </a>

</div>

</div>

</body>
</html>