-- ex1
-- List projects on which at least 3 employees are collaborating. Note the
-- sorting. Solve this exercise in 2 steps.
SELECT COUNT(*), project_id
FROM tasks
WHERE hours IS NOT NULL
GROUP BY project_id
HAVING COUNT(employee_id) >= 3
ORDER BY 2;

SELECT project_id, project_name
FROM projects
WHERE project_id IN (
    SELECT project_id
    FROM tasks
    WHERE hours IS NOT NULL
    GROUP BY project_id
    HAVING COUNT(employee_id) >= 3
    );

-- also find the solution with a join
SELECT t.project_id, p.project_name
FROM tasks t
JOIN projects p ON (t.project_id = p.project_id)
WHERE t.hours IS NOT NULL
GROUP BY t.project_id, p.project_name
HAVING COUNT(t.employee_id) >= 3
ORDER BY 1;

-- ex2
-- List employees working on projects localised in Eindhoven. Sort
-- descending by employee_id.
-- as a join:
SELECT DISTINCT e.employee_id, e.last_name
FROM employees e
JOIN tasks t ON (e.employee_id = t.employee_id)
JOIN projects p ON (t.project_id = p.project_id)
WHERE UPPER(p.location) = 'EINDHOVEN'
ORDER BY 1;
-- as a subquery:
SELECT DISTINCT e.employee_id, e.last_name
FROM employees e
WHERE e.employee_id IN (
    SELECT t.employee_id
    FROM tasks t
    JOIN projects p ON (t.project_id = p.project_id)
    WHERE UPPER(p.location) = 'EINDHOVEN'
    )
ORDER BY 1;

-- ex3
-- List the employees who worked more than 10 hours on the
-- ORDERMANAGEMENT project. Please provide first name and surname.

-- using only joins
SELECT e.first_name, e.last_name
FROM employees e
JOIN tasks t ON (e.employee_id = t.employee_id)
JOIN projects p ON (t.project_id = p.project_id)
WHERE UPPER(p.project_name) = 'ORDERMANAGEMENT' AND t.hours > 10
ORDER BY 1;
-- using only subqueries
SELECT first_name, last_name
FROM employees
WHERE employee_id IN (
    SELECT employee_id
    FROM tasks
    WHERE hours > 10 AND project_id IN (
        SELECT project_id
        FROM projects
        WHERE UPPER(project_name) = 'ORDERMANAGEMENT'
        )
    )
ORDER BY 1;
-- using both joins and subqueries
SELECT e.first_name, e.last_name
FROM employees e
WHERE employee_id IN (
    SELECT t.employee_id
    FROM tasks t
    JOIN projects p ON (t.project_id = p.project_id)
    WHERE UPPER(p.project_name) = 'ORDERMANAGEMENT' AND t.hours > 10
    )
ORDER BY 1;

-- ex4
-- List employees who have at least 2 children.
-- using joins:
SELECT e.employee_id, e.last_name
FROM employees e
JOIN family_members f ON(e.employee_id = f.employee_id)
GROUP BY 1,2
HAVING COUNT(UPPER(f.relationship) IN ('DAUGHTER', 'SON')) >= 2
ORDER BY 1 DESC;
-- using subqueries:
SELECT employee_id, last_name
FROM employees
WHERE employee_id IN (
    SELECT employee_id
    FROM family_members
    GROUP BY 1
    HAVING COUNT(UPPER(relationship) IN ('DAUGHTER', 'SON')) >= 2
    )
ORDER BY 1 DESC;

-- ex5
-- Which department has the highest wage bill?
SELECT d.department_id, SUM(e.salary)
FROM departments d
JOIN employees e ON (d.department_id = e.department_id)
GROUP BY 1
ORDER BY 2 DESC
FETCH FIRST ROW ONLY;

SELECT department_id, sum
FROM (
         SELECT d.department_id, SUM(e.salary) AS sum
         FROM departments d
                  JOIN employees e ON d.department_id = e.department_id
         GROUP BY d.department_id
         ORDER BY 2 DESC
     ) AS department_salary
FETCH FIRST ROW ONLY;

-- even easier:
SELECT department_id, SUM(salary)
FROM employees
GROUP BY department_id
ORDER BY 2 DESC
FETCH FIRST ROW ONLY;

-- using subqueries:
SELECT MAX(depwages.sum)
FROM (
         SELECT department_id, SUM(salary) AS sum
         FROM employees
         GROUP BY department_id
     ) AS depwages; -- this finds the highest wagebill

SELECT department_id, SUM(salary) AS sum
FROM employees
GROUP BY department_id
HAVING SUM(salary) = (
    SELECT MAX(depwages.sum)
    FROM (
             SELECT department_id, SUM(salary) AS sum
             FROM employees
             GROUP BY department_id
         ) AS depwages
    );

-- Give the number + name of that department whose total wage cost = the
-- maximum found
SELECT department_id, department_name
FROM (
         SELECT d.department_name, d.department_id, SUM(e.salary) AS sum
         FROM departments d
                  JOIN employees e ON d.department_id = e.department_id
         GROUP BY d.department_id
         ORDER BY 2 DESC
     ) AS department_salary
FETCH FIRST ROW ONLY;

SELECT department_id, department_name
FROM departments
WHERE department_id IN (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    HAVING SUM(salary) = (SELECT MAX(depwages.sum)
                          FROM (SELECT department_id, SUM(salary) AS sum
                                FROM employees
                                GROUP BY department_id) AS depwages)
    );

-- ex6
-- Which question does the select below answer?
SELECT *
FROM EMPLOYEES
WHERE employee_id NOT IN (SELECT manager_id
                        FROM EMPLOYEES);
-- Give the employee id of employees who are not managers. But there are NULL values for manager_ids.
-- What does it mean when something is NOT IN 'NULL'? NOT IN does not work anymore! How do we solve this?
-- 1) Using the COALESCE function
SELECT *
FROM EMPLOYEES
WHERE employee_id NOT IN (SELECT COALESCE(manager_id, 'empty')
                          FROM EMPLOYEES);
-- 2) Usage NOT NULL
SELECT *
FROM EMPLOYEES
WHERE employee_id NOT IN (SELECT manager_id
                          FROM EMPLOYEES
                          WHERE manager_id IS NOT NULL);
-- 3) Using OUTER JOIN:
SELECT m.employee_id
FROM employees e
RIGHT JOIN employees m ON (e.manager_id = m.employee_id)
WHERE e.manager_id IS NULL;

-- 4) Use of EXISTS --> next week


-- ex7
-- Who has as many children as employee 'BOCK'?
SELECT e.employee_id, e.last_name, COUNT(UPPER(f.relationship)) AS amount
FROM employees e
JOIN family_members f ON (e.employee_id = f.employee_id)
WHERE UPPER(e.last_name) = 'BOCK' AND UPPER(f.relationship) IN ('DAUGHTER', 'SON')
GROUP BY 1, 2; -- how many children does Bock have?

SELECT e.employee_id, e.last_name, COUNT(UPPER(f.relationship))
FROM employees e
         JOIN family_members f ON (e.employee_id = f.employee_id)
WHERE UPPER(f.relationship) IN ('DAUGHTER', 'SON') AND UPPER(e.last_name) != 'BOCK'
GROUP BY 1, 2
HAVING COUNT(UPPER(f.relationship)) = (
    SELECT COUNT(UPPER(f.relationship))
    FROM employees e
             JOIN family_members f ON (e.employee_id = f.employee_id)
    WHERE UPPER(e.last_name) = 'BOCK' AND UPPER(f.relationship) IN ('DAUGHTER', 'SON')
);

--ex8
-- The payroll department wants a view where they can see at a glance what the total payroll
-- cost is for each department. Create a view v_emp_sal_dep that provides this information.
CREATE VIEW  v_emp_sal_dep
AS
    SELECT department_id, TO_CHAR(SUM(salary), '999999.00') AS "Total salary cost per department"
    FROM employees
    GROUP BY department_id
    ORDER BY  1;

-- ex9
-- The personnel department wants an overview of staff members and their children. The view
-- v_emp_child will contain the staff member's employee_id, their first name and full surname,
-- their date of birth and the first names of their children.
CREATE VIEW  v_emp_child
AS
    SELECT e.employee_id, CONCAT_WS(' ', e.first_name, e.infix, e.last_name) AS name_emp, e.birth_date, fm.name
    FROM employees e
    JOIN family_members fm ON (e.employee_id = fm.employee_id)
    WHERE UPPER(fm.relationship) IN ('DAUGHTER', 'SON')
    ORDER BY 1, 4;

-- ex10
-- The payroll department is only interested in an employee's employee_ids, first and
-- last name and salary sorted by salary. Write the view v_emp_salary.
CREATE VIEW v_emp_salary
AS
    SELECT employee_id, first_name, last_name, salary
    FROM employees
    ORDER BY 4 DESC;

-- Payroll still finds it easier if the previous view also lists the department_id. Customise
-- the view without dropping it and creating it again.
CREATE OR REPLACE VIEW v_emp_salary
AS
    SELECT employee_id, first_name, last_name, salary, department_id
    FROM employees
    ORDER BY 4 DESC;

-- What if you want to remove department_id again? You will need to drop the table first and create it again!
DROP VIEW v_emp_salary;
CREATE OR REPLACE VIEW v_emp_salary
AS
SELECT employee_id, first_name, last_name, salary
FROM employees
ORDER BY 4 DESC;

-- ex11
-- Perform the following steps sequentially:
-- a. Create a view v_department that shows all columns of the table departments.
CREATE OR REPLACE VIEW v_department
AS
    SELECT *
    FROM departments;
-- b. Add to the table departments the column dept_telnr (9 alphanumeric).
ALTER TABLE departments
ADD COLUMN dept_telnr CHAR(9);
-- c. Select on the view created in a. What do you notice?
-- Select the view_definition field from the dictionary table.
SELECT view_definition
FROM INFORMATION_SCHEMA.views
WHERE table_name='v_department';
-- d. Adjust the view definition so that the telnr is also selected by the view. Is the phone
-- number included?
-- e. In the DEPARTMENTS table, delete the column telnr. What do you notice?
ALTER TABLE departments
DROP COLUMN IF EXISTS dept_telnr;
-- view_definition uses dept_telnr! you can't remove it!
-- How can you still achieve this?
DROP VIEW v_department;
ALTER TABLE departments
DROP COLUMN IF EXISTS dept_telnr;
-- What is the consequence of this?
-- f. Get the view back in order --> re-run exercise a!

-- ex12
-- Adjust the view v_emp_salary so that only employees from department 7 are selected. Then
-- select for verification on the view.
CREATE OR REPLACE VIEW v_emp_salary
AS
SELECT employee_id, first_name, last_name, salary, department_id
FROM employees
WHERE department_id = 7
ORDER BY 4 DESC;

-- ex13
-- Which DML instructions are possible via the view v_emp_salary on the underlying table
-- EMPLOYEES?

-- ex14
-- Carry out the following instruction:
INSERT INTO v_emp_salary
VALUES('999999999','Jan','Janssens',35000,3);
-- Check the change afterwards via the view. What do you notice and how do you solve
-- that problem?
-- it is created but because it's outside of the view window we don't see it
-- add WITH CHECK OPTION if you want to block activities outside of your window's scope
CREATE OR REPLACE VIEW v_emp_salary
AS
SELECT employee_id, first_name, last_name, salary, department_id
FROM employees
WHERE department_id = 7
ORDER BY 4 DESC
WITH CHECK OPTION;


