package model;

import java.sql.Timestamp;

public class Flight {
    private int flightID;
    private String flightNumber;
    private String source;
    private String destination;
    private Timestamp departureTime;
    private Timestamp arrivalTime;
    private int seatsAvailable;
    private double price;
    
    public Flight() {}
    
    public Flight(int flightID, String flightNumber, String source, String destination, 
                  Timestamp departureTime, Timestamp arrivalTime, int seatsAvailable, double price) {
        this.flightID = flightID;
        this.flightNumber = flightNumber;
        this.source = source;
        this.destination = destination;
        this.departureTime = departureTime;
        this.arrivalTime = arrivalTime;
        this.seatsAvailable = seatsAvailable;
        this.price = price;
    }
    
    // Getters and Setters
    public int getFlightID() { return flightID; }
    public void setFlightID(int flightID) { this.flightID = flightID; }
    
    public String getFlightNumber() { return flightNumber; }
    public void setFlightNumber(String flightNumber) { this.flightNumber = flightNumber; }
    
    public String getSource() { return source; }
    public void setSource(String source) { this.source = source; }
    
    public String getDestination() { return destination; }
    public void setDestination(String destination) { this.destination = destination; }
    
    public Timestamp getDepartureTime() { return departureTime; }
    public void setDepartureTime(Timestamp departureTime) { this.departureTime = departureTime; }
    
    public Timestamp getArrivalTime() { return arrivalTime; }
    public void setArrivalTime(Timestamp arrivalTime) { this.arrivalTime = arrivalTime; }
    
    public int getSeatsAvailable() { return seatsAvailable; }
    public void setSeatsAvailable(int seatsAvailable) { this.seatsAvailable = seatsAvailable; }
    
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
}
