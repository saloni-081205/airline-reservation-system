<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Flight, java.sql.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
    
    int flightID = Integer.parseInt(request.getParameter("flightID"));
    Flight flight = null;
    
    // Fetch flight details
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "student");
        
        String sql = "SELECT * FROM Flights WHERE FlightID = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, flightID);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            flight = new Flight();
            flight.setFlightID(rs.getInt("FlightID"));
            flight.setFlightNumber(rs.getString("FlightNumber"));
            flight.setSource(rs.getString("Source"));
            flight.setDestination(rs.getString("Destination"));
            flight.setDepartureTime(rs.getTimestamp("DepartureTime"));
            flight.setArrivalTime(rs.getTimestamp("ArrivalTime"));
            flight.setSeatsAvailable(rs.getInt("SeatsAvailable"));
            flight.setPrice(rs.getDouble("Price"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
    
    if (flight == null) {
        response.sendRedirect("SearchFlights.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Flight</title>
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
            <h2>Book Flight</h2><br>
            
            <div class="flight-details">
                <h3>Flight Details</h3><br>
                <div class="detail-card">
                    <p><strong>Flight Number:</strong> <%= flight.getFlightNumber() %></p>
                    <p><strong>Route:</strong> <%= flight.getSource() %> to <%= flight.getDestination() %></p>
                    <p><strong>Departure:</strong> <%= flight.getDepartureTime() %></p>
                    <p><strong>Arrival:</strong> <%= flight.getArrivalTime() %></p>
                    <p><strong>Available Seats:</strong> <%= flight.getSeatsAvailable() %></p>
                    <p><strong>Price per seat:</strong> $<%= String.format("%.2f", flight.getPrice()) %></p>
                </div>
            </div><br>
            
            <div class="booking-form">
                <form action="BookFlightServlet" method="post">
                    <input type="hidden" name="flightID" value="<%= flight.getFlightID() %>">
                    
                    <div class="form-group">
                        <label for="seatCount">Number of Seats:</label>
                        <select id="seatCount" name="seatCount" required>
                            <% for (int i = 1; i <= Math.min(flight.getSeatsAvailable(), 10); i++) { %>
                                <option value="<%= i %>"><%= i %></option>
                            <% } %>
                        </select>
                    </div>
                    
                    <div class="price-summary">
                        <h4>Price Summary</h4>
                        <p>Price per seat: $<%= String.format("%.2f", flight.getPrice()) %></p>
                        <p id="totalPrice">Total: $<%= String.format("%.2f", flight.getPrice()) %></p>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">Confirm Booking</button>
                    <a href="SearchFlights.jsp" class="btn btn-secondary">Cancel</a>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        document.getElementById('seatCount').addEventListener('change', function() {
            var seatCount = parseInt(this.value);
            var pricePerSeat = <%= flight.getPrice() %>;
            var totalPrice = seatCount * pricePerSeat;
            document.getElementById('totalPrice').textContent = 'Total: $' + totalPrice.toFixed(2);
        });
    </script>
</body>
</html>