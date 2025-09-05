<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - NextWork App</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="login-container">
    <h2>Welcome to NextWork App</h2>
    <form action="dashboard.jsp" method="post">
        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" placeholder="Enter username" required>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="Enter password" required>
        </div>
        <button type="submit" class="btn">Login</button>
    </form>
    <p class="note">Use demo credentials for now (no backend yet).</p>
</div>
</body>
</html>
