-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS mysql_db;
USE mysql_db;

CREATE TABLE monthly_revenue (
    month_start DATE PRIMARY KEY,
    revenue DECIMAL(10, 2) NOT NULL
);

INSERT INTO monthly_revenue (month_start, revenue) VALUES
('2024-01-01', 10000.00),
('2024-02-01', 12000.50),
('2024-03-01', 11000.75),
('2024-04-01', 13000.00),
('2024-05-01', 13500.00),
('2024-06-01', 12500.00);

/*
INSERT INTO monthly_revenue (month_start, revenue) VALUES ('2024-07-01', 14000.00);

INSERT INTO monthly_revenue (month_start, revenue) VALUES ('2024-08-01', 14500.00);

INSERT INTO monthly_revenue (month_start, revenue) VALUES ('2024-09-01', 15000.00);
*/