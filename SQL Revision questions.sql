-- SQL Revision Sheet (Before Window Functions)
-- Total Questions: 20
-- Level
-- Questions
-- Time
-- Easy
-- 6

-- Medium
-- 8

-- Difficult
-- 6


-- Tables
-- We'll use only 2 tables throughout the revision.
-- employees
CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(30),
    salary INT,
    city VARCHAR(30),
    hire_date DATE,
    dept_id INT
);
INSERT INTO employee
(emp_id,name,department,salary,city,hire_date,dept_id)
VALUES
(1,'Aarav Singh','Sales',49000,'Delhi','2022-08-01',40),
(2,'Rahul Mehta','Engineering',85000,'Pune','2021-07-15',10),
(3,'Karan Patel','Engineering',91000,'Mumbai','2020-10-15',10),
(4,'Sneha Iyer','Marketing',61000,'Delhi','2023-01-12',20),
(5,'Aanya Shah','HR',52000,'Mumbai','2022-04-10',30),
(6,'Riya Desai','HR',58000,'Bangalore','2021-03-20',30),
(7,'Neha Kapoor','Engineering',98000,'Mumbai','2019-11-01',10),
(8,'Rohan Gupta','Finance',73000,'Pune','2022-06-18',NULL),
(9,'Priya Nair','Marketing',65000,'Mumbai','2021-08-25',20),
(10,'Kabir Joshi','Sales',51000,'Delhi','2020-12-10',40),
(11,'Meera Rao','Support',45000,'Chennai','2023-03-15',NULL),
(12,'Aditya Verma','Engineering',88000,'Pune','2022-09-20',10);

-- department
CREATE TABLE department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(30)
);
INSERT INTO department
VALUES
(10,'Engineering'),
(20,'Marketing'),
(30,'HR'),
(40,'Sales'),
(50,'Finance'),
(60,'Support');

EASY (1-6)
Q1
-- Show all employees working in Mumbai.
SELECT
	name
FROM 
	employee
WHERE 
	city = 'Mumbai'

Q2
-- Display employee name and salary in descending order.

SELECT
	name as emp_name,
	 salary
FROM 
	employee
ORDER BY salary DESC

Q3
-- Find employees earning more than ₹60,000.

SELECT
	name
FROM 
	employee
WHERE 
	salary > 60000
	
Q4
-- Show number of employees in each department.

SELECT
	COUNT(emp_id) as no_of_emp,
	department
FROM 
	employee
GROUP BY 
	department
ORDER BY COUNT(emp_id) DESC

Q5
-- Show departments having more than 2 employees.

SELECT
	COUNT(emp_id) as no_of_emp,
	department
FROM 
	employee
GROUP BY 
	department
HAVING 
	COUNT(emp_id) >2

Q6
Display departments having no employees.

SELECT
	COUNT(e.emp_id) as no_of_emp,
	d.dept_name
FROM 
	department d
LEFT JOIN
	employee e
ON 	
	e.department = d.dept_name
GROUP BY 
		d.dept_name
HAVING 
	COUNT(e.emp_id) = 0


MEDIUM (7-14)
Q7
Find employees earning more than the average salary of their department.
(Correlated Subquery)

SELECT 
	sub.name as emp_name
FROM employee sub
WHERE 
	sub.salary >
			(SELECT
				AVG(e.salary) as avg_salary				
			FROM 
				employee e
			WHERE sub.department = e.department
			)

			
Q8
Find employees earning more than the average salary of their city.


SELECT 
	sub.name as emp_name
FROM employee sub
WHERE 
	sub.salary >
			(SELECT
				AVG(e.salary) as avg_salary				
			FROM 
				employee e
			WHERE sub.city = e.city
			)

Q9
Show departments whose total salary is greater than the average department salary.
(Subquery in FROM)

SELECT 
	sub.department as department
FROM (
select
sum(salary) as total_salary,
department
from employee 
group by department) sub
WHERE
	(total_salary) > (SELECT AVG(total_salary) FROM (select
sum(salary) as total_salary,
department
from employee 
group by department) t)

Q10
Find employees who belong to departments that exist in the departments table.
(IN)

SELECT 
	e.name as emp_name
FROM 
	employee e
WHERE e.depart IN (SELECT d.dept_name
FROM department d)
	
Q11
Find employees whose department does NOT exist in the departments table.
(NOT EXISTS)

SELECT
	e.name as emp_name
FROM 
	employee e
WHERE NOT EXISTS (SELECT d.dept_id 
FROM department d
WHERE e.dept_id = d.dept_id)


Q12
Show all employees along with their department names.
(LEFT JOIN)

SELECT
	e.name as emp_name,
	d.dept_name as dept_name
FROM 
	employee e
LEFT JOIN 
	department d
ON e.dept_id = d.dept_id


Q13
Find departments with zero employees.
(LEFT JOIN + NULL)

SELECT
	d.dept_name as dept_name
FROM 
	department d
LEFT JOIN 
	employee e
ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL

Q14
Show department names and employee count including departments with zero employees.

SELECT
	d.dept_id,
	d.dept_name as dept_name,
	COUNT(e.emp_id) as emp_count
FROM 
	department d
LEFT JOIN 
	employee e
ON e.dept_id = d.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY d.dept_id ASC

DIFFICULT (15-20)
Q15
Find employees hired before the average hire date of their department.
(Correlated Subquery with Dates)

Q16
Find employees earning the highest salary in each department.
(Correlated Subquery)

Q17
Find departments where every employee earns more than ₹50,000.
(NOT EXISTS)

Q18
Show employees who earn more than the highest salary in the HR department.
(Scalar Subquery)

Q19
Find employees who work in the same city as the highest-paid employee.
(Nested Subqueries)

Q20
Find departments whose average salary is higher than the company's overall average salary.
(Subquery + GROUP BY + HAVING)
