<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Flight" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
    
    Flight flight = (Flight) session.getAttribute("flight");
    Integer seatCount = (Integer) session.getAttribute("seatCount");
    Double totalAmount = (Double) session.getAttribute("totalAmount");
    
    if (flight == null || seatCount == null || totalAmount == null) {
        response.sendRedirect("SearchFlights.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment</title>
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
            <h2>Payment</h2><br>
            
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="error-message">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>
            
            <div class="payment-summary">
                <h3>Booking Summary</h3><br>
                <div class="summary-card">
                    <p><strong>Flight:</strong> <%= flight.getFlightNumber() %></p>
                    <p><strong>Route:</strong> <%= flight.getSource() %> to <%= flight.getDestination() %></p>
                    <p><strong>Seats:</strong> <%= seatCount %></p>
                    <p><strong>Total Amount:</strong> $<%= String.format("%.2f", totalAmount) %></p>
                </div>
            </div><br>
            
            <div class="payment-form">
                <form action="PaymentServlet" method="post">
                    <h3>Payment Details</h3><br>
                    
                    <div class="form-group">
                        <label for="cardHolder">Card Holder Name:</label>
                        <input type="text" id="cardHolder" name="cardHolder" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="cardNumber">Card Number:</label>
                        <input type="text" id="cardNumber" name="cardNumber" maxlength="16" required>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="expiryDate">Expiry Date:</label>
                            <input type="month" id="expiryDate" name="expiryDate" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="cvv">CVV:</label>
                            <input type="text" id="cvv" name="cvv" maxlength="3" required>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">Pay $<%= String.format("%.2f", totalAmount) %></button>
                    <a href="SearchFlights.jsp" class="btn btn-secondary">Cancel</a>
                </form>
            </div>
        </div>
    </div>
</body>
</html>