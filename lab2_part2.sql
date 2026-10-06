-- Part 1 : Multiple Database Management
-- Task 1.1 Database Creation with Parameters
-- 1. university_main
CREATE DATABASE university_main
    WITH
    OWNER = postgres
    ENCODING = 'UTF8';

-- 2. university_archive
CREATE DATABASE university_archive
    WITH
    CONNECTION LIMIT = 50;

-- 3. university_test
CREATE DATABASE university_test
    WITH
    CONNECTION LIMIT = 10;


-- Task 1.2 : Tablespace Operations
CREATE TABLESPACE student_data
    LOCATION '/tmp/data/students';

CREATE TABLESPACE course_data
    OWNER postgres
    LOCATION '/tmp/data/courses';

CREATE DATABASE university_distributed
    WITH
    TABLESPACE = student_data
    ENCODING = 'UTF8';



--Defense:
CREATE DATABASE airport_db
    WITH
    OWNER = postgres
    CONNECTION LIMIT  = 30
    ENCODING = 'UTF8';


--Defense3:
-- Setup for In-Class Task: IT Projects (run before the task)
DROP TABLE IF EXISTS team_members;
DROP TABLE IF EXISTS projects;

CREATE TABLE projects (
                          project_id     SERIAL PRIMARY KEY,
                          project_name   VARCHAR(60),
                          budget         NUMERIC(10,2),
                          start_date     DATE,
                          end_date       DATE,
                          total_tasks    INTEGER DEFAULT 0,
                          done_tasks     INTEGER DEFAULT 0,
                          completion_pct NUMERIC(5,1) DEFAULT 0
);

CREATE TABLE team_members (
                              member_id  SERIAL PRIMARY KEY,
                              full_name  VARCHAR(60),
                              role       VARCHAR(20),
                              project_id INTEGER,
                              status     VARCHAR(15) DEFAULT 'Assigned'
);

INSERT INTO projects (project_name, budget, start_date, end_date, total_tasks, done_tasks) VALUES
                                                                                               ('CRM Upgrade',       750000.00, '2026-03-01', '2026-12-31', 12,  8),
                                                                                               ('Data Warehouse',   1200000.00, '2026-01-15', '2026-11-30', 20,  5),
                                                                                               ('Website Redesign',  300000.00, '2025-06-01', '2025-12-15', 10, 10),
                                                                                               ('AI Chatbot',        600000.00, '2026-09-01', '2027-03-01',  0,  0),
                                                                                               ('Legacy Migration',  900000.00, '2025-02-01', '2025-10-31', 15, 12);

INSERT INTO team_members (full_name, role, project_id) VALUES
                                                           ('Aliya Nurova',      'Developer', 1),
                                                           ('Bauyrzhan Kim',     'Analyst',   1),
                                                           ('Zhanna Ermekova',   'Developer', 1),
                                                           ('Olzhas Abenov',     'Developer', 2),
                                                           ('Kamila Seitova',    'Tester',    2),
                                                           ('Ruslan Dzhumabaev', 'Developer', 3),
                                                           ('Asel Mukanova',     'Tester',    5),
                                                           ('Nurbol Iskakov',    'Developer', NULL),
                                                           ('Gulnaz Tokayeva',   'Analyst',   NULL);

--TASK1;
INSERT INTO projects (budget, start_date, end_date)
VALUES (40000*1.25, 'TODAYS DATE' , 90);
SET VALUES (project_id, budget) INTO projects;

--TASK2;
UPDATE team_members
SET status ='Unassigned'
SET VALUES (full_name, status) INTO projects;







-- Create tables
CREATE TABLE employees (
                           employee_id SERIAL PRIMARY KEY,
                           first_name VARCHAR(50),
                           last_name VARCHAR(50),
                           department VARCHAR(50),
                           salary NUMERIC(10,2),
                           hire_date DATE,
                           manager_id INTEGER,
                           email VARCHAR(100)
);
CREATE TABLE projects (
                          project_id SERIAL PRIMARY KEY,
                          project_name VARCHAR(100),
                          budget NUMERIC(12,2),
                          start_date DATE,
                          end_date DATE,
                          status VARCHAR(20)
);
CREATE TABLE assignments (
                             assignment_id SERIAL PRIMARY KEY,
                             employee_id INTEGER REFERENCES employees(employee_id),
                             project_id INTEGER REFERENCES projects(project_id),
                             hours_worked NUMERIC(5,1),
                             assignment_date DATE
);

-- Insert sample data
INSERT INTO employees (first_name, last_name, department,
                       salary, hire_date, manager_id, email) VALUES
                                                                 ('John', 'Smith', 'IT', 75000, '2020-01-15', NULL,
                                                                  'john.smith@company.com'),
                                                                 ('Sarah', 'Johnson', 'IT', 65000, '2020-03-20', 1,
                                                                  'sarah.j@company.com'),
                                                                 ('Michael', 'Brown', 'Sales', 55000, '2019-06-10', NULL,
                                                                  'mbrown@company.com'),
                                                                 ('Emily', 'Davis', 'HR', 60000, '2021-02-01', NULL,
                                                                  'emily.davis@company.com'),
                                                                 ('Robert', 'Wilson', 'IT', 70000, '2020-08-15', 1, NULL),
                                                                 ('Lisa', 'Anderson', 'Sales', 58000, '2021-05-20', 3,
                                                                  'lisa.a@company.com');
INSERT INTO projects (project_name, budget, start_date,
                      end_date, status) VALUES
                                            ('Website Redesign', 150000, '2024-01-01', '2024-06-30',
                                             'Active'),
                                            ('CRM Implementation', 200000, '2024-02-15', '2024-12-31',
                                             'Active'),
                                            ('Marketing Campaign', 80000, '2024-03-01', '2024-05-31',
                                             'Completed'),
                                            ('Database Migration', 120000, '2024-01-10', NULL, 'Active');
INSERT INTO assignments (employee_id, project_id,
                         hours_worked, assignment_date) VALUES
                                                            (1, 1, 120.5, '2024-01-15'),
                                                            (2, 1, 95.0, '2024-01-20'),
                                                            (1, 4, 80.0, '2024-02-01'),
                                                            (3, 3, 60.0, '2024-03-05'),
                                                            (5, 2, 110.0, '2024-02-20'),
                                                            (6, 3, 75.5, '2024-03-10');
