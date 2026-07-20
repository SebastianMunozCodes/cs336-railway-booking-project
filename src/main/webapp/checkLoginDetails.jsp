<%@ page import="java.sql.*" %>

<%
String username = request.getParameter("username");
String password = request.getParameter("password");

String url = "jdbc:mysql://localhost:3306/railway_booking";
String dbUser = "root";
String dbPassword = "";

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection(url, dbUser, dbPassword);

    // 1. Check whether the login belongs to a customer
    String customerSql =
        "SELECT Username FROM Customer WHERE Username=? AND Password=?";

    ps = con.prepareStatement(customerSql);
    ps.setString(1, username);
    ps.setString(2, password);

    rs = ps.executeQuery();

    if (rs.next()) {
        session.setAttribute("user", username);
        session.setAttribute("role", "CUSTOMER");

        response.sendRedirect("customerDashboard.jsp");
        return;
    }

    rs.close();
    ps.close();

    // 2. If not a customer, check whether the login belongs to an employee
    String employeeSql =
        "SELECT SSN, Username, Role FROM Employee WHERE Username=? AND Password=?";

    ps = con.prepareStatement(employeeSql);
    ps.setString(1, username);
    ps.setString(2, password);

    rs = ps.executeQuery();

    if (rs.next()) {
        String role = rs.getString("Role");
        String employeeSSN = rs.getString("SSN");

        session.setAttribute("user", username);
        session.setAttribute("role", role);
        session.setAttribute("employeeSSN", employeeSSN);

        if ("ADMIN".equals(role)) {
            response.sendRedirect("adminDashboard.jsp");
            return;
        } else if ("REP".equals(role)) {
            response.sendRedirect("repDashboard.jsp");
            return;
        }
    }

    // 3. No matching account found
    out.println("<h2>Invalid username or password.</h2>");
    out.println("<a href='index.jsp'>Try Again</a>");

} catch (Exception e) {
    out.println("<h2>Error connecting to database</h2>");
    out.println(e.getMessage());

} finally {

    try {
        if (rs != null) {
            rs.close();
        }
    } catch (SQLException e) {
        // Ignore cleanup error
    }

    try {
        if (ps != null) {
            ps.close();
        }
    } catch (SQLException e) {
        // Ignore cleanup error
    }

    try {
        if (con != null) {
            con.close();
        }
    } catch (SQLException e) {
        // Ignore cleanup error
    }
}
%>
