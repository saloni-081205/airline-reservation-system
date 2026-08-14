

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.DBConnection;
import model.Flight;
import model.User;

@WebServlet("/BookFlightServlet")
public class BookFlightServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("Login.jsp");
            return;
        }
        
        int flightID = Integer.parseInt(request.getParameter("flightID"));
        int seatCount = Integer.parseInt(request.getParameter("seatCount"));
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Get flight details
            String flightSql = "SELECT * FROM Flights WHERE FlightID = ?";
            pstmt = conn.prepareStatement(flightSql);
            pstmt.setInt(1, flightID);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Flight flight = new Flight();
                flight.setFlightID(rs.getInt("FlightID"));
                flight.setFlightNumber(rs.getString("FlightNumber"));
                flight.setSource(rs.getString("Source"));
                flight.setDestination(rs.getString("Destination"));
                flight.setPrice(rs.getDouble("Price"));
                flight.setSeatsAvailable(rs.getInt("SeatsAvailable"));
                
                // Check if enough seats available
                if (flight.getSeatsAvailable() < seatCount) {
                    request.setAttribute("errorMessage", "Not enough seats available!");
                    request.getRequestDispatcher("SearchFlights.jsp").forward(request, response);
                    return;
                }
                
                // Create reservation
                String reserveSql = "INSERT INTO Reservations (ReservationID, UserID, FlightID, SeatCount, Status) VALUES (SEQ_RES.NEXTVAL, ?, ?, ?, 'Confirmed')";
                pstmt = conn.prepareStatement(reserveSql);
                pstmt.setInt(1, user.getUserID());
                pstmt.setInt(2, flightID);
                pstmt.setInt(3, seatCount);
                pstmt.executeUpdate();
                
                // Update available seats
                String updateSql = "UPDATE Flights SET SeatsAvailable = SeatsAvailable - ? WHERE FlightID = ?";
                pstmt = conn.prepareStatement(updateSql);
                pstmt.setInt(1, seatCount);
                pstmt.setInt(2, flightID);
                pstmt.executeUpdate();
                
                // Get the reservation ID
                String getReservationSql = "SELECT SEQ_RES.CURRVAL FROM DUAL";
                pstmt = conn.prepareStatement(getReservationSql);
                rs = pstmt.executeQuery();
                int reservationID = 0;
                if (rs.next()) {
                    reservationID = rs.getInt(1);
                }
                
                double totalAmount = flight.getPrice() * seatCount;
                
                session.setAttribute("reservationID", reservationID);
                session.setAttribute("flight", flight);
                session.setAttribute("seatCount", seatCount);
                session.setAttribute("totalAmount", totalAmount);
                
                response.sendRedirect("Payment.jsp");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Booking failed: " + e.getMessage());
            request.getRequestDispatcher("SearchFlights.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}