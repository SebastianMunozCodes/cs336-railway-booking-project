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

Connection con = null;
PreparedStatement ps = null;

String message = null;
boolean deletedSuccessfully = false;

try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    con =
        DriverManager.getConnection(
            url,
            dbUser,
            dbPassword
        );

    String deleteSql =
        "DELETE FROM Employee " +
        "WHERE SSN=? AND Role='REP'";

    ps = con.prepareStatement(deleteSql);

    ps.setString(1, ssnParam);

    int rowsDeleted =
        ps.executeUpdate();

    if (rowsDeleted > 0) {

        message =
            "Representative deleted successfully.";

        deletedSuccessfully = true;

    } else {

        message =
            "Representative was not found or could not be deleted.";
    }

} catch (SQLIntegrityConstraintViolationException e) {

    message =
        "This representative cannot be deleted because existing customer replies reference this employee.";

} catch (Exception e) {

    message =
        "Error deleting representative: " +
        e.getMessage();

} finally {

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
<title>Delete Customer Representative</title>

<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    text-align: center;
    margin-top: 100px;
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
    color: <%= deletedSuccessfully ? "green" : "#d9534f" %>;
}

a {
    display: inline-block;
    margin-top: 20px;
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

    <h2>
        <%= deletedSuccessfully
            ? "Representative Deleted"
            : "Unable to Delete Representative" %>
    </h2>

    <p>
        <%= message %>
    </p>

    <a href="manageReps.jsp">
        Back to Manage Representatives
    </a>

</div>

</body>
</html>