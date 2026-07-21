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

String selectedMonth = request.getParameter("month");

/*
 * Default to the most recent month that has reservation data.
 * With the current sample data, this should resolve to 2026-07.
 */
if (selectedMonth == null || selectedMonth.trim().isEmpty()) {

    try (
        Connection defaultCon =
            DriverManager.getConnection(url, dbUser, dbPassword);

        PreparedStatement defaultPS =
            defaultCon.prepareStatement(
                "SELECT DATE_FORMAT(MAX(ReservationDate), '%Y-%m') AS LatestMonth " +
                "FROM Reservation"
            );

        ResultSet defaultRS =
            defaultPS.executeQuery()
    ) {

        if (defaultRS.next()) {
            selectedMonth = defaultRS.getString("LatestMonth");
        }

    } catch (Exception e) {
        selectedMonth = null;
    }
}

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>Top Five Transit Lines</title>

<style>

body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 40px;
}

.container {
    background-color: white;
    max-width: 850px;
    margin: auto;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0px 0px 10px lightgray;
}

h2 {
    text-align: center;
    color: #5cb85c;
}

.description {
    text-align: center;
    margin-bottom: 25px;
}

form {
    text-align: center;
    margin-bottom: 25px;
}

label {
    font-weight: bold;
    margin-right: 8px;
}

input[type="month"] {
    padding: 8px;
    font-size: 15px;
}

button {
    margin-left: 8px;
    padding: 9px 16px;
    border: none;
    border-radius: 5px;
    background-color: #5cb85c;
    color: white;
    cursor: pointer;
}

button:hover {
    background-color: #449d44;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 25px;
}

th,
td {
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
    margin-top: 25px;
    text-decoration: none;
    color: white;
    background-color: #5cb85c;
    padding: 10px 18px;
    border-radius: 5px;
}

a:hover {
    background-color: #449d44;
}

.back {
    text-align: center;
}

.no-data {
    text-align: center;
}

</style>

</head>

<body>

<div class="container">

<h2>Top Five Transit Lines by Month</h2>

<p class="description">
    Displays the five most active transit lines based on the number
    of reservations made during the selected month.
</p>

<form method="get" action="topTransitLines.jsp">

    <label for="month">
        Select Month:
    </label>

    <input
        type="month"
        id="month"
        name="month"
        value="<%= selectedMonth != null ? selectedMonth : "" %>"
        required
    >

    <button type="submit">
        View Report
    </button>

</form>

<%
if (selectedMonth != null && !selectedMonth.trim().isEmpty()) {
%>

<table>

<tr>
    <th>Rank</th>
    <th>Transit Line</th>
    <th>Reservations This Month</th>
</tr>

<%
try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    con =
        DriverManager.getConnection(
            url,
            dbUser,
            dbPassword
        );

    /*
     * Start from TransitLine so that lines with zero reservations
     * during the selected month are still considered.
     *
     * The month condition is placed inside the LEFT JOIN rather
     * than WHERE so that zero-reservation lines are not removed.
     */
    String sql =
        "SELECT " +
        "tl.LineName, " +
        "COUNT(r.ReservationNumber) AS ReservationCount " +

        "FROM TransitLine tl " +

        "LEFT JOIN Schedule s " +
        "ON tl.LineName = s.LineName " +

        "LEFT JOIN Reservation r " +
        "ON s.ScheduleID = r.ScheduleID " +
        "AND r.Status <> 'Cancelled' " +
        "AND DATE_FORMAT(r.ReservationDate, '%Y-%m') = ? " +

        "GROUP BY tl.LineName " +

        "ORDER BY " +
        "ReservationCount DESC, " +
        "tl.LineName " +

        "LIMIT 5";

    ps = con.prepareStatement(sql);

    ps.setString(
        1,
        selectedMonth
    );

    rs = ps.executeQuery();

    boolean found = false;
    int rank = 1;

    while (rs.next()) {

        found = true;
%>

<tr>

    <td>
        <%= rank %>
    </td>

    <td>
        <%= rs.getString("LineName") %>
    </td>

    <td>
        <%= rs.getInt("ReservationCount") %>
    </td>

</tr>

<%
        rank++;
    }

    if (!found) {
%>

<tr>

    <td colspan="3" class="no-data">
        No transit line data found.
    </td>

</tr>

<%
    }

} catch (Exception e) {
%>

<tr>

    <td colspan="3">
        Error loading top transit lines:
        <%= e.getMessage() %>
    </td>

</tr>

<%
} finally {

    try {
        if (rs != null) {
            rs.close();
        }
    } catch (SQLException e) {}

    try {
        if (ps != null) {
            ps.close();
        }
    } catch (SQLException e) {}

    try {
        if (con != null) {
            con.close();
        }
    } catch (SQLException e) {}
}
%>

</table>

<%
}
%>

<div class="back">

    <a href="adminReports.jsp">
        Back to Reports
    </a>

</div>

</div>

</body>
</html>