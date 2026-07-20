<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
String user = (String) session.getAttribute("user");
String role = (String) session.getAttribute("role");

if (user == null || role == null || !"REP".equals(role)) {
    response.sendRedirect("index.jsp");
    return;
}

String selectedLine = request.getParameter("lineName");
String selectedDate = request.getParameter("travelDate");

String url = "jdbc:mysql://localhost:3306/railway_booking";
String dbUser = "root";
String dbPassword = "";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Customers by Transit Line and Date</title>

<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 40px;
}

.container {
    background-color: white;
    max-width: 1150px;
    margin: auto;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0px 0px 10px lightgray;
}

h2 {
    text-align: center;
    color: #337ab7;
}

.search-box {
    text-align: center;
    margin-bottom: 30px;
}

select, input {
    padding: 10px;
    margin: 5px;
}

button, a {
    display: inline-block;
    text-decoration: none;
    color: white;
    background-color: #337ab7;
    padding: 10px 18px;
    margin: 5px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

button:hover, a:hover {
    background-color: #286090;
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
    background-color: #337ab7;
    color: white;
}

.back {
    text-align: center;
    margin-top: 25px;
}

.message {
    text-align: center;
    margin-top: 20px;
}
</style>

</head>

<body>

<div class="container">

<h2>Find Customers by Transit Line and Date</h2>

<div class="search-box">

<form method="get" action="customersByLineDate.jsp">

    <label for="lineName">
        Transit Line:
    </label>

    <select name="lineName" id="lineName" required>

        <option value="">
            -- Select Transit Line --
        </option>

<%
Connection lineCon = null;
PreparedStatement linePs = null;
ResultSet lineRs = null;

try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    lineCon =
        DriverManager.getConnection(url, dbUser, dbPassword);

    linePs =
        lineCon.prepareStatement(
            "SELECT LineName FROM TransitLine ORDER BY LineName"
        );

    lineRs = linePs.executeQuery();

    while (lineRs.next()) {

        String lineName =
            lineRs.getString("LineName");

        String selected = "";

        if (
            selectedLine != null &&
            selectedLine.equals(lineName)
        ) {
            selected = "selected";
        }
%>

        <option
            value="<%= lineName %>"
            <%= selected %>>
            <%= lineName %>
        </option>

<%
    }

} catch (Exception e) {
%>

        <option disabled>
            Error loading transit lines
        </option>

<%
} finally {

    try {
        if (lineRs != null) lineRs.close();
    } catch (SQLException e) {}

    try {
        if (linePs != null) linePs.close();
    } catch (SQLException e) {}

    try {
        if (lineCon != null) lineCon.close();
    } catch (SQLException e) {}
}
%>

    </select>

    <label for="travelDate">
        Date:
    </label>

    <input
        type="date"
        id="travelDate"
        name="travelDate"
        value="<%= selectedDate != null ? selectedDate : "" %>"
        required>

    <button type="submit">
        Search
    </button>

</form>

</div>

<%
if (
    selectedLine != null &&
    !selectedLine.trim().isEmpty() &&
    selectedDate != null &&
    !selectedDate.trim().isEmpty()
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
            "c.Username, " +
            "c.FirstName, " +
            "c.LastName, " +
            "s.TrainID, " +
            "s.LineName, " +
            "so.StationName AS OriginStation, " +
            "sd.StationName AS DestinationStation, " +
            "s.DepartureDateTime, " +
            "s.ArrivalDateTime, " +
            "r.TotalFare, " +
            "r.Status " +
            "FROM Reservation r " +
            "JOIN Customer c " +
            "ON r.Username = c.Username " +
            "JOIN Schedule s " +
            "ON r.ScheduleID = s.ScheduleID " +
            "JOIN Station so " +
            "ON r.OriginStationID = so.StationID " +
            "JOIN Station sd " +
            "ON r.DestinationStationID = sd.StationID " +
            "WHERE s.LineName = ? " +
            "AND DATE(s.DepartureDateTime) = ? " +
            "ORDER BY c.LastName, c.FirstName";

        ps = con.prepareStatement(sql);

        ps.setString(1, selectedLine);
        ps.setString(2, selectedDate);

        rs = ps.executeQuery();

        boolean found = false;
%>

<h2>
Customers Reserved on <%= selectedLine %>
for <%= selectedDate %>
</h2>

<table>

<tr>
    <th>Reservation #</th>
    <th>Customer</th>
    <th>Username</th>
    <th>Train</th>
    <th>Origin</th>
    <th>Destination</th>
    <th>Departure</th>
    <th>Arrival</th>
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
        <%= rs.getString("FirstName") %>
        <%= rs.getString("LastName") %>
    </td>

    <td>
        <%= rs.getString("Username") %>
    </td>

    <td>
        <%= rs.getString("TrainID") %>
    </td>

    <td>
        <%= rs.getString("OriginStation") %>
    </td>

    <td>
        <%= rs.getString("DestinationStation") %>
    </td>

    <td>
        <%= rs.getTimestamp("DepartureDateTime") %>
    </td>

    <td>
        <%= rs.getTimestamp("ArrivalDateTime") %>
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
        No customers found with reservations for this transit line and date.
    </td>
</tr>

<%
        }

%>

</table>

<%
    } catch (Exception e) {
%>

<p class="message">
    Error loading customers:
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

    <a href="repDashboard.jsp">
        Back to Representative Dashboard
    </a>

</div>

</div>

</body>
</html>