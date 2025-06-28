-- tags: trigger, function.

-- create a table to store employee data
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    salary NUMERIC NOT NULL CHECK (salary > 0)
);

-- create an audit table to log insertions
CREATE TABLE employee_audit (
    audit_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees (id),
    action VARCHAR(50) NOT NULL,
    action_time TIMESTAMP NOT NULL
);

-- create a function to handle the trigger logic
CREATE OR REPLACE FUNCTION log_employee_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO employee_audit (employee_id, action, action_time)
    VALUES (NEW.id, 'INSERT', CURRENT_TIMESTAMP);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- create the trigger
CREATE TRIGGER employee_insert_trigger
AFTER INSERT ON employees
FOR EACH ROW
EXECUTE FUNCTION log_employee_insert();

-- test the trigger
INSERT INTO employees (name, salary)
VALUES
('amiao', 50000),
('yahaha', 80000);

-- check the result
SELECT * FROM employees;
-- check the audit table
SELECT * FROM employee_audit;
