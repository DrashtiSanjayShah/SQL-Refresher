-- DAY 2/3
-- Every SQL query runs in this order:
-- 1️⃣ FROM        → pick the table(s)
-- 2️⃣ WHERE       → filter individual rows
-- 3️⃣ GROUP BY    → group remaining rows
-- 4️⃣ HAVING      → filter groups
-- 5️⃣ SELECT      → choose what to display
-- 6️⃣ ORDER BY    → sort your final results

-- Use WHERE → for raw rows
-- Use HAVING → for aggregated results

-- SIMPLE QUESTIONS
-- 1. Total salary per department

SELECT
	department,
	SUM(salary)
FROM
	employees
GROUP BY
	department

-- 2: Average salary per city
SELECT
	city,
	AVG(salary)
FROM
	employees
GROUP BY
	city
ORDER BY 
	AVG(salary) DESC
	
-- 3. departments whose average salary is higher than the overall company average salary

-- Step 1: average salary per dept

SELECT
	department,
	AVG(salary)
FROM
	employees
GROUP BY
	department
	
	
-- Step 2: company average salary

SELECT 
	AVG(salary)
FROM
	employees

-- Step3: subquering step2 into step 1 using "HAVING" as its aggregate function

SELECT
	department,
	AVG(salary)
FROM
	employees
GROUP BY
	department
HAVING 
AVG(salary) > (SELECT 
	AVG(salary)
FROM
	employees)

-- 4. Find the total salary and average salary per department and city combination,
-- but only show results where the average salary is greater than 60,000.

-- Step 1: total salary per department and city

SELECT
	SUM(salary),
	city,
	department 
FROM
	employees
GROUP BY
	city, department

-- Step 2: Average and total salary per dept and city

SELECT
	city,
	department, 
	round(AVG(salary),2) as "Average_salary"
FROM
	employees
GROUP BY
	city, department

-- Step 3: average salary > 60000. Combining step 1 and 2 and using having clause for avg condition
SELECT
	city,
	department, 
	round(AVG(salary),2) as "Average_salary",
	SUM(salary) as "Total_salary"
FROM
	employees
GROUP BY
	city, department
HAVING
	AVG(salary) > 60000
	
	
-- 5. Find the department with the highest total salary in each city.
-- (So for every city, we want to know which department pays the most overall.)	

-- step 1: highest salary for each city

SELECT
	city,
	department,
	SUM(salary) as "Total_salary"
FROM
	employees
GROUP BY
	city, department
ORDER BY 
	SUM(salary) DESC
	
-- Step 2: comparing highest salary of city and getting that department 

SELECT 
    e.city,
    e.department,
    SUM(e.salary) AS total_salary
FROM employees e
GROUP BY e.city, e.department
HAVING SUM(e.salary) = (
    SELECT MAX(sub.total_salary)
    FROM (
        SELECT city, department, SUM(salary) AS total_salary
        FROM employees
        GROUP BY city, department
    ) AS sub
    WHERE sub.city = e.city
)
ORDER BY e.city;

-- 6. Find each department’s highest-paid employee along with their salary.

SELECT 
    e.name as "Employee_Name",
    e.department,
    SUM(e.salary) AS total_salary
FROM employees e
GROUP BY e.name, e.department
HAVING SUM(e.salary) = (
    SELECT MAX(sub.total_salary)
    FROM (
        SELECT name, department, SUM(salary) AS total_salary
        FROM employees
        GROUP BY name, department
    ) AS sub
    WHERE sub.department = e.department
)
ORDER BY e.department;

-- HOMEWORK

-- 1. Find all departments whose average salary is higher than the overall company average.

-- Step1: average salary per department
SELECT
	round(AVG(salary),2),
	department
FROM
	employees
GROUP BY
	department
	
	
-- Step 2: average salary of the company	
	
SELECT
	round(avg(salary),2)
FROM
	employees

-- STEP 3: combine 1 and 2
SELECT
	round(AVG(e.salary),2),
	e.department
FROM
	employees e
GROUP BY
	e.department
HAVING	
	AVG(e.salary) > (SELECT
	round(avg(e.salary),2)
		 	FROM employees)
					 
-- 2. Show each city and department with
-- total salary
-- average salary
-- only if the average > 60 000.
-- Order by average salary descending.

SELECT
	city,
	department,
	SUM(salary) as "Total Salary",
	round(AVG(salary)) as "Average Salary"
FROM
	employees
GROUP BY
	department, city
HAVING 
	AVG(salary) > 60000
ORDER BY
	AVG(salary) DESC
	
-- 3. Find the department with the highest total salary in each city.

-- Step 1: Highest salary by department 
SELECT
	MAX(salary),
	department
FROM 
	employees
GROUP BY
	department

-- FINAL (WRONG)
SELECT
	e.city,
	MAX(e.salary) as "Highest Salary",
	e.department
FROM
	employees e
WHERE
	"Highest Salary" > (SELECT sub.city, sub.salary FROM employees sub WHERE e.city = sub.city )
GROUP BY
	e.city, e.department
	
-- 	| Issue                                               | Explanation                                                                                     |
-- | --------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
-- | `MAX(e.salary)`                                     | You took the *maximum individual salary*, not the *total per department*.                       |
-- | `"Highest Salary"` alias                            | Aliases cannot be referenced in the same `WHERE` clause. SQL processes `WHERE` before `SELECT`. |
-- | Subquery returns 2 columns (`sub.city, sub.salary`) | A subquery in a comparison must return a *single value* — not multiple columns.                 |
-- | Missing aggregation for total salary                | You didn’t use `SUM(salary)` per department per city, which is essential for this question.     |

--Step2: Max salary from each city 
SELECT
	city,
	MAX(total_salary) AS max_salary
FROM (
	SELECT
		city,
		department,
		SUM(salary) AS total_salary
	FROM employees
	GROUP BY city, department
) sub
GROUP BY city;

-- Combination for 1 and 2

SELECT
	t1.city,
	t1.department,
	t1.total_salary
FROM (
	SELECT
		city,
		department,
		SUM(salary) AS total_salary
	FROM employees
	GROUP BY city, department
) t1
WHERE t1.total_salary = (
	SELECT 
		MAX(t2.total_salary)
	FROM (
		SELECT 
			city,
			department,
			SUM(salary) AS total_salary
		FROM employees
		GROUP BY city, department
	) t2
	WHERE t2.city = t1.city
);

-- What’s the difference between WHERE and HAVING? : Major difference is that you use having for aggregate functions like sum and max and avg. 
-- where is not for aggregate functions. also having is usually paired with GROUP BY caluse and you cannot use it with WHERE.

-- corrected/better explained answers Chatgpt gave
-- WHERE filters rows before grouping
-- HAVING filters after grouping

-- What’s the difference between a subquery and a JOIN?Subquery is a query inside a query. 
-- Join is to connect 2 different tables using a foreign key

-- Find the departments where the total salary is greater than the average total salary of all departments.

SELECT
	department,
	(SUM(salary))
FROM
	employees
GROUP BY
	department
	
-- 	average of total salary of all department 

SELECT AVG(dept_total)
        FROM (
            SELECT SUM(salary) AS dept_total
            FROM employees
            GROUP BY department
        ) AS sub

-- combining 1 and 2

SELECT
	e.department,
	(SUM(e.salary))
FROM
	employees e
GROUP BY
	department
HAVING SUM(e.salary)> (SELECT AVG(dept_total)
        FROM (
            SELECT SUM(salary) AS dept_total
            FROM employees
            GROUP BY department
        ) AS sub
		)
-- WHERE e.department = sub.department