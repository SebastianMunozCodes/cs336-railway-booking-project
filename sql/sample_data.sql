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
('Newark Penn Station', 'Newark', 'NJ'),
('New York Penn Station', 'New York', 'NY'),
('Edison', 'Edison', 'NJ'),
('Metropark', 'Iselin', 'NJ');

INSERT INTO TransitLine (LineName, Fare, OriginID, DestinationID)
VALUES
('Northeast Line', 15.00, 1, 4),
('New York Express', 25.00, 1, 5),
('Newark to New York', 12.00, 4, 5),
('Metropark Express', 18.00, 5, 3),
('Edison Local', 10.00, 4, 2);

INSERT INTO Schedule
(DepartureDateTime, ArrivalDateTime, TravelTime, TrainID, LineName)
VALUES

('2026-07-21 08:00:00', '2026-07-21 08:45:00',
 45, '1001', 'Northeast Line'),

('2026-07-21 10:00:00', '2026-07-21 11:15:00',
 75, '1002', 'New York Express'),

('2026-07-21 13:00:00', '2026-07-21 13:30:00',
30, '1003', 'Edison to Metropark'),


('2026-09-10 09:00:00', '2026-09-10 09:45:00',
 45, '1001', 'Northeast Line'),

('2026-09-10 11:00:00', '2026-09-10 12:15:00',
 75, '1002', 'New York Express'),

('2026-09-11 14:00:00', '2026-09-11 14:40:00',
40, '1003', 'Edison to Metropark'),
 

('2026-09-12 10:00:00', '2026-09-12 10:40:00',
 40, '1004', 'Metropark Express'),

('2026-09-12 13:00:00', '2026-09-12 13:25:00',
 25, '1005', 'Edison Local'),


('2026-09-13 15:00:00', '2026-09-13 15:40:00',
 40, '1004', 'Metropark Express'),


('2026-09-13 17:00:00', '2026-09-13 17:25:00',
 25, '1005', 'Edison Local');
 

INSERT INTO Stop
(
    ScheduleID,
    StopNumber,
    StationID,
    ArrivalTime,
    DepartureTime
)
VALUES

-- Schedule 1: Northeast Line
-- New Brunswick → Edison
(1, 1, 1, NULL,       '08:00:00'),
(1, 2, 4, '08:45:00', NULL),

-- Schedule 2: New York Express
-- New Brunswick → Edison → Metropark
(2, 1, 1, NULL,       '10:00:00'),
(2, 2, 4, '10:35:00', '10:37:00'),
(2, 3, 5, '11:15:00', NULL),

-- Schedule 3: Edison to Metropark
(3, 1, 4, NULL,       '13:00:00'),
(3, 2, 5, '13:30:00', NULL),

-- Schedule 4: Northeast Line
-- New Brunswick → Edison
(4, 1, 1, NULL,       '09:00:00'),
(4, 2, 4, '09:45:00', NULL),

-- Schedule 5: New York Express
-- New Brunswick → Edison → Metropark
(5, 1, 1, NULL,       '11:00:00'),
(5, 2, 4, '11:35:00', '11:37:00'),
(5, 3, 5, '12:15:00', NULL),

-- Schedule 6: Edison to Metropark
(6, 1, 4, NULL,       '14:00:00'),
(6, 2, 5, '14:40:00', NULL),

-- Schedule 7: Metropark Express
-- Metropark → Newark Penn → New York Penn
(7, 1, 5, NULL,       '10:00:00'),
(7, 2, 2, '10:20:00', '10:22:00'),
(7, 3, 3, '10:40:00', NULL),

-- Schedule 8: Edison Local
-- Edison → New Brunswick → Newark Penn
(8, 1, 4, NULL,       '13:00:00'),
(8, 2, 1, '13:10:00', '13:12:00'),
(8, 3, 2, '13:25:00', NULL),

-- Schedule 9: Metropark Express
-- Metropark → Newark Penn → New York Penn
(9, 1, 5, NULL,       '15:00:00'),
(9, 2, 2, '15:20:00', '15:22:00'),
(9, 3, 3, '15:40:00', NULL),

-- Schedule 10: Edison Local
-- Edison → New Brunswick → Newark Penn
(10, 1, 4, NULL,       '17:00:00'),
(10, 2, 1, '17:10:00', '17:12:00'),
(10, 3, 2, '17:25:00', NULL);



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
('2026-07-20 15:47:44', 22.50, 'Round-Trip', 'Child',    'Current',   'JOHN', 1, 1, 2),
('2026-07-20 15:48:37', 30.00, 'Round-Trip', 'None',     'Cancelled', 'JOHN', 1, 1, 2),
('2026-07-20 15:57:15',  9.75, 'One-Way',    'Senior',   'Current',   'JOHN', 1, 1, 2),
('2026-07-21 11:47:01', 15.00, 'Round-Trip', 'Disabled', 'Current',   'JOHN', 1, 1, 2),
('2026-07-21 11:47:42', 11.25, 'One-Way',    'Child',    'Current',   'JOHN', 1, 1, 2),

('2026-07-21 11:49:37', 18.75, 'One-Way', 'Child',  'Current', 'JOHN', 2, 1, 3),
('2026-07-21 12:02:35', 25.00, 'One-Way', 'None',   'Current', 'JOHN', 2, 1, 3),

('2026-07-21 12:17:39', 7.80, 'One-Way', 'Senior', 'Cancelled', 'JOHN', 3, 2, 3),

('2026-07-21 12:32:57', 11.25, 'One-Way', 'Child', 'Current', 'JOHN', 4, 1, 2),

('2026-07-21 13:53:12', 15.00, 'One-Way', 'None', 'Current', 'ANNA', 4, 1, 4),
('2026-07-21 13:54:31', 15.00, 'One-Way', 'None', 'Current', 'ANNA', 1, 1, 4),

('2026-07-21 14:01:49', 9.00,  'One-Way', 'Disabled', 'Current',   'BOB', 7, 5, 3),
('2026-07-21 14:03:00', 11.25, 'One-Way', 'Child',    'Cancelled', 'BOB', 4, 1, 4);

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
