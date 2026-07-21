USE railway_booking;

INSERT INTO Customer
(Username, Password, FirstName, LastName, Email)
VALUES
('JOHN', '1234', 'John', 'Smith', 'john@example.com'),
('ANNA', 'pass1', 'Anna', 'Jones', 'anna@example.com'),
('BOB', 'hello', 'Bob', 'Brown', 'bob@example.com');


INSERT INTO Train (TrainID)
VALUES
('1001'),
('1002'),
('1003'),
('1004'),
('1005'),
('1006');

INSERT INTO Station (StationName, City, State)
VALUES
('New Brunswick', 'New Brunswick', 'NJ'),
('Edison', 'Edison', 'NJ'),
('Metropark', 'Iselin', 'NJ'),
('Newark Penn Station', 'Newark', 'NJ'),
('New York Penn Station', 'New York', 'NY');

INSERT INTO TransitLine (LineName, Fare, OriginID, DestinationID)
VALUES
('Northeast Line', 15.00, 1, 2),
('New York Express', 25.00, 1, 3),
('Newark to New York', 12.00, 2, 3),
('Metropark Express', 18.00, 3, 5),
('Edison Local', 10.00, 2, 4),
('New Brunswick Shuttle', 8.00, 1, 4);

INSERT INTO Schedule
(DepartureDateTime, ArrivalDateTime, TravelTime, TrainID, LineName)
VALUES
('2026-08-10 08:00:00', '2026-08-10 08:45:00', 45, '1001', 'Northeast Line'),

('2026-08-10 10:00:00', '2026-08-10 11:15:00', 75, '1002', 'New York Express'),

('2026-08-10 13:00:00', '2026-08-10 13:40:00', 40, '1003', 'Newark to New York'),

('2026-08-11 15:00:00', '2026-08-11 15:40:00', 40, '1004', 'Metropark Express'),

('2026-08-11 17:00:00', '2026-08-11 17:25:00', 25, '1005', 'Edison Local'),

('2026-08-11 19:00:00', '2026-08-11 19:20:00', 20, '1006', 'New Brunswick Shuttle');


INSERT INTO Stop
(
    ScheduleID,
    StopNumber,
    StationID,
    ArrivalTime,
    DepartureTime
)
VALUES

-- Schedule 1
(1, 1, 1, NULL,       '08:00:00'),
(1, 2, 4, '08:10:00', '08:12:00'),
(1, 3, 5, '08:22:00', '08:24:00'),
(1, 4, 2, '08:35:00', '08:37:00'),
(1, 5, 3, '08:45:00', NULL),

-- Schedule 2
(2, 1, 1, NULL,       '10:00:00'),
(2, 2, 4, '10:10:00', '10:12:00'),
(2, 3, 5, '10:22:00', '10:24:00'),
(2, 4, 2, '10:35:00', '10:37:00'),
(2, 5, 3, '10:50:00', NULL),

-- Schedule 3
(3, 1, 1, NULL,       '13:00:00'),
(3, 2, 4, '13:10:00', '13:12:00'),
(3, 3, 5, '13:22:00', '13:24:00'),
(3, 4, 2, '13:35:00', '13:37:00'),
(3, 5, 3, '13:40:00', NULL),

-- Schedule 4: Metropark Express
(4, 1, 3, NULL,       '15:00:00'),
(4, 2, 4, '15:20:00', '15:22:00'),
(4, 3, 5, '15:40:00', NULL),

-- Schedule 5: Edison Local
(5, 1, 2, NULL,       '17:00:00'),
(5, 2, 1, '17:10:00', '17:12:00'),
(5, 3, 4, '17:25:00', NULL),

-- Schedule 6: New Brunswick Shuttle
(6, 1, 1, NULL,       '19:00:00'),
(6, 2, 2, '19:08:00', '19:10:00'),
(6, 3, 4, '19:20:00', NULL);

INSERT INTO Reservation
(
    ReservationDate,
    TotalFare,
    TicketType,
    DiscountType,
    Status,
    Username,
    ScheduleID,
    OriginStationID,
    DestinationStationID
)
VALUES

-- Northeast Line: 5 reservations
('2026-07-01 09:00:00', 15.00, 'One-Way', 'None', 'Current', 'JOHN', 1, 1, 2),
('2026-07-02 10:00:00', 11.25, 'One-Way', 'Child', 'Current', 'ANNA', 1, 1, 2),
('2026-07-03 11:00:00', 10.00, 'One-Way', 'Senior', 'Current', 'BOB', 1, 1, 2),
('2026-07-04 12:00:00', 15.00, 'One-Way', 'None', 'Current', 'JOHN', 1, 1, 2),
('2026-07-05 13:00:00', 15.00, 'One-Way', 'None', 'Current', 'ANNA', 1, 1, 2),

-- New York Express: 4 reservations
('2026-07-06 09:00:00', 25.00, 'One-Way', 'None', 'Current', 'JOHN', 2, 1, 3),
('2026-07-07 10:00:00', 25.00, 'One-Way', 'None', 'Current', 'ANNA', 2, 1, 3),
('2026-07-08 11:00:00', 20.00, 'One-Way', 'Senior', 'Current', 'BOB', 2, 1, 3),
('2026-07-09 12:00:00', 25.00, 'One-Way', 'None', 'Current', 'JOHN', 2, 1, 3),

-- Newark to New York: 3 reservations
('2026-07-10 09:00:00', 12.00, 'One-Way', 'None', 'Current', 'ANNA', 3, 2, 3),
('2026-07-11 10:00:00', 12.00, 'One-Way', 'None', 'Current', 'BOB', 3, 2, 3),
('2026-07-12 11:00:00', 12.00, 'One-Way', 'None', 'Current', 'JOHN', 3, 2, 3),

-- Metropark Express: 2 reservations
('2026-07-13 09:00:00', 18.00, 'One-Way', 'None', 'Current', 'ANNA', 4, 3, 5),
('2026-07-14 10:00:00', 18.00, 'One-Way', 'None', 'Current', 'JOHN', 4, 3, 5),

-- Edison Local: 1 reservation
('2026-07-15 09:00:00', 10.00, 'One-Way', 'None', 'Current', 'BOB', 5, 2, 4);

INSERT INTO Employee
(SSN, FirstName, LastName, Username, Password, Role)
VALUES
('111223333', 'System', 'Admin', 'admin', 'admin123', 'ADMIN'),
('222334444', 'Sarah', 'Miller', 'rep1', 'rep123', 'REP'),
('333445555', 'Michael', 'Davis', 'rep2', 'rep123', 'REP');

INSERT INTO CustomerQuestion
(QuestionText, Username)
VALUES
('Can I cancel my reservation before departure?', 'JOHN'),
('Are senior discounts available on all transit lines?', 'ANNA'),
('How do I view the stops for my train?', 'BOB');

INSERT INTO CustomerReply
(ReplyText, QuestionID, EmployeeSSN)
VALUES
('Yes. Current reservations can be cancelled before departure.', 1, '222334444'),
('Yes. Senior passengers receive the applicable senior discount.', 2, '222334444');
