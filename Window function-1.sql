-- window functions
SELECT * FROM employees
-- GROUP BY = class average → one result
-- Window function = show each student + class average → keeps all rows

-- function_name() OVER (
--     PARTITION BY column
--     ORDER BY column
-- )
-- Let’s break this:
-- ✅ OVER() → This makes it a window function
-- Without it, it's just a normal function.

-- In the employees table (with employee_id, name, department, salary), 
-- write a query to rank each employee’s salary within their department 
-- using a window function.

SELECT
	name,
	department,
	salary, 
	RANK() OVER (PARTITION BY department ORDER BY salary DESC)
FROM employees

-- For the employees table, compute a running total of each employee’s salary 
-- ordered by employee_id, and show each employee’s cumulative salary.


SELECT
	name,
	(salary) as emp_salary, 
	SUM(salary) OVER (ORDER BY emp_id)
FROM employees

-- For each department, show each employee’s salary and the difference between 
that employee’s salary and the department average salary.

SELECT
	department,
	(salary) as emp_salary, 
	salary - AVG(salary) OVER (PARTITION BY department) as diff_from_avgsalary
FROM employees