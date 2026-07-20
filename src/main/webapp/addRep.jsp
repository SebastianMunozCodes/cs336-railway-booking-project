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

String message = null;
boolean addedSuccessfully = false;

if ("POST".equalsIgnoreCase(request.getMethod())) {

    String ssn = request.getParameter("ssn");
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    if (
        ssn != null &&
        firstName != null &&
        lastName != null &&
        username != null &&
        password != null &&
        !ssn.trim().isEmpty() &&
        !firstName.trim().isEmpty() &&
        !lastName.trim().isEmpty() &&
        !username.trim().isEmpty() &&
        !password.trim().isEmpty()
    ) {

        String url = "jdbc:mysql://localhost:3306/railway_booking";
        String dbUser = "root";
        String dbPassword = "";

        Connection con = null;
        PreparedStatement ps = null;

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                url,
                dbUser,
                dbPassword
            );

            String sql =
                "INSERT INTO Employee " +
                "(SSN, FirstName, LastName, Username, Password, Role) " +
                "VALUES (?, ?, ?, ?, ?, 'REP')";

            ps = con.prepareStatement(sql);

            ps.setString(1, ssn.trim());
            ps.setString(2, firstName.trim());
            ps.setString(3, lastName.trim());
            ps.setString(4, username.trim());
            ps.setString(5, password.trim());

            ps.executeUpdate();

            message = "Representative added successfully.";
            addedSuccessfully = true;

        } catch (SQLIntegrityConstraintViolationException e) {

            message =
                "A representative with that SSN or username already exists.";

        } catch (Exception e) {

            message =
                "Error adding representative: " +
                e.getMessage();

        } finally {

            try {
                if (ps != null) ps.close();
            } catch (SQLException e) {}

            try {
                if (con != null) con.close();
            } catch (SQLException e) {}
        }

    } else {

        message = "Please complete all fields.";
    }
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Customer Representative</title>

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
</style>

</head>

<body>

<div class="container">

<% if (addedSuccessfully) { %>

    <h2>Representative Added</h2>

    <div class="message">
        <%= message %>
    </div>

    <a href="addRep.jsp">
        Add Another Representative
    </a>

    <a href="manageReps.jsp">
        Back to Manage Representatives
    </a>

<% } else { %>

    <h2>Add Customer Representative</h2>

    <% if (message != null) { %>

        <div class="message">
            <%= message %>
        </div>

    <% } %>

    <form method="post" action="addRep.jsp">

        <label for="ssn">
            SSN
        </label>

        <input
            type="text"
            id="ssn"
            name="ssn"
            maxlength="9"
            required>

        <label for="firstName">
            First Name
        </label>

        <input
            type="text"
            id="firstName"
            name="firstName"
            required>

        <label for="lastName">
            Last Name
        </label>

        <input
            type="text"
            id="lastName"
            name="lastName"
            required>

        <label for="username">
            Username
        </label>

        <input
            type="text"
            id="username"
            name="username"
            required>

        <label for="password">
            Password
        </label>

        <input
            type="password"
            id="password"
            name="password"
            required>

        <button type="submit">
            Add Representative
        </button>

    </form>

    <a href="manageReps.jsp">
        Cancel
    </a>

<% } %>

</div>

</body>
</html>