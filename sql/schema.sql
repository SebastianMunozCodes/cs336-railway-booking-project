CREATE DATABASE IF NOT EXISTS railway_booking;
USE railway_booking;

CREATE TABLE Customer (
    Username VARCHAR(80) PRIMARY KEY,
    Password VARCHAR(80) NOT NULL,
    FirstName VARCHAR(80) NOT NULL,
    LastName VARCHAR(80) NOT NULL,
    Email VARCHAR(100) NOT NULL
    
);