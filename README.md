# CS336 Railway Booking Project

A web-based railway reservation and management system developed for **CS 336 - Principles of Information and Data Management**.

The application provides role-based functionality for **customers**, **customer representatives**, and **administrators**. Users share a common login page, and the system determines the account type after authentication and redirects the user to the appropriate dashboard.

## Test Credentials

The following accounts are included in `sql/sample_data.sql` and can be used to test the completed application.

### Administrator

| Username | Password |
|---|---|
| `admin` | `admin123` |

### Customer Representatives

| Username | Password |
|---|---|
| `rep1` | `rep123` |
| `rep2` | `rep123` |

Representative accounts are managed by administrators. Customers can self-register from the login page, but representatives cannot create their own accounts.

### Sample Customers

| Username | Password |
|---|---|
| `JOHN` | `1234` |
| `ANNA` | `pass1` |
| `BOB` | `hello` |

Additional customer accounts can be created through the application's customer registration page.

## User Roles and Features

### Customer

Customers can:

- Register a new customer account.
- Log in and log out.
- Search train schedules by:
  - Origin
  - Destination
  - Date of travel
- Sort schedule results by:
  - Departure time
  - Arrival time
  - Fare
- View schedule information including train, transit line, departure time, arrival time, travel time, and fare.
- View all stops associated with a train schedule.
- Make railway reservations.
- Choose between one-way and round-trip ticket types.
- Receive applicable discounts for:
  - Children
  - Seniors
  - Disabled passengers
- View current reservations and their details.
- View past reservations separately from current reservations.
- Cancel eligible current reservations.
- Submit questions to customer service.
- Browse customer questions and representative answers.
- Search questions and answers by keyword.

### Customer Representative

Customer representatives can:

- Log in and log out through the shared authentication system.
- View train schedules.
- Edit existing train schedule information.
- Delete train schedules when permitted by the database constraints.
- View customer service questions.
- Reply to unanswered customer questions.
- View train schedules associated with a selected station:
  - As an origin
  - As a destination
- Find customers with reservations for a specified transit line and travel date.

Representative accounts are created, edited, and deleted by administrators.

### Administrator

Administrators can:

- Log in and log out through the shared authentication system.
- Manage customer representative accounts:
  - Add representatives
  - Edit representative information
  - Delete representatives
- Generate monthly sales reports.
- View reservations by transit line.
- View reservations by customer.
- View revenue by transit line.
- View revenue by customer.
- Identify the best customer based on generated revenue.
- View the five most active transit lines by month.

## Authentication and Role-Based Access

The application uses one shared login page for all account types.

After credentials are submitted:

1. The system first checks the `Customer` table for a matching customer account.
2. If no customer account matches, it checks the `Employee` table.
3. Employee accounts are assigned either the `ADMIN` or `REP` role.
4. The authenticated user's role is stored in the session.
5. The user is redirected to the appropriate dashboard:
   - Customer → `customerDashboard.jsp`
   - Customer Representative → `repDashboard.jsp`
   - Administrator → `adminDashboard.jsp`

Protected pages verify the active session and required role before allowing access. Unauthorized or logged-out users are redirected to the login page.

## Technology Stack

- **Java 21**
- **JSP**
- **HTML/CSS**
- **JDBC**
- **MySQL**
- **MySQL Connector/J 9.7.0**
- **Apache Tomcat**
- **Eclipse IDE / Eclipse Dynamic Web Project**

The application uses server-side JSP pages with JDBC queries to communicate directly with the MySQL database.

## Database Overview

The application uses a MySQL database named:

`railway_booking`

The database schema is defined in:

`sql/schema.sql`

Sample accounts, schedules, reservations, questions, replies, stations, trains, and transit lines are provided in:

`sql/sample_data.sql`

An additional exported schema file is available at:

`sql/exported_schema.sql`

### Main Database Tables

| Table | Purpose |
|---|---|
| `Customer` | Stores registered customer accounts and login information |
| `Employee` | Stores administrator and customer representative accounts and roles |
| `Train` | Stores train identifiers |
| `Station` | Stores railway station names and locations |
| `TransitLine` | Stores transit lines, base fares, origins, and destinations |
| `Schedule` | Stores scheduled train trips, dates, times, trains, and transit lines |
| `Stop` | Stores the ordered stops associated with each schedule |
| `Reservation` | Stores customer reservations, fares, ticket types, discounts, and statuses |
| `CustomerQuestion` | Stores questions submitted by customers |
| `CustomerReply` | Stores customer representative replies to questions |

The schema uses primary keys and foreign-key relationships to connect customers, reservations, schedules, trains, transit lines, stations, stops, employees, questions, and replies.

## Database Setup

### 1. Start MySQL

Make sure a local MySQL server is installed and running.

The JSP files are configured by default to connect using:

- Host: `localhost`
- Port: `3306`
- Database: `railway_booking`
- MySQL user: `root`
- MySQL password: empty

### 2. Create the Database and Tables

From the repository root, run:

    mysql -u root < sql/schema.sql

If the MySQL `root` account requires a password:

    mysql -u root -p < sql/schema.sql

`schema.sql` creates the `railway_booking` database and all required tables.

### 3. Load the Sample Data

After creating the schema, run:

    mysql -u root < sql/sample_data.sql

Or, if the MySQL account requires a password:

    mysql -u root -p < sql/sample_data.sql

The sample data provides:

- Administrator and representative accounts
- Sample customer accounts
- Trains
- Stations
- Transit lines
- Train schedules
- Schedule stops
- Reservations
- Customer questions
- Customer representative replies

Loading this file is recommended for testing the full application immediately after setup.

## JDBC Configuration

The MySQL JDBC driver is already included in the project at:

`src/main/webapp/WEB-INF/lib/mysql-connector-j-9.7.0.jar`

The application currently uses the following JDBC configuration throughout its JSP pages:

    String url = "jdbc:mysql://localhost:3306/railway_booking";
    String dbUser = "root";
    String dbPassword = "";

If the local MySQL configuration uses a different username, password, port, or database name, update these JDBC connection values in the JSP files before running the application.

Do not commit personal or production database credentials to a public repository.

## Running the Application with Eclipse and Apache Tomcat

### Prerequisites

Before running the project, make sure the following are available:

- Java 21
- Eclipse IDE with Java Enterprise / Web Development support
- Apache Tomcat
- MySQL Server
- The included MySQL Connector/J driver

### 1. Import the Project into Eclipse

1. Open Eclipse.
2. Choose **File → Import**.
3. Import the repository as an existing Eclipse project.
4. Select the `cs336-railway-booking-project` project directory.
5. Confirm that Eclipse recognizes it as a Dynamic Web Project.

The repository already contains Eclipse project configuration files such as:

- `.project`
- `.classpath`
- `.settings/`

The project is configured for **Java 21** and the **Dynamic Web Module 5.0** project facet.

### 2. Configure Apache Tomcat

Add an Apache Tomcat server in Eclipse if one is not already configured.

In Eclipse:

1. Open the **Servers** view.
2. Create a new Apache Tomcat server.
3. Select the local Tomcat installation directory.
4. Add `cs336-railway-booking-project` to the server.

### 3. Configure MySQL

Make sure MySQL is running and that the following SQL files have been executed in order:

1. `sql/schema.sql`
2. `sql/sample_data.sql`

Verify that the `railway_booking` database exists before starting the web application.

If the local MySQL `root` account has a password, update the `dbPassword` value used by the JSP database connections.

### 4. Run the Project

In Eclipse:

1. Right-click the project.
2. Select **Run As → Run on Server**.
3. Choose the configured Apache Tomcat server.
4. Allow Eclipse/Tomcat to deploy the application.

Open the application's `index.jsp` page in the browser.

The login page can then be used with any of the administrator, representative, or customer credentials listed above.

## Project Structure

    cs336-railway-booking-project/
    │
    ├── README.md
    ├── .classpath
    ├── .project
    ├── .settings/
    │
    ├── sql/
    │   ├── schema.sql
    │   ├── sample_data.sql
    │   └── exported_schema.sql
    │
    └── src/
        └── main/
            └── webapp/
                ├── index.jsp
                ├── checkLoginDetails.jsp
                ├── logout.jsp
                │
                ├── register.jsp
                ├── registerCustomer.jsp
                │
                ├── customerDashboard.jsp
                ├── search.jsp
                ├── searchResults.jsp
                ├── viewStops.jsp
                ├── makeReservation.jsp
                ├── confirmReservation.jsp
                ├── myReservations.jsp
                ├── cancelReservation.jsp
                ├── askQuestion.jsp
                ├── customerQuestions.jsp
                │
                ├── repDashboard.jsp
                ├── manageSchedules.jsp
                ├── editSchedule.jsp
                ├── deleteSchedule.jsp
                ├── repQuestions.jsp
                ├── replyQuestion.jsp
                ├── stationSchedules.jsp
                ├── customersByLineDate.jsp
                │
                ├── adminDashboard.jsp
                ├── manageReps.jsp
                ├── addRep.jsp
                ├── editRep.jsp
                ├── deleteRep.jsp
                ├── adminReports.jsp
                ├── monthlySales.jsp
                ├── reservationsByLine.jsp
                ├── reservationsByCustomer.jsp
                ├── revenueByLine.jsp
                ├── revenueByCustomer.jsp
                ├── bestCustomer.jsp
                ├── topTransitLines.jsp
                │
                ├── META-INF/
                └── WEB-INF/
                    └── lib/
                        └── mysql-connector-j-9.7.0.jar

## Important Application Files

### Authentication and Registration

- `index.jsp` — shared login page for customers, representatives, and administrators
- `checkLoginDetails.jsp` — authenticates accounts, creates session information, determines the account role, and redirects to the correct dashboard
- `register.jsp` — customer registration form
- `registerCustomer.jsp` — creates customer accounts after checking for duplicate usernames or email addresses
- `logout.jsp` — ends the active session

### Customer Functionality

- `customerDashboard.jsp` — main customer dashboard
- `search.jsp` — train schedule search form
- `searchResults.jsp` — displays and sorts matching train schedules
- `viewStops.jsp` — displays the ordered stops for a schedule
- `makeReservation.jsp` — collects ticket and discount selections
- `confirmReservation.jsp` — calculates the fare and creates the reservation
- `myReservations.jsp` — displays current and past customer reservations
- `cancelReservation.jsp` — cancels eligible current reservations
- `askQuestion.jsp` — submits customer service questions
- `customerQuestions.jsp` — browses and searches customer questions and answers

### Customer Representative Functionality

- `repDashboard.jsp` — main representative dashboard
- `manageSchedules.jsp` — lists schedules available for management
- `editSchedule.jsp` — edits schedule information
- `deleteSchedule.jsp` — deletes eligible schedules
- `repQuestions.jsp` — displays customer questions and their answer status
- `replyQuestion.jsp` — allows a representative to answer an unanswered question
- `stationSchedules.jsp` — lists schedules where a selected station is an origin or destination
- `customersByLineDate.jsp` — lists customers with reservations on a selected transit line and date

### Administrator Functionality

- `adminDashboard.jsp` — main administrator dashboard
- `manageReps.jsp` — displays customer representative accounts
- `addRep.jsp` — creates new representative accounts
- `editRep.jsp` — edits representative account information
- `deleteRep.jsp` — deletes representative accounts
- `adminReports.jsp` — central page for administrator reporting functions
- `monthlySales.jsp` — monthly sales report
- `reservationsByLine.jsp` — reservations grouped/filterable by transit line
- `reservationsByCustomer.jsp` — reservations for a selected customer
- `revenueByLine.jsp` — revenue generated by transit line
- `revenueByCustomer.jsp` — revenue generated by customer
- `bestCustomer.jsp` — identifies the highest-revenue customer
- `topTransitLines.jsp` — displays the five most active transit lines for a selected month

## Sample Data and Testing Notes

The included sample data is designed to make the major application features testable immediately after database setup.

It includes:

- Three sample customers
- One administrator
- Two customer representatives
- Six trains
- Multiple stations and transit lines
- Multiple train schedules and stops
- Reservations across several customers and transit lines
- Different reservation discount types
- Customer questions with both answered and unanswered examples

For a quick role-based test:

- Log in as `JOHN / 1234` to test customer functionality.
- Log in as `rep1 / rep123` to test customer representative functionality.
- Log in as `admin / admin123` to test administrator functionality.

The seeded data can also be used to test administrative reports, representative searches, reservation history, schedule browsing, customer service questions, and role-based access control.