<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.math.RoundingMode" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Reservation Confirmation</title>

<style>

body {
    font-family: Arial, sans-serif;
    background: #f4f4f4;
    margin: 0;
}

.container {
    width: 500px;
    margin: 70px auto;
    padding: 30px;
    background: white;
    border-radius: 8px;
    box-shadow: 0 0 10px lightgray;
}

h2 {
    text-align: center;
    color: green;
}

.confirmation {
    background: #f7f7f7;
    padding: 20px;
    border-radius: 5px;
    line-height: 1.8;
    margin-top: 20px;
}

.message {
    text-align: center;
    font-size: 18px;
    line-height: 1.6;
}

.button-area {
    text-align: center;
    margin-top: 25px;
}

.button {
    display: inline-block;
    margin: 5px;
    padding: 12px 22px;
    background: #cc0033;
    color: white;
    text-decoration: none;
    border-radius: 5px;
}

.button:hover {
    background: #a30029;
}

</style>
</head>

<body>

<div class="container">

<h2>Reservation Confirmation</h2>

<%
String username =
(String) session.getAttribute("user");

String scheduleIDText =
    request.getParameter("scheduleID");

String origin =
    request.getParameter("origin");

String destination =
    request.getParameter("destination");

String ticketType =
    request.getParameter("ticketType");

String discountType =
    request.getParameter("discountType");

String url =
    "jdbc:mysql://localhost:3306/railway_booking";

String dbUser = "root";
String dbPassword = "";

Connection con = null;

PreparedStatement schedulePS = null;
PreparedStatement stationPS = null;
PreparedStatement insertPS = null;

ResultSet scheduleRS = null;
ResultSet stationRS = null;

boolean reservationCreated = false;

int reservationNumber = 0;
int scheduleID = 0;
int originStationID = 0;
int destinationStationID = 0;

BigDecimal baseFare = BigDecimal.ZERO;
BigDecimal totalFare = BigDecimal.ZERO;
%>

<%
if (username == null) {
%>

<p class="message">
You must be logged in before making a reservation.
</p>

<div class="button-area">
    <a class="button" href="index.jsp">
        Go to Login
    </a>
</div>

<%
} else if (
    scheduleIDText == null ||
    origin == null ||
    destination == null ||
    ticketType == null ||
    discountType == null
) {
%>

<p class="message">
Some reservation information is missing.
</p>

<div class="button-area">
    <a class="button" href="search.jsp">
        Return to Search
    </a>
</div>

<%
} else {

    try {

        scheduleID =
            Integer.parseInt(scheduleIDText);

        Class.forName(
            "com.mysql.cj.jdbc.Driver"
        );

        con = DriverManager.getConnection(
            url,
            dbUser,
            dbPassword
        );

        
        String scheduleSql =
            "SELECT t.Fare " +
            "FROM Schedule s " +
            "JOIN TransitLine t " +
            "ON s.LineName = t.LineName " +
            "WHERE s.ScheduleID = ?";

        schedulePS =
            con.prepareStatement(scheduleSql);

        schedulePS.setInt(
            1,
            scheduleID
        );

        scheduleRS =
            schedulePS.executeQuery();

        if (!scheduleRS.next()) {
            throw new Exception(
                "The selected schedule was not found."
            );
        }

        baseFare =
            scheduleRS.getBigDecimal("Fare");

        totalFare = baseFare;

       
        if ("Round-Trip".equals(ticketType)) {
            totalFare =
                totalFare.multiply(
                    new BigDecimal("2.00")
                );
        }

        
        if ("Child".equals(discountType)) {

            totalFare =
                totalFare.multiply(
                    new BigDecimal("0.75")
                );

        } else if ("Senior".equals(discountType)) {

            totalFare =
                totalFare.multiply(
                    new BigDecimal("0.65")
                );

        } else if ("Disabled".equals(discountType)) {

            totalFare =
                totalFare.multiply(
                    new BigDecimal("0.50")
                );

        } else {

            discountType = "None";
        }

        totalFare =
            totalFare.setScale(
                2,
                RoundingMode.HALF_UP
            );

        
        String stationSql =
            "SELECT StationID " +
            "FROM Station " +
            "WHERE StationName = ?";

        stationPS =
            con.prepareStatement(stationSql);

        stationPS.setString(
            1,
            origin
        );

        stationRS =
            stationPS.executeQuery();

        if (!stationRS.next()) {
            throw new Exception(
                "The origin station was not found."
            );
        }

        originStationID =
            stationRS.getInt("StationID");

        stationRS.close();
        stationRS = null;

        stationPS.close();
        stationPS = null;

        
        stationPS =
            con.prepareStatement(stationSql);

        stationPS.setString(
            1,
            destination
        );

        stationRS =
            stationPS.executeQuery();

        if (!stationRS.next()) {
            throw new Exception(
                "The destination station was not found."
            );
        }

        destinationStationID =
            stationRS.getInt("StationID");

        
        String insertSql =
            "INSERT INTO Reservation " +
            "(ReservationDate, TotalFare, TicketType, " +
            "DiscountType, Status, Username, ScheduleID, " +
            "OriginStationID, DestinationStationID) " +
            "VALUES " +
            "(CURRENT_TIMESTAMP, ?, ?, ?, 'Current', ?, ?, ?, ?)";

        insertPS =
            con.prepareStatement(
                insertSql,
                Statement.RETURN_GENERATED_KEYS
            );

        insertPS.setBigDecimal(
            1,
            totalFare
        );

        insertPS.setString(
            2,
            ticketType
        );

        insertPS.setString(
            3,
            discountType
        );

        insertPS.setString(
            4,
            username
        );

        insertPS.setInt(
            5,
            scheduleID
        );

        insertPS.setInt(
            6,
            originStationID
        );

        insertPS.setInt(
            7,
            destinationStationID
        );

        int rowsInserted =
            insertPS.executeUpdate();

        if (rowsInserted > 0) {

            reservationCreated = true;

            ResultSet generatedKeys =
                insertPS.getGeneratedKeys();

            if (generatedKeys.next()) {
                reservationNumber =
                    generatedKeys.getInt(1);
            }

            generatedKeys.close();
        }

    } catch (NumberFormatException e) {
%>

<p class="message">
The schedule number is invalid.
</p>

<%
    } catch (Exception e) {
%>

<p class="message">
Reservation could not be created.
<br><br>
<%= e.getMessage() %>
</p>

<%
    } finally {

        try {

            if (stationRS != null) {
                stationRS.close();
            }

            if (scheduleRS != null) {
                scheduleRS.close();
            }

            if (insertPS != null) {
                insertPS.close();
            }

            if (stationPS != null) {
                stationPS.close();
            }

            if (schedulePS != null) {
                schedulePS.close();
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

<%
if (reservationCreated) {
%>

<p class="message">
Your reservation was created successfully.
</p>

<div class="confirmation">

<strong>Reservation Number:</strong>
<%= reservationNumber %>

<br>

<strong>Customer:</strong>
<%= username %>

<br>

<strong>Schedule ID:</strong>
<%= scheduleID %>

<br>

<strong>Origin:</strong>
<%= origin %>

<br>

<strong>Destination:</strong>
<%= destination %>

<br>

<strong>Ticket Type:</strong>
<%= ticketType %>

<br>

<strong>Discount:</strong>
<%= discountType %>

<br>

<strong>Total Fare:</strong>
$<%= totalFare %>

<br>

<strong>Status:</strong>
Current

</div>

<div class="button-area">

    <a class="button" href="search.jsp">
        Search More Trains
    </a>

    <a class="button" href="myReservations.jsp">
        My Reservations
    </a>

</div>

<%
}
%>

</div>

</body>
</html>