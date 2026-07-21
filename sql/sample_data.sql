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
-- July schedules
('2026-07-21 08:00:00', '2026-07-21 08:45:00',
 45, '1001', 'Northeast Line'),

('2026-07-21 10:00:00', '2026-07-21 11:15:00',
 75, '1002', 'New York Express'),

('2026-07-21 13:00:00', '2026-07-21 13:30:00',
 30, '1003', 'Newark to New York'),

-- September schedules
('2026-09-10 09:00:00', '2026-09-10 09:45:00',
 45, '1001', 'Northeast Line'),

('2026-09-10 11:00:00', '2026-09-10 12:15:00',
 75, '1002', 'New York Express'),

('2026-09-11 14:00:00', '2026-09-11 14:40:00',
 40, '1003', 'Newark to New York');


INSERT INTO Stop
(
    ScheduleID,
    StopNumber,
    StationID,
    ArrivalTime,
    DepartureTime
)
VALUES

-- Schedule 1: New Brunswick to Newark Penn Station
(1, 1, 1, NULL,       '08:00:00'),
(1, 2, 4, '08:45:00', NULL),

-- Schedule 2: New Brunswick to New York Penn Station
(2, 1, 1, NULL,       '10:00:00'),
(2, 2, 4, '10:40:00', '10:42:00'),
(2, 3, 5, '11:15:00', NULL),

-- Schedule 3: Newark Penn Station to New York Penn Station
(3, 1, 4, NULL,       '13:00:00'),
(3, 2, 5, '13:30:00', NULL),

-- Schedule 4: New Brunswick to Newark Penn Station
(4, 1, 1, NULL,       '09:00:00'),
(4, 2, 4, '09:45:00', NULL),

-- Schedule 5: New Brunswick to New York Penn Station
(5, 1, 1, NULL,       '11:00:00'),
(5, 2, 4, '11:40:00', '11:42:00'),
(5, 3, 5, '12:15:00', NULL),

-- Schedule 6: Newark Penn Station to New York Penn Station
(6, 1, 4, NULL,       '14:00:00'),
(6, 2, 5, '14:40:00', NULL);


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
