<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Search Train Schedules</title>

<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 0;
}

.container {
    width: 420px;
    margin: 70px auto;
    padding: 30px;
    background-color: white;
    border-radius: 8px;
    box-shadow: 0 0 10px lightgray;
}

h2 {
    text-align: center;
    color: green;
    margin-bottom: 25px;
}

label {
    display: block;
    margin-top: 15px;
    margin-bottom: 5px;
    font-weight: bold;
}

input,
select {
    width: 100%;
    padding: 10px;
    box-sizing: border-box;
    border: 1px solid #cccccc;
    border-radius: 4px;
}

input[type="submit"] {
    margin-top: 25px;
    background-color: #cc0033;
    color: white;
    border: none;
    cursor: pointer;
    font-size: 16px;
}

input[type="submit"]:hover {
    background-color: #a30029;
}

.link-area {
    text-align: center;
    margin-top: 20px;
}

.link-area a {
    color: #cc0033;
    text-decoration: none;
}

.link-area a:hover {
    text-decoration: underline;
}
</style>
</head>

<body>

<div class="container">

    <h2>Search Train Schedules</h2>

    <form action="searchResults.jsp" method="get">

        <label for="origin">Origin Station</label>
        <input
            type="text"
            id="origin"
            name="origin"
            placeholder="Example: New Brunswick"
            required>

        <label for="destination">Destination Station</label>
        <input
            type="text"
            id="destination"
            name="destination"
            placeholder="Example: Newark Penn Station"
            required>

        <label for="travelDate">Date of Travel</label>
        <input
            type="date"
            id="travelDate"
            name="travelDate"
            required>

        <label for="sortBy">Sort Results By</label>
        <select id="sortBy" name="sortBy">
            <option value="departure">Departure Time</option>
            <option value="arrival">Arrival Time</option>
            <option value="fare">Fare</option>
        </select>

        <input type="submit" value="Search Schedules">

    </form>

    <div class="link-area">
        <a href="customerDashboard.jsp">Back to Dashboard</a>
    </div>

</div>

</body>
</html>