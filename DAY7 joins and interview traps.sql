SELECT * FROM employees
SELECT * FROM departments

ALTER TABLE employees
ADD dept_id INT,
ADD hire_date DATE;


INSERT INTO employees (emp_id, name, department, salary, city, hire_date, dept_id) VALUES
(1, 'Aarav Singh','Sales',49000, 'Delhi', '2022-08-01', NULL), 
(2, 'Rahul Mehta','Engineering',85000, 'Pune', '2021-07-15', 10),
(3, 'Karan Patel','Engineering',91000, 'Mumbai', '2020-10-15', 10),
(4, 'Sneha Iyer','Marketing',61000, 'Delhi', '2023-01-12', 20),
(5, 'Aanya Shah','HR',52000, 'Mumbai', '2022-04-10', 30),
(6, 'Riya Desai','HR',58000, 'Bangalore', '2021-03-20', 30)


SELECT * FROM employees


-- Find all employees who earn more than the average salary of their department.

SELECT
	e.name,
	e.department,
	e.salary
FROM
	employees e
GROUP BY e.name, e.department, e.salary
HAVING
	e.salary > (
		SELECT AVG(sub.salary)
		FROM employees sub
		WHERE e.department = sub.department
		GROUP BY sub.department
	)


-- Find names of employees who earn more than the average salary of their department
SELECT 
	e.name,
	e.department
FROM
	employees e
WHERE e.salary > (SELECT AVG(sub.salary)
					FROM employees sub
					WHERE e.department = sub.department
					)

-- employees with their departments in Mumbai
SELECT
	name,
	department
FROM
	employees 
WHERE city = 'Mumbai'

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

INSERT INTO departments (dept_id, dept_name) VALUES
(10, 'Engineering'),
(20, 'Marketing'),
(30, 'HR'),
(40, 'Finance');


UPDATE employees
SET dept_id = 10
WHERE department = 'Engineering';

UPDATE employees
SET dept_id = 20
WHERE department = 'Marketing';

UPDATE employees
SET dept_id = 30
WHERE department = 'HR';

UPDATE employees
SET dept_id = 40
WHERE department = 'Finance';

SELECT * FROM departments

-- find names of employees whoes average salary is greater than the average salary of their city
SELECT 
	e.name
FROM 
	employees e
WHERE e.salary > (
	SELECT AVG(sub.salary)
	FROM employees sub
	WHERE e.city = sub.city
)

-- Employees who do not belong to any 

SELECT e.name
FROM employees e
WHERE dept_id NOT IN (SELECT sub.dept_id from departments sub WHERE e.dept_id = sub.dept_id)
-- This is wrong

SELECT e.name
FROM employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM departments d
    WHERE d.dept_id = e.dept_id
);
-- this si the correct query. 
-- This worked because of NOT EXIST. this keyword makes it NULL safe. 

-- Why this works (short + clear)
-- For each employee, SQL checks:
-- “Does a department with the same dept_id exist?”
-- NOT EXISTS returns TRUE only if no matching row is found
-- It does not break with NULLs
-- It is correlated correctly (outer query → inner query)


-- WHY MY QUERY IS CORRECT AND INCORREcT AT THE SAME TIME

-- Step-by-step: what SQL actually does here
-- This is a correlated subquery.
-- The inner query depends on e.dept_id from the outer query.
-- For EACH row in employees:
-- SQL plugs in that employee’s dept_id and runs:
-- SELECT sub.dept_id
-- FROM departments sub
-- WHERE e.dept_id = sub.dept_id
-- Two possibilities:
-- ✅ Case 1: department EXISTS
-- Employee dept_id = 10
-- Inner query returns:
-- 10
-- Outer condition becomes:
-- 10 NOT IN (10)   → FALSE
-- Employee is excluded ✅
-- ✅ Case 2: department DOES NOT exist
-- Employee dept_id = 99
-- Inner query returns:
-- (empty set)
-- Outer condition becomes:
-- 99 NOT IN ()   → TRUE
-- Employee is included ✅
-- 🔑 That is why your query worked
-- Because:
-- The subquery returns either 1 value or nothing
-- No NULLs involved
-- Logical comparison stays clean
-- So yes, in this specific data setup, your query behaves correctly.
-- 🚨 But here’s the important interview truth
-- Your query works by accident, not by guarantee.
-- Why it can break:
-- If departments.dept_id contains NULL
-- If schema changes
-- If optimizer rewrites the query
-- Then this happens:
-- dept_id NOT IN (NULL)
-- Which evaluates to:
-- UNKNOWN → no rows returned 😵


-- Find all employees and their department names,
-- but show ONLY employees working in the Mumbai location.
-- Still include employees who do NOT belong to any department

SELECT
	e.names as employee_name,
	e.department as department_name
FROM employees e
LEFT JOIN departments d
	AND e.department = 'Mumbai'
	ON e.depT-id = d.dept_id

-- there are mistakes in this

SELECT
	e.name as employee_name,
	e.department as department_name
FROM employees e
LEFT JOIN departments d
	ON e.dept_id = d.dept_id
	AND e.department = 'Mumbai'

	-- and should come after on. on is a base for the join and and is the filter 