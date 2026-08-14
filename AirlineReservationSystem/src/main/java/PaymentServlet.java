
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.DBConnection;
import model.User;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("Login.jsp");
            return;
        }
        
        int reservationID = (Integer) session.getAttribute("reservationID");
        double amount = (Double) session.getAttribute("totalAmount");
        String cardNumber = request.getParameter("cardNumber");
        String expiryDate = request.getParameter("expiryDate");
        String cvv = request.getParameter("cvv");
        String cardHolder = request.getParameter("cardHolder");
        
        // Simple payment validation (in real application, use proper payment gateway)
        if (cardNumber == null || cardNumber.length() != 16 || 
            expiryDate == null || cvv == null || cvv.length() != 3) {
            request.setAttribute("errorMessage", "Invalid payment details!");
            request.getRequestDispatcher("Payment.jsp").forward(request, response);
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Record payment
            String sql = "INSERT INTO Payments (PaymentID, ReservationID, Amount, PaymentStatus) VALUES (SEQ_PAY.NEXTVAL, ?, ?, 'Completed')";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, reservationID);
            pstmt.setDouble(2, amount);
            pstmt.executeUpdate();
            
            // Update reservation status
            String updateReservation = "UPDATE Reservations SET Status = 'Paid' WHERE ReservationID = ?";
            pstmt = conn.prepareStatement(updateReservation);
            pstmt.setInt(1, reservationID);
            pstmt.executeUpdate();
            
            // Clear session attributes
            session.removeAttribute("reservationID");
            session.removeAttribute("flight");
            session.removeAttribute("seatCount");
            session.removeAttribute("totalAmount");
            
            request.setAttribute("reservationID", reservationID);
            request.setAttribute("amount", amount);
            request.getRequestDispatcher("Confirmation.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Payment failed: " + e.getMessage());
            request.getRequestDispatcher("Payment.jsp").forward(request, response);
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}