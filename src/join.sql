-- tags: inner join, left outer join, full outer join, cross join.
-- notes: RIGHT OUTER JOIN is deprecated by CV08 rule of sqlfluff.

-- create customers table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL
);

-- create orders table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    order_amount DECIMAL,
    customer_id INT -- deliberately omitting foreign key to demo joins below
);

-- insert sample data into customers
INSERT INTO customers (customer_name)
VALUES
('amiao'),
('yahaha'),
('wowo');

-- insert sample data into orders
INSERT INTO orders (customer_id, order_amount)
VALUES
(1, 100.50),  -- amiao's order
(1, 200.75),  -- amiao's second order
(2, 150.00),  -- yahaha's order
(4, 300.00);  -- order with no matching customer

-- inner join
SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_amount
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id;

-- left outer join
SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_amount
FROM customers AS c
LEFT OUTER JOIN orders AS o
    ON c.customer_id = o.customer_id;

-- full outer join
SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_amount
FROM customers AS c
FULL OUTER JOIN orders AS o
    ON c.customer_id = o.customer_id;

-- cross join
SELECT
    c.customer_id,
    c.customer_name,
    o.order_amount
FROM customers AS c
CROSS JOIN orders AS o;
