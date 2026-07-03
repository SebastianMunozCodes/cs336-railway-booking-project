<!DOCTYPE html>
<html>

<head>
    <title>Login</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;

            display: flex;
            justify-content: center;
            align-items: center;

            height: 100vh;
            margin: 0;
        }

        .login-box {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px lightgray;
            text-align: center;
            width: 320px;
        }

        input[type=text],
        input[type=password] {
            width: 90%;
            padding: 10px;
            margin-top: 5px;
            margin-bottom: 15px;
        }

        input[type=submit] {
            width: 100%;
            padding: 10px;
            background-color: #cc0033;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        input[type=submit]:hover {
            background-color: #a30029;
        }
    </style>

</head>

<body>

<div class="login-box">

    <h2>Customer Login</h2>

    <form action="checkLoginDetails.jsp" method="post">

        Username:<br>
        <input type="text" name="username" required><br>

        Password:<br>
        <input type="password" name="password" required><br>

        <input type="submit" value="Login">

    </form>

</div>

</body>

</html> 