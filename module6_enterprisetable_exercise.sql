--WEEK 6 - EXERCISES ON CREATING TABLES--
--06_2_Create_Table_Simple--
-- Exercise 1
-- Write and execute the statements to create the tables. Below you will find a description of
-- each table. Pay attention to the order in which you create them!

DROP TABLE IF EXISTS departments;
CREATE TABLE IF NOT EXISTS departments(
    department_id NUMERIC(2)
        CONSTRAINT pk_departments PRIMARY KEY,
    department_name VARCHAR(20) NOT NULL,
    manager_id CHAR(9),
    mgr_start_date date
);


DROP TABLE IF EXISTS employees;
CREATE TABLE IF NOT EXISTS employees(
    employee_id CHAR(9)
        CONSTRAINT pk_employees PRIMARY KEY,
    last_name VARCHAR(25) NOT NULL,
    first_name VARCHAR(25) NOT NULL,
    infix VARCHAR(25),
    street VARCHAR(50),
    city VARCHAR(25),
    province CHAR(2),
    postal_code VARCHAR(7),
    birth_date DATE,
    salary NUMERIC(7,2)
        CONSTRAINT ch_employees_salary CHECK (salary >= 85000),
    parking_spot NUMERIC(4)
        CONSTRAINT un_employees_parking_spot UNIQUE,
    gender VARCHAR(50) NOT NULL,
    department_id NUMERIC(4)
        CONSTRAINT fk_departments_department_id REFERENCES departments(department_id),
    manager_id CHAR(9)
        CONSTRAINT fk_departments_manager_id REFERENCES employees(employee_id)
);
--NULLS DISTINCT means each null is a distinct value, so you don't violate the unique condition
--> this is the default so you don't need to specify it, otherwise:
--NULLS NOT DISTINCT means that if there are two null values in one column, it violates the unique condition

DROP TABLE IF EXISTS projects;
CREATE TABLE IF NOT EXISTS projects(
    project_id NUMERIC(2)
        CONSTRAINT pk_projects PRIMARY KEY,
    project_name VARCHAR(25) NOT NULL,
    location VARCHAR(25),
    department_id NUMERIC(2)
        CONSTRAINT fk_projects_department_id REFERENCES departments(department_id)
);


DROP TABLE IF EXISTS locations;
CREATE TABLE IF NOT EXISTS locations(
    department_id NUMERIC(2)
        CONSTRAINT fk_locations_department_id REFERENCES departments(department_id),
    location VARCHAR(20) NOT NULL,
    CONSTRAINT pk_locations PRIMARY KEY(department_id, location)
);


DROP TABLE IF EXISTS tasks;
CREATE TABLE IF NOT EXISTS tasks(
    employee_id CHAR(9)
        CONSTRAINT fk_tasks_employee_id REFERENCES employees(employee_id),
    project_id NUMERIC(2)
        CONSTRAINT fk_employees_project_id REFERENCES projects(project_id),
    hours NUMERIC(5,1),
    CONSTRAINT pk_tasks PRIMARY KEY(employee_id, project_id)
);


DROP TABLE IF EXISTS family_members;
CREATE TABLE IF NOT EXISTS family_members(
    employee_id CHAR(9)
        CONSTRAINT fk_family_members_employee_id REFERENCES employees(employee_id),
    name VARCHAR(50),
    gender VARCHAR(50) NOT NULL,
    birth_date date
        CONSTRAINT ch_family_members_birth_date
            CHECK (birth_date BETWEEN TO_DATE('20-03-1950', 'DD-MM-YYYY') AND TO_DATE('01-01-2018', 'DD-MM-YYYY')),
    relationship VARCHAR(10) NOT NULL,
    CONSTRAINT pk_family_members PRIMARY KEY(employee_id, name)
);

--no need to specify NOT NULL for primary keys, that is one of the qualities of primary keys, they are standard never null


