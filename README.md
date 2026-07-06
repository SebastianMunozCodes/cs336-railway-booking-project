# CS336 Railway Booking Project

Group project for **CS 336 - Principles of Information and Data Management**.

## Project Overview

This project is a web-based railway booking system. The final system will allow customers to search train schedules, make reservations, cancel reservations, view reservation history, and ask customer service questions.

Customer representatives will be able to manage train schedules, reply to customer questions, and view reservation-related information.

Managers/admins will be able to manage customer representatives and generate reports, including monthly sales, revenue by transit line or customer, and the most active transit lines.

## Tech Stack

- HTML / JSP
- Java
- JDBC
- MySQL
- Apache Tomcat
- Eclipse
- GitHub

## Project Due Dates

| Date | Deliverable |
|---|---|
| June 28 | Project groups, ER diagram, and relational schema |
| July 6 | Login/logout web application |
| July 17 | Final project |

## Current Milestone

### Part 2: Login/Logout Web Application - Due July 6

For this checkpoint, the goal is to create a simple JSP web application that can:

- Log in an already-created account
- Read a username and password from a login page
- Check the username and password against the MySQL database using JDBC
- Display whether the user was successfully logged in
- Log out a logged-in user
- Prevent logged-out users from directly accessing the success page

The login credentials are inserted directly into the database for this checkpoint.

## Part 2 Status

The Part 2 login/logout flow has been implemented and tested locally with Eclipse, Apache Tomcat, MySQL, and JDBC.

Tested flow:

1. User enters login credentials on `index.jsp`
2. `checkLoginDetails.jsp` checks the username/password against the `Customer` table
3. Valid login redirects to `success.jsp`
4. Logout redirects the user back to `index.jsp`
5. Directly accessing `success.jsp` after logout redirects back to `index.jsp`

## Test Credentials

Use the following sample account for testing:

Username: JOHN  
Password: 1234

## Database Setup

The project uses a local MySQL database named `railway_booking`.

The current schema and sample data are located in the `sql/` folder.

To create the database and insert sample users from the terminal:

mysql -u root < sql/schema.sql  
mysql -u root < sql/sample_data.sql

If your local MySQL `root` account uses a password, use:

mysql -u root -p < sql/schema.sql  
mysql -u root -p < sql/sample_data.sql

## JDBC Setup

The MySQL Connector/J driver is included in:

`src/main/webapp/WEB-INF/lib/mysql-connector-j-9.7.0.jar`

This allows the JSP pages to connect to MySQL using JDBC.

In `checkLoginDetails.jsp`, the database connection currently uses:

String url = "jdbc:mysql://localhost:3306/railway_booking";  
String dbUser = "root";  
String dbPassword = "";

If your local MySQL `root` account has a password, update `dbPassword` locally before running the project.

Do not commit real personal database passwords to GitHub.

## Part 2 Submission Requirements

One group member submits:

1. A `.zip` file of the Eclipse web application project folder
2. An exported `.sql` file from MySQL Workbench with `Include Create Schema` selected
3. The credentials of at least one test user

## Current Folder Structure

cs336-railway-booking-project/
│
├── README.md
├── .gitignore
│
├── docs/
│   └── project documents
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
            ├── success.jsp
            ├── logout.jsp
            ├── META-INF/
            └── WEB-INF/
                └── lib/
                    └── mysql-connector-j-9.7.0.jar

## Folder Purposes

### `docs/`

Project documents, including:

- ER diagram
- Relational schema
- Project requirements
- Planning notes

### `sql/`

Database-related files:

- `schema.sql` - working database schema
- `sample_data.sql` - sample/test data
- `exported_schema.sql` - exported schema from MySQL Workbench for submission

### `src/main/webapp/`

Web application files, including:

- JSP pages
- HTML forms
- Login/logout pages
- Future customer, representative, and admin pages

### `src/main/webapp/WEB-INF/lib/`

Library files required by the web application, including the MySQL JDBC connector.

## Team Workflow

- Do not push broken code directly to `main`
- Test changes locally before pushing
- Keep SQL files inside the `sql/` folder
- Keep web app files inside `src/main/webapp/`
- Keep project documentation inside the `docs/` folder
- Write clear commit messages
- Do not commit real personal database passwords

## Suggested Branches

Examples:

- `database-setup`
- `login-page`
- `logout-page`
- `jdbc-connection`
- `customer-pages`
- `rep-pages`
- `admin-pages`

## Current Next Steps

- Have group members review the current Part 2 implementation
- Export the database schema from MySQL Workbench
- Prepare the final `.zip` of the Eclipse project folder
- Submit the project ZIP, exported `.sql` file, and test credentials