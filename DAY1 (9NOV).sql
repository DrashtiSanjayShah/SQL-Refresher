-- SQL Masterclass DAY-1: 9NOV 2025
Select * FROM employees



-- List all employees from Engineering or Marketing who earn more than 60000, ordered by salary (highest first).
SELECT 
	Name as "Employee Name",
	salary,
	Department
FROM 
	employees
WHERE
	salary >60000 
	AND
	department IN ('Engineering','Marketing')
ORDER BY 
	salary DESC;





-- using subquery
SELECT 
	Name as "Employee Name",
	department,
	salary
FROM 
	employees
WHERE 
	salary > 60000
	AND department in (SELECT DISTINCT department FROM employees WHERE department IN ('Engineering', 'Marketing'))
ORDER BY 
	salary DESC;
	
	
	
--Find all employees whose names end with ‘a’ (case-insensitive).

SELECT 
	Name as "Employee Name ending with 'a'"
FROM
	employees
WHERE
	Name LIKE '%a';

--Show employees who joined before 2022.

SELECT
	name as "Employee Name",
	date as "Joining Date"
FROM
	employees
WHERE
	date < '2021-12-31'
	
	
--“employees who joined before 2022 and earn above the average salary”	

SELECT
	name as "Employee Name",
	date as "Joining Date"
FROM
	employees
WHERE
	date < '2021-12-31'
	AND salary > (
		SELECT AVG(salary)
		FROM employees)
		
		
--List employees who are not from Mumbai and earn more than 55000.

SELECT
	name as "Employee Name",
	city
FROM
	employees
WHERE
	city <> 'Mumbai' AND salary > 55000
	
	
--Display each employee’s name as Employee_Name and their annual salary as Annual_Salary (salary * 12).

SELECT
	name as "Employee Name",
	salary*12 as "Annual salary"
	
FROM
	employees

--Find the third-highest salary in the company (you can use OFFSET or subquery — whichever feels easier).
SELECT
	name as "Employee Name"
FROM
	employees
WHERE
	salary = (
	SELECT salary
	FROM employees
	ORDER BY salary DESC
	OFFSET 2
	LIMIT 1
	)
	
	
--Find employees who earn more than the average salary of their city

SELECT e.name, e.city, e.salary 
FROM employees e
WHERE e.salary > 
(SELECT AVG(salary) from employees sub WHERE sub.city = e.city
)
ORDER BY e.salary DESC

--Find the top earner from each city (using either subquery or window function)
SELECT 
	e.name, 
	e.city,	
	e.salary
FROM 
	employees e
WHERE 
	e.salary = 
		(select salary from employees sub WHERE sub.city = e.city ORDER BY salary DESC LIMIT 1)

-- 		HOMEWORK

--1. Who earns the closest salary to the average salary of the company (ABS(salary - (SELECT AVG(salary) ...)))

-- Step1: Average salary
select round(avg(salary),2) from employees 

--Step2: use that inside select statement
SELECT
	e.name as "Employee name",
	e.salary,
	ABS (e.salary - (select round(avg(salary),2) from employees sub)) as closest_to_average_salary
FROM	
	employees e
 
ORDER BY e.salary
LIMIT 1

-- why not use WHERE here?
-- The WHERE clause filters rows — it removes records that don’t meet a condition before ordering, grouping, etc.
-- So if we said:
-- WHERE salary > (SELECT AVG(salary) FROM employees)
-- —we’d only get people earning above the average, not the closest to it.


--2. List all cities where the average salary is above the overall company average.

--Step1: find city avg salary

	(SELECT e.city, round(avg(e.salary)) from employees e GROUP BY e.city)
--step2: overall company avg salary
SELECT avg(salary) from employees
-- SELECT
-- 	e.city as City,
-- 	e.salary as "City Avg Salary",
-- 	avg(salary) as "Global Avg salary"
-- FROM
-- 	employees e
-- GROUP BY
-- 	e.city
-- HAVING  	
-- 	(SELECT e.city, round(avg(e.salary)) from employees e GROUP BY e.city) > avg(salary)
-- ORDER BY 	
-- 	sub.salary;

-- the above is wrong

--correct solution
SELECT
	e.city as City,
	AVG(e.salary) as "City Avg Salary"
FROM
	employees e
GROUP BY
	e.city
HAVING  	
	(SELECT AVG(salary) from employees) < avg(e.salary)
ORDER BY 	
	"City Avg Salary" DESC;
	
--Find employees who earn more than the highest salary in the HR department.

-- step 1
-- finding highes salary in hr dept

select salary, department from employees where department = 'HR' order by salary desc limit 1

-- step 2
-- find employees earning more than hr highest salary

SELECT 
	e.name as "Employee name",
	e.department,
	e.salary
FROM
	employees as e
WHERE
	e.salary > (select MAX(sub.salary)from employees sub where department = 'HR')

	
	
