<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Flight, model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Search Flights</title>
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
            <h2>Search Flights</h2>
            
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="error-message">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>
            
            <div class="search-form">
                <form action="SearchFlightServlet" method="post">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="source">From:</label>
                            <input type="text" id="source" name="source" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="destination">To:</label>
                            <input type="text" id="destination" name="destination" required>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">Search Flights</button>
                </form>
            </div>
            
            <% 
                List<Flight> flights = (List<Flight>) request.getAttribute("flights");
                if (flights != null) {
                    if (flights.isEmpty()) {
            %>
                        <div class="no-flights">
                            <p>No flights found for your search criteria.</p>
                        </div>
            <%
                    } else {
            %>
                        <div class="flights-list">
                            <h3>Available Flights</h3>
                            <table>
                                <thead>
                                    <tr>
                                        <th>Flight Number</th>
                                        <th>From</th>
                                        <th>To</th>
                                        <th>Departure</th>
                                        <th>Arrival</th>
                                        <th>Available Seats</th>
                                        <th>Price</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Flight flight : flights) { %>
                                        <tr>
                                            <td><%= flight.getFlightNumber() %></td>
                                            <td><%= flight.getSource() %></td>
                                            <td><%= flight.getDestination() %></td>
                                            <td><%= flight.getDepartureTime() %></td>
                                            <td><%= flight.getArrivalTime() %></td>
                                            <td><%= flight.getSeatsAvailable() %></td>
                                            <td>$<%= String.format("%.2f", flight.getPrice()) %></td>
                                            <td>
                                                <form action="BookFlight.jsp" method="post" style="display: inline;">
                                                    <input type="hidden" name="flightID" value="<%= flight.getFlightID() %>">
                                                    <button type="submit" class="btn btn-book">Book Now</button>
                                                </form>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
            <%
                    }
                }
            %>
        </div>
    </div>
</body>
</html>