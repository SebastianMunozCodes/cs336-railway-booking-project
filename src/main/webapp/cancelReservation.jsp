<%@ page import="java.sql.*" %>

<%
String username =
    (String) session.getAttribute("user");

String role =
    (String) session.getAttribute("role");

String reservationNumberText =
    request.getParameter("reservationNumber");

String url =
    "jdbc:mysql://localhost:3306/railway_booking";

String dbUser = "root";
String dbPassword = "";

Connection con = null;
PreparedStatement ps = null;

if (username == null ||
    role == null ||
    !"CUSTOMER".equals(role)) {

    response.sendRedirect("index.jsp");
    return;
}

if (reservationNumberText == null ||
    reservationNumberText.trim().isEmpty()) {

    response.sendRedirect(
        "myReservations.jsp?message=error"
    );

    return;
}

try {

    int reservationNumber =
        Integer.parseInt(reservationNumberText);

    Class.forName(
        "com.mysql.cj.jdbc.Driver"
    );

    con =
        DriverManager.getConnection(
            url,
            dbUser,
            dbPassword
        );

   
    String sql =
        "UPDATE Reservation r " +
        "JOIN Schedule s " +
        "ON r.ScheduleID = s.ScheduleID " +
        "SET r.Status = 'Cancelled' " +
        "WHERE r.ReservationNumber = ? " +
        "AND r.Username = ? " +
        "AND r.Status = 'Current' " +
        "AND s.DepartureDateTime > NOW()";

    ps =
        con.prepareStatement(sql);

    ps.setInt(
        1,
        reservationNumber
    );

    ps.setString(
        2,
        username
    );

    int rowsUpdated =
        ps.executeUpdate();

    if (rowsUpdated > 0) {

    	response.sendRedirect(
    		    "myReservations.jsp?message=notFound"
    		);

    } else {

        response.sendRedirect(
            "myReservations.jsp?message=error"
        );
    }

} catch (Exception e) {

    response.sendRedirect(
        "myReservations.jsp?message=error"
    );

} finally {

    try {

        if (ps != null) {
            ps.close();
        }

        if (con != null) {
            con.close();
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>