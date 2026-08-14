

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

import model.DBConnection;
import model.Flight;

@WebServlet("/SearchFlightServlet")
public class SearchFlightServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String source = request.getParameter("source");
        String destination = request.getParameter("destination");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Flights WHERE UPPER(Source) LIKE UPPER(?) AND UPPER(Destination) LIKE UPPER(?) AND SeatsAvailable > 0";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + source + "%");
            pstmt.setString(2, "%" + destination + "%");
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
            request.getRequestDispatcher("SearchFlights.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("SearchFlights.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}