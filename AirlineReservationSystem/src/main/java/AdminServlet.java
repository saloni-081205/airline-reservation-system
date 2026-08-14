

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.DBConnection;
import model.Flight;
import model.Reservation;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        model.User user = (model.User) session.getAttribute("user");
        
        if (user == null || !"Admin".equals(user.getRole())) {
            response.sendRedirect("Login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("viewReservations".equals(action)) {
            viewReservations(request, response);
        } else if ("viewFlights".equals(action)) {
            viewFlights(request, response);
        } else {
            response.sendRedirect("AdminDashboard.jsp");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("addFlight".equals(action)) {
            addFlight(request, response);
        }
    }
    
    private void viewReservations(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT r.ReservationID, r.UserID, r.FlightID, r.BookingDate, r.SeatCount, r.Status, " +
                        "u.Name as UserName, f.FlightNumber, f.Source, f.Destination " +
                        "FROM Reservations r " +
                        "JOIN Users u ON r.UserID = u.UserID " +
                        "JOIN Flights f ON r.FlightID = f.FlightID " +
                        "ORDER BY r.BookingDate DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            List<java.util.Map<String, Object>> reservations = new ArrayList<>();
            while (rs.next()) {
                java.util.Map<String, Object> reservation = new java.util.HashMap<>();
                reservation.put("ReservationID", rs.getInt("ReservationID"));
                reservation.put("UserID", rs.getInt("UserID"));
                reservation.put("FlightID", rs.getInt("FlightID"));
                reservation.put("BookingDate", rs.getTimestamp("BookingDate"));
                reservation.put("SeatCount", rs.getInt("SeatCount"));
                reservation.put("Status", rs.getString("Status"));
                reservation.put("UserName", rs.getString("UserName"));
                reservation.put("FlightNumber", rs.getString("FlightNumber"));
                reservation.put("Source", rs.getString("Source"));
                reservation.put("Destination", rs.getString("Destination"));
                
                reservations.add(reservation);
            }
            
            request.setAttribute("reservations", reservations);
            request.getRequestDispatcher("ViewReservations.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading reservations: " + e.getMessage());
            request.getRequestDispatcher("AdminDashboard.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
    
    private void viewFlights(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Flights ORDER BY DepartureTime";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            List<Flight> flights = new ArrayList<>();
            while (rs.next()) {
                Flight flight = new Flight();
                flight.setFlightID(rs.getInt("FlightID"));
                flight.setFlightNumber(rs.getString("FlightNumber"));
                flight.setSource(rs.getString("Source"));
                flight.setDestination(rs.getString("Destination"));
                flight.setDepartureTime(rs.getTimestamp("DepartureTime"));
                flight.setArrivalTime(rs.getTimestamp("ArrivalTime"));
                flight.setSeatsAvailable(rs.getInt("SeatsAvailable"));
                flight.setPrice(rs.getDouble("Price"));
                flights.add(flight);
            }
            
            request.setAttribute("flights", flights);
            request.getRequestDispatcher("AdminDashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading flights: " + e.getMessage());
            request.getRequestDispatcher("AdminDashboard.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
    
    private void addFlight(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String flightNumber = request.getParameter("flightNumber");
        String source = request.getParameter("source");
        String destination = request.getParameter("destination");
        String departureTime = request.getParameter("departureTime");
        String arrivalTime = request.getParameter("arrivalTime");
        int seatsAvailable = Integer.parseInt(request.getParameter("seatsAvailable"));
        double price = Double.parseDouble(request.getParameter("price"));
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO Flights (FlightID, FlightNumber, Source, Destination, DepartureTime, ArrivalTime, SeatsAvailable, Price) " +
                        "VALUES (SEQ_FLIGHTS.NEXTVAL, ?, ?, ?, TO_TIMESTAMP(?, 'YYYY-MM-DD\"T\"HH24:MI'), TO_TIMESTAMP(?, 'YYYY-MM-DD\"T\"HH24:MI'), ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, flightNumber);
            pstmt.setString(2, source);
            pstmt.setString(3, destination);
            pstmt.setString(4, departureTime);
            pstmt.setString(5, arrivalTime);
            pstmt.setInt(6, seatsAvailable);
            pstmt.setDouble(7, price);
            
            int rows = pstmt.executeUpdate();
            
            if (rows > 0) {
                request.setAttribute("successMessage", "Flight added successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to add flight!");
            }
            
            viewFlights(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error adding flight: " + e.getMessage());
            request.getRequestDispatcher("AdminDashboard.jsp").forward(request, response);
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}