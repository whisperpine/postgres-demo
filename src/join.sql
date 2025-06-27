-- tags: inner join, left outer join, full outer join.
-- notes: RIGHT OUTER JOIN is deprecated by CV08 rule of sqlfluff.

-- create customers table
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

-- create orders table
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT,
    amount DECIMAL
);

-- insert sample data into customers
INSERT INTO customers (name)
VALUES
('amiao'),
('yahaha'),
('wowo');

-- insert sample data into orders
INSERT INTO orders (customer_id, amount)
VALUES
(1, 100.50),  -- amiao's order
(1, 200.75),  -- amiao's second order
(2, 150.00),  -- yahaha's order
(4, 300.00);  -- order with no matching customer

-- inner join
SELECT
    c.id AS customer_id,
    c.name AS customer_name,
    o.id AS order_id,
    o.amount AS order_amount
FROM customers AS c
INNER JOIN orders AS o
    ON c.id = o.customer_id;

-- left outer join
SELECT
    c.id AS customer_id,
    c.name AS customer_name,
    o.id AS order_id,
    o.amount AS order_amount
FROM customers AS c
LEFT OUTER JOIN orders AS o
    ON c.id = o.customer_id;

-- full outer join
SELECT
    c.id AS customer_id,
    c.name AS customer_name,
    o.id AS order_id,
    o.amount AS order_amount
FROM customers AS c
FULL OUTER JOIN orders AS o
    ON c.id = o.customer_id;
