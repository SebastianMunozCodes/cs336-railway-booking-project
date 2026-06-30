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

### Part 2: Login Page - Due July 6

For this checkpoint, the goal is to create a simple JSP web application that can:

- Log in an already-created account
- Read a username and password from a login page
- Check the username and password against the MySQL database
- Display whether the user was successfully logged in
- Log out a logged-in user

The login credentials can be inserted directly into the database for this checkpoint.

## Part 2 Submission Requirements

One group member submits:

1. A `.zip` file of the Eclipse web application project folder
2. An exported `.sql` file from MySQL Workbench with `Include Create Schema` selected
3. The credentials of at least one test user

## Current Folder Structure

```text
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
└── webapp/
    └── JSP/HTML files for the web application
```

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

### `webapp/`

Web application files, including:

- JSP pages
- HTML forms
- Login/logout pages
- Future customer, representative, and admin pages

## Team Workflow

- Do not push broken code directly to `main`
- Create a separate branch for each feature
- Test changes locally before merging
- Keep SQL files inside the `sql/` folder
- Keep web app files inside the `webapp/` folder
- Keep project documentation inside the `docs/` folder
- Write clear commit messages

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

- Confirm everyone has installed the required project tools
- Set up the local MySQL database
- Create/import the database schema
- Insert at least one test user
- Create the login page
- Connect the login page to the database using JDBC
- Add logout functionality
- Prepare the final `.zip` and exported `.sql` file for submission