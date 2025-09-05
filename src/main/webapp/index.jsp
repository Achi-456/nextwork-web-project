<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="dashboard">
    <h2>Hello, <%= request.getParameter("username") %>!</h2>
    <p>You are now logged in.</p>
    <p>Current Server Time: <%= new Date() %></p>
    <a href="login.jsp" class="btn">Logout</a>
</div>
</body>
</html>
