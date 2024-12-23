# 🚀 Dive into the SaleOrderQuiz Database: A Hands-On SQL Learning Journey 🚀

Welcome to an interactive exploration of SQL through the **SaleOrderQuiz** database! This guide uses a practical example to illustrate fundamental and intermediate SQL principles. Let's embark on this exciting journey together!

## 🛠️ Setting the Stage: Database Management

```sql
-- Creating a database (if it doesn't already exist)
CREATE DATABASE IF NOT EXISTS SaleOrderQuiz;
-- Selecting the active database
USE SaleOrderQuiz;
```

Here, we demonstrate the core principles of **database management**: **creation** (`CREATE DATABASE`) and **selection** (`USE`). The `IF NOT EXISTS` clause illustrates **idempotency**, ensuring the script can be run repeatedly without errors.

## 🧹 Starting Fresh: Table Management

```sql
-- Dropping tables (if they exist) for a clean start
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Inventories;
DROP TABLE IF EXISTS Employees;
```

This section focuses on **table management**, specifically **dropping tables** (`DROP TABLE`). The `IF EXISTS` clause again demonstrates **idempotency**.

## 🏗️ Building Blocks: Data Definition Language (DDL)

This part showcases **Data Definition Language (DDL)**, used to define the structure of the database.

### 👤 Defining Tables and Columns

```sql
-- Defining the Customers table
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
```

This illustrates defining a **table** (`CREATE TABLE`) with various **columns**, each having a specific **data type** (`INT`, `VARCHAR`, `CHAR`) and **constraints** (`NOT NULL`, `NULL`). The `PRIMARY KEY` constraint is introduced for **unique identification**.

### 📦 Choosing Appropriate Data Types

```sql
-- Defining the Inventories table
CREATE TABLE Inventories(
    InventoryID TINYINT NOT NULL,
    InventoryName VARCHAR(50) NOT NULL,
    InventoryDescription VARCHAR(255) NULL,
    PRIMARY KEY(InventoryID)
);
```

The use of `TINYINT` demonstrates the principle of choosing **appropriate data types** for efficiency.

### 💼 Ensuring Data Integrity with Constraints

```sql
-- Defining the Employees table
CREATE TABLE Employees(
    EmployeeID TINYINT NOT NULL,
    EmployeeFirstName VARCHAR(50) NOT NULL,
    EmployeeLastName VARCHAR(50) NOT NULL,
    EmployeeExtension CHAR(4) NULL,
    PRIMARY KEY(EmployeeID)
);
```

Constraints like `NOT NULL` are crucial for ensuring **data integrity**.

### 🛒 Establishing Relationships with Foreign Keys

```sql
-- Defining the Sales table with foreign key relationships
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
```

This showcases the principle of establishing **relationships between tables** using **foreign keys**, ensuring **referential integrity**.

## 💉 Populating Our Database: Data Manipulation Language (DML)

This section demonstrates **Data Manipulation Language (DML)**, used to manipulate data within the database.

```sql
-- Inserting data into the Customers table
INSERT INTO Customers (CustomerID, CustomerFirstName, CustomerLastName, CustomerAddress, CustomerCity, CustomerPostCode, CustomerPhoneNumber) VALUES
(1, 'Ilyass', 'Anida', 'Wakanda', 'Safi', '4600', '0612345678'),
(2, 'Fatima', 'Zahrae', 'Rue Al Qods', 'Marrakech', '4000', '0698765432'),
(3, 'Ahmed', 'Benali', 'Avenue Hassan II', 'New York', '2000', '0655555555');
```

The `INSERT INTO` statement is a fundamental DML operation for **data population**.

```sql
-- Inserting data into other tables (Inventories, Employees, Sales)
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
```

## 📊 Time to See Our Data: Basic Queries

This section focuses on basic **data retrieval** using the `SELECT` statement.

```sql
-- Selecting all columns from a table
SELECT * FROM Customers;
```

This demonstrates selecting all columns.

```sql
-- Selecting all columns and creating a calculated column with an alias
SELECT *, (Sales.SaleQuantity * Sales.SaleUnitPrice) as totalPrice FROM Sales;
```

This introduces the concept of **calculated columns** and using **aliases**.

```sql
-- Using subqueries for more complex data retrieval
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
```

This illustrates the use of **subqueries** for filtering and aggregating data.

## 🛠️ Making Changes: Modifying Data

This section demonstrates principles of **data modification**.

```sql
-- Adding a new column to a table
ALTER TABLE Customers
ADD CustomerEmail VARCHAR(255);
```

The `ALTER TABLE` statement is used for **schema modification**.

```sql
-- Updating data in a table based on a condition
UPDATE Customers
SET CustomerEmail = "ilyass@gmail.com"
WHERE CustomerID = 1;
```

The `UPDATE` statement is used for **data updates**, emphasizing the importance of the `WHERE` clause.

## 🗑️ Removing Data: Deleting Records

This section focuses on **data removal**.

```sql
-- Deleting data from a table based on a condition using a subquery
DELETE FROM Sales
WHERE CustomerID IN (SELECT CustomerID FROM Customers WHERE CustomerCity = "New York");

-- Deleting data from a table based on a condition
DELETE FROM Customers
WHERE CustomerCity = "New York";
```

The `DELETE FROM` statement is used for **data deletion**, highlighting the consideration of **referential integrity**.

## 🚀 Taking it Further: Advanced Queries

This section explores more advanced querying techniques.

```sql
-- Filtering data based on date ranges
SELECT * FROM Sales
WHERE Sales.SaleDate > NOW() - INTERVAL 30 DAY;
```

This demonstrates filtering using **date functions**.

```sql
-- Filtering data based on aggregate functions in subqueries
SELECT * FROM Customers
WHERE (
    SELECT MAX(Sales.SaleQuantity)
    FROM Sales
    WHERE Sales.CustomerID = Customers.CustomerID
    ) > 5;
```

This illustrates advanced filtering using **aggregate functions** within subqueries.

```sql
-- Joining tables to retrieve data from multiple sources and grouping results
SELECT
    Inventories.InventoryName,
    SUM(Sales.SaleQuantity * Sales.SaleUnitPrice)
    as TotalRevenue
FROM Sales
JOIN Inventories
ON Inventories.InventoryID = Sales.InventoryID
GROUP BY Inventories.InventoryName;
```

This showcases **joining tables** and using the `GROUP BY` clause with **aggregate functions**.

### 🎭 Views: Abstraction and Simplified Queries

```sql
-- Creating a view to simplify complex joins
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

-- Querying the view
SELECT * FROM CustomerSalesView;
```

This introduces **views** as a way to **abstract complex queries**.

### ⚙️ Stored Procedures: Reusability and Efficiency

```sql
-- Creating a stored procedure for reusable queries
CREATE PROCEDURE purchasesOfClient (IN ID INT)
BEGIN
    SELECT * FROM Sales
    WHERE Sales.CustomerID = ID;
END;

-- Calling the stored procedure
CALL purchasesOfClient(1);
```

This demonstrates the principle of **code reusability** and efficiency using **stored procedures**.

This guide uses the `SaleOrderQuiz` database as a practical example to illustrate fundamental and intermediate SQL principles. Understanding these principles is crucial for effective database management and data manipulation. Keep exploring and experimenting!
