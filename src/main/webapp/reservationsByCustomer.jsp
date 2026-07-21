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

String selectedCustomer = request.getParameter("username");

String url = "jdbc:mysql://localhost:3306/railway_booking";
String dbUser = "root";
String dbPassword = "";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Reservations by Customer</title>

<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 40px;
}

.container {
    background-color: white;
    max-width: 1100px;
    margin: auto;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0px 0px 10px lightgray;
}

h2 {
    text-align: center;
    color: #5cb85c;
}

.search-box {
    text-align: center;
    margin-bottom: 25px;
}

select {
    padding: 10px;
    min-width: 250px;
}

button, a {
    display: inline-block;
    margin: 8px;
    text-decoration: none;
    color: white;
    background-color: #5cb85c;
    padding: 10px 18px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

button:hover, a:hover {
    background-color: #449d44;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 25px;
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

.back {
    text-align: center;
    margin-top: 25px;
}
</style>

</head>

<body>

<div class="container">

<h2>Reservations by Customer</h2>

<div class="search-box">

<form method="get" action="reservationsByCustomer.jsp">

    <label for="username">
        Customer:
    </label>

    <select name="username" id="username" required>

        <option value="">
            -- Select Customer --
        </option>

<%
Connection customerCon = null;
PreparedStatement customerPs = null;
ResultSet customerRs = null;

try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    customerCon =
        DriverManager.getConnection(url, dbUser, dbPassword);

    customerPs =
        customerCon.prepareStatement(
            "SELECT Username, FirstName, LastName " +
            "FROM Customer " +
            "ORDER BY LastName, FirstName"
        );

    customerRs = customerPs.executeQuery();

    while (customerRs.next()) {

        String customerUsername =
            customerRs.getString("Username");

        String selected = "";

        if (
            selectedCustomer != null &&
            selectedCustomer.equals(customerUsername)
        ) {
            selected = "selected";
        }
%>

        <option
            value="<%= customerUsername %>"
            <%= selected %>>

            <%= customerRs.getString("FirstName") %>
            <%= customerRs.getString("LastName") %>
            (<%= customerUsername %>)

        </option>

<%
    }

} catch (Exception e) {
%>

        <option disabled>
            Error loading customers
        </option>

<%
} finally {

    try {
        if (customerRs != null) customerRs.close();
    } catch (SQLException e) {}

    try {
        if (customerPs != null) customerPs.close();
    } catch (SQLException e) {}

    try {
        if (customerCon != null) customerCon.close();
    } catch (SQLException e) {}
}
%>

    </select>

    <button type="submit">
        Search
    </button>

</form>

</div>

<%
if (
    selectedCustomer != null &&
    !selectedCustomer.trim().isEmpty()
) {

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

        String sql =
            "SELECT " +
            "r.ReservationNumber, " +
            "r.ReservationDate, " +
            "s.ScheduleID, " +
            "s.TrainID, " +
            "s.LineName, " +
            "so.StationName AS OriginStation, " +
            "sd.StationName AS DestinationStation, " +
            "r.TicketType, " +
            "r.DiscountType, " +
            "r.TotalFare, " +
            "r.Status " +
            "FROM Reservation r " +
            "JOIN Schedule s " +
            "ON r.ScheduleID = s.ScheduleID " +
            "JOIN Station so " +
            "ON r.OriginStationID = so.StationID " +
            "JOIN Station sd " +
            "ON r.DestinationStationID = sd.StationID " +
            "WHERE r.Username = ? " +
            "ORDER BY r.ReservationDate DESC";

        ps = con.prepareStatement(sql);

        ps.setString(1, selectedCustomer);

        rs = ps.executeQuery();

        boolean found = false;
%>

<h2>
Reservations for <%= selectedCustomer %>
</h2>

<table>

<tr>
    <th>Reservation #</th>
    <th>Schedule</th>
    <th>Train</th>
    <th>Transit Line</th>
    <th>Origin</th>
    <th>Destination</th>
    <th>Ticket</th>
    <th>Discount</th>
    <th>Fare</th>
    <th>Status</th>
</tr>

<%
        while (rs.next()) {

            found = true;
%>

<tr>

    <td>
        <%= rs.getInt("ReservationNumber") %>
    </td>

    <td>
        <%= rs.getInt("ScheduleID") %>
    </td>

    <td>
        <%= rs.getString("TrainID") %>
    </td>

    <td>
        <%= rs.getString("LineName") %>
    </td>

    <td>
        <%= rs.getString("OriginStation") %>
    </td>

    <td>
        <%= rs.getString("DestinationStation") %>
    </td>

    <td>
        <%= rs.getString("TicketType") %>
    </td>

    <td>
        <%= rs.getString("DiscountType") %>
    </td>

    <td>
        $<%= rs.getBigDecimal("TotalFare") %>
    </td>

    <td>
        <%= rs.getString("Status") %>
    </td>

</tr>

<%
        }

        if (!found) {
%>

<tr>
    <td colspan="10" style="text-align:center;">
        No reservations found for this customer.
    </td>
</tr>

<%
        }
%>

</table>

<%
    } catch (Exception e) {
%>

<p>
    Error loading reservations:
    <%= e.getMessage() %>
</p>

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