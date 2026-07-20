<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
String user = (String) session.getAttribute("user");
String role = (String) session.getAttribute("role");
String employeeSSN = (String) session.getAttribute("employeeSSN");

if (user == null || role == null || !"REP".equals(role) || employeeSSN == null) {
    response.sendRedirect("index.jsp");
    return;
}

String questionIDParam = request.getParameter("questionID");

if (questionIDParam == null) {
    response.sendRedirect("repQuestions.jsp");
    return;
}

int questionID;

try {
    questionID = Integer.parseInt(questionIDParam);
} catch (NumberFormatException e) {
    response.sendRedirect("repQuestions.jsp");
    return;
}

String url = "jdbc:mysql://localhost:3306/railway_booking";
String dbUser = "root";
String dbPassword = "";

String questionText = null;
String customerUsername = null;
String message = null;
boolean submittedSuccessfully = false;

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection(url, dbUser, dbPassword);

    // Load the selected question
    String questionSql =
        "SELECT Username, QuestionText FROM CustomerQuestion WHERE QuestionID=?";

    ps = con.prepareStatement(questionSql);
    ps.setInt(1, questionID);
    rs = ps.executeQuery();

    if (rs.next()) {
        customerUsername = rs.getString("Username");
        questionText = rs.getString("QuestionText");
    } else {
        response.sendRedirect("repQuestions.jsp");
        return;
    }

    rs.close();
    ps.close();

    // Handle reply submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String replyText = request.getParameter("replyText");

        if (replyText != null && !replyText.trim().isEmpty()) {

            // Prevent duplicate replies to the same question
            String checkSql =
                "SELECT ReplyID FROM CustomerReply WHERE QuestionID=?";

            ps = con.prepareStatement(checkSql);
            ps.setInt(1, questionID);
            rs = ps.executeQuery();

            if (rs.next()) {
                message = "This question has already been answered.";
            } else {

                rs.close();
                ps.close();

                String insertSql =
                    "INSERT INTO CustomerReply " +
                    "(ReplyText, QuestionID, EmployeeSSN) " +
                    "VALUES (?, ?, ?)";

                ps = con.prepareStatement(insertSql);

                ps.setString(1, replyText.trim());
                ps.setInt(2, questionID);
                ps.setString(3, employeeSSN);

                ps.executeUpdate();

                message = "Reply submitted successfully.";
                submittedSuccessfully = true;
            }

        } else {
            message = "Please enter a reply.";
        }
    }

} catch (Exception e) {
    message = "Error: " + e.getMessage();

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
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Reply to Customer Question</title>

<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    text-align: center;
    margin-top: 80px;
}

.container {
    background-color: white;
    width: 600px;
    margin: auto;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0px 0px 10px lightgray;
}

.question-box {
    background-color: #f8f8f8;
    padding: 15px;
    margin: 20px 0;
    text-align: left;
    border-radius: 5px;
}

textarea {
    width: 90%;
    height: 140px;
    padding: 10px;
}

button, a {
    display: inline-block;
    margin: 10px;
    text-decoration: none;
    color: white;
    background-color: #337ab7;
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

button:hover, a:hover {
    background-color: #286090;
}

.message {
    margin: 20px 0;
    font-weight: bold;
}
</style>

</head>

<body>

<div class="container">

<% if (submittedSuccessfully) { %>

    <h2>Reply Submitted</h2>

    <div class="message">
        <%= message %>
    </div>

    <a href="repQuestions.jsp">
        Back to Customer Questions
    </a>

<% } else { %>

    <h2>Reply to Customer Question</h2>

    <div class="question-box">

        <p>
            <strong>Customer:</strong>
            <%= customerUsername %>
        </p>

        <p>
            <strong>Question:</strong>
            <%= questionText %>
        </p>

    </div>

    <form method="post"
          action="replyQuestion.jsp?questionID=<%= questionID %>">

        <label for="replyText">
            Your Reply:
        </label>

        <br><br>

        <textarea
            id="replyText"
            name="replyText"
            required></textarea>

        <br>

        <button type="submit">
            Submit Reply
        </button>

    </form>

    <% if (message != null) { %>

        <div class="message">
            <%= message %>
        </div>

    <% } %>

    <a href="repQuestions.jsp">
        Back to Customer Questions
    </a>

<% } %>

</div>

</body>
</html>