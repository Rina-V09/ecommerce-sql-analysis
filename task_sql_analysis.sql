create database ecommerce_db;
use ecommerce_db;

-- Customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(50)
);
INSERT INTO customers VALUES
(1, 'Meenakshi', 'meena@example.com', 'India'),
(2, 'Rina', 'rin@example.com', 'Canada'),
(3, 'Shivani', 'shiv@example.com', 'USA');

-- Products table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);
INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 900.00),
(2, 'Phone', 'Electronics', 500.00),
(3, 'Shoes', 'Fashion', 80.00);

-- Orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
INSERT INTO orders VALUES
(1, 1, '2025-08-06'),
(2, 2, '2025-08-07'),
(3, 1, '2025-08-08');

-- Order Items table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
INSERT INTO order_items VALUES
(1, 1, 1, 1),
(2, 1, 3, 2),
(3, 2, 2, 1),
(4, 3, 2, 2);


SELECT name, country
FROM customers
WHERE country = 'USA'
ORDER BY name ASC;

SELECT o.order_id, c.name, p.product_name, oi.quantity, p.price
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;

SELECT c.country, COUNT(o.order_id) AS total_orders, SUM(p.price * oi.quantity) AS total_sales
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.country;

SELECT name, email
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
);

CREATE VIEW sales_summary AS
SELECT c.name, SUM(p.price * oi.quantity) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.name;

CREATE INDEX idx_customer_country ON customers(country);



