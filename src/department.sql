-- tags: primary key, foreign key, unique, check, join, group by, CTE.

-- ======================================
-- table declarations
-- ======================================

CREATE TABLE IF NOT EXISTS departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS employees (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    emp_ssn VARCHAR(30) NOT NULL UNIQUE,
    emp_salary NUMERIC(9, 2) NOT NULL CHECK (emp_salary > 0),
    emp_dept_id INT REFERENCES departments (dept_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);


-- ======================================
-- data inserts
-- ======================================

INSERT INTO departments (dept_name)
VALUES
('marketing'),
('engineering'),
('design');

INSERT INTO employees (emp_name, emp_ssn, emp_salary, emp_dept_id)
VALUES
('amiao', '123-45-6789', 6634.88, 1),
('yahaha', '123-33-6666', 3847, 1),
('bili', '111-22-3333', 0.34, 2),
('zhihu', '123-12-1234', 150, 3);


-- ======================================
-- queries
-- ======================================

SELECT
    e.emp_name,
    d.dept_name,
    e.emp_salary,
    avg(e.emp_salary) OVER w AS dept_average
FROM employees AS e
INNER JOIN departments AS d
    ON e.emp_dept_id = d.dept_id
WINDOW w AS (PARTITION BY e.emp_dept_id)
ORDER BY d.dept_name DESC;

-- SELECT * FROM departments LIMIT 20;
-- SELECT * FROM employees LIMIT 20;


-- ======================================
-- CTE (Common Table Expression)
-- ======================================

WITH grouped_emp AS (
    SELECT
        e.emp_dept_id,
        count(*) AS emp_counts
    FROM employees AS e
    GROUP BY e.emp_dept_id
)

SELECT
    d.dept_id,
    d.dept_name,
    g.emp_counts
FROM departments AS d
INNER JOIN grouped_emp AS g
    ON d.dept_id = g.emp_dept_id
ORDER BY d.dept_id;


-- ======================================
-- query plan
-- ======================================

ANALYZE VERBOSE employees;
EXPLAIN SELECT * FROM employees;
EXPLAIN ANALYZE SELECT * FROM employees;
