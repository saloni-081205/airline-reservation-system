<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Reservations - Admin</title>
<link rel="stylesheet" type="text/css" href="css/style.css">
<style>
    body {
        font-family: 'Arial', sans-serif;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        margin: 0;
        padding: 0;
        min-height: 100vh;
    }

    .container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 20px;
    }

    header {
        background: rgba(255, 255, 255, 0.95);
        color: #2c3e50;
        padding: 1rem 2rem;
        border-radius: 10px;
        margin-bottom: 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }

    header h1 {
        font-size: 1.8rem;
        background: linear-gradient(45deg, #3498db, #2c3e50);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        margin: 0;
    }

    .user-info {
        font-size: 0.9rem;
        color: #7f8c8d;
    }

    .user-info a {
        color: #3498db;
        text-decoration: none;
        margin-left: 10px;
        font-weight: bold;
    }

    .user-info a:hover {
        color: #2980b9;
        text-decoration: underline;
    }

    .main-content {
        background: rgba(255, 255, 255, 0.95);
        padding: 2rem;
        border-radius: 15px;
        box-shadow: 0 8px 25px rgba(0,0,0,0.1);
    }

    .page-title {
        text-align: center;
        color: #2c3e50;
        margin-bottom: 2rem;
        font-size: 2.5rem;
        background: linear-gradient(45deg, #3498db, #9b59b6);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }

    .reservations-container {
        display: grid;
        gap: 1.5rem;
        margin-top: 2rem;
    }

    .reservation-card {
        background: linear-gradient(135deg, #ffffff, #f8f9fa);
        border: 2px solid #e1e8ed;
        border-radius: 12px;
        padding: 1.5rem;
        box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        transition: all 0.3s ease;
        border-left: 4px solid #3498db;
    }

    .reservation-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        border-left-color: #9b59b6;
    }

    .reservation-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1rem;
        padding-bottom: 1rem;
        border-bottom: 2px solid #ecf0f1;
    }

    .reservation-id {
        font-size: 1.2rem;
        font-weight: bold;
        color: #3498db;
        background: #ecf0f1;
        padding: 0.5rem 1rem;
        border-radius: 20px;
    }

    .status {
        padding: 0.5rem 1rem;
        border-radius: 20px;
        font-weight: bold;
        text-transform: uppercase;
        font-size: 0.8rem;
        letter-spacing: 0.5px;
    }

    .status-confirmed {
        background: #e8f5e8;
        color: #27ae60;
        border: 1px solid #27ae60;
    }

    .status-pending {
        background: #fef9e7;
        color: #f39c12;
        border: 1px solid #f39c12;
    }

    .status-cancelled {
        background: #fdedec;
        color: #e74c3c;
        border: 1px solid #e74c3c;
    }

    .reservation-details {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1rem;
    }

    .detail-item {
        display: flex;
        flex-direction: column;
    }

    .detail-label {
        font-size: 0.8rem;
        color: #7f8c8d;
        font-weight: bold;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-bottom: 0.3rem;
    }

    .detail-value {
        font-size: 1rem;
        color: #2c3e50;
        font-weight: 600;
    }

    .no-reservations {
        text-align: center;
        padding: 3rem;
        background: linear-gradient(135deg, #f8f9fa, #e9ecef);
        border-radius: 12px;
        border: 2px dashed #bdc3c7;
    }

    .no-reservations-icon {
        font-size: 4rem;
        margin-bottom: 1rem;
        opacity: 0.5;
    }

    .no-reservations h3 {
        color: #7f8c8d;
        margin-bottom: 1rem;
        font-size: 1.5rem;
    }

    .no-reservations p {
        color: #95a5a6;
        line-height: 1.6;
        margin-bottom: 0.5rem;
    }

    .stats-info {
        background: #ecf0f1;
        padding: 1rem;
        border-radius: 8px;
        text-align: center;
        margin-bottom: 1rem;
        font-weight: bold;
        color: #7f8c8d;
    }

    .navigation-links {
        text-align: center;
        margin-top: 2rem;
        padding-top: 2rem;
        border-top: 2px solid #ecf0f1;
    }

    .btn {
        display: inline-block;
        padding: 0.75rem 2rem;
        border: none;
        border-radius: 8px;
        text-decoration: none;
        text-align: center;
        font-size: 1rem;
        font-weight: bold;
        cursor: pointer;
        transition: all 0.3s;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin: 0 0.5rem;
    }

    .btn-primary {
        background: linear-gradient(45deg, #3498db, #2980b9);
        color: white;
        box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
    }

    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(52, 152, 219, 0.4);
    }

    .btn-secondary {
        background: linear-gradient(45deg, #95a5a6, #7f8c8d);
        color: white;
        box-shadow: 0 4px 15px rgba(149, 165, 166, 0.3);
    }

    .btn-secondary:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(149, 165, 166, 0.4);
    }

    .admin-nav {
        background: linear-gradient(45deg, #34495e, #2c3e50);
        padding: 1rem 2rem;
        border-radius: 10px;
        margin-bottom: 2rem;
        display: flex;
        gap: 2rem;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }

    .nav-link {
        color: white;
        text-decoration: none;
        font-weight: bold;
        padding: 0.75rem 1.5rem;
        border-radius: 6px;
        transition: all 0.3s;
        background: rgba(255,255,255,0.1);
    }

    .nav-link:hover {
        background: rgba(255,255,255,0.2);
        transform: translateY(-2px);
    }

    @media (max-width: 768px) {
        .container {
            padding: 10px;
        }
        
        header {
            flex-direction: column;
            text-align: center;
            padding: 1rem;
        }
        
        .user-info {
            margin-top: 1rem;
        }
        
        .reservation-details {
            grid-template-columns: 1fr;
        }
        
        .admin-nav {
            flex-direction: column;
            gap: 1rem;
        }
        
        .reservation-header {
            flex-direction: column;
            gap: 1rem;
            text-align: center;
        }
    }
</style>
</head>
<body>
    <div class="container">
        <header>
            <h1>Airline Reservation System - Admin Dashboard</h1>
            <div class="user-info">
                <a href="AdminDashboard.jsp">Dashboard</a> | 
                <a href="LogoutServlet">Logout</a>
            </div>
        </header>
        
        
        <div class="main-content">
            <h1 class="page-title">📋 All Reservations</h1>

            <%
                List<Map<String, Object>> reservations = (List<Map<String, Object>>) request.getAttribute("reservations");

                if (reservations != null && !reservations.isEmpty()) {
            %>
                    <div class="stats-info">
                        Total Reservations: <strong><%= reservations.size() %></strong>
                    </div>
                    
                    <div class="reservations-container">
            <%
                    for (Map<String, Object> r : reservations) {
                        String status = (String) r.get("Status");
                        String statusClass = "status-confirmed";
                        if ("Pending".equalsIgnoreCase(status)) {
                            statusClass = "status-pending";
                        } else if ("Cancelled".equalsIgnoreCase(status)) {
                            statusClass = "status-cancelled";
                        }
            %>
                        <div class="reservation-card">
                            <div class="reservation-header">
                                <div class="reservation-id">Reservation #<%= r.get("ReservationID") %></div>
                                <div class="status <%= statusClass %>"><%= status %></div>
                            </div>
                            
                            <div class="reservation-details">
                                <div class="detail-item">
                                    <span class="detail-label">User ID</span>
                                    <span class="detail-value">👤 <%= r.get("UserID") %></span>
                                </div>
                                
                                <div class="detail-item">
                                    <span class="detail-label">Flight ID</span>
                                    <span class="detail-value">✈️ <%= r.get("FlightID") %></span>
                                </div>
                                
                                <div class="detail-item">
                                    <span class="detail-label">Seats</span>
                                    <span class="detail-value">💺 <%= r.get("SeatCount") != null ? r.get("SeatCount") : "N/A" %></span>
                                </div>
                                
                                <div class="detail-item">
                                    <span class="detail-label">Booking Date</span>
                                    <span class="detail-value">📅 <%= r.get("BookingDate") != null ? r.get("BookingDate") : "N/A" %></span>
                                </div>
                            </div>
                        </div>
            <%
                    }
            %>
                    </div>
            <%
                } else {
            %>
                    <div class="no-reservations">
                        <div class="no-reservations-icon">📭</div>
                        <h3>No Reservations Found</h3>
                        <p>There are no reservations in the system yet.</p>
                        <p>When customers book flights, their reservations will appear here.</p>
                        <p><em>List size: <%= (reservations == null ? "null" : reservations.size()) %></em></p>
                    </div>
            <%
                }
            %>
            
            <div class="navigation-links">
                <a href="AdminDashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
            </div>
        </div>
    </div>
</body>
</html>