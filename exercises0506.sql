--ex1
-- error is that you can't have an aggregate function in your WHERE condition
SELECT AVG(salary)
FROM employees
WHERE salary>30000;
--second error is that you need a GROUP BY because SUM(hours) is only one square
SELECT SUM(hours)
FROM tasks
GROUP BY employee_id;

--ex2
--COUNT is only counting the rows, while SUM is adding the value of the hours

--ex3
--same as in ex2 basically

--ex4
SELECT COUNT(*) --NULL values are also counted here
FROM tasks;

SELECT COUNT(hours) --NULL values not included, only counts the rows with values, it's like ALL
FROM tasks;

--ex5
-- Give the number of projects already being worked on by employees.
SELECT COUNT(DISTINCT project_id) AS count_projects
FROM tasks;

--ex6
-- On average, how many hours employees worked on project 30?
SELECT ROUND(AVG(hours)) AS number_of_hours
FROM tasks
WHERE project_id = '30';

--ex7
-- How many employees have children?
SELECT COUNT(DISTINCT employee_id) AS employees_with_kids
FROM family_members
WHERE UPPER(relationship) IN ('SON', 'DAUGHTER');

--ex8
-- What is the highest number of hours logged on project 20?
SELECT MAX(hours) AS "highest amount hours"
FROM tasks
WHERE project_id = '20';

--ex9
-- What is the date of birth of the youngest child of employee 999111111?
SELECT MAX(birth_date) AS youngest_child
FROM family_members
WHERE employee_id = '999111111' AND UPPER(relationship) IN ('SON', 'DAUGHTER');

--ex10
-- What is the average length of employees' last names?
SELECT ROUND(AVG(char_length(last_name))) AS "Average length last name"
FROM employees;

--ex11
-- For each project, provide the number of staff working on that project.
SELECT DISTINCT project_id, COUNT(DISTINCT employee_id)
FROM tasks
GROUP BY project_id
ORDER BY 1;

--ex12
-- Find out how many employees are working on each project and calculate the
-- average from those numbers.
-- (Tip: numbers first, then averages)
--> YOU NEED TO KNOW SUBQUERIES FOR THIS

--ex13
-- For each department, provide the number of employees who are from the province
-- of Limburg (LI) .
SELECT department_id, COUNT(employee_id) AS number_employees
FROM employees
WHERE UPPER(province) = 'LI'
GROUP BY department_id;

--ex14
-- For each manager, give the number of subordinates.
SELECT m.employee_id, COUNT(e.employee_id) AS number_employees
FROM employees e
         JOIN employees m ON (e.manager_id = m.employee_id)
GROUP BY m.employee_id;

--ex15
-- How many projects does a department support per location.
SELECT department_id, location, COUNT(project_id) AS number_projects
FROM projects
WHERE department_id IS NOT NULL
GROUP BY department_id, location
ORDER BY department_id NULLS LAST;

--ex16
-- Represent how many sons and how many daughters an employee has, but only
-- the employees with more than 1 child PER gender. Solve in 1 instruction.
SELECT employee_id, relationship, COUNT(relationship)
FROM family_members
WHERE UPPER(relationship) IN ('SON', 'DAUGHTER')
GROUP BY employee_id, relationship
HAVING COUNT(UPPER(relationship) IN ('DAUGHTER')) > '1' AND COUNT(UPPER(relationship) IN ('SON')) > '1'
ORDER BY 1, 2;

--ex17
-- For each department, give the number of female employees who earn less than
-- 33000 AND have a parking space.
SELECT department_id, COUNT(employee_id)
FROM employees
WHERE UPPER(gender) = 'F' AND parking_spot IS NOT NULL AND salary < '33000'
GROUP BY department_id;

--ex18
-- For each employee, provide the number of PROJECTS he/she is working on. Note the
-- results table to be obtained.
SELECT e.first_name, e.last_name, COUNT(t.project_id) AS "number of projects"
FROM tasks t
         JOIN employees e ON (t.employee_id = e.employee_id)
GROUP BY e.first_name, e.last_name
ORDER BY 1;

--ex19
-- List the employees with grandchildren, including the number of grandchildren.
-- Notice the output.
SELECT CONCAT_WS(' ', e.first_name, e.infix, e.last_name) AS employee_name,
       COUNT(fm.relationship) AS number_grandchildren
FROM family_members fm
         JOIN employees e ON (fm.employee_id = e.employee_id)
WHERE UPPER(fm.relationship) = 'GRANDCHILD'
GROUP BY 1
ORDER BY 1;

--ex20
-- honestly idk i'd think the first

--ex21
-- List all employees between 30 and 35 years old with the projects they are working
-- on.
SELECT e.last_name, e.first_name, age(e.birth_date), t.project_id
FROM employees e
LEFT JOIN tasks t ON (e.employee_id = t.employee_id)
WHERE date_part('years', age(e.birth_date)) BETWEEN 30 AND 35
ORDER BY e.last_name;

--ex22
-- List the employees who did not participate in any project. We want to have in the
-- results table the first and last names of those employees.
SELECT e.last_name, e.first_name
FROM employees e
LEFT JOIN tasks t ON (e.employee_id = t.employee_id)
GROUP BY e.last_name, e.first_name
HAVING COUNT(project_id) = 0
ORDER BY 1 DESC;

--ex23
-- For each employees between 30 and 35 years old, provide the number of projects
-- on which he/she participated.
-- Make sure to also list the ZERO projects in your results table!
SELECT e.last_name, e.first_name, COUNT(t.project_id) AS "number of projects"
FROM employees e
LEFT JOIN tasks t ON (e.employee_id = t.employee_id)
WHERE date_part('years', age(e.birth_date)) BETWEEN 30 AND 35
GROUP BY e.last_name, e.first_name
ORDER BY 1, 2;

--ex24
-- List all departments and the projects they support (if any).
-- In the results table will be: department name, project name and project location
SELECT d.department_name, p.project_name, p.location
FROM departments d
LEFT JOIN projects p ON (d.department_id = p.department_id);

--ex25
-- a. List all employees whose last name starts with the letter G or J and the name of the
-- department in which they work. Also give the names of their family members.
SELECT e.employee_id, e.last_name, d.department_name, fm.name AS family_member
FROM employees e
LEFT JOIN departments d ON (e.department_id = d.department_id)
LEFT JOIN family_members fm ON (e.employee_id = fm.employee_id)
WHERE UPPER(e.last_name) LIKE 'G%' OR UPPER(e.last_name) LIKE 'J%'
ORDER BY 2;

-- b. Suppose each employee is always assigned a department.
-- (assume for a moment that there is a NOT NULL constraint on department_id from
-- employees).
-- How then can we modify previous solution?
SELECT e.employee_id, e.last_name, d.department_name, fm.name AS family_member
FROM employees e
JOIN departments d ON (e.department_id = d.department_id)
LEFT JOIN family_members fm ON (e.employee_id = fm.employee_id)
WHERE UPPER(e.last_name) LIKE 'G%' OR UPPER(e.last_name) LIKE 'J%'
ORDER BY 2;

--ex26
-- List all employees, whose first name starts with a B, D, G, L or M, with the projects
-- they are working on.
-- We want in the results table last name, first name, project name and the number of
-- hours that employee worked on that project. Note the sorting.
SELECT e.last_name, e.first_name, p.project_name, t.hours
FROM employees e
LEFT JOIN tasks t ON (e.employee_id = t.employee_id)
LEFT JOIN projects p ON (t.project_id = p.project_id)
WHERE SUBSTRING(UPPER(e.first_name) FOR 1) IN ('B', 'D', 'G', 'L', 'M')
ORDER BY 3, 2;

--ex27
-- Give all employees who are not managers of another employee.
SELECT e.employee_id, e.last_name
FROM employees e
RIGHT JOIN employees m ON (e.manager_id = m.employee_id)
WHERE e.manager_id IS NULL
ORDER BY 1;

--ex28
-- Give all employees who are not managers of another employee or who do not have
-- a manager.
SELECT e.last_name AS "has no manager" , m.last_name AS "does not manage employees"
FROM employees e
FULL JOIN employees m ON (e.manager_id = m.employee_id)
WHERE e.manager_id IS NULL OR m.employee_id IS NULL
ORDER BY 2, 1;