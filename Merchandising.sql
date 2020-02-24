CREATE DATABASE Merchandising;

USE Merchandising;

CREATE TABLE Category
(id INT PRIMARY KEY IDENTITY (1,1),
designation VARCHAR(80));

CREATE TABLE products
(id INT PRIMARY KEY IDENTITY (1,1),
price DECIMAL(5,2) NOT NULL,
designation VARCHAR(80) NOT NULL,
category INT NOT NULL,
CONSTRAINT Fk_pdCat FOREIGN KEY (category) REFERENCES Category(id)
);

CREATE TABLE Purchase
(id INT PRIMARY KEY IDENTITY (1,1),
purchasedProducts INT,
CONSTRAINT Fk_purchasedPd FOREIGN KEY (purchasedProducts) REFERENCES products(id),
purchasedDate DATE NOT NULL,
numberOfProducts INT NOT NULL
);

INSERT INTO Category (designation)
VALUES
('vegetables'),
('clothes'),
('fish'),
('meet');

INSERT INTO products (price, designation, category)
VALUES
(2.5, 'sockets', 2),
(3.2, 'tomatoe', 1),
(5.1, 'blue fish', 3),
(10, 'cow', 4),
(50, 'trouser', 2),
(1.2, 'cucumber', 1),
(200, 'black Angus', 4),
(30, 't-shirt', 2),
(25, 'salmon', 3);

INSERT INTO Purchase (purchasedProducts, purchasedDate, numberOfProducts)
VALUES
(1, '2019-01-03', 1),
(2, '2019-02-08', 1),
(3, '2019-03-08', 1),
(4, '2019-04-06', 1),
(5, '2019-05-06', 1),
(6, '2019-06-06', 1),
(7, '2019-07-06', 1),
(8, '2019-08-06', 1),
(9, '2019-09-06', 1),
(1, '2019-10-06', 1),
(2, '2019-11-06', 1),
(3, '2019-12-06', 1),
(4, '2019-04-20', 1),
(5, '2019-04-12', 2),
(6, '2019-05-10', 3),
(7, '2019-06-25', 1),
(8, '2019-07-31', 5),
(9, '2019-09-20', 10);

SELECT SUM (purchase.numberOfProducts * products.price) AS TotalPriceFromCat, Category.designation FROM Purchase
INNER JOIN products ON Purchase.purchasedProducts = products.id
INNER JOIN Category ON products.category = Category.id
GROUP BY products.category, Category.designation;



SELECT SUM (purchase.numberOfProducts * products.price) AS TotalPrice FROM Purchase
INNER JOIN products ON Purchase.purchasedProducts = products.id
WHERE Purchase.purchasedDate < '2020-01-01' AND Purchase.purchasedDate > '2019-01-01';

