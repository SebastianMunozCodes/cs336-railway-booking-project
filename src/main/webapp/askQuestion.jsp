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

String message = null;
boolean submittedSuccessfully = false;

if ("POST".equalsIgnoreCase(request.getMethod())) {
    String questionText = request.getParameter("questionText");

    if (questionText != null && !questionText.trim().isEmpty()) {

        String url = "jdbc:mysql://localhost:3306/railway_booking";
        String dbUser = "root";
        String dbPassword = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con =
                DriverManager.getConnection(url, dbUser, dbPassword);

            String sql =
                "INSERT INTO CustomerQuestion (QuestionText, Username) VALUES (?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, questionText.trim());
            ps.setString(2, user);

            ps.executeUpdate();

            ps.close();
            con.close();

            message = "Your question was submitted successfully.";
            submittedSuccessfully = true;

        } catch (Exception e) {
            message = "Error submitting question: " + e.getMessage();
        }

    } else {
        message = "Please enter a question.";
    }
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Ask Customer Service</title>

<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    text-align: center;
    margin-top: 80px;
}

.container {
    background-color: white;
    width: 500px;
    margin: auto;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0px 0px 10px lightgray;
}

textarea {
    width: 90%;
    height: 140px;
    padding: 10px;
    margin-top: 10px;
}

button, a {
    display: inline-block;
    margin: 10px;
    text-decoration: none;
    color: white;
    background-color: #d9534f;
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

button:hover, a:hover {
    background-color: #c9302c;
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

        <h2>Question Submitted</h2>

        <div class="message">
            <%= message %>
        </div>

        <a href="askQuestion.jsp">
            Submit Another Question
        </a>

        <a href="customerDashboard.jsp">
            Back to Dashboard
        </a>

    <% } else { %>

        <h2>Ask Customer Service</h2>

        <form method="post" action="askQuestion.jsp">

            <label for="questionText">Your Question:</label><br>

            <textarea
                id="questionText"
                name="questionText"
                required></textarea>

            <br>

            <button type="submit">
                Submit Question
            </button>

        </form>

        <% if (message != null) { %>
            <div class="message">
                <%= message %>
            </div>
        <% } %>

        <a href="customerDashboard.jsp">
            Back to Dashboard
        </a>

    <% } %>

</div>

</body>
</html>