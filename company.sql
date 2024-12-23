CREATE DATABASE IF NOT EXISTS SaleOrderQuiz;
USE SaleOrderQuiz;

DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Inventories;
DROP TABLE IF EXISTS Employees;

-- Create database tables --

CREATE TABLE Customers(
    CustomerID INT NOT NULL,
    CustomerFirstName VARCHAR(50) NOT NULL,
    CustomerLastName VARCHAR(50) NOT NULL,
    CustomerAddress VARCHAR(50) NOT NULL,
    CustomerCity VARCHAR(50) NOT NULL,
    CustomerPostCode CHAR(4) NULL,
    CustomerPhoneNumber CHAR(12) NULL,
    PRIMARY KEY(CustomerID)
);

CREATE TABLE Inventories(
    InventoryID TINYINT NOT NULL,
    InventoryName VARCHAR(50) NOT NULL,
    InventoryDescription VARCHAR(255) NULL,
    PRIMARY KEY(InventoryID)
);

CREATE TABLE Employees(
    EmployeeID TINYINT NOT NULL,
    EmployeeFirstName VARCHAR(50) NOT NULL,
    EmployeeLastName VARCHAR(50) NOT NULL,
    EmployeeExtension CHAR(4) NULL,
    PRIMARY KEY(EmployeeID)
);

CREATE TABLE Sales(
    SaleID TINYINT NOT NULL,
    CustomerID INT NOT NULL,
    InventoryID TINYINT NOT NULL,
    EmployeeID TINYINT NOT NULL,
    SaleDate DATE NOT NULL,
    SaleQuantity INT NOT NULL,
    SaleUnitPrice INT NOT NULL,
    PRIMARY KEY(SaleID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (InventoryID) REFERENCES Inventories(InventoryID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);


-- Insert fake data --

INSERT INTO Customers (CustomerID, CustomerFirstName, CustomerLastName, CustomerAddress, CustomerCity, CustomerPostCode, CustomerPhoneNumber) VALUES
(1, 'Ilyass', 'Anida', '7ay Anas', 'Safi', '4600', '0612345678'),
(2, 'Fatima', 'Zahrae', 'Rue Al Qods', 'Marrakech', '4000', '0698765432'),
(3, 'Ahmed', 'Benali', 'Avenue Hassan II', 'New York', '2000', '0655555555');

INSERT INTO Inventories (InventoryID, InventoryName, InventoryDescription) VALUES
(1, 'Laptop', 'High-performance laptop with 16GB RAM and 1TB SSD.'),
(2, 'Monitor', '27-inch curved monitor with 144Hz refresh rate.'),
(3, 'Keyboard', 'Mechanical keyboard with RGB backlighting.');

INSERT INTO Employees (EmployeeID, EmployeeFirstName, EmployeeLastName, EmployeeExtension) VALUES
(1, 'Salma', 'Elalami', '1234'),
(2, 'Youssef', 'Khattabi', '5678'),
(3, 'Nadia', 'Fassi', '9012');

INSERT INTO Sales (SaleID, CustomerID, InventoryID, EmployeeID, SaleDate, SaleQuantity, SaleUnitPrice) VALUES
(1, 1, 1, 3, '2023-10-26', 7, 1200.00),
(2, 2, 2, 2, '2023-10-25', 3, 300.50),
(3, 3, 3, 3, '2023-10-24', 3, 75.99),
(4, 1, 1, 2, '2023-10-26', 2, 1200.00),
(5, 1, 2, 3, '2023-10-25', 2, 300.50),
(6, 3, 3, 3, '2023-10-24', 4, 75.99);



-- Show data --

SELECT * FROM Customers;

SELECT *, (Sales.SaleQuantity * Sales.SaleUnitPrice) as totalPrice FROM Sales;

SELECT 
    Employees.*,
    (SELECT  SUM(Sales.SaleQuantity * Sales.SaleUnitPrice)
    FROM Sales
    WHERE Sales.EmployeeID = Employees.EmployeeID)
    as totalSales
FROM Employees
WHERE (
    SELECT COUNT(*) FROM Sales
    WHERE Employees.EmployeeID  = Sales.EmployeeID
    ) >= 1;


-- Modifications

ALTER TABLE Customers
ADD CustomerEmail VARCHAR(255);

UPDATE Customers
SET CustomerEmail = "ilyass@gmail.com"
WHERE CustomerID = 1;

DELETE FROM Sales
WHERE CustomerID IN (SELECT CustomerID FROM Customers WHERE CustomerCity = "New York");

DELETE FROM Customers
WHERE CustomerCity = "New York";

-- Advanced select --

SELECT * FROM Sales
WHERE Sales.SaleDate > NOW() - INTERVAL 30 DAY;

SELECT * FROM Customers
WHERE (
    SELECT MAX(Sales.SaleQuantity)
    FROM Sales
    WHERE Sales.CustomerID = Customers.CustomerID
    ) > 5;


SELECT 
    Inventories.InventoryName,
    SUM(Sales.SaleQuantity * Sales.SaleUnitPrice)
    as TotalRevenue
FROM Sales
JOIN Inventories
ON Inventories.InventoryID = Sales.InventoryID
GROUP BY Inventories.InventoryName;


-- Bonus --

CREATE VIEW CustomerSalesView AS
SELECT
    Customers.CustomerFirstName,
    Customers.CustomerLastName,
    Sales.SaleDate,
    Inventories.InventoryName,
    Sales.SaleQuantity,
    Sales.SaleQuantity * Sales.SaleUnitPrice as TotalAmount
FROM Sales
JOIN Customers
ON Customers.CustomerID = Sales.CustomerID
JOIN Inventories
ON Inventories.InventoryID = Sales.InventoryID;

SELECT * FROM CustomerSalesView;


-- Procedurs --

CREATE PROCEDURE purchasesOfClient (IN ID INT)
BEGIN
    SELECT * FROM Sales
    WHERE Sales.CustomerID = ID;
END;

CALL purchasesOfClient(1);