<%@ page import="java.sql.*" %>

<%
String username = request.getParameter("username");
String password = request.getParameter("password");

String url = "jdbc:mysql://localhost:3306/railway_booking";
String dbUser = "root";    // added my user
String dbPassword = "add_your_SQL_WORKBENCH_pass"; // works when i put my pass but not sure how it
                               //works when shared 

try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(url, dbUser, dbPassword);

    String sql = "SELECT * FROM Customer WHERE Username=? AND Password=?";
    PreparedStatement ps = con.prepareStatement(sql);

    ps.setString(1, username);
    ps.setString(2, password);

    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        session.setAttribute("user", username);
        response.sendRedirect("success.jsp");
    } else {
        out.println("<h2>Invalid username or password.</h2>");
        out.println("<a href='index.jsp'>Try Again</a>");
    }

    rs.close();
    ps.close();
    con.close();

} catch (Exception e) {
    out.println("<h2>Error connecting to database</h2>");
    out.println(e.getMessage());
}
%>