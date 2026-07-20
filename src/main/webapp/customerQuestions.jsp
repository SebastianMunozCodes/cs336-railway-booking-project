<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
String user = (String) session.getAttribute("user");
String role = (String) session.getAttribute("role");

if (user == null || role == null || !"CUSTOMER".equals(role)) {
    response.sendRedirect("index.jsp");
    return;
}

String keyword = request.getParameter("keyword");

if (keyword == null) {
    keyword = "";
}

keyword = keyword.trim();

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
<title>Questions and Answers</title>

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
    color: green;
}

.search-box {
    text-align: center;
    margin-bottom: 25px;
}

input[type="text"] {
    width: 350px;
    padding: 10px;
}

button, a {
    display: inline-block;
    margin: 8px;
    text-decoration: none;
    color: white;
    background-color: #d9534f;
    padding: 10px 18px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

button:hover, a:hover {
    background-color: #c9302c;
}

.question-card {
    border: 1px solid #ddd;
    padding: 20px;
    margin: 18px 0;
    border-radius: 8px;
    background-color: #fafafa;
}

.question {
    font-weight: bold;
    margin-bottom: 10px;
}

.answer {
    margin-top: 10px;
    padding: 12px;
    background-color: #eef7ee;
    border-left: 4px solid green;
}

.unanswered {
    margin-top: 10px;
    color: #d9534f;
    font-style: italic;
}

.meta {
    color: #666;
    font-size: 0.9em;
    margin-bottom: 10px;
}

.back {
    text-align: center;
    margin-top: 25px;
}
</style>

</head>

<body>

<div class="container">

<h2>Customer Questions & Answers</h2>

<div class="search-box">

    <form method="get" action="customerQuestions.jsp">

        <input
            type="text"
            name="keyword"
            placeholder="Search questions or answers..."
            value="<%= keyword %>">

        <button type="submit">
            Search
        </button>

        <a href="customerQuestions.jsp">
            Clear Search
        </a>

    </form>

</div>

<%
try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(url, dbUser, dbPassword);

    String sql;

    if (keyword.isEmpty()) {

        sql =
            "SELECT q.QuestionID, q.Username, q.QuestionText, " +
            "q.QuestionDateTime, r.ReplyText, r.ReplyDateTime, " +
            "e.Username AS RepliedBy " +
            "FROM CustomerQuestion q " +
            "LEFT JOIN CustomerReply r " +
            "ON q.QuestionID = r.QuestionID " +
            "LEFT JOIN Employee e " +
            "ON r.EmployeeSSN = e.SSN " +
            "ORDER BY q.QuestionDateTime DESC";

        ps = con.prepareStatement(sql);

    } else {

        sql =
            "SELECT q.QuestionID, q.Username, q.QuestionText, " +
            "q.QuestionDateTime, r.ReplyText, r.ReplyDateTime, " +
            "e.Username AS RepliedBy " +
            "FROM CustomerQuestion q " +
            "LEFT JOIN CustomerReply r " +
            "ON q.QuestionID = r.QuestionID " +
            "LEFT JOIN Employee e " +
            "ON r.EmployeeSSN = e.SSN " +
            "WHERE q.QuestionText LIKE ? " +
            "OR r.ReplyText LIKE ? " +
            "ORDER BY q.QuestionDateTime DESC";

        ps = con.prepareStatement(sql);

        String searchPattern = "%" + keyword + "%";

        ps.setString(1, searchPattern);
        ps.setString(2, searchPattern);
    }

    rs = ps.executeQuery();

    boolean found = false;

    while (rs.next()) {

        found = true;

        int questionID =
            rs.getInt("QuestionID");

        String customerUsername =
            rs.getString("Username");

        String questionText =
            rs.getString("QuestionText");

        Timestamp questionDateTime =
            rs.getTimestamp("QuestionDateTime");

        String replyText =
            rs.getString("ReplyText");

        Timestamp replyDateTime =
            rs.getTimestamp("ReplyDateTime");

        String repliedBy =
            rs.getString("RepliedBy");
%>

<div class="question-card">

    <div class="meta">
        Question #<%= questionID %>
        |
        Asked by <%= customerUsername %>
        |
        <%= questionDateTime %>
    </div>

    <div class="question">
        Q: <%= questionText %>
    </div>

    <% if (replyText != null) { %>

        <div class="answer">

            <strong>Answer:</strong>
            <%= replyText %>

            <br><br>

            <small>
                Replied by <%= repliedBy %>
                on <%= replyDateTime %>
            </small>

        </div>

    <% } else { %>

        <div class="unanswered">
            This question has not been answered yet.
        </div>

    <% } %>

</div>

<%
    }

    if (!found) {
%>

<p style="text-align:center;">
    No questions or answers matched your search.
</p>

<%
    }

} catch (Exception e) {
%>

<p>
    Error loading questions:
    <%= e.getMessage() %>
</p>

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

<div class="back">

    <a href="customerDashboard.jsp">
        Back to Dashboard
    </a>

</div>

</div>

</body>
</html>