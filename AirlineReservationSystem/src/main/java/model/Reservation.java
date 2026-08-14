package model;

import java.sql.Timestamp;

public class Reservation {
    private int reservationID;
    private int userID;
    private int flightID;
    private Timestamp bookingDate;
    private int seatCount;
    private String status;
    private Flight flight;
    private User user;
    
    public Reservation() {}
    
    // Getters and Setters
    public int getReservationID() { return reservationID; }
    public void setReservationID(int reservationID) { this.reservationID = reservationID; }
    
    public int getUserID() { return userID; }
    public void setUserID(int userID) { this.userID = userID; }
    
    public int getFlightID() { return flightID; }
    public void setFlightID(int flightID) { this.flightID = flightID; }
    
    public Timestamp getBookingDate() { return bookingDate; }
    public void setBookingDate(Timestamp bookingDate) { this.bookingDate = bookingDate; }
    
    public int getSeatCount() { return seatCount; }
    public void setSeatCount(int seatCount) { this.seatCount = seatCount; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Flight getFlight() { return flight; }
    public void setFlight(Flight flight) { this.flight = flight; }
    
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
}
