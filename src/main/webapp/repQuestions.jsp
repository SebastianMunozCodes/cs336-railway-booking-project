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

String url = "jdbc:mysql://localhost:3306/railway_booking";
String dbUser = "root";
String dbPassword = "";

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Customer Questions</title>

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
    color: #337ab7;
    text-align: center;
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
    vertical-align: top;
}

th {
    background-color: #337ab7;
    color: white;
}

.status-unanswered {
    color: #d9534f;
    font-weight: bold;
}

.status-answered {
    color: green;
    font-weight: bold;
}

a {
    display: inline-block;
    text-decoration: none;
    color: white;
    background-color: #337ab7;
    padding: 8px 14px;
    border-radius: 5px;
}

a:hover {
    background-color: #286090;
}

.back {
    margin-top: 25px;
    text-align: center;
}
</style>

</head>

<body>

<div class="container">

<h2>Customer Questions</h2>

<table>

<tr>
    <th>Question ID</th>
    <th>Customer</th>
    <th>Question</th>
    <th>Date</th>
    <th>Status</th>
    <th>Action</th>
</tr>

<%
try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(url, dbUser, dbPassword);

    String sql =
        "SELECT q.QuestionID, q.Username, q.QuestionText, " +
        "q.QuestionDateTime, r.ReplyID " +
        "FROM CustomerQuestion q " +
        "LEFT JOIN CustomerReply r " +
        "ON q.QuestionID = r.QuestionID " +
        "ORDER BY q.QuestionDateTime DESC";

    ps = con.prepareStatement(sql);
    rs = ps.executeQuery();

    boolean found = false;

    while (rs.next()) {

        found = true;

        int questionID = rs.getInt("QuestionID");
        String customerUsername = rs.getString("Username");
        String questionText = rs.getString("QuestionText");
        Timestamp questionDateTime =
            rs.getTimestamp("QuestionDateTime");

        Integer replyID =
            (Integer) rs.getObject("ReplyID");
%>

<tr>

    <td>
        <%= questionID %>
    </td>

    <td>
        <%= customerUsername %>
    </td>

    <td>
        <%= questionText %>
    </td>

    <td>
        <%= questionDateTime %>
    </td>

    <td>

        <% if (replyID == null) { %>

            <span class="status-unanswered">
                Unanswered
            </span>

        <% } else { %>

            <span class="status-answered">
                Answered
            </span>

        <% } %>

    </td>

    <td>

        <% if (replyID == null) { %>

            <a href="replyQuestion.jsp?questionID=<%= questionID %>">
                Reply
            </a>

        <% } else { %>

            No Action

        <% } %>

    </td>

</tr>

<%
    }

    if (!found) {
%>

<tr>
    <td colspan="6" style="text-align:center;">
        No customer questions found.
    </td>
</tr>

<%
    }

} catch (Exception e) {
%>

<tr>
    <td colspan="6">
        Error loading questions:
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

<div class="back">

    <a href="repDashboard.jsp">
        Back to Representative Dashboard
    </a>

</div>

</div>

</body>
</html>