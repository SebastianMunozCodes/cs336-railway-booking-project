CREATE DATABASE IF NOT EXISTS railway_booking;
USE railway_booking;

CREATE TABLE Customer (
    Username VARCHAR(80) PRIMARY KEY,
    Password VARCHAR(80) NOT NULL,
    FirstName VARCHAR(80) NOT NULL,
    LastName VARCHAR(80) NOT NULL,
    Email VARCHAR(100) NOT NULL
    
);

CREATE TABLE Train (
    TrainID CHAR(4),
    PRIMARY KEY (TrainID)
);

CREATE TABLE Station (
    StationID INT AUTO_INCREMENT,
    StationName VARCHAR(60) NOT NULL,
    City VARCHAR(60) NOT NULL,
    State CHAR(2) NOT NULL,
    PRIMARY KEY (StationID)
);

CREATE TABLE TransitLine (
    LineName VARCHAR(60),
    Fare DECIMAL(8,2) NOT NULL,
    OriginID INT NOT NULL,
    DestinationID INT NOT NULL,

    PRIMARY KEY (LineName),

    FOREIGN KEY (OriginID)
        REFERENCES Station(StationID),

    FOREIGN KEY (DestinationID)
        REFERENCES Station(StationID)
);

CREATE TABLE Schedule (
    ScheduleID INT AUTO_INCREMENT,
    DepartureDateTime DATETIME NOT NULL,
    ArrivalDateTime DATETIME NOT NULL,
    TravelTime INT,
    TrainID CHAR(4) NOT NULL,
    LineName VARCHAR(60) NOT NULL,

    PRIMARY KEY (ScheduleID),

    FOREIGN KEY (TrainID)
        REFERENCES Train(TrainID),

    FOREIGN KEY (LineName)
        REFERENCES TransitLine(LineName)
);

CREATE TABLE Stop (
    ScheduleID INT NOT NULL,
    StopNumber INT NOT NULL,
    StationID INT NOT NULL,
    ArrivalTime TIME,
    DepartureTime TIME,

    PRIMARY KEY (ScheduleID, StopNumber),

    FOREIGN KEY (ScheduleID)
        REFERENCES Schedule(ScheduleID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    FOREIGN KEY (StationID)
        REFERENCES Station(StationID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE Reservation (
    ReservationNumber INT AUTO_INCREMENT,
    ReservationDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    TotalFare DECIMAL(8,2) NOT NULL,
    TicketType VARCHAR(20) NOT NULL,
    DiscountType VARCHAR(20) NOT NULL DEFAULT 'None',
    Status VARCHAR(20) NOT NULL DEFAULT 'Current',

    Username VARCHAR(80) NOT NULL,
    ScheduleID INT NOT NULL,
    OriginStationID INT NOT NULL,
    DestinationStationID INT NOT NULL,

    PRIMARY KEY (ReservationNumber),

    FOREIGN KEY (Username)
        REFERENCES Customer(Username)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    FOREIGN KEY (ScheduleID)
        REFERENCES Schedule(ScheduleID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    FOREIGN KEY (OriginStationID)
        REFERENCES Station(StationID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    FOREIGN KEY (DestinationStationID)
        REFERENCES Station(StationID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);