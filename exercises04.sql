--ex1
-- cartesian product --> matches each column from table1 to a column from table2

--ex2
--Make a list of all department managers with their employee number, name, salary and the
--numbers of their assigned parking spaces.
SELECT d.department_id, d.manager_id, e.last_name, e.salary, e.parking_spot
FROM departments d
JOIN employees e ON (d.manager_id = e.employee_id)
ORDER BY e.last_name;

--ex3
--Management needs a list of the projects and the employees working on those projects. The
--results table should include:
--● name of the project
--● location of the project
--● name of the employee
--● Department to which the employee is assigned

SELECT p.project_name,
       p.location,
       CONCAT_WS(' ', e.first_name, e.infix, e.last_name) AS full_name,
       e.department_id
FROM projects p
JOIN tasks t ON (p.project_id = t.project_id)
JOIN employees e ON (t.employee_id = e.employee_id)
ORDER BY e.department_id, last_name;

--ex4
--Now limit the results table of the previous query to projects localized in Eindhoven or
--managed by department Administration.
SELECT p.project_name,
       p.location,
       CONCAT_WS(' ', e.first_name, e.infix, e.last_name) AS full_name,
       e.department_id
FROM projects p
         JOIN tasks t ON (p.project_id = t.project_id)
         JOIN employees e ON (t.employee_id = e.employee_id)
         JOIN departments d ON (d.department_id = p.department_id)
WHERE LOWER(p.location) = 'eindhoven'
OR LOWER(d.department_name) = 'administration'
ORDER BY e.department_id, last_name;

--ex5
-- List employees with their children.
-- Please note the sorting!!!

SELECT CONCAT_WS(' ', e.first_name, e.infix, e.last_name) AS full_name,
       fm.name,
       fm.gender,
       TO_CHAR(fm.birth_date, 'DD-MM-YYYY') AS "Date of birth"
FROM employees e
JOIN family_members fm ON (e.employee_id = fm.employee_id)
WHERE UPPER(fm.relationship) = 'DAUGHTER' OR UPPER(fm.relationship) = 'SON'
ORDER BY e.last_name, fm.birth_date ASC

--ex6
---- Which male employees have a different residence from employee Jochems?
SELECT j.last_name AS "last name jochems",
       j.location AS "location jochems",
       e.last_name,
       e.location
FROM employees j
JOIN employees e ON (UPPER(j.location) != UPPER(e.location))
WHERE UPPER(j.last_name) = 'JOCHEMS'
  AND UPPER(e.gender) = 'M'
ORDER BY e.last_name;

--ex7
--List employees who have their birth date in the same month. Note the order of the rows.
SELECT e.employee_id,
       e.last_name,
       TO_CHAR(e.birth_date, 'YYYY-MM-DD')
FROM employees e
JOIN employees e2 ON (TO_CHAR(e.birth_date, 'MM') = TO_CHAR(e2.birth_date, 'MM'))
AND e.employee_id != e2.employee_id
ORDER BY TO_CHAR(e.birth_date, 'MM');


--ex8
--Which projects are supported by the same department as project 3? Please provide all
--project data
SELECT p.project_id,
       p.project_name,
       p.location,
       p.department_id
FROM projects p
JOIN projects p3 ON (p3.department_id = p.department_id)
WHERE p3.project_id = '3'
AND p.project_id != '3'
ORDER BY p.project_id;

--ex9
--A self join with a foreign key that points to a primary table is called recursive because you can
--apply it multiple times. Show the workers for whom Bordoloi is the boss of their boss

SELECT e.last_name AS employee,
       b.last_name AS boss,
       bb.last_name AS big_boss
FROM employees e
JOIN employees b ON (b.employee_id = e.manager_id)
JOIN employees bb ON (bb.employee_id = b.manager_id)
WHERE lower(bb.last_name) = 'bordoloi';




