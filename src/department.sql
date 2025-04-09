-- tags: primary key, foreign key, unique, check, join.

CREATE TABLE IF NOT EXISTS department (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS employee (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    emp_ssn VARCHAR(30) NOT NULL UNIQUE,
    emp_salary NUMERIC(9, 2) NOT NULL CHECK (emp_salary > 0),
    emp_dept_id INT REFERENCES department (dept_id)
);

INSERT INTO department (dept_name)
VALUES
('marketing'),
('engineering'),
('design');

INSERT INTO employee (emp_name, emp_ssn, emp_salary, emp_dept_id)
VALUES
('amiao', '123-45-6789', 6634.88, 1),
('yahaha', '123-33-6666', 3847, 1),
('bili', '111-22-3333', 0.34, 2),
('zhihu', '123-12-1234', 150, 3);

-- SELECT * FROM department LIMIT 20;
-- SELECT * FROM employee LIMIT 20;

SELECT
    e.emp_name,
    e.emp_salary,
    d.dept_name
FROM employee AS e
INNER JOIN department AS d
    ON e.emp_dept_id = d.dept_id;
