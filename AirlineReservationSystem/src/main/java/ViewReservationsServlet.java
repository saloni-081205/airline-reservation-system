import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ViewReservationsServlet")
public class ViewReservationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Map<String, Object>> reservations = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM Reservations")) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("ReservationID", rs.getInt("ReservationID"));
                row.put("UserID", rs.getInt("UserID"));
                row.put("FlightID", rs.getInt("FlightID"));
                row.put("Status", rs.getString("Status"));
                reservations.add(row);
            }

            request.setAttribute("reservations", reservations);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("ViewReservations.jsp").forward(request, response);
    }
}
