-- DAY 4 - subqueries


SELECT * FROM employees
-- 1. Find all employees who earn more than the highest salary in the HR department.

SELECT
	name as "Employee Name",
	salary
FROM 
	employees
WHERE
	salary > (SELECT MAX(salary) FROM employees WHERE department = 'HR')
	
	
	
-- 2. Write only the subquery:
-- “Get total salary for each department” inside the FROM block.
	
SELECT *
FROM (SELECT department, SUM(salary) as "Total salary" FROM employees GROUP BY department) sub

-- 2.5 Using your temporary table,
-- find the department with the highest total salary.

SELECT *
FROM (SELECT department, SUM(salary) as "Total salary" FROM employees GROUP BY department) sub
ORDER BY 
	"Total salary" DESC
LIMIT 1

--  3 (FROM-subquery practice)
-- Find the average of the department-wise total salaries.
-- Meaning:
-- First find total salary per department.
-- Then calculate the overall average of those totals.

-- Step 1: total salary department wise

SELECT
	department,
	SUM(salary) as total_salary
FROM 
	employees
GROUP BY
	department

-- Step 2: average of all the total salary from departemnt i.e. total of departemnts combined ka average

SELECT
	round(AVG(total_salary),2) as total_average_salary
FROM 
	(SELECT
	department,
	SUM(salary) as total_salary
FROM 
	employees
GROUP BY
	department)	sub

-- PRACTICE QUESTIONS TO MAKE SUBQUERIES INSIDE FROM STRONG


-- Question 1 (Easy–Medium)
-- Find the average of the maximum salary from each department.

-- Step 1: find max salary of each department

SELECT
	MAX(salary),
	department
FROM
	employees
GROUP BY
	department


-- step 2: average of the max salary
	
SELECT
	round(AVG(Max_salary_per_dept),2) as "Average of max salaries/department"
FROM (SELECT
	MAX(salary) as Max_salary_per_dept,
	department
FROM
	employees
GROUP BY
	department)	AS sub
	
-- 2. ✅ Question 2 (Medium)
-- Find the highest total salary among all city–department combinations.
	
-- step 1: highest salary group by city and department

SELECT
	city,
	department,
	MAX(salary) as max_salary
FROM
	employees
GROUP BY 
	city, department
	
-- Step 2: Find highest amongst the above combination

SELECT 
department,
city,
	MAX(max_salary) AS "Highest salary overall"
FROM
	(SELECT
	city,
	department,
	MAX(salary) as max_salary
FROM
	employees
GROUP BY 
	city, department) AS sub
GROUP BY 
	city, department
ORDER BY
	max_salary DESC
LIMIT 1
	
-- QUESTION 3
-- For each department, compute the difference between:
-- its total salary
-- and the average total salary across all departments


-- Step 1: total salary per dept

SELECT
	department,
	SUM(salary) as total_salary_per_dept
FROM
	employees
GROUP BY
	department
	
-- Step 2: average total salary across all depts which is the average salary?

SELECT
	AVG((salary)),
	department
FROM 
	employees
GROUP BY
	department
	
-- Step 3: combining all and finding difference

SELECT
	department,
	SUM(salary) as total_salary_per_dept
	
FROM
	employees
WHERE 
	diff_salary = (total_salary_per_dept - (SELECT
	AVG((salary)),
	department
FROM 
	employees
GROUP BY
	department)) AS sub
GROUP BY
	department
	
-- STEP 2 and 3 is incorrect
-- ❌ Your Step 2 — You calculated avg salary, not avg total_salary_per_dept
-- We need:
-- 📌 First compute total salary per department
-- 📌 THEN compute average of these totals

-- Step 2:
SELECT
	AVG(total_salary_per_dept) as avg_total_salary
FROM 
	(SELECT
	department,
	SUM(salary) as total_salary_per_dept
FROM
	employees
GROUP BY
	department) AS sub
	
-- ❌ Your Step 3 — Completely broken
-- You referenced alias inside WHERE
-- You used GROUP BY incorrectly
-- You attempted subquery in WHERE but also tried to compute difference inside WHERE (not allowed)

SELECT
	d.department,
	d.total_salary_per_dept,
	d.total_salary_per_dept - (SELECT
	AVG(total_salary_per_dept) as avg_total_salary
FROM 
	(SELECT
	department,
	SUM(salary) as total_salary_per_dept
FROM
	employees
GROUP BY
	department) AS sub) as difference
FROM
	(SELECT
	department,
	SUM(salary) as total_salary_per_dept
FROM
	employees
GROUP BY
	department) AS d
	

-- ⭐ Correlated Subquery — Question 1 (Easy Warm-up)
-- Find all employees whose salary is higher than the average salary of their own department.

SELECT
	round(AVG(salary),2),
	department
FROM
	employees
GROUP BY
	department
	
	
SELECT
	e.name,
	e.department,
	e.salary
FROM
	employees e
WHERE
	e.salary > (SELECT
	round(AVG(salary),2)
FROM
	employees sub
where
	e.department = sub.department)
	
-- Find employees whose salary is higher than the average salary of their city.

SELECT 
	round(AVG(salary),2),
	city
FROM
	employees sub
GROUP BY
	city


SELECT
	e.name,
	e.city,
	e.salary
FROM
	employees e
WHERE 
	e.salary > (SELECT 
	round(AVG(salary),2)
FROM
	employees sub
WHERE 
	e.city = sub.city)

-- ❓Question 3 (Medium–Hard):
-- Find employees who earn more than the average salary of their department AND their city

SELECT
	e.name,
	e.city,
	e.salary,
	e.department
FROM
	employees e
WHERE 
	e.salary > (SELECT 
	round(AVG(salary),2)
FROM
	employees sub
WHERE 
	 e.city = sub.city AND e.department = sub.department)
	 


-- Find employees whose salary is the highest within their department, but not the highest in their city.
-- So you need to check two conditions:
-- 1️⃣ Their salary = max salary of their department
-- 2️⃣ Their salary < max salary of their city


SELECT
	department,
	MAX(salary)
FROM
	employees
GROUP BY
	department

SELECT
	e.name,
	e.city,
	e.department,
	e.salary
FROM
	employees e
WHERE
	e.salary = (SELECT
	MAX(salary)
FROM
	employees sub
WHERE
	e.department = sub.department) AND e.salary < (SELECT MAX(salary) from employees d WHERE e.city = d.city)
