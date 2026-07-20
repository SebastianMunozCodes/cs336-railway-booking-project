<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Customer Registration</title>

<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
    }

    .register-box {
        width: 350px;
        margin: 80px auto;
        padding: 25px;
        background-color: white;
        border-radius: 8px;
        box-shadow: 0 0 10px lightgray;
    }

    h2 {
        text-align: center;
    }

    input {
        width: 100%;
        padding: 10px;
        margin: 8px 0;
        box-sizing: border-box;
    }

    button {
        width: 100%;
        padding: 10px;
        background-color: #cc0033;
        color: white;
        border: none;
        cursor: pointer;
    }

    button:hover {
        background-color: #990026;
    }

    .login-link {
        text-align: center;
        margin-top: 15px;
    }
</style>
</head>

<body>

<div class="register-box">

    <h2>Create Customer Account</h2>

    <form action="registerCustomer.jsp" method="post">

        <label>First Name:</label>
        <input type="text" name="firstName" required>

        <label>Last Name:</label>
        <input type="text" name="lastName" required>

        <label>Username:</label>
        <input type="text" name="username" required>

        <label>Email:</label>
        <input type="email" name="email" required>

        <label>Password:</label>
        <input type="password" name="password" required>

        <button type="submit">Register</button>

    </form>

    <div class="login-link">
        Already have an account?
        <a href="index.jsp">Login</a>
    </div>

</div>

</body>
</html>