<%@ page import="java.sql.*" %>

<%
String firstName = request.getParameter("firstName");
String lastName = request.getParameter("lastName");
String username = request.getParameter("username");
String email = request.getParameter("email");
String password = request.getParameter("password");

String url = "jdbc:mysql://localhost:3306/railway_booking";
String dbUser = "root";
String dbPassword = "";

Connection con = null;
PreparedStatement checkStatement = null;
PreparedStatement insertStatement = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(url, dbUser, dbPassword);

    String checkSql =
        "SELECT Username FROM Customer WHERE Username = ? OR Email = ?";

    checkStatement = con.prepareStatement(checkSql);
    checkStatement.setString(1, username);
    checkStatement.setString(2, email);

    rs = checkStatement.executeQuery();

    if (rs.next()) {
%>

        <h2>Username or email already exists.</h2>
        <a href="register.jsp">Try Again</a>

<%
    } else {
        String insertSql =
            "INSERT INTO Customer " +
            "(FirstName, LastName, Username, Email, Password) " +
            "VALUES (?, ?, ?, ?, ?)";

        insertStatement = con.prepareStatement(insertSql);

        insertStatement.setString(1, firstName);
        insertStatement.setString(2, lastName);
        insertStatement.setString(3, username);
        insertStatement.setString(4, email);
        insertStatement.setString(5, password);

        insertStatement.executeUpdate();
%>

        <h2>Account created successfully!</h2>
        <p>You can now log in.</p>
        <a href="index.jsp">Go to Login</a>

<%
    }

} catch (Exception e) {
    e.printStackTrace();
%>

    <h2>Registration failed.</h2>
    <p><%= e.getMessage() %></p>
    <a href="register.jsp">Try Again</a>

<%
} finally {
    try {
        if (rs != null) {
            rs.close();
        }

        if (checkStatement != null) {
            checkStatement.close();
        }

        if (insertStatement != null) {
            insertStatement.close();
        }

        if (con != null) {
            con.close();
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>