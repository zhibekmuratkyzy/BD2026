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