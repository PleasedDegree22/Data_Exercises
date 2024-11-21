--ex1
--Give the number of employees with children under 18?
SELECT employee_id, date_part('year', age(birth_date))
FROM family_members
WHERE date_part('year', age(birth_date)) < '18';

--ex2
--Which employees from Eindhoven or Maarssen are older than 30?
SELECT employee_id, last_name, location, age(birth_date) AS age
FROM employees
WHERE UPPER(location) IN ('EINDHOVEN', 'MAARSSEN')
AND date_part('year', age(birth_date)) > 30;

--ex3
--Which employees have a partner with an age between 35y and 45y? Give the
--number of the employee and the age of that partner.
SELECT employee_id, age(birth_date) AS age
FROM family_members
WHERE relationship = 'PARTNER'
AND date_part('year', age(birth_date)) BETWEEN 35 AND 45;

--ex4
--For each employee, give the date when he/she will retire. Assume that the
--retirement age is 65 and that one retires on his/her birthday.
SELECT first_name,
       last_name,
       TO_CHAR(birth_date, 'DD Month YYYY') AS "Date of birth",
       TO_CHAR(birth_date + INTERVAL '65 years', 'day DD month YYYY') AS pension
FROM employees;

--ex5
--a. Enter the date of birth of family members in the format below. Note the order.
SELECT name, TO_CHAR(birth_date, 'day DD month YYYY') AS "born on"
FROM family_members
ORDER BY birth_date DESC

--b. Do the same but provide a custom format.
SELECT name, TO_CHAR(birth_date, 'FMday FMDD FMmonth FMYYYY') AS "born on"
FROM family_members
ORDER BY birth_date DESC

--c. And now put this in "French”
SET lc_time = 'fr_FR'
SELECT name, TO_CHAR(birth_date, 'FMday FMDD FMmonth FMYYYY') AS "born on"
FROM family_members
ORDER BY birth_date DESC;

--ex6
--Provide the full name of each employee! Please provide a solution that:
--a) Does not use a function
SELECT first_name || ' ' || last_name AS name
FROM employees;
--b) Only uses the function concat
SELECT CONCAT_WS(' ', first_name, last_name) AS name
FROM employees;
--c) Uses functions concat, lpad (to add a blank) and length each used once
SELECT CONCAT(rpad(first_name, length(first_name)+1, ' '),
       rpad(last_name, length(last_name)+1, ' '))
FROM employees;

--ex7
--Get the address of all employees to which you apply the following:
--a) Convert all characters to lowercase
SELECT LOWER(street)
FROM employees;
--b) Remove the initial 'z' from the address
SELECT TRIM(LEADING 'z' FROM LOWER(street))
FROM employees;
--c) Show 30 characters each, if the address is shorter complete the string
--with '*' characters
SELECT RPAD(TRIM(LEADING 'z' FROM LOWER(street)), 30, '*') AS "new address"
FROM employees;

--ex8
--List all employees with the letter 'o' in their name and first name? Use a text
--function.
SELECT first_name, last_name
FROM employees
WHERE POSITION('o' IN LOWER(first_name)) != 0
AND POSITION('o' IN LOWER(first_name)) != 0;

--ex9
--List all employees who have 2 O's in a row in their last name and no other O's.
SELECT last_name
FROM employees
WHERE POSITION('oo' IN LOWER(last_name)) != 0
AND POSITION('o' IN
             CONCAT(substring(last_name FOR POSITION('oo' IN LOWER(last_name))-1),
                    substring(last_name FROM POSITION('oo' IN LOWER(last_name))+2))) = 0;

--ex10
--In employees' addresses, replace all the letters 'e' with an 'o' except the first 'e'.
SELECT CONCAT(substring(street FOR POSITION('e' IN street)),
       REPLACE(substring(street FROM POSITION('e' IN street)+1), 'e', 'o')) AS name
FROM employees;

--ex11
--Form an email address for each employee. Form: 3 first characters of first name + "."
-- + 3 first characters of the last name + "@" + name of the department + ".be". All
--must be in lower case. Do not use a || sign.

SELECT CONCAT(substring(LOWER(first_name) FOR 3),
       '.',
       substring(LOWER(last_name) FOR 3),
       '@',
       LOWER(d.department_name),
       '.be')
FROM employees e
JOIN departments d ON (e.department_id = d.department_id)