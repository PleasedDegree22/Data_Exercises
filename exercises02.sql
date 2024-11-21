-- ex1
-- Provide full details of all projects completed within the company.
SELECT *
FROM projects;

--ex2
-- For all projects, print the project name and department number of the supporting
-- department
SELECT project_name, department_id
FROM projects;

--ex3
-- a) Modify the previous SELECT so that you get the following results table:
SELECT 'project',
       project_name,
       'is handled by',
       department_id
FROM projects;

-- b) make sure the headers for the constant columns remain blank
SELECT 'project' AS " ",
       project_name,
       'is handled by' AS " ",
       department_id
FROM projects;

-- c) Make sure you print everything in 1 column and give the whole column the
-- header "projects with department".
-- || concatenates strings!
SELECT 'project' || ' ' || project_id || ' ' || 'is handled by' || ' ' || department_id
    AS "projects with departments"
FROM projects;

--ex4
--Perform the following instruction. What does the result show?
SELECT current_date - birth_date
FROM FAMILY_MEMBERS;
-- displays the difference in days

--ex5
-- a. Explain the error in each case:
SELECT employee_id,project_id,hours; --no FROM

SELECT * FROM TASK; --table is called tasks, not task

SELECT department_id, manager_id, start_date
FROM DEPARTMENTS; --start_date is not a column in our departments table

-- b
-- query should show last name, salary and department number for all employees
-- what is wrong here?
SELECT last_name, salary department_id FROM EMPLOYEES;
-- no comma between salary and department_id
--SQL displays the salary in a column called department_id

--ex6
-- a. A survey is requested of the places of residence of the company's employees.
-- This gives the result table below:
SELECT location
FROM employees;

--b note there are multiples and even a lowercase maastricht
--INITCAP() converts only the first letter to uppercase and the rest to lowercase
-- DISTINCT removes duplicates
SELECT DISTINCT INITCAP(location) location
FROM employees

--ex7
-- We want to know in which departments employees are employed and what their place
-- of residence is.
SELECT department_id, INITCAP(location)
FROM employees;

--ex8
--a. SELECT without table today's date
SELECT current_date;
--b.calculate a 15% discount on 150.
SELECT 150-(0.15*150) AS calculation;
--c. Use the separate words "Data Retrieval", " Chapter 3-4" and "SQL" to obtain the
-- following results table in one instruction. Also note the column title!
SELECT 'SQL' || ' ' || 'Data Retrieval' || ' ' || 'Chapter 3-4' AS "Best course";

--ex9
-- Which people belong to the family of employee 999111111?
SELECT employee_id employee, name "NAME FAMILY MEMBER", relationship, gender
FROM family_members
WHERE employee_id = '999111111'

--ex10
--Provide all information about the administration department?
SELECT *
FROM departments
WHERE UPPER(department_name) = 'ADMINISTRATION';

--ex11
-- We would like an overview of all employees with residence in Maastricht and use the following instruction
SELECT employee_id, last_name, location
FROM EMPLOYEES
WHERE location='Maastricht';
-- why is employee not in the results table?
-- Modify the query in an efficient way
SELECT employee_id, last_name, INITCAP(location)
FROM EMPLOYEES
WHERE UPPER(location)='MAASTRICHT';

--ex12
--Which employees worked between 20 and 35 hours (both inclusive) on project 10?
--Display the employee number, project number, and number of hours worked
SELECT employee_id, project_id, hours
FROM tasks
WHERE project_id = '10'
AND hours BETWEEN 20 AND 35;

--ex13
--On which projects did employee 999222222 work less than 10 hours? Provide project
--number and number of hours.
SELECT project_id, hours
FROM tasks
WHERE employee_id = '999222222'
AND hours < '10';

--ex14
--Which employees are from the province of Groningen (GR) or Noord Brabant (NB)? Solve
--in 2 ways!
SELECT employee_id, last_name, province
FROM employees
WHERE province = 'GR' OR province = 'NB'

SELECT employee_id, last_name, province
FROM employees
WHERE province LIKE 'NB' OR province LIKE 'GR';

--ex15
--Are there any employees with first name Suzan, Martina, Henk or Douglas and in which
--department do they work? Sort by department number (in descending order) and within
--that alphabetically by first name.

SELECT department_id, first_name
FROM employees
WHERE UPPER(first_name) IN ('SUZAN', 'MARTINA', 'HENK', 'DOUGLAS')
ORDER BY 1 DESC, 2;

--ex16
--We want to include in our results table:
--Name, department number, and salary of employees in department 7 earning less than 40000
-- + name, department number, and salary of employee 999666666

SELECT last_name, salary, department_id
FROM employees
WHERE department_id = '7' AND salary < '40000'
   OR employee_id = '999666666';

--ex17
--Which employees do not live in Maarssen and neither in Eindhoven?

SELECT last_name, department_id
FROM employees
WHERE UPPER(location) != 'MAARSSEN' AND UPPER(location) != 'EINDHOVEN';

--ex18
--Summarize the contents of the table TASKS.
--a. Sort by HOURS in ascending order.
--Ensure that rows with a NULL value for HOURS are displayed first.
SELECT *
FROM tasks
ORDER BY hours ASC NULLS FIRST;

--b. Sort by HOURS in descending order.
--Make sure that rows with a NULL value for HOURS are shown last.
SELECT *
FROM tasks
ORDER BY hours DESC NULLS LAST;

--ex19
--List the employees and their place of residence whose place of residence begins with an "m"
--or "o" and who have a salary greater than 30000€.

SELECT last_name, location, salary
FROM employees
WHERE salary > 30000
    AND UPPER(location) LIKE 'M%' OR UPPER(location) LIKE 'O%';
-- use LIKE if you want to specify a name using wildcards
--% stands for multiple characters and -stands for one arbitrary character

--ex20
--Give the names of family members born in 1988
SELECT name
FROM family_members
WHERE TO_CHAR(birth_date, 'YYYY') = '1988';

--ex21
--Provide the employees with the lowest salary
SELECT first_name, last_name, salary
FROM employees
ORDER BY salary ASC
FETCH FIRST 1 ROWS WITH TIES;

--ex22
--Provide the 3 oldest employees.
SELECT first_name, last_name, birth_date
FROM employees
ORDER BY birth_date ASC
FETCH NEXT 3 ROWS WITH TIES;

--ex23
--Provide the employee ID for the employees on the 4th, 5th and 6th place, if you sort by
--hours performed, from most to least, without taking the NULL into account

SELECT employee_id, project_id, hours
FROM tasks
WHERE hours IS NOT NULL
ORDER BY hours DESC
OFFSET 3 ROWS -- so the next row will be the 4th
FETCH NEXT 3 ROWS ONLY
