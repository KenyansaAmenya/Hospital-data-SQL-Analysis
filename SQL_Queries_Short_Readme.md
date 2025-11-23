# SQL Queries Summary

This README provides a brief overview of the SQL queries created to
analyze and manage data in a hospital information system. The queries
cover patients, appointments, treatments, billing, payments, admissions,
and administrative operations.

## Key SQL Topics Covered

-   Basic SELECT queries
-   JOIN operations across multiple tables
-   CTEs (Common Table Expressions)
-   Aggregations and ranking
-   Conditional filtering
-   INSERT, UPDATE, DELETE commands
-   Stored procedures with input validation

## Highlights of Implemented Queries

1.  **Retrieve male patients born after 1990**\
2.  **Join appointments with patients and doctors**\
3.  **Left join to list patients with or without treatments**\
4.  **Identify treatments without a corresponding appointment**\
5.  **Doctor appointment count summary**\
6.  **Doctors with more than 20 appointments**\
7.  **Patients seen by cardiologists**\
8.  **Patients with unpaid bills**\
9.  **Bills above the system-wide average**\
10. **Most recent appointment per patient**\
11. **Rank appointments per patient (most recent → oldest)**\
12. **Daily appointment counts with running totals (Oct 2021)**\
13. **Billing statistics using temporary query structures**\
14. **Patients with outstanding balances**\
15. **Generate date range (Jan 1--15, 2021)**\
16. **Insert new patient records**\
17. **Update NULL appointment statuses to "Scheduled"**\
18. **Delete prescriptions for cancelled appointments**\
19. **Stored procedure to add a doctor**\
20. **Stored procedure with validation before inserting appointments**

## Purpose

These SQL queries support reporting, auditing, data quality, and
operational efficiency across hospital departments.
