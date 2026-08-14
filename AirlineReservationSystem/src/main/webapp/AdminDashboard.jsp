<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, java.util.List, model.Flight" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"Admin".equals(user.getRole())) {
        response.sendRedirect("Login.jsp");
        return;
    }
    
    List<Flight> flights = (List<Flight>) request.getAttribute("flights");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <style>
        .admin-nav {
            background: #34495e;
            padding: 1rem;
            border-radius: 5px;
            margin-bottom: 2rem;
            display: flex;
            gap: 2rem;
        }
        
        .nav-link {
            color: white;
            text-decoration: none;
            font-weight: bold;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            transition: background-color 0.3s;
        }
        
        .nav-link:hover {
            background: #3498db;
        }
        
        .admin-section {
            margin-bottom: 3rem;
            padding: 1.5rem;
            background: #f8f9fa;
            border-radius: 8px;
        }
        
        .admin-section h2 {
            border-bottom: 2px solid #3498db;
            padding-bottom: 0.5rem;
            margin-bottom: 1.5rem;
            color: #2c3e50;
        }
        
        .admin-form {
            background: white;
            padding: 1.5rem;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .form-row {
            display: flex;
            gap: 1rem;
            margin-bottom: 1rem;
        }
        
        .form-group {
            flex: 1;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: bold;
            color: #555;
        }
        
        .form-group input {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1rem;
        }
        
        .admin-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 5px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .admin-table th,
        .admin-table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        .admin-table th {
            background: #34495e;
            color: white;
            font-weight: bold;
        }
        
        .admin-table tr:hover {
            background: #f8f9fa;
        }
        
        .no-data {
            text-align: center;
            padding: 2rem;
            color: #7f8c8d;
            background: white;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>Airline Reservation System - Admin Dashboard</h1>
            <div class="user-info">
                Welcome, <%= user.getName() %> ! (Admin) | 
                <a href="LogoutServlet">Logout</a> |
                <a href="index.jsp">Home</a><br><br><br>
            </div>
        </header>
        
        <div class="admin-nav">
            <a href="AdminServlet?action=viewFlights" class="nav-link">View Flights</a>
            <a href="AdminServlet?action=viewReservations" class="nav-link">View Reservations</a>
            <a href="#addFlight" class="nav-link">Add Flight</a>
        </div>
        
        <div class="main-content">
            <% if (request.getAttribute("successMessage") != null) { %>
                <div class="success-message">
                    <%= request.getAttribute("successMessage") %>
                </div>
            <% } %>
            
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="error-message">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>
            
            <!-- Add Flight Form -->
            <div id="addFlight" class="admin-section">
                <h2>Add New Flight</h2>
                <form action="AdminServlet" method="post" class="admin-form">
                    <input type="hidden" name="action" value="addFlight">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="flightNumber">Flight Number:</label>
                            <input type="text" id="flightNumber" name="flightNumber" required 
                                   placeholder="e.g., AI101">
                        </div>
                        
                        <div class="form-group">
                            <label for="source">Source:</label>
                            <input type="text" id="source" name="source" required 
                                   placeholder="e.g., New York">
                        </div>
                        
                        <div class="form-group">
                            <label for="destination">Destination:</label>
                            <input type="text" id="destination" name="destination" required 
                                   placeholder="e.g., London">
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="departureTime">Departure Time:</label>
                            <input type="datetime-local" id="departureTime" name="departureTime" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="arrivalTime">Arrival Time:</label>
                            <input type="datetime-local" id="arrivalTime" name="arrivalTime" required>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="seatsAvailable">Seats Available:</label>
                            <input type="number" id="seatsAvailable" name="seatsAvailable" required 
                                   min="1" max="500" placeholder="e.g., 150">
                        </div>
                        
                        <div class="form-group">
                            <label for="price">Price ($):</label>
                            <input type="number" id="price" name="price" step="0.01" required 
                                   min="0" placeholder="e.g., 299.99">
                        </div>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">Add Flight</button>
                    <button type="reset" class="btn btn-secondary">Reset Form</button>
                </form>
            </div>
            
            <!-- Flights List -->
            <div class="admin-section">
                <h2>All Flights</h2>
                <% if (flights != null && !flights.isEmpty()) { %>
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Flight ID</th>
                                <th>Flight Number</th>
                                <th>Source</th>
                                <th>Destination</th>
                                <th>Departure</th>
                                <th>Arrival</th>
                                <th>Available Seats</th>
                                <th>Price</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Flight flight : flights) { %>
                                <tr>
                                    <td><%= flight.getFlightID() %></td>
                                    <td><%= flight.getFlightNumber() %></td>
                                    <td><%= flight.getSource() %></td>
                                    <td><%= flight.getDestination() %></td>
                                    <td><%= flight.getDepartureTime() %></td>
                                    <td><%= flight.getArrivalTime() %></td>
                                    <td><%= flight.getSeatsAvailable() %></td>
                                    <td>$<%= String.format("%.2f", flight.getPrice()) %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } else { %>
                    <div class="no-data">
                        <p>No flights found. Add your first flight using the form above.</p>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
    
    <script>
        // Set min datetime to current time
        const now = new Date();
        const timezoneOffset = now.getTimezoneOffset() * 60000; // offset in milliseconds
        const localISOTime = new Date(now - timezoneOffset).toISOString().slice(0, 16);
        
        document.getElementById('departureTime').min = localISOTime;
        document.getElementById('arrivalTime').min = localISOTime;
        
        // Validate that arrival time is after departure time
        document.getElementById('arrivalTime').addEventListener('change', function() {
            const departureTime = document.getElementById('departureTime').value;
            const arrivalTime = this.value;
            
            if (departureTime && arrivalTime && arrivalTime <= departureTime) {
                alert('Arrival time must be after departure time!');
                this.value = '';
            }
        });
        
        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const departureTime = document.getElementById('departureTime').value;
            const arrivalTime = document.getElementById('arrivalTime').value;
            
            if (!departureTime || !arrivalTime) {
                alert('Please select both departure and arrival times!');
                e.preventDefault();
                return;
            }
            
            if (arrivalTime <= departureTime) {
                alert('Arrival time must be after departure time!');
                e.preventDefault();
                return;
            }
        });
    </script>
</body>
</html>