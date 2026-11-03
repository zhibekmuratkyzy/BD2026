--Part 1
--Step 1.1
CREATE TABLE employees (
                           emp_id INT PRIMARY KEY,
                           emp_name VARCHAR(50),
                           dept_id INT,
                           salary DECIMAL(10, 2)
);

CREATE TABLE departments (
                             dept_id INT PRIMARY KEY,
                             dept_name VARCHAR(50),
                             location VARCHAR(50)
);

CREATE TABLE projects (
                          project_id INT PRIMARY KEY,
                          project_name VARCHAR(50),
                          dept_id INT,
                          budget DECIMAL(10, 2)
);

--Step 1.2
INSERT INTO employees (emp_id, emp_name, dept_id, salary)
VALUES
(1, 'John Smith', 101, 50000),
(2, 'Jane Doe', 102, 60000),
(3, 'Mike Johnson', 101, 55000),
(4, 'Sarah Williams', 103, 65000),
(5, 'Tom Brown', NULL, 45000);

INSERT INTO departments (dept_id, dept_name, location) VALUES
(101, 'IT', 'Building A'),
(102, 'HR', 'Building B'),
(103, 'Finance', 'Building C'),
(104, 'Marketing', 'Building D');

INSERT INTO projects (project_id, project_name, dept_id, budget) VALUES
(1, 'Website Redesign', 101, 100000),
(2, 'Employee Training', 102, 50000),
(3, 'Budget Analysis', 103, 75000),
(4, 'Cloud Migration', 101, 150000),
(5, 'AI Research', NULL, 200000);



--Part 2
--Exercise 2.1
SELECT e.emp_name, d.dept_name
FROM employees e CROSS JOIN departments d;
--Answer: N x M = 5 x 4 = 20 rows

--Exercise 2.2
--a)Comma notation
SELECT e.emp_name, d.dept_name
FROM employees e, departments d;

--b)INNER JOIN with TRUE condition
SELECT e.emp_name, d.dept_name
FROM employees e
INNER JOIN departments d ON TRUE;

--Exercise 2.3
SELECT e.emp_name, p.project_name
FROM employees e
CROSS JOIN projects p;


--Part 3
--Exercise 3.1
SELECT e.emp_name, d.dept_name, d.location
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;
--Answer: 4 rows. Tom Brown is not included because his dept_id is NULL

--Exercise 3.2
SELECT emp_name, dept_name, location
FROM employees
INNER JOIN departments USING (dept_id);
--Answer: With these selected columns the output is the same. With SELECT * USING returns the dept_id column once, while ON returns it twice (e.dept_id and d.dept_id)

--Exercise 3.3
SELECT emp_name, dept_name, location
FROM employees
NATURAL INNER JOIN departments;

--Exercise 3.4
SELECT e.emp_name, d.dept_name, p.project_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
INNER JOIN projects p ON d.dept_id = p.dept_id;


--Part 4
--Exercise 4.1
SELECT e.emp_name, e.dept_id AS emp_dept, d.dept_id AS
dept_dept, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;
--Answer: Tom Brown appears with emp_dept = NULL, dept_dept = NULL and dept_name = NULL (5 rows total)

--Exercise 4.2
SELECT emp_name, dept_id, dept_name
FROM employees
LEFT JOIN departments USING (dept_id);

--Exercise 4.3
SELECT e.emp_name, e.dept_id
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_id IS NULL;

--Exercise 4.4
SELECT d.dept_name, COUNT(e.emp_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY employee_count DESC;


--Part 5
--Exercise 5.1
SELECT e.emp_name, d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;

--Exercise 5.2
SELECT e.emp_name, d.dept_name
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id;

--Exercise 5.3
SELECT d.dept_name, d.location
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL;

--Part 6
--Exercise 6.1
SELECT e.emp_name, e.dept_id AS emp_dept, d.dept_id AS
dept_dept, d.dept_name
FROM employees e
FULL JOIN departments d ON e.dept_id = d.dept_id;
--Answer: 6 rows. NULL on the left side (employee columns): the Marketing department (no employees). NULL on the right side (department columns): Tom Brown (no department).

--Exercise 6.2
SELECT d.dept_name, p.project_name, p.budget
FROM departments d
FULL JOIN projects p ON d.dept_id = p.dept_id;

--Exercise 6.3
SELECT
    CASE
        WHEN e.emp_id IS NULL THEN 'Department without
employees'
        WHEN d.dept_id IS NULL THEN 'Employee without
department'
        ELSE 'Matched'
        END AS record_status,
    e.emp_name,
    d.dept_name
FROM employees e
         FULL JOIN departments d ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL OR d.dept_id IS NULL;
--Returns Tom Brown and Marketing

--Part 7
--Exercise 7.1
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id AND d.location = 'Building A';

--Exercise 7.2
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.location = 'Building A';
--2 rows (John and Mike). Employees whose department is not in Building A (or who have no department) are removed by the WHERE filter.
--Query 1 (ON): filter is part of the matching, unmatched left rows stay.
--Query 2 (WHERE): filter is applied after the join, rows are removed.

--Exercise 7.3
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id AND d.location = 'Building A';
--Answer: No difference, both return the same 2 rows (John and Mike).
--INNER JOIN only keeps matching rows anyway, so removing rows during the join (ON) or after it (WHERE) gives the same result.


--Part 8
--Exercise 8.2
SELECT
    d.dept_name,
    e.emp_name,
    e.salary,
    p.project_name,
    p.budget
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
LEFT JOIN projects p ON d.dept_id = p.dept_id
ORDER BY d.dept_name, e.emp_name;

--Exercise 8.3
ALTER TABLE employees ADD COLUMN manager_id INT;

UPDATE employees SET manager_id = 3 WHERE emp_id = 1;
UPDATE employees SET manager_id = 3 WHERE emp_id = 2;
UPDATE employees SET manager_id = NULL WHERE emp_id = 3;
UPDATE employees SET manager_id = 3 WHERE emp_id = 4;
UPDATE employees SET manager_id = 3 WHERE emp_id = 5;

SELECT
    e.emp_name AS employee,
    m.emp_name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id;
--Mike Johnson has no manager (NULL); everyone else reports to Mike Johnson

--Exercise 8.3
SELECT d.dept_name, AVG(e.salary) AS avg_salary
FROM departments d
INNER JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
HAVING AVG(e.salary) > 50000;
--IT 52500, HR 60000, Finance 65000. Marketing has no employees, so it is not in the INNER JOIN result


--Lab Questions
--1. INNER JOIN returns only matching rows. LEFT JOIN returns all left-table rows, with NULLs where there is no match.
--2. To get all combinations, e.g. an employee × project availability matrix.
--3. In an outer join, a WHERE filter removes the NULL rows that ON would keep. In an inner join, unmatched rows are dropped anyway, so it makes no difference.
--4. 5 × 10 = 50.
--5. It joins on all columns with the same name in both tables.
--6. It can join on unintended columns, and it breaks silently if columns are added or renamed.
--7. SELECT * FROM B RIGHT JOIN A ON A.id = B.id
--8. When you need all rows from both tables, e.g. to find unmatched records on either side.

--Additional Challenges
--1. Simulate FULL OUTER JOIN with UNION of LEFT and RIGHT joins
SELECT e.emp_name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
UNION
SELECT e.emp_name, d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;

--2. Employees in departments with more than one project
SELECT e.emp_name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_id IN (
    SELECT dept_id
    FROM projects
    GROUP BY dept_id
    HAVING COUNT(*) > 1
);
--Returns John Smith and Mike Johnson (IT has 2 projects)

--3. Organizational structure: employee -> manager -> manager's manager
SELECT
    e.emp_name  AS employee,
    m.emp_name  AS manager,
    mm.emp_name AS managers_manager
FROM employees e
LEFT JOIN employees m  ON e.manager_id = m.emp_id
LEFT JOIN employees mm ON m.manager_id = mm.emp_id;

--4. All pairs of employees in the same department
SELECT e1.emp_name AS employee_1, e2.emp_name AS employee_2, d.dept_name
FROM employees e1
INNER JOIN employees e2 ON e1.dept_id = e2.dept_id AND e1.emp_id < e2.emp_id
INNER JOIN departments d ON e1.dept_id = d.dept_id;
--Returns the pair John Smith / Mike Johnson (IT)




