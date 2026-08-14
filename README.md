# ✈️ Airline Reservation System

[![Java](https://img.shields.io/badge/Java-11-blue.svg)](https://www.oracle.com/java/)
[![JSP](https://img.shields.io/badge/JSP-2.3-red.svg)](https://www.oracle.com/java/technologies/jspt.html)
[![Oracle](https://img.shields.io/badge/Oracle-19c-orange.svg)](https://www.oracle.com/database/)
[![Tomcat](https://img.shields.io/badge/Tomcat-9.0-yellow.svg)](https://tomcat.apache.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📖 Overview

The **Airline Reservation System** is a comprehensive Enterprise Web Application developed using Java Enterprise Edition (Java EE) technologies. It provides a complete solution for airlines to manage flight bookings, customer reservations, payments, and administrative operations. The system features role-based access control with separate interfaces for customers and administrators.

### 🎯 Key Features

- 🔐 **User Authentication & Authorization**
  - Role-based access (Admin/Customer)
  - Secure session management
  - Registration with email validation

- ✈️ **Flight Management**
  - Search flights by source and destination
  - Real-time seat availability
  - Dynamic flight scheduling
  - Price management

- 💳 **Booking & Payments**
  - Multi-seat booking capability
  - Secure payment processing
  - Automatic seat allocation
  - E-ticket generation

- 👨‍💼 **Admin Dashboard**
  - Complete flight CRUD operations
  - View all reservations
  - User management
  - System monitoring

- 📱 **Responsive Design**
  - Mobile-friendly interface
  - Modern UI with gradients and animations
  - Cross-browser compatibility

## 🏗️ Architecture

### System Architecture
```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer (JSP)                 │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐            │
│  │ Login   │ │ Register│ │ Search  │ │ Admin   │            │
│  │         │ │         │ │ Flights │ │ Dashboard│           │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘            │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                    Business Layer (Servlets)                │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐            │
│  │Login    │ │Register │ │Search   │ │Book     │            │
│  │Servlet  │ │Servlet  │ │Flight   │ │Flight   │            │
│  │         │ │         │ │Servlet  │ │Servlet  │            │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘            │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐                        │
│  │Payment  │ │Admin    │ │Logout   │                        │
│  │Servlet  │ │Servlet  │ │Servlet  │                        │
│  └─────────┘ └─────────┘ └─────────┘                        │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                    Data Layer (JDBC + Oracle)               │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐            │
│  │ Users   │ │ Flights │ │Reservat-│ │Payments │            │
│  │ Table   │ │ Table   │ │ions     │ │ Table   │            │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘            │
└─────────────────────────────────────────────────────────────┘
```

### MVC Pattern Implementation
- **Model**: Java Beans (User, Flight, Reservation, Payment)
- **View**: JSP pages with CSS styling
- **Controller**: Servlets handling business logic

## 🗄️ Database Schema

### Tables Structure

```sql
-- Users Table
CREATE TABLE Users (
    UserID NUMBER PRIMARY KEY,
    Name VARCHAR2(50) NOT NULL,
    Email VARCHAR2(50) UNIQUE NOT NULL,
    Password VARCHAR2(50) NOT NULL,
    Role VARCHAR2(20) CHECK (Role IN ('Admin','Customer'))
);

-- Flights Table
CREATE TABLE Flights (
    FlightID NUMBER PRIMARY KEY,
    FlightNumber VARCHAR2(20) NOT NULL,
    Source VARCHAR2(50) NOT NULL,
    Destination VARCHAR2(50) NOT NULL,
    DepartureTime TIMESTAMP,
    ArrivalTime TIMESTAMP,
    SeatsAvailable NUMBER,
    Price NUMBER(10,2)
);

-- Reservations Table
CREATE TABLE Reservations (
    ReservationID NUMBER PRIMARY KEY,
    UserID NUMBER REFERENCES Users(UserID),
    FlightID NUMBER REFERENCES Flights(FlightID),
    BookingDate TIMESTAMP DEFAULT SYSDATE,
    SeatCount NUMBER,
    Status VARCHAR2(20)
);

-- Payments Table
CREATE TABLE Payments (
    PaymentID NUMBER PRIMARY KEY,
    ReservationID NUMBER REFERENCES Reservations(ReservationID),
    Amount NUMBER(10,2),
    PaymentDate TIMESTAMP DEFAULT SYSDATE,
    PaymentStatus VARCHAR2(20)
);

-- Seat Allocations Table
CREATE TABLE SeatAllocations (
    AllocationID NUMBER PRIMARY KEY,
    ReservationID NUMBER REFERENCES Reservations(ReservationID),
    FlightID NUMBER REFERENCES Flights(FlightID),
    SeatNumber VARCHAR2(10) NOT NULL,
    PassengerName VARCHAR2(100)
);
```

## 📂 Project Structure

```
AirlineReservation/
│
├── src/
│   ├── model/
│   │   ├── DBConnection.java      # Database connection handler
│   │   ├── User.java              # User model
│   │   ├── Flight.java            # Flight model
│   │   ├── Reservation.java       # Reservation model
│   │   └── Payment.java           # Payment model
│   │
│   └── servlet/
│       ├── RegisterServlet.java   # User registration
│       ├── LoginServlet.java      # User authentication
│       ├── SearchFlightServlet.java # Flight search
│       ├── BookFlightServlet.java  # Flight booking
│       ├── PaymentServlet.java    # Payment processing
│       ├── AdminServlet.java      # Admin operations
│       └── LogoutServlet.java     # User logout
│
├── WebContent/
│   ├── css/
│   │   └── style.css              # Main stylesheet
│   ├── index.jsp                  # Home page
│   ├── Login.jsp                  # Login page
│   ├── Register.jsp               # Registration page
│   ├── SearchFlights.jsp          # Flight search
│   ├── BookFlight.jsp             # Booking page
│   ├── Payment.jsp                # Payment page
│   ├── Confirmation.jsp           # Booking confirmation
│   ├── AdminDashboard.jsp         # Admin dashboard
│   ├── ViewReservations.jsp       # View reservations
│   └── WEB-INF/
│       └── web.xml                # Web configuration
│
├── README.md
├── LICENSE
└── .gitignore
```

## 🚀 Getting Started

### Prerequisites

- **Java JDK 8 or higher**
- **Apache Tomcat 9.0**
- **Oracle Database 19c or higher**
- **Eclipse IDE (or any Java IDE)**
- **Oracle SQL Developer**

### Installation Steps

#### 1. Database Setup

```sql
-- Connect to Oracle Database
-- Run the database script provided in the project
-- Update credentials in DBConnection.java
```

#### 2. Configure Database Connection

```java
// In DBConnection.java
private static final String URL = "jdbc:oracle:thin:@localhost:1521:XE";
private static final String USERNAME = "your_username";
private static final String PASSWORD = "your_password";
```

#### 3. Setup in Eclipse

```bash
1. Open Eclipse IDE
2. File → Import → Existing Projects into Workspace
3. Select the project folder
4. Add Oracle JDBC driver to build path
5. Configure Tomcat server
6. Deploy the project to Tomcat
```

#### 4. Run the Application

```bash
1. Start Apache Tomcat server
2. Open web browser
3. Navigate to: http://localhost:8080/AirlineReservation/
4. Default admin credentials:
   Email: admin@airline.com
   Password: admin123
```

## 💻 Technology Stack

### Frontend Technologies
| Technology | Version | Purpose |
|------------|---------|---------|
| HTML5 | - | Structure |
| CSS3 | - | Styling |
| JSP | 2.3 | Dynamic content |
| JavaScript | ES6 | Client-side logic |

### Backend Technologies
| Technology | Version | Purpose |
|------------|---------|---------|
| Java | 11 | Core language |
| Servlets | 4.0 | Request handling |
| JDBC | 4.3 | Database connectivity |
| Oracle | 19c | Database |

### Development Tools
| Tool | Version | Purpose |
|------|---------|---------|
| Eclipse | 2023-06 | IDE |
| Tomcat | 9.0 | Web server |
| SQL Developer | 23.1 | Database management |

## 🔧 Features Explained

### User Registration & Login
- **Registration**: New users can create accounts with email validation
- **Login**: Secure authentication with role-based redirection
- **Session Management**: Maintains user state across the application

### Flight Search & Booking
- **Search**: Filter flights by source and destination
- **Availability**: Real-time seat availability checking
- **Booking**: Multi-seat booking with automatic price calculation

### Payment Processing
- **Payment**: Simulated payment gateway
- **Transaction**: Records all payment transactions
- **Confirmation**: Generates booking confirmation with e-ticket

### Admin Dashboard
- **Flight Management**: Add, edit, and delete flights
- **Reservation View**: Monitor all bookings
- **System Control**: Complete system management

## 🔒 Security Features

### Authentication
- Session-based authentication
- Role-based access control
- Secure logout functionality

### Data Protection
- SQL injection prevention via parameterized queries
- Input validation and sanitization
- XSS protection through output encoding

## 🧪 Testing

### Test Scenarios

```java
1. User Registration:
   - Valid registration flow
   - Duplicate email handling
   - Invalid input validation

2. User Login:
   - Valid credentials
   - Invalid credentials
   - Session timeout handling

3. Flight Search:
   - Valid search criteria
   - No results handling
   - Invalid search parameters

4. Booking Process:
   - Seat availability check
   - Multi-passenger booking
   - Payment processing

5. Admin Functions:
   - Flight CRUD operations
   - Reservation viewing
   - User management
```

