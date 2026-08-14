<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
    
    Integer reservationID = (Integer) request.getAttribute("reservationID");
    Double amount = (Double) request.getAttribute("amount");
    
    if (reservationID == null || amount == null) {
        response.sendRedirect("SearchFlights.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking Confirmation</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>Airline Reservation System</h1>
            <div class="user-info">
                Welcome, <%= user.getName() %> ! | 
                <a href="LogoutServlet">Logout</a>
            </div>
        </header>
        
        <div class="main-content">
            <div class="confirmation-section">
                <div class="success-icon">✓</div>
                <h2>Booking Confirmed!</h2>
                
                <div class="confirmation-details">
                    <p><strong>Reservation ID:</strong> #<%= reservationID %></p>
                    <p><strong>Amount Paid:</strong> $<%= String.format("%.2f", amount) %></p>
                    <p><strong>Status:</strong> <span style="color: #27ae60;">Confirmed</span></p>
                    <p><strong>Passenger:</strong> <%= user.getName() %></p>
                    <p><strong>Email:</strong> <%= user.getEmail() %></p>
                </div>
                
                <div class="confirmation-message">
                    <p>Your flight has been successfully booked. A confirmation email has been sent to your registered email address.</p>
                </div>
                
                <div class="action-buttons">
                    <a href="SearchFlights.jsp" class="btn btn-primary">Book Another Flight</a>
                    <a href="index.jsp" class="btn btn-secondary">Back to Home</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>