DROP DATABASE IF EXISTS module02;

# NUMBER 2

CREATE DATABASE module02;
USE module02;

CREATE TABLE customers (
	customer_id INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(60) DEFAULT NULL,
	phone_number VARCHAR(20) DEFAULT NULL,
	PRIMARY KEY (customer_id)
);

CREATE TABLE items (
	item_id INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(60) DEFAULT NULL,
	price INT DEFAULT NULL,
	PRIMARY KEY (item_id)
);

CREATE TABLE orders (
	order_id INT NOT NULL AUTO_INCREMENT,
	customer_id INT,
	order_date DATE DEFAULT CURRENT_DATE,
	PRIMARY KEY (order_id),
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE itemorders (
	order_id INT NOT NULL,
	item_id INT NOT NULL,
	quantity INT DEFAULT 1,
	price_each INT DEFAULT 0,
	FOREIGN KEY (order_id) REFERENCES orders(order_id),
	FOREIGN KEY (item_id) REFERENCES items(item_id)
);

# Number 3

INSERT INTO customers (name, phone_number) VALUES
('Budiawan', '+6212345678'),
('Mary Jones', '+6287654321'),
('Budiwati', '+6289753124'),
('Mary Janes', '+6213243546'),
('John Doe', '+6200000000');

INSERT INTO items (name, price) VALUES
('Nasi Goreng Gila', 25000),
('Ice Water', 2000),
('Spaghetti', 40000),
('Green Tea Latte', 18000),
('Orange Juice', 15000),
('Cordon Bleu', 36000);

INSERT INTO orders (customer_id, order_date) VALUES
(1, '2020-10-10'),
(2, '2020-10-10'),
(3, '2020-10-10'),
(1, '2020-10-11'),
(2, '2020-10-11');

INSERT INTO itemorders (order_id, item_id, price_each) VALUES
(1, 1, 25000),
(1, 2, 2000),
(2, 3, 40000),
(2, 4, 18000),
(3, 3, 40000),
(3, 5, 15000),
(4, 1, 25000),
(4, 2, 2000),
(5, 6, 36000),
(5, 4, 18000);

# Number 4

SELECT o.order_id AS 'Order ID', 
	o.order_date AS 'Order date',
	c.name AS 'Customer name',
	c.phone_number AS 'Customer phone',
	SUM(i.price) AS 'Total',
	GROUP_CONCAT(i.name SEPARATOR ', ') AS 'Items bought'
FROM orders o
INNER JOIN customers c USING(customer_id)
INNER JOIN itemorders ior USING(order_id)
INNER JOIN items i USING(item_id)
GROUP BY (o.order_id);