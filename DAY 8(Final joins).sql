-- FINAL JOINS PRACTICE QUESTIONS
SELECT * FROM employees 
SELECT * FROM departments
-- List all employees and their department names.
-- 👉 Even if an employee does not belong to any department, they must still appear in the result.

SELECT
	e.name as employee_name,
	d.dept_name as department_name
FROM employees e
LEFT JOIN departments d
ON e.dept_id = d.dept_id

-- List all employees and their department names, but show ONLY employees who belong to the Mumbai department.

SELECT
	e.name as employee_name,
	d.dept_name as department_name
FROM employees e
LEFT JOIN departments d
ON e.dept_id = d.dept_id
AND e.city = 'Mumbai'
-- we want only mumbai employees. so, "AND" is incorrect. it shoudl be "WHERE"

SELECT
	e.name as employee_name,
	d.dept_name as department_name
FROM employees e
LEFT JOIN departments d
ON e.dept_id = d.dept_id
WHERE e.city = 'Mumbai'

-- Write a SQL query to:
-- 👉 Display all departments and the number of employees in each department
-- 👉 Include departments that have zero employees

SELECT
	d.dept_name as department_name,
	COUNT(e.emp_id) as employee_count
FROM departments d
LEFT JOIN employees e
ON e.dept_id = d.dept_id
GROUP BY d.dept_name

-- Find all departments that have no employees.

SELECT
	d.dept_name as department_name
FROM departments d
LEFT JOIN employees e
ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING COUNT(e.emp_id) = 0

Drashti Shah:
	-- FINAL JOINS PRACTICE QUESTIONS
SELECT * FROM employees 
SELECT * FROM departments
-- List all employees and their department names.
-- 👉 Even if an employee does not belong to any department, they must still appear in the result.

SELECT
	e.name as employee_name,
	d.dept_name as department_name
FROM employees e
LEFT JOIN departments d
ON e.dept_id = d.dept_id

-- List all employees and their department names, but show ONLY employees who belong to the Mumbai department.

SELECT
	e.name as employee_name,
	d.dept_name as department_name
FROM employees e
LEFT JOIN departments d
ON e.dept_id = d.dept_id
AND e.city = 'Mumbai'
-- we want only mumbai employees. so, "AND" is incorrect. it shoudl be "WHERE"

SELECT
	e.name as employee_name,
	d.dept_name as department_name
FROM employees e
LEFT JOIN departments d
ON e.dept_id = d.dept_id
WHERE e.city = 'Mumbai'

-- Write a SQL query to:
-- 👉 Display all departments and the number of employees in each department
-- 👉 Include departments that have zero employees

SELECT
	d.dept_name as department_name,
	COUNT(e.emp_id) as employee_count
FROM departments d
LEFT JOIN employees e
ON e.dept_id = d.dept_id
GROUP BY d.dept_name

-- Find all departments that have no employees.

SELECT
	d.dept_name as department_name
FROM departments d
LEFT JOIN employees e
ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING COUNT(e.emp_id) = 0

-- Find all employees whose departments dont exist in departments table

SELECT
	e.name as employee_name
FROM employees e
WHERE (SELECT d.dept_id FROM departments d on e.dept_id = d.dept_id) NOT IN d.dept_id

-- Find departments whose total salary is greater than the average of total salaries across all departments.

SELECT
    e.total_salary, 
	e.department
FROM (SELECT SUM(d.salary) as total_salary, d.department from employees d group by d.department) e
WHERE total_salary > (SELECT AVG(total_salary) FROM (SELECT SUM(d.salary) as total_salary, d.department from employees d group by d.department) x) 


-- employees who earn more than the average salary of their city

SELECT
	e.name as emp_name
FROM employees e
GROUP BY e.city, e.name, e.salary
HAVING 	
	e.salary > (SELECT AVG(d.salary) as avg_salary FROM employees d WHERE e.city = d.city)

-- Use:
-- FROM subquery → when you need a table
-- WHERE subquery → when you need a value per row