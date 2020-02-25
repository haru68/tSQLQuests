CREATE DATABASE Magasin;

USE Magasin;

CREATE TABLE Category
(CategoryId INT PRIMARY KEY IDENTITY (1, 1),
"Name" VARCHAR(80) NOT NULL
);

CREATE TABLE Product
(ProductId INT PRIMARY KEY IDENTITY (1, 1),
"Name" VARCHAR(80) NOT NULL,
Price DECIMAL(5,2) NOT NULL,
Category_id INT NOT NULL,
CONSTRAINT Fk_CategoryId FOREIGN KEY (Category_id) REFERENCES Category(CategoryId)
);

CREATE TABLE ProductStock
(ProductStockId INT PRIMARY KEY IDENTITY (1, 1),
ProductStockName VARCHAR(80) NOT NULL,
Number INT NOT NULL
);

CREATE TABLE ProductStockProduct
(ProductStockProductID INT PRIMARY KEY IDENTITY (1,1),
Fk_ProductStockId INT NULL,
CONSTRAINT Fk_ProductStockIdFK FOREIGN KEY (Fk_ProductStockId) REFERENCES ProductStock(ProductStockId),
Fk_ProductId INT NOT NULL, 
CONSTRAINT Fk_ProductIdP FOREIGN KEY (Fk_ProductId) REFERENCES Product(ProductId)
);

CREATE TABLE ProductSale
(ProductSaleId INT PRIMARY KEY IDENTITY (1, 1),
Product_id INT NOT NULL,
CONSTRAINT Fk_ProductIdSale FOREIGN KEY (Product_id) REFERENCES Product(ProductId),
BoughtAt DATE NOT NULL
);

INSERT INTO Category ("name")
VALUES
('Animals'),
('Food'),
('Plants');

INSERT INTO Product
("Name", Price, Category_id)
VALUES
('Dog', 500, 1),
('Cat', 300, 1),
('Rat', 50, 1),
('Seeds', 21, 2),
('Pumpkin', 3, 2),
('Banana', 4, 2),
('Tree', 70, 3),
('Orchidea', 15, 3),
('Bruyere', 6, 3);

INSERT INTO ProductSale
(Product_id, BoughtAt)
VALUES
(1, '2019-05-09'),
(2, '2019-06-09'),
(3, '2019-07-09'),
(4, '2019-08-09'),
(5, '2019-09-09'),
(6, '2019-10-09'),
(7, '2019-11-09'),
(8, '2019-12-09'),
(9, '2019-04-09'),
(1, '2019-03-09'),
(2, '2019-02-09'),
(3, '2019-01-09'),
(4, '2019-05-20'),
(5, '2019-05-15'),
(6, '2019-08-10'),
(7, '2019-09-16'),
(8, '2019-12-15'),
(9, '2019-11-18');


INSERT INTO ProductStock
(ProductStockName, Number)
VALUES
('#Seeds', 21),
('#Pumpkin', 3),
('#Banana', 4),
('#Tree', 70),
('#Orchidea', 15),
('#Bruyere', 6);

INSERT INTO ProductStockProduct
(Fk_ProductStockId, Fk_ProductId)
VALUES
(1, 4),
(2, 5),
(3, 6),
(4, 7),
(5, 8),
(6, 9);

-- Renvoyer les stocks de tous les produits d'une seule et même catégorie

SELECT  ProductStock.ProductStockName, ProductStock.Number, Category.Name FROM ProductStock
INNER JOIN ProductStockProduct ON ProductStockProduct.Fk_ProductStockId = ProductStock.ProductStockId
INNER JOIN Product ON Product.ProductId = ProductStockProduct.Fk_ProductId
INNER JOIN Category ON Product.Category_id = Category.CategoryId
WHERE Category.CategoryId = 2;