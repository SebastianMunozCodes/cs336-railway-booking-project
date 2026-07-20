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

String ssnParam = request.getParameter("ssn");

if (ssnParam == null || ssnParam.trim().isEmpty()) {
    response.sendRedirect("manageReps.jsp");
    return;
}

String url = "jdbc:mysql://localhost:3306/railway_booking";
String dbUser = "root";
String dbPassword = "";

String firstName = "";
String lastName = "";
String username = "";
String password = "";

String message = null;
boolean updatedSuccessfully = false;

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    con =
        DriverManager.getConnection(
            url,
            dbUser,
            dbPassword
        );

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        firstName = request.getParameter("firstName");
        lastName = request.getParameter("lastName");
        username = request.getParameter("username");
        password = request.getParameter("password");

        if (
            firstName != null &&
            lastName != null &&
            username != null &&
            password != null &&
            !firstName.trim().isEmpty() &&
            !lastName.trim().isEmpty() &&
            !username.trim().isEmpty() &&
            !password.trim().isEmpty()
        ) {

            String updateSql =
                "UPDATE Employee " +
                "SET FirstName=?, LastName=?, Username=?, Password=? " +
                "WHERE SSN=? AND Role='REP'";

            ps = con.prepareStatement(updateSql);

            ps.setString(1, firstName.trim());
            ps.setString(2, lastName.trim());
            ps.setString(3, username.trim());
            ps.setString(4, password.trim());
            ps.setString(5, ssnParam);

            int rowsUpdated = ps.executeUpdate();

            ps.close();
            ps = null;

            if (rowsUpdated > 0) {

                message =
                    "Representative updated successfully.";

                updatedSuccessfully = true;

            } else {

                message =
                    "Representative could not be updated.";
            }

        } else {

            message =
                "Please complete all fields.";
        }

    } else {

        String selectSql =
            "SELECT FirstName, LastName, Username, Password " +
            "FROM Employee " +
            "WHERE SSN=? AND Role='REP'";

        ps = con.prepareStatement(selectSql);

        ps.setString(1, ssnParam);

        rs = ps.executeQuery();

        if (rs.next()) {

            firstName =
                rs.getString("FirstName");

            lastName =
                rs.getString("LastName");

            username =
                rs.getString("Username");

            password =
                rs.getString("Password");

        } else {

            response.sendRedirect("manageReps.jsp");
            return;
        }
    }

} catch (SQLIntegrityConstraintViolationException e) {

    message =
        "That username is already being used by another employee.";

} catch (Exception e) {

    message =
        "Error updating representative: " +
        e.getMessage();

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
<title>Edit Customer Representative</title>

<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    text-align: center;
    margin-top: 60px;
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
    color: #5cb85c;
}

label {
    display: block;
    text-align: left;
    margin-top: 15px;
    font-weight: bold;
}

input {
    width: 95%;
    padding: 10px;
    margin-top: 5px;
}

button, a {
    display: inline-block;
    margin: 12px;
    text-decoration: none;
    color: white;
    background-color: #5cb85c;
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

button:hover, a:hover {
    background-color: #449d44;
}

.message {
    margin: 20px 0;
    font-weight: bold;
}

.ssn-box {
    background-color: #f8f8f8;
    padding: 10px;
    margin-bottom: 20px;
    border-radius: 5px;
}
</style>

</head>

<body>

<div class="container">

<% if (updatedSuccessfully) { %>

    <h2>Representative Updated</h2>

    <div class="message">
        <%= message %>
    </div>

    <a href="manageReps.jsp">
        Back to Manage Representatives
    </a>

<% } else { %>

    <h2>Edit Customer Representative</h2>

    <div class="ssn-box">

        <strong>SSN:</strong>
        <%= ssnParam %>

    </div>

    <% if (message != null) { %>

        <div class="message">
            <%= message %>
        </div>

    <% } %>

    <form method="post"
          action="editRep.jsp?ssn=<%= ssnParam %>">

        <label for="firstName">
            First Name
        </label>

        <input
            type="text"
            id="firstName"
            name="firstName"
            value="<%= firstName %>"
            required>

        <label for="lastName">
            Last Name
        </label>

        <input
            type="text"
            id="lastName"
            name="lastName"
            value="<%= lastName %>"
            required>

        <label for="username">
            Username
        </label>

        <input
            type="text"
            id="username"
            name="username"
            value="<%= username %>"
            required>

        <label for="password">
            Password
        </label>

        <input
            type="text"
            id="password"
            name="password"
            value="<%= password %>"
            required>

        <button type="submit">
            Save Changes
        </button>

    </form>

    <a href="manageReps.jsp">
        Cancel
    </a>

<% } %>

</div>

</body>
</html>