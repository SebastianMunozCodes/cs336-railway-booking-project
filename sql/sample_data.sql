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
('1003');

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
('Newark to New York', 12.00, 2, 3);

INSERT INTO Schedule
(DepartureDateTime, ArrivalDateTime, TravelTime, TrainID, LineName)
VALUES
('2026-07-21 08:00:00', '2026-07-21 08:45:00', 45, '1001', 'Northeast Line'),

('2026-07-21 10:00:00', '2026-07-21 11:15:00', 75, '1002', 'New York Express'),

('2026-07-21 13:00:00', '2026-07-21 13:30:00', 30, '1003', 'Newark to New York');


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
(3, 5, 3, '13:40:00', NULL);

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
