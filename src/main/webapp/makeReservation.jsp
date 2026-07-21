<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
String user = (String) session.getAttribute("user");
String role = (String) session.getAttribute("role");

if (user == null || role == null || !"CUSTOMER".equals(role)) {
    response.sendRedirect("index.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Make Reservation</title>

<style>

body {
    font-family: Arial, sans-serif;
    background: #f4f4f4;
    margin: 0;
}

.container {
    width: 500px;
    margin: 60px auto;
    padding: 30px;
    background: white;
    border-radius: 8px;
    box-shadow: 0 0 10px lightgray;
}

h2 {
    text-align: center;
    color: green;
}

.schedule-info {
    background: #f7f7f7;
    padding: 18px;
    margin-bottom: 25px;
    border-radius: 5px;
    line-height: 1.7;
}

label {
    display: block;
    margin-top: 15px;
    margin-bottom: 5px;
    font-weight: bold;
}

select {
    width: 100%;
    padding: 10px;
    box-sizing: border-box;
    border: 1px solid #cccccc;
    border-radius: 4px;
}

input[type="submit"] {
    width: 100%;
    margin-top: 25px;
    padding: 12px;
    background: #cc0033;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-size: 16px;
}

input[type="submit"]:hover {
    background: #a30029;
}

.message {
    text-align: center;
    font-size: 18px;
}

.button-area {
    text-align: center;
    margin-top: 20px;
}

.button {
    color: #cc0033;
    text-decoration: none;
}

.button:hover {
    text-decoration: underline;
}

</style>
</head>

<body>

<div class="container">

<h2>Make a Reservation</h2>

<%
String scheduleIDText = request.getParameter("scheduleID");
String origin = request.getParameter("origin");
String destination = request.getParameter("destination");

String url = "jdbc:mysql://localhost:3306/railway_booking";
String dbUser = "root";
String dbPassword = "";

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

SimpleDateFormat formatter =
    new SimpleDateFormat("MMM d, yyyy h:mm a");

boolean scheduleFound = false;
%>

<%
if (scheduleIDText == null ||
    scheduleIDText.trim().isEmpty()) {
%>

<p class="message">
No schedule was selected.
</p>

<%
} else {

    try {

        int scheduleID =
            Integer.parseInt(scheduleIDText);

        Class.forName("com.mysql.cj.jdbc.Driver");

        con = DriverManager.getConnection(
            url,
            dbUser,
            dbPassword
        );

        String sql =
            "SELECT s.ScheduleID, s.TrainID, s.LineName, " +
            "s.DepartureDateTime, s.ArrivalDateTime, " +
            "s.TravelTime, t.Fare " +
            "FROM Schedule s " +
            "JOIN TransitLine t " +
            "ON s.LineName = t.LineName " +
            "WHERE s.ScheduleID = ?";

        ps = con.prepareStatement(sql);
        ps.setInt(1, scheduleID);

        rs = ps.executeQuery();

        if (rs.next()) {

            scheduleFound = true;
%>

<div class="schedule-info">

<strong>Schedule ID:</strong>
<%= rs.getInt("ScheduleID") %>

<br>

<strong>Train:</strong>
<%= rs.getString("TrainID") %>

<br>

<strong>Transit Line:</strong>
<%= rs.getString("LineName") %>

<br>

<strong>Origin:</strong>
<%= origin %>

<br>

<strong>Destination:</strong>
<%= destination %>

<br>

<strong>Departure:</strong>
<%= formatter.format(
        rs.getTimestamp("DepartureDateTime")
    ) %>

<br>

<strong>Arrival:</strong>
<%= formatter.format(
        rs.getTimestamp("ArrivalDateTime")
    ) %>

<br>

<strong>Travel Time:</strong>
<%= rs.getInt("TravelTime") %> minutes

<br>

<strong>Base Fare:</strong>
$<%= rs.getBigDecimal("Fare") %>

</div>

<form action="confirmReservation.jsp" method="post">

    <input
        type="hidden"
        name="scheduleID"
        value="<%= rs.getInt("ScheduleID") %>">

    <input
        type="hidden"
        name="origin"
        value="<%= origin %>">

    <input
        type="hidden"
        name="destination"
        value="<%= destination %>">

    <label for="ticketType">
        Ticket Type
    </label>

    <select
        id="ticketType"
        name="ticketType"
        required>

        <option value="One-Way">
            One-Way
        </option>

        <option value="Round-Trip">
            Round-Trip
        </option>

    </select>

    <label for="discountType">
        Discount
    </label>

    <select
        id="discountType"
        name="discountType"
        required>

        <option value="None">
            No Discount
        </option>

        <option value="Child">
            Child:  25% Off
        </option>

        <option value="Senior">
            Senior: 35% Off
        </option>

        <option value="Disabled">
            Disabled: 50% Off
        </option>

    </select>

    <input
        type="submit"
        value="Confirm Reservation">

</form>

<%
        } else {
%>

<p class="message">
The selected schedule was not found.
</p>

<%
        }

    } catch (NumberFormatException e) {
%>

<p class="message">
Invalid schedule number.
</p>

<%
    } catch (Exception e) {
%>

<p class="message">
Error:
<br><br>
<%= e.getMessage() %>
</p>

<%
    } finally {

        try {

            if (rs != null) {
                rs.close();
            }

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
}
%>

<div class="button-area">

<a class="button"
   href="javascript:history.back()">
    Back to Search Results
</a>

</div>

</div>

</body>
</html>