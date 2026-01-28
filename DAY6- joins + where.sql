-- DAY 6 - joins
SELECT * FROM employees
SELECT * FROM departments
-- Warm-up question (very simple):
-- Show all employee names along with their department names.
SELECT
	e.name,
	d.dept_name
FROM
	employees e
INNER JOIN
	departments d
ON e.dept_id = d.dept_id

-- 🔹 Question 2 (still easy, but important)
-- Show all employees, even if they don’t belong to any department yet.

SELECT
	e.name,
	d.dept_name
FROM
	employees e
LEFT JOIN
	departments d
ON e.dept_id = d.dept_id

-- Next micro-challenge (still beginner, but powerful)
-- Show departments and the number of employees in each department
-- (Departments with zero employees should also appear.)

SELECT 
	d.dept_name,
	COUNT(e.dept_id)
FROM
	departments d
LEFT JOIN employees e
on e.dept_id = d.dept_id
GROUP BY d.dept_name

-- LEFT JOIN + WHERE
-- 🔹 PART 1: LEFT JOIN + WHERE (the classic trap)
-- This is where 90% of people break LEFT JOINs without realizing it.
-- 🧠 Mental rule (memorize this)
-- LEFT JOIN keeps unmatched rows —
-- but a WHERE condition on the right table can silently kill them.

-- Show all departments and their employees,
-- but only include employees from Mumbai.

SELECT
	e.name,
	d.dept_name,
	e.city
FROM departments d
LEFT JOIN employees e
ON e.dept_id = d.dept_id
WHERE e.city = 'Mumbai'

-- ✅ The correct solution (this is the key learning)
-- When filtering the right table in a LEFT JOIN,
-- 👉 put the condition in the ON clause
-- ✅ Correct query
SELECT
    e.name,
    d.dept_name
FROM departments d
LEFT JOIN employees e
    ON e.dept_id = d.dept_id
   AND e.city = 'Mumbai';


-- “Show all departments and the count of employees from Mumbai in each department.”
SELECT
	d.dept_name,
	COUNT(e.emp_id) as employee_count
FROM departments d
LEFT JOIN employees e
	ON e.dept_id = d.dept_id
AND e.city = 'Mumbai'
GROUP BY d.dept_name

-- creating new table for multi-join

CREATE TABLE locations (
    city VARCHAR(50) PRIMARY KEY,
    country VARCHAR(50)
);

INSERT INTO locations (city, country) VALUES
('Mumbai', 'India'),
('Delhi', 'India'),
('Bangalore', 'India'),
('Pune', 'India'),
('Hyderabad', 'India'),
('Chennai', 'India');

SELECT * FROM locations;

-- Now the actual MULTI-JOIN challenge
-- Question (do this slowly)
-- “Show department name, city, country, and number of employees in each combination.”

SELECT
	COUNT(e.emp_id),
	d.dept_name,
	c.city,
	c.country
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id 
INNER JOIN locations c
ON  e.city = c.city
GROUP BY d.dept_name,
	c.city,
	c.country


-- Next (final join challenge for today)
-- “Show department name, country, and total salary per department per country.”


SELECT
	SUM(e.salary),
	d.dept_name,
	c.country
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id 
INNER JOIN locations c
ON  e.city = c.city
GROUP BY d.dept_name,
	c.country


