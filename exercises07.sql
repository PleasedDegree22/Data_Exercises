--DML EXERCISES WEEK 7--
------------------------

-- ex1
--1a --> primary key employee_id contains unique values, the value you want to insert already exists
--1b --> parking spot is a unique key, parking_spot 1 is already assigned to someone elese!
--1c --> you need both a first name and a last name! also there is a check constraint on salary it has to be less than 85000
--1d --> violating the foreign key constraint! You have employees working in department 3
--1e --> you are setting it to a department that doesn't exist (department_id 15)

-- ex2
-- Write the necessary DML instructions to adapt the database to the new situation below.
-- A new department (department_id =15) 'Human Resources' is established in Antwerp.
INSERT INTO departments (department_name, department_id)
VALUES ('Human Resources', 15);

INSERT INTO locations
VALUES (15, 'Antwerp');

-- A new employee is recruited. His name is Jan Janssens; he has employee_id number 999999999 and
-- is assigned to the new department and also becomes head of that department. It is not yet known
-- exactly when Janssens will take up his manager position in the new department.
INSERT INTO employees (employee_id, last_name, first_name, department_id)
VALUES ('999999999', 'Jan', 'Janssens', 15);

UPDATE departments
SET manager_id = '999999999'
WHERE department_id = 15;

-- A new project will be set up with project_id 40 and name 'Training'. The project will be carried out in
-- Antwerp and will be supported by the new department.
INSERT INTO projects
VALUES (40, 'Training', 'Antwerp', 15);

-- In the department, 2 employees will be employed for the time being, namely Joosten (sofi_nr
-- 999333333) and Bock (sofi_nr 999111111). Joosten will get Janssens as his direct boss, Bock will get
-- Joosten as his direct boss.
UPDATE employees
SET manager_id = '999999999'
WHERE employee_id = '999333333';

UPDATE employees
SET manager_id = '999333333'
WHERE employee_id = '999111111';

-- Joosten already performed 20 h on the new project, Bock 10 h.
INSERT INTO tasks
VALUES ('999333333', 40, 20), ('999111111', 40, 10);

-- ex3
-- In the departments table, the attribute department_name must be widened to 25 character
-- positions
ALTER TABLE IF EXISTS departments
    ALTER COLUMN department_name
    SET DATA TYPE VARCHAR(25);

-- ex4
-- In the projects table, enforce that the project name is entered in uppercase.
-- If the data is not correct, adjust it AFTER adding the constraint.
-- Make sure that the constraint is validated.
ALTER TABLE projects
    ADD CONSTRAINT ch_projects_project_name
    CHECK (project_name = UPPER(project_name)) NOT VALID; --sets constraint for data from now on is added to table

UPDATE projects
SET project_name = UPPER(project_name); -- we need to update the existing data in the table bc the constraint doesn't apply yet

ALTER TABLE projects
VALIDATE CONSTRAINT ch_projects_project_name; -- validate the constraint --> checks if all date in the table adheres to the new constraint

-- ex5
-- In the employees table, the attribute email must be added (20 characters). --> you are not creating, you are changing the definition of a table
-- The attribute is mandatory. Make sure the field is filled with the string 'unknown' for the existing
-- rows.
-- Bonus points if you can solve this in 1 statement!
ALTER TABLE employees
ADD COLUMN email VARCHAR(20)
    NOT NULL
    DEFAULT 'unknown';

-- ex6
-- In the departments table, the NOT NULL constraint on the department name must be removed
ALTER TABLE departments
ALTER COLUMN department_name DROP NOT NULL;

-- ex7
-- In the employees table, the attribute email must be removed again.
ALTER TABLE employees
DROP COLUMN IF EXISTS email;

-- ex8
-- In the projects table, remove the check constraint on project name.
-- TIP: If you don't know the name, you can also look up the check constraint.
select * from pg_constraint where contype = 'c';
-- --(c = check, f = foreign, u = unique)
ALTER TABLE projects
DROP CONSTRAINT ch_projects_project_name;

-- ex9
-- In the table family_members, for the attribute gender one must also allow the values f and m (i.e.
-- additionally with lowercase letters).
ALTER TABLE family_members
    DROP CONSTRAINT c_gender,
    ADD CONSTRAINT ch_family_members_gender CHECK (gender IN ('F', 'M', 'f', 'm'))

-- ex10
-- On the table departments, place a foreign key to the table employees; (if it would not already exist, remove the existing constraints)
ALTER TABLE departments
    DROP CONSTRAINT IF EXISTS fk_dep_emp, -- drop the constraint that already exists
    DROP CONSTRAINT IF EXISTS fk_departments_manager_id, --we drop it in case we had already done the exercise and already made the constraint
    ADD CONSTRAINT fk_departments_manager_id
        FOREIGN KEY (manager_id) REFERENCES employees(employee_id);

-- ex11
-- Remove the tables you created above. Don't use CASCADE so remember the order!
-- view ERD
-- make it rerunnable
DROP TABLE IF EXISTS locations; -- it's a loose end, no foreign keys being referenced! it is a child table
DROP TABLE IF EXISTS family_members; -- same here
DROP TABLE IF EXISTS tasks; -- this is also safe to remove, because it is child table to employees and projects (you can see this because of the association, it has *)
DROP TABLE IF EXISTS projects; -- projects is no longer parent table because tasks is gone, it is a child table
ALTER TABLE IF EXISTS departments
    DROP CONSTRAINT IF EXISTS fk_departments_manager_id;
DROP TABLE IF EXISTS employees; -- now you can drop employees bc no more foreign key depending on it
DROP TABLE IF EXISTS departments; -- last table to drop!

-- ex12
-- Which query can be used to retrieve the highest department number of departments.
-- (use FETCH...)
SELECT department_id
FROM departments
ORDER BY 1 DESC
FETCH FIRST ROW ONLY;

--- ex13
-- Add a new column department_id_new with datatype INTEGER to the table departments.
-- This is an Identity column that generates a value only when no value is supplied. --> so by default
-- Use the department_id from the previous query to set the starting value of the identity column

ALTER TABLE departments
    ADD COLUMN department_id_new INTEGER
        GENERATED BY DEFAULT AS IDENTITY (START WITH 8); --because department_id 7 is the last existing one
--> but because you are generating a new column (while there are already 3 rows in the table),
-- the 3 empty slots in our new column will be filled up with 8, 9, 10

-- ex14
-- Copy the data from department_id to department_id_new for each record.
UPDATE departments
SET department_id_new = department_id;

-- ex15
-- Remove the primary key constraint from the table departments, along with the linked FKs.
ALTER TABLE departments
DROP CONSTRAINT pk_departments; --> this wouldnt work bc of foreign keys depending on it

ALTER TABLE departments
    DROP CONSTRAINT pk_departments CASCADE; --> also removes linked fk's, so removed half of the relations to this table! Very dangerous!

-- ex16
-- Delete the column department_id
ALTER TABLE departments
DROP COLUMN department_id; --> this works because we removed the pk_departments constraint

-- ex17
-- Rename the department_id_new column to department_id
ALTER TABLE departments
RENAME COLUMN department_id TO department_id;

-- ex18
-- Add the primary key constraint to the department_id column
ALTER TABLE departments
ADD CONSTRAINT pk_departments PRIMARY KEY (department_id);

-- ex19
-- Add the new department ICT to the departments table.
-- Verify that the identity column has assigned the expected department_id.

INSERT INTO departments (department_name)
VALUES ('ICT'); --> bc of the identity column we made, it will automatically get a department_id

ALTER TABLE departments
ALTER COLUMN department_id RESTART WITH 8; -- we state again RESTART WITH 8 or else it will start at 11 because of ex13!

-- Note
-- ● Basically, we now should add all the foreign key constraints that refer to department_id
-- (e.g. In the employees table) again.
-- ● Afterwards, run the database creation and completion script again.

-- a more brief way to do these exercises:
ALTER TABLE departments
DROP CONSTRAINT pk_departments CASCADE, -- drop the constraints
    ALTER COLUMN department_id SET DATA TYPE INTEGER, --set it to integer, so u can turn it into an identity column
    ALTER COLUMN department_id ADD GENERATED BY DEFAULT AS IDENTITY (START WITH 8);
ALTER TABLE departments
    ADD CONSTRAINT pk_departments PRIMARY KEY (department_id); -- turn it back into a pk

-- change the data type and set the foreign keys back:
ALTER TABLE employees
ALTER COLUMN department_id SET DATA TYPE INTEGER, -- needs to be the same data type as the key it is referencing
    ADD CONSTRAINT fk_employees_department_id
        FOREIGN KEY (department_id) REFERENCES departments(department_id);