-- Lab Work 5: Database Constraints
-- Name: Zhibek Muratkyzy
-- Student ID: 25B032118

-- Separate schema so this does not clash with other labs
DROP SCHEMA IF EXISTS lab5 CASCADE;
CREATE SCHEMA lab5;
SET search_path TO lab5;


-- PART 1: CHECK Constraints

-- Task 1.1: Basic CHECK Constraint
CREATE TABLE employees (
                           employee_id INTEGER,
                           first_name TEXT,
                           last_name TEXT,
                           age INTEGER CHECK (age BETWEEN 18 AND 65),   -- age 18-65
                           salary NUMERIC CHECK (salary > 0)            -- salary above 0
);

-- Task 1.2: Named CHECK Constraint
CREATE TABLE products_catalog (
                                  product_id INTEGER,
                                  product_name TEXT,
                                  regular_price NUMERIC,
                                  discount_price NUMERIC,
                                  CONSTRAINT valid_discount CHECK (
                                      regular_price > 0 AND discount_price > 0 AND discount_price < regular_price
                                      )
);

-- Task 1.3: Multiple Column CHECK
CREATE TABLE bookings (
                          booking_id INTEGER,
                          check_in_date DATE,
                          check_out_date DATE,
                          num_guests INTEGER CHECK (num_guests BETWEEN 1 AND 10),
                          CHECK (check_out_date > check_in_date)       -- check-out after check-in
);

-- Task 1.4: Testing CHECK Constraints
INSERT INTO employees VALUES (1, 'Ann', 'Lee', 30, 5000);
INSERT INTO employees VALUES (2, 'Bob', 'Ray', 65, 4200);
-- INSERT INTO employees VALUES (3, 'Cara', 'Fox', 17, 3000);
-- fails: age below 18 (employees_age_check)
-- INSERT INTO employees VALUES (4, 'Dan', 'Moe', 25, 0);
-- fails: salary must be > 0 (employees_salary_check)

INSERT INTO products_catalog VALUES (1, 'Laptop', 1000, 850);
INSERT INTO products_catalog VALUES (2, 'Mouse', 25, 20);
-- INSERT INTO products_catalog VALUES (3, 'Desk', 200, 250);
-- fails: discount higher than regular price (valid_discount)
-- INSERT INTO products_catalog VALUES (4, 'Pen', -5, -10);
-- fails: prices must be > 0 (valid_discount)

INSERT INTO bookings VALUES (1, '2026-11-01', '2026-11-05', 2);
INSERT INTO bookings VALUES (2, '2026-12-20', '2026-12-27', 10);
-- INSERT INTO bookings VALUES (3, '2026-11-01', '2026-11-05', 11);
-- fails: more than 10 guests (bookings_num_guests_check)
-- INSERT INTO bookings VALUES (4, '2026-11-05', '2026-11-01', 2);
-- fails: check-out before check-in (bookings_check)


-- PART 2: NOT NULL Constraints

-- Task 2.1: NOT NULL Implementation
CREATE TABLE customers (
                           customer_id INTEGER NOT NULL,
                           email TEXT NOT NULL,
                           phone TEXT,                                  -- can be NULL
                           registration_date DATE NOT NULL
);

-- Task 2.2: Combining Constraints
CREATE TABLE inventory (
                           item_id INTEGER NOT NULL,
                           item_name TEXT NOT NULL,
                           quantity INTEGER NOT NULL CHECK (quantity >= 0),
                           unit_price NUMERIC NOT NULL CHECK (unit_price > 0),
                           last_updated TIMESTAMP NOT NULL
);

-- Task 2.3: Testing NOT NULL
INSERT INTO customers VALUES (1, 'a@mail.com', '+77001112233', '2026-10-01');
INSERT INTO customers VALUES (2, 'b@mail.com', NULL, '2026-10-02');   -- NULL phone is OK
INSERT INTO inventory VALUES (1, 'Notebook', 100, 4.99, '2026-10-13 09:00:00');
INSERT INTO inventory VALUES (2, 'Pen', 0, 1.50, '2026-10-13 09:05:00');
-- INSERT INTO customers VALUES (3, NULL, '123', '2026-10-03');
-- fails: email is NULL (not-null constraint)
-- INSERT INTO inventory VALUES (3, NULL, 10, 5.00, '2026-10-13 09:00:00');
-- fails: item_name is NULL (not-null constraint)
-- INSERT INTO inventory VALUES (4, 'Ruler', -1, 2.00, '2026-10-13 09:00:00');
-- fails: quantity below 0 (inventory_quantity_check)


-- PART 3: UNIQUE Constraints

-- Task 3.1: Single Column UNIQUE
CREATE TABLE users (
                       user_id INTEGER,
                       username TEXT UNIQUE,
                       email TEXT UNIQUE,
                       created_at TIMESTAMP
);

-- Task 3.2: Multi-Column UNIQUE
CREATE TABLE course_enrollments (
                                    enrollment_id INTEGER,
                                    student_id INTEGER,
                                    course_code TEXT,
                                    semester TEXT,
                                    UNIQUE (student_id, course_code, semester)
);

INSERT INTO course_enrollments VALUES (1, 100, 'CS101', '2026-Fall');
INSERT INTO course_enrollments VALUES (2, 100, 'CS101', '2027-Spring');   -- different semester: OK
-- INSERT INTO course_enrollments VALUES (3, 100, 'CS101', '2026-Fall');
-- fails: same student, course and semester already exist

-- Task 3.3: Named UNIQUE Constraints
ALTER TABLE users DROP CONSTRAINT users_username_key;
ALTER TABLE users DROP CONSTRAINT users_email_key;
ALTER TABLE users ADD CONSTRAINT unique_username UNIQUE (username);
ALTER TABLE users ADD CONSTRAINT unique_email UNIQUE (email);

INSERT INTO users VALUES (1, 'alice', 'alice@mail.com', '2026-10-01 10:00:00');
INSERT INTO users VALUES (2, 'bob', 'bob@mail.com', '2026-10-02 11:30:00');
-- INSERT INTO users VALUES (3, 'alice', 'new@mail.com', '2026-10-03 09:00:00');
-- fails: duplicate username (unique_username)
-- INSERT INTO users VALUES (4, 'erin', 'alice@mail.com', '2026-10-03 09:30:00');
-- fails: duplicate email (unique_email)


-- PART 4: PRIMARY KEY Constraints

-- Task 4.1: Single Column Primary Key
CREATE TABLE departments (
                             dept_id INTEGER PRIMARY KEY,
                             dept_name TEXT NOT NULL,
                             location TEXT
);

INSERT INTO departments VALUES (10, 'IT', 'Almaty');
INSERT INTO departments VALUES (20, 'HR', 'Astana');
INSERT INTO departments VALUES (30, 'Sales', 'Shymkent');
-- INSERT INTO departments VALUES (10, 'Legal', 'Almaty');
-- fails: duplicate dept_id (departments_pkey)
-- INSERT INTO departments VALUES (NULL, 'Legal', 'Almaty');
-- fails: primary key cannot be NULL

-- Task 4.2: Composite Primary Key
CREATE TABLE student_courses (
                                 student_id INTEGER,
                                 course_id INTEGER,
                                 enrollment_date DATE,
                                 grade TEXT,
                                 PRIMARY KEY (student_id, course_id)
);

INSERT INTO student_courses VALUES (1, 101, '2026-09-01', 'A');
INSERT INTO student_courses VALUES (1, 102, '2026-09-01', 'B');
-- INSERT INTO student_courses VALUES (1, 101, '2026-09-10', 'C');
-- fails: pair (1, 101) already exists (student_courses_pkey)

-- Task 4.3: Comparison Exercise
-- 1. UNIQUE vs PRIMARY KEY: a primary key is unique AND not NULL, and a table has
--    only one. UNIQUE allows NULLs and a table can have many.
-- 2. Single vs composite key: use a single column when one column identifies the
--    row (dept_id). Use a composite key when only a combination identifies it,
--    for example a student/course link table.
-- 3. One PRIMARY KEY, many UNIQUE: the primary key is the main identity of a row
--    (other tables reference it). Other columns like email can still need to be
--    unique, so those use UNIQUE.


-- PART 5: FOREIGN KEY Constraint

-- Task 5.1: Basic Foreign Key
CREATE TABLE employees_dept (
                                emp_id INTEGER PRIMARY KEY,
                                emp_name TEXT NOT NULL,
                                dept_id INTEGER REFERENCES departments,
                                hire_date DATE
);

INSERT INTO employees_dept VALUES (1, 'John Smith', 10, '2024-01-15');
INSERT INTO employees_dept VALUES (2, 'Emily Davis', 20, '2024-06-01');
-- INSERT INTO employees_dept VALUES (3, 'Ghost Person', 99, '2026-01-01');
-- fails: department 99 does not exist (employees_dept_dept_id_fkey)

-- Task 5.2: Multiple Foreign Key
CREATE TABLE authors (
                         author_id INTEGER PRIMARY KEY,
                         author_name TEXT NOT NULL,
                         country TEXT
);

CREATE TABLE publishers (
                            publisher_id INTEGER PRIMARY KEY,
                            publisher_name TEXT NOT NULL,
                            city TEXT
);

CREATE TABLE books (
                       book_id INTEGER PRIMARY KEY,
                       title TEXT NOT NULL,
                       author_id INTEGER REFERENCES authors,
                       publisher_id INTEGER REFERENCES publishers,
                       publication_year INTEGER,
                       isbn TEXT UNIQUE
);

INSERT INTO authors VALUES (1, 'Leo Tolstoy', 'Russia');
INSERT INTO authors VALUES (2, 'Jane Austen', 'United Kingdom');
INSERT INTO publishers VALUES (1, 'Penguin Classics', 'London');
INSERT INTO publishers VALUES (2, 'Vintage', 'New York');
INSERT INTO books VALUES (1, 'War and Peace', 1, 1, 1869, '978-0-14-044793-4');
INSERT INTO books VALUES (2, 'Pride and Prejudice', 2, 1, 1813, '978-0-14-143951-8');
-- INSERT INTO books VALUES (3, 'Unknown', 99, 1, 2000, '111');
-- fails: author 99 does not exist (books_author_id_fkey)
-- INSERT INTO books VALUES (4, 'Copy', 1, 1, 2001, '978-0-14-044793-4');
-- fails: duplicate isbn (books_isbn_key)

-- Task 5.3: ON DELETE Options
CREATE TABLE categories (
                            category_id INTEGER PRIMARY KEY,
                            category_name TEXT NOT NULL
);

CREATE TABLE products_fk (
                             product_id INTEGER PRIMARY KEY,
                             product_name TEXT NOT NULL,
                             category_id INTEGER REFERENCES categories ON DELETE RESTRICT
);

CREATE TABLE orders (
                        order_id INTEGER PRIMARY KEY,
                        order_date DATE NOT NULL
);

CREATE TABLE order_items (
                             item_id INTEGER PRIMARY KEY,
                             order_id INTEGER REFERENCES orders ON DELETE CASCADE,
                             product_id INTEGER REFERENCES products_fk,
                             quantity INTEGER CHECK (quantity > 0)
);

INSERT INTO categories VALUES (1, 'Electronics');
INSERT INTO categories VALUES (2, 'Books');
INSERT INTO products_fk VALUES (1, 'Laptop', 1);
INSERT INTO products_fk VALUES (2, 'Novel', 2);
INSERT INTO orders VALUES (1, '2026-10-01');
INSERT INTO orders VALUES (2, '2026-10-05');
INSERT INTO order_items VALUES (1, 1, 1, 1);
INSERT INTO order_items VALUES (2, 1, 2, 2);
INSERT INTO order_items VALUES (3, 2, 1, 1);

-- 1. RESTRICT: category 1 still has products, so deleting it fails
-- DELETE FROM categories WHERE category_id = 1;
-- fails: category 1 is still referenced by products_fk

-- 2. CASCADE: deleting order 1 also deletes its items
DELETE FROM orders WHERE order_id = 1;
SELECT * FROM order_items;
-- result: only item 3 is left, items 1 and 2 were deleted automatically


-- PART 6: Practical Application
-- Task 6.1: E-Commerce Database Design
DROP TABLE IF EXISTS order_items, orders, customers CASCADE;

CREATE TABLE customers (
                           customer_id SERIAL PRIMARY KEY,
                           name TEXT NOT NULL,
                           email TEXT NOT NULL UNIQUE,                  -- no two customers with the same email
                           phone TEXT,
                           registration_date DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE products (
                          product_id SERIAL PRIMARY KEY,
                          name TEXT NOT NULL,
                          description TEXT,
                          price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
                          stock_quantity INTEGER NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0)
);

CREATE TABLE orders (
                        order_id SERIAL PRIMARY KEY,
                        customer_id INTEGER NOT NULL REFERENCES customers ON DELETE RESTRICT,   -- keep order history
                        order_date DATE NOT NULL DEFAULT CURRENT_DATE,
                        total_amount NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (total_amount >= 0),
                        status TEXT NOT NULL DEFAULT 'pending'
                            CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled'))
);

CREATE TABLE order_details (
                               order_detail_id SERIAL PRIMARY KEY,
                               order_id INTEGER NOT NULL REFERENCES orders ON DELETE CASCADE,        -- order deleted -> lines deleted
                               product_id INTEGER NOT NULL REFERENCES products ON DELETE RESTRICT,   -- cannot delete ordered product
                               quantity INTEGER NOT NULL CHECK (quantity > 0),
                               unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0)
);

INSERT INTO customers (name, email, phone, registration_date) VALUES
                                                                  ('Anna Petrova', 'anna@mail.com', '+77011234567', '2026-01-10'),
                                                                  ('Daniyar Seitov', 'daniyar@mail.com', NULL, '2026-02-14'),
                                                                  ('Maria Lopez', 'maria@mail.com', '+77021112233', '2026-03-05'),
                                                                  ('Tom Baker', 'tom@mail.com', NULL, '2026-04-21'),
                                                                  ('Chen Wei', 'chen@mail.com', '+77059998877', '2026-05-30');

INSERT INTO products (name, description, price, stock_quantity) VALUES
                                                                    ('Laptop', 'Everyday laptop', 850.00, 15),
                                                                    ('Headphones', 'Wireless headphones', 120.50, 40),
                                                                    ('Desk Lamp', 'LED lamp', 35.00, 0),
                                                                    ('Notebook', 'A5 notebook', 4.99, 200),
                                                                    ('Office Chair', 'Ergonomic chair', 210.00, 8);

INSERT INTO orders (customer_id, order_date, total_amount, status) VALUES
                                                                       (1, '2026-06-01', 859.98, 'delivered'),
                                                                       (2, '2026-06-10', 241.00, 'shipped'),
                                                                       (3, '2026-07-03', 245.00, 'processing'),
                                                                       (1, '2026-08-15', 49.90, 'pending'),
                                                                       (4, '2026-09-01', 120.50, 'cancelled');

INSERT INTO order_details (order_id, product_id, quantity, unit_price) VALUES
                                                                           (1, 1, 1, 850.00),
                                                                           (1, 4, 2, 4.99),
                                                                           (2, 2, 2, 120.50),
                                                                           (3, 5, 1, 210.00),
                                                                           (3, 3, 1, 35.00),
                                                                           (4, 4, 10, 4.99),
                                                                           (5, 2, 1, 120.50);

-- Tests (each should fail)
-- INSERT INTO customers (name, email) VALUES ('Fake', 'anna@mail.com');
-- fails: duplicate email (customers_email_key)
-- INSERT INTO products (name, price) VALUES ('Bad', -1);
-- fails: negative price (products_price_check)
-- INSERT INTO products (name, price, stock_quantity) VALUES ('Bad', 5, -3);
-- fails: negative stock (products_stock_quantity_check)
-- INSERT INTO orders (customer_id, status) VALUES (1, 'lost');
-- fails: invalid status (orders_status_check)
-- INSERT INTO order_details (order_id, product_id, quantity, unit_price) VALUES (1, 1, 0, 850);
-- fails: quantity must be positive (order_details_quantity_check)
-- INSERT INTO orders (customer_id) VALUES (99);
-- fails: customer 99 does not exist (orders_customer_id_fkey)
-- DELETE FROM customers WHERE customer_id = 1;
-- fails: customer has orders (RESTRICT)
-- DELETE FROM products WHERE product_id = 1;
-- fails: product is used in order_details (RESTRICT)

-- CASCADE test (rolled back so the data stays)
BEGIN;
DELETE FROM orders WHERE order_id = 5;
SELECT * FROM order_details WHERE order_id = 5;   -- result: 0 rows, the line was deleted too
ROLLBACK;
