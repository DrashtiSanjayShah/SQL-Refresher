-- SUBQUERIES + JOINS

-- 🌱 Warm-up Question (Very Small Win)
-- Question:
-- List all departments and their total salary,
-- but only include departments whose total salary is greater than 100,000.
-- Order the result by total salary (highest first).


SELECT
	department,
	SUM(salary) as total_salary 
FROM
	employees
GROUP BY
	department
HAVING 
	SUM(salary) > 100000
ORDER BY total_salary DESC


-- 🌱 Warm-up #2 (still safe, slightly deeper)
-- Question:
-- Find each city and the average salary in that city,
-- but only show cities where the average salary is higher than the company’s overall average salary.
-- Order by city average salary (highest first).

SELECT
	city,
	AVG(salary)
FROM
	employees
GROUP BY 
	city
HAVING 
	AVG(salary) > (SELECT AVG(salary) FROM employees)
ORDER BY 
	AVG(salary) DESC



-- 🌱 Warm-up #3 (Confidence Builder)
-- Question:
-- Find all departments whose maximum salary is less than the overall average salary of the company.
-- Show:
-- department
-- maximum salary

SELECT
	department,
	MAX(salary)
FROM 
	employees
GROUP BY
	department
HAVING
	MAX(salary) < (SELECT AVG(salary) FROM employees)


----------------------------JOINS----------------------------

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

INSERT INTO departments (dept_id, dept_name) VALUES
(10, 'Engineering'),
(20, 'Marketing'),
(30, 'HR'),
(40, 'Finance');

ALTER TABLE employees
ADD COLUMN dept_id INT;

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

SELECT * FROM employees
SELECT * FROM departments

-- Tiny practice (you do this)
-- Question:
-- Using the same tables, write a query to show:
-- employee name
-- department id
-- department name

SELECT
	e.name,
	d.dept_id,
	d.dept_name
FROM 
	employees e
JOIN departments d
ON e.dept_id = d.dept_id

-- 🔹 What LEFT JOIN means (plain English)
-- LEFT JOIN =
-- “Give me ALL rows from the left table, and matching rows from the right table.
-- If there’s no match, still show the left row — put NULL for the right side.”


SELECT
    e.name,
    e.dept_id,
    d.dept_name
FROM employees e
LEFT JOIN departments d
    ON e.dept_id = d.dept_id
WHERE d.dept_name IS NULL;


SELECT
    *
FROM employees
WHERE dept_id IS NULL;

---INNER JOIN ---
SELECT
    e.name,
    e.dept_id,
    d.dept_name
FROM employees e
INNER JOIN departments d
    ON e.dept_id = d.dept_id


--display empployee name and department name sorted by department name 
SELECT
	e.name,
	d.dept_name
FROM
	employees e
INNER JOIN departments d
	ON e.dept_id = d.dept_id
ORDER BY d.dept_name

-- 🧩 JOIN Challenge 1 (Very Beginner–Friendly)
-- 📌 Question
-- Show the employee name and department name
-- ONLY for employees who work in the HR department

SELECT
	e.name,
	d.dept_name
FROM
	employees e
INNER JOIN departments d
	ON e.dept_id = d.dept_id
WHERE d.dept_name = 'HR'

--show all employee name and department names including employees who do not belong to any department 

SELECT
	e.name,
	d.dept_name
FROM
	employees e
LEFT JOIN departments d
	ON e.dept_id = d.dept_id



-- Show department names and how many employees are in each department.
SELECT
	 d.dept_name,
	COUNT(e.emp_id)
FROM
	employees e
LEFT JOIN departments d
ON 	
	e.dept_id = d.dept_id
GROUP BY d.dept_name

-- this query is incorrect as it talks about the employees and their correspondin departments while we needed to find the count of employees per DEPARTMENT. 

SELECT
	COUNT(e.name),
	d.dept_name
FROM departments d
LEFT JOIN employees e
	ON e.dept_id = d.dept_id
GROUP BY d.dept_name

	
-- show only departments with more than 1 employee
SELECT
	d.dept_name,
	COUNT(e.name) as employee_count
FROM employees e
INNER JOIN departments d
	ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING COUNT(e.name) > 1

-- 🔥 Next Join Challenge (Level up)
-- 👉 Show employee name, department name, and city — only for employees whose department is NOT NULL
SELECT
	e.name,
	d.dept_name,
	e.city
FROM 
	employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id
-- WHERE d.dept_id IS NOT NULL thsis line is optional or not needed because we are using inner join 

-- 🚀 Ready for next challenge?
-- 👉 Using LEFT JOIN, show all employees — even those without a department — and display NULL for missing department names

SELECT
	e.name,
	d.dept_name
FROM
	employees e
LEFT JOIN departments d
ON e.dept_id = d.dept_id

-- 🚀 Next challenge (slightly trickier)
-- Show department names even if they have zero employees.


SELECT
	e.name,
	d.dept_name
FROM
	departments d
LEFT JOIN employees e
ON e.dept_id = d.dept_id
