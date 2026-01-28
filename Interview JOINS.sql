SELECT * FROM employees
SELECT * FROM departments
SELECT * FROM locations

-- Next Challenge — LEFT JOIN + WHERE (the tricky version)
-- Question
-- Show all departments and the number of employees located in Mumbai,
-- including departments that have zero Mumbai employees
SELECT 
	count(e.name),
	d.dept_name
FROM employees e
LEFT JOIN departments d
ON e.dept_id = d.dept_id
AND city = 'Mumbai'
GROUP BY d.dept_name


-- Multi-join challenge (still beginner-safe):
-- Show department name, city, and total salary
-- using employees, departments, and locations.


SELECT
	d.dept_name,
	l.city,
	SUM(e.salary)
FROM 
	employees e
LEFT JOIN departments d
ON e.dept_id= d.dept_id
LEFT JOIN locations l
ON e.city = l.city
GROUP BY 
	d.dept_name,
	l.city


-- 🔜 Next challenge (still safe, slightly harder)
-- Show department name and country
-- with total salary,
-- but only for departments that have employees.

SELECT
	d.dept_name,
	l.city,
	SUM(e.salary)
FROM 
	employees e
INNER JOIN departments d
ON e.dept_id= d.dept_id
LEFT JOIN locations l
ON e.city = l.city
GROUP BY 
	d.dept_name,
	l.city

-- Final concept before window functions)
-- Find departments that have no employees
-- (classic LEFT JOIN + NULL check

SELECT
	d.dept_name, 
	COUNT(e.dept_id)
FROM departments d
LEFT JOIN employees e
ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING COUNT(e.dept_id) = 0 

-- “Find employees who are not assigned to any department.”

SELECT
	e.name,
	d.dept_name
FROM employees e
LEFT JOIN departments d
ON e.dept_id = d.dept_id
AND d.dept_name is NULL

-- “Find departments where total salary > 200,000.”

SELECT
	d.dept_name, 
	SUM(e.salary)
FROM departments d
JOIN employees e
ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING SUM(e.salary) > 200000

-- “Show all departments and total salary paid (even if zero).”

SELECT
	d.dept_name, 
	SUM(e.salary)
FROM departments d
LEFT JOIN employees e
ON e.dept_id = d.dept_id
GROUP BY d.dept_name

-- “Find all departments where the average employee salary is greater than the company-wide average salary.”

SELECT 
	department,
	AVG(salary) as average_salary_dept
FROM employees e
GROUP BY department
HAVING AVG(salary) > (SELECT AVG(salary) FROM employees)

-- Find all departments that have no employees.

SELECT
	d.dept_name,
	COUNT(e.name)
FROM departments d
LEFT JOIN employees e
ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING COUNT(e.name) = 0 


-- Interview Trap #2 (harder)
-- Write a query to list all departments, along with employees from Mumbai only,
-- but still show departments that have no Mumbai employees.


-- SELECT
-- 	d.dept_name,
-- 	e.name
-- FROM departments d
-- LEFT JOIN employees e
-- ON e.dept_id = d.dept_id
-- AND d.dept_name = 'Mumbai'

-- This is wromg because i compared department name with city "Mumbai"



SELECT
	d.dept_name,
	e.name,
	l.city
FROM departments d
LEFT JOIN employees e
ON e.dept_id = d.dept_id
LEFT JOIN locations l
ON e.city = l.city
AND l.city = 'Mumbai'
-- the above solution is 99.9% correct. The only prblem is that in the last line i have used l.city which goes to the locations table and 
-- not the employees table. in the question we have a constraint on the employees. so, the correct response would be 

SELECT
	d.dept_name,
	e.name,
	l.city
FROM departments d
LEFT JOIN employees e
ON e.dept_id = d.dept_id
LEFT JOIN locations l
ON e.city = l.city
AND e.city = 'Mumbai'

-- List all departments that have no employees assigned.
-- Tables:
-- departments(dept_id, dept_name)
-- employees(emp_id, name, dept_id)

SELECT
	COUNT(e.name),
	d.dept_name
FROM departments d
LEFT JOIN employees e
ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING COUNT(e.name) = 0

-- 🎯 Trap 1 (very common)
-- Find the number of employees per department,
-- including departments with zero employees.

SELECT
	COUNT(e.name),
	d.dept_name
FROM departments d
LEFT JOIN employees e
ON e.dept_id = d.dept_id
GROUP BY d.dept_name

-- this is mostly correct but just one thing to remeber is as name is not the primary key, it can be null. making the count clause fail using the primary key 
-- lik eemp_id would be a better option

-- Interview follow-up (they WILL ask this)
-- “What happens if you use COUNT(*) here?”
-- Answer:
-- COUNT(*) 
-- 🚫 WRONG for this question
-- Because it counts the department row even when no employees exist → returns 1 instead of 0.


-- Next trap (harder 👀)
-- Find departments where the employee count is greater than the company’s average employee count per department.

-- SELECT
-- 	COUNT(e.emp_id) as count_emp,
-- 	d.dept_name
-- FROM departments d
-- LEFT JOIN employees e
-- ON e.dept_id = d.dept_id
-- GROUP BY d.dept_name
-- HAVING COUNT(e.emp_id) > (SELECT
-- 	AVG(e.emp_id)
-- FROM (SELECT COUNT(e.emp_id), e.department FROM employees e GROUP BY e.department) sub
-- GROUP BY sub.department)

-- This solution is incorrect. you need to get the count first, then its average and then compare/

SELECT
	COUNT(e.emp_id) as count_emp,
	d.dept_name
FROM departments d
LEFT JOIN employees e
ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING COUNT(e.emp_id) > (SELECT
	AVG(avg_no)
FROM (SELECT COUNT(e.emp_id) as avg_no, e.department FROM employees e GROUP BY e.department) sub)

-- even this solution has inconsistencies. the alias needs to be better. avg_no is not correct as we are taking the count and not the average of the employees
-- the group by is d.dept_name and e.department which is refrencing 2 different tables. better is to use the dept_id 

SELECT
    d.dept_name,
    COUNT(e.emp_id) AS emp_count
FROM departments d
LEFT JOIN employees e
ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING COUNT(e.emp_id) > (
    SELECT AVG(emp_count)
    FROM (
        SELECT
            dept_id,
            COUNT(emp_id) AS emp_count
        FROM employees
        GROUP BY dept_id
    ) sub
);
