﻿/*CREATE SCHEMA practice
SELECT *
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'practice';
*/
create database Practice
use Practice

-- Create the Customer table
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(50),
    City VARCHAR(50),
    Grade INT,
    SalesmanID INT
);

-- Create the Salesman table
CREATE TABLE Salesman (
    SalesmanID INT PRIMARY KEY,
    Name VARCHAR(50),
    City VARCHAR(50),
    Commission DECIMAL(5, 2)
);

-- Create the Orders table
CREATE TABLE Orders (
    OrderNo INT PRIMARY KEY,
    PurchaseAmount DECIMAL(10, 2),
    OrderDate DATE,
    CustomerID INT,
    SalesmanID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (SalesmanID) REFERENCES Salesman(SalesmanID)
);

--Tasks 25-03-2025 subqueries
--1. Display Orders Issued by Salesman 'Paul Adam'
SELECT ord_no, purch_amt, ord_date, customer_id, salesman_id
FROM Orders
WHERE salesman_id = (SELECT salesman_id FROM Salesman WHERE name = 'Paul Adam');

--2. Display Orders Generated by London-Based Salespeople

SELECT o.ord_no, o.purch_amt, o.ord_date, o.customer_id, o.salesman_id
FROM Orders o
JOIN Salesman s ON o.salesman_id = s.salesman_id
WHERE s.city = 'London';

--3. Display Orders from Salespeople Handling Customer ID 3007

SELECT ord_no, purch_amt, ord_date, customer_id, salesman_id
FROM Orders
WHERE customer_id = 3007;
--4. Display Orders Exceeding Average Value on 10-Oct-2012

SELECT ord_no, purch_amt, ord_date, customer_id, salesman_id
FROM Orders
WHERE purch_amt > (SELECT AVG(purch_amt) FROM Orders WHERE ord_date = '2012-10-10');

--5. Display Orders Generated in New York City

SELECT ord_no, purch_amt, ord_date, customer_id, salesman_id
FROM Orders o
JOIN Salesman s ON o.salesman_id = s.salesman_id
WHERE s.city = 'New York';

--6. Display Commission of Salespeople in Paris

SELECT commission
FROM Salesman
WHERE city = 'Paris';

--7. Display Customers with ID Below 2001 Under Salesperson Mc Lyon

SELECT *
FROM Customer
WHERE salesman_id = (SELECT salesman_id FROM Salesman WHERE name = 'Mc Lyon')
AND customer_id < 2001;

--8. Count of Customers with Above-Average Grades in New York City

SELECT grade, COUNT(*) AS count
FROM Customer
WHERE city = 'New York' AND grade > (SELECT AVG(grade) FROM Customer WHERE city = 'New York')
GROUP BY grade;

--9. Display Orders of Salespeople with Maximum Commission

SELECT o.ord_no, o.purch_amt, o.ord_date, o.salesman_id
FROM Orders o
JOIN Salesman s ON o.salesman_id = s.salesman_id
WHERE s.commission = (SELECT MAX(commission) FROM Salesman);

--10. Display Customers Who Placed Orders on 17th August 2012

SELECT o.ord_no, o.purch_amt, o.ord_date, o.customer_id, o.salesman_id, c.cust_name
FROM Orders o
JOIN Customer c ON o.customer_id = c.customer_id
WHERE o.ord_date = '2012-08-17';

--11. Display Salespeople with More Than One Customer

SELECT s.salesman_id, s.name
FROM Salesman s
JOIN Customer c ON s.salesman_id = c.salesman_id
GROUP BY s.salesman_id, s.name
HAVING COUNT(c.customer_id) > 1;

--12. Display Orders with Amount Above Average Order Value

SELECT ord_no, purch_amt, ord_date, customer_id, salesman_id
FROM Orders
WHERE purch_amt > (SELECT AVG(purch_amt) FROM Orders);

--13. Display Orders with Amount ≥ Average Order Value

SELECT ord_no, purch_amt, ord_date, customer_id, salesman_id
FROM Orders
WHERE purch_amt >= (SELECT AVG(purch_amt) FROM Orders);

--14. Show Order Sums by Date Exceeding Max Order by 1000

SELECT ord_date, SUM(purch_amt) AS total_amount
FROM Orders
GROUP BY ord_date
HAVING SUM(purch_amt) > (SELECT MAX(purch_amt) + 1000 FROM Orders WHERE ord_date = Orders.ord_date);

--15. Show All Customers If Any Are Located in London

SELECT *
FROM Customer
WHERE EXISTS (SELECT 1 FROM Customer WHERE city = 'London');
--16. Find Salespeople Handling Multiple Customers

SELECT s.salesman_id, s.name, s.city, s.commission
FROM Salesman s
JOIN Customer c ON s.salesman_id = c.salesman_id
GROUP BY s.salesman_id, s.name, s.city, s.commission
HAVING COUNT(c.customer_id) > 1;

--17. Find Salespeople Handling Only One Customer

SELECT s.salesman_id, s.name, s.city, s.commission
FROM Salesman s
JOIN Customer c ON s.salesman_id = c.salesman_id
GROUP BY s.salesman_id, s.name, s.city, s.commission
HAVING COUNT(c.customer_id) = 1;

--18. Find Salespeople Handling Customers with Multiple Orders

SELECT s.salesman_id, s.name, s.city, s.commission
FROM Salesman s
JOIN Customer c ON s.salesman_id = c.salesman_id
WHERE c.customer_id IN (SELECT customer_id FROM Orders GROUP BY customer_id HAVING COUNT(ord_no) > 1);

--19. Find Salespeople in Cities with at Least One Customer

SELECT DISTINCT s.salesman_id, s.name, s.city, s.commission
FROM Salesman s
WHERE s.city IN (SELECT DISTINCT city FROM Customer);
--20. Find Salespeople Living in a Customer City

SELECT DISTINCT s.salesman_id, s.name, s.city, s.commission
FROM Salesman s
WHERE s.city IN (SELECT DISTINCT city FROM Customer);

--21. Find Salespeople with Names Alphabetically Before Customers

SELECT s.salesman_id, s.name, s.city, s.commission
FROM Salesman s
JOIN Customer c ON s.salesman_id = c.salesman_id
WHERE s.name < c.cust_name;

--22. Find Customers with Higher Grade Than Those Below New York

SELECT *
FROM Customer
WHERE grade > (SELECT MAX(grade) FROM Customer WHERE city <> 'New York');

--23. Find Orders Exceeding Any Order from September 10, 2012
SELECT *
FROM Orders
WHERE purch_amt > (SELECT MAX(purch_amt) FROM Orders WHERE ord_date = '2012-09-10');

-----24. Find Orders with Amount Less Than Any Order from London

SELECT *
FROM Orders
WHERE purch_amt < (SELECT MIN(purch_amt) FROM Orders o JOIN Customer c ON o.customer_id = c.customer_id WHERE c.city = "London");

-----25. Find Orders with Amount Less Than the Max Order from London

SELECT *
FROM Orders
WHERE purch_amt < (SELECT MAX(purch_amt) FROM Orders o JOIN Customer c ON o.customer_id = c.customer_id WHERE c.city = 'London');

-----26. Find Customers with Higher Grades Than Those in New York

SELECT *
FROM Customer
WHERE grade > (SELECT MAX(grade) FROM Customer WHERE city = 'New York');

-----27. Calculate Total Order Amount by Salespeople in Customer Cities

SELECT s.name, s.city, SUM(o.purch_amt) AS total_order_amount
FROM Salesman s
JOIN Orders o ON s.salesman_id = o.salesman_id
JOIN Customer c ON o.customer_id = c.customer_id
GROUP BY s.name, s.city;

-----28. Find Customers with Grades Different from Those in London

SELECT *
FROM Customer
WHERE grade NOT IN (SELECT DISTINCT grade FROM Customer WHERE city = 'London');

-----29. Find Customers with Grades Different from Those in Paris

SELECT *
FROM Customer
WHERE grade NOT IN (SELECT DISTINCT grade FROM Customer WHERE city = 'Paris');

-----30. Find Customers with Grades Different from Any in Dallas

SELECT *
FROM Customer
WHERE grade NOT IN (SELECT DISTINCT grade FROM Customer WHERE city = 'Dallas');

-----31. Calculate Average Price of Products by Manufacturer

SELECT c.COM_NAME, AVG(i.PRO_PRICE) AS Average_Price
FROM item_mast i
JOIN company_mast c ON i.PRO_COM = c.COM_ID
GROUP BY c.COM_NAME;

-----32.

SELECT c.COM_NAME, AVG(i.PRO_PRICE) AS Average_Price
FROM item_mast i
JOIN company_mast c ON i.PRO_COM = c.COM_ID
WHERE i.PRO_PRICE >= 350
GROUP BY c.COM_NAME;
-----33. Find Most Expensive Product of Each Company

SELECT i.PRO_NAME, i.PRO_PRICE, c.COM_NAME
FROM item_mast i
JOIN company_mast c ON i.PRO_COM = c.COM_ID
WHERE i.PRO_PRICE = (SELECT MAX(PRO_PRICE) FROM item_mast WHERE PRO_COM = i.PRO_COM);
-----34. Find Employees with Last Name Gabriel or Dosio

SELECT EMP_IDNO, EMP_FNAME, EMP_LNAME, EMP_DEPT
FROM emp_details
WHERE EMP_LNAME IN ('Gabriel', 'Dosio');
-----35. Find Employees in Departments 89 or 63

SELECT EMP_IDNO, EMP_FNAME, EMP_LNAME, EMP_DEPT
FROM emp_details
WHERE EMP_DEPT IN (89, 63);
-----36. Find Employees in Departments with Allotment > Rs. 50000

SELECT e.EMP_FNAME, e.EMP_LNAME
FROM emp_details e
JOIN emp_department d ON e.EMP_DEPT = d.DPT_CODE
WHERE d.DPT_ALLOTMENT > 50000;
-----37. Find Departments with Sanction Amount Above Average

SELECT DPT_CODE, DPT_NAME, DPT_ALLOTMENT
FROM emp_department
WHERE DPT_ALLOTMENT > (SELECT AVG(DPT_ALLOTMENT) FROM emp_department);
-----38. Find Departments with More Than Two Employees

SELECT d.DPT_NAME
FROM emp_department d
JOIN emp_details e ON d.DPT_CODE = e.EMP_DEPT
GROUP BY d.DPT_NAME
HAVING COUNT(e.EMP_IDNO) > 2;
-----39. Find Employees in Departments with Second Lowest Allotment

SELECT e.EMP_FNAME, e.EMP_LNAME
FROM emp_details e
JOIN emp_department d ON e.EMP_DEPT = d.DPT_CODE
WHERE d.DPT_ALLOTMENT = (SELECT DISTINCT DPT_ALLOTMENT FROM emp_department ORDER BY DPT_ALLOTMENT OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY);

--Tasks 24-03-2025
-- Create the Customer table
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(50),
    Location VARCHAR(50),
    Grade INT,
    SalesmanID INT
);

-- Insert data into Customer table
INSERT INTO Customer (CustomerID, Name, Location, Grade, SalesmanID)
VALUES 
    (3002, 'Nick Rimando', 'New York', 100, 5001),
    (3007, 'Brad Davis', 'New York', 200, 5001),
    (3005, 'Graham Zusi', 'California', 200, 5002),
    (3008, 'Julian Green', 'London', 300, 5002),
    (3004, 'Fabian Johnson', 'Paris', 300, 5006),
    (3009, 'Geoff Cameron', 'Berlin', 100, 5003),
    (3003, 'Jozy Altidore', 'Moscow', 200, 5007),
    (3001, 'Brad Guzan', 'London', NULL, 5005);

-- Create the Salesman table
CREATE TABLE Salesman (
    SalesmanID INT PRIMARY KEY,
    Name VARCHAR(50),
    City VARCHAR(50),
    Commission DECIMAL(5, 2)
);

-- Insert data into Salesman table
INSERT INTO Salesman (SalesmanID, Name, City, Commission)
VALUES
    (5001, 'James Hoog', 'New York', 0.15),
    (5002, 'Nail Knite', 'Paris', 0.13),
    (5005, 'Pit Alex', 'London', 0.11),
    (5006, 'Mc Lyon', 'Paris', 0.14),
    (5007, 'Paul Adam', 'Rome', 0.13),
    (5003, 'Lauson Hen', 'San Jose', 0.12);

-- Create the Orders table
CREATE TABLE Orders (
    OrderNo INT PRIMARY KEY,
    PurchaseAmount DECIMAL(10, 2),
    OrderDate DATE,
    CustomerID INT,
    SalesmanID INT
);

-- Insert data into Orders table
INSERT INTO Orders (OrderNo, PurchaseAmount, OrderDate, CustomerID, SalesmanID)
VALUES 
    (70001, 150.5, '2012-10-05', 3005, 5002),
    (70009, 270.65, '2012-09-10', 3001, 5005),
    (70002, 65.26, '2012-10-05', 3002, 5001),
    (70004, 110.5, '2012-08-17', 3009, 5003),
    (70007, 948.5, '2012-09-10', 3005, 5002),
    (70005, 2400.6, '2012-07-27', 3007, 5001),
    (70008, 5760, '2012-09-10', 3002, 5001),
    (70010, 1983.43, '2012-10-10', 3004, 5006),
    (70003, 2480.4, '2012-10-10', 3009, 5003);

-- Create the Employee Department table
CREATE TABLE EmployeeDepartment (
    DepartmentCode INT PRIMARY KEY,
    DepartmentName VARCHAR(50),
    Allotment INT
);

-- Create the Employee Details table
CREATE TABLE EmployeeDetails (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentCode INT,
    FOREIGN KEY (DepartmentCode) REFERENCES EmployeeDepartment(DepartmentCode)
);

-- Create the Company Master table
CREATE TABLE CompanyMaster (
    CompanyID INT PRIMARY KEY,
    CompanyName VARCHAR(50)
);

-- Create the Item Master table
CREATE TABLE ItemMaster (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    ProductPrice DECIMAL(10, 2),
    CompanyID INT,
    FOREIGN KEY (CompanyID) REFERENCES CompanyMaster(CompanyID)
);

-----
SELECT s.Name AS Salesman, c.Name AS Customer, s.Location
FROM Salesman s
JOIN Customer c ON s.Location = c.Location;
-----
SELECT o.OrderNo, o.PurchaseAmount, c.Name AS Customer, c.Location
FROM Orders o
JOIN Customer c ON o.CustomerID = c.CustomerID
WHERE o.PurchaseAmount BETWEEN 500 AND 2000;
-----
SELECT c.Name AS Customer, c.Location, s.Name AS Salesman, s.Commission
FROM Customer c
JOIN Salesman s ON c.SalesmanID = s.SalesmanID;
-----
SELECT c.Name AS Customer, c.Location AS CustomerLocation, s.Name AS Salesman, s.Commission
FROM Customer c
JOIN Salesman s ON c.SalesmanID = s.SalesmanID
WHERE s.Commission > 0.12;
-----
SELECT c.Name AS Customer, 
       c.Location AS CustomerLocation, 
       s.Name AS Salesman, 
       s.Location AS SalesmanLocation, 
       s.Commission
FROM Customer c
JOIN Salesman s ON c.SalesmanID = s.SalesmanID
WHERE s.Location <> c.Location AND s.Commission > 0.12;
-----
SELECT o.OrderNo, 
       o.OrderDate, 
       o.PurchaseAmount, 
       c.Name AS Customer, 
       c.Grade, 
       s.Name AS Salesman, 
       s.Commission
FROM Orders o
JOIN Customer c ON o.CustomerID = c.CustomerID
JOIN Salesman s ON o.SalesmanID = s.SalesmanID;
-----
SELECT o.OrderNo, 
       o.PurchaseAmount, 
       o.OrderDate, 
       c.Name AS Customer, 
       c.Location, 
       c.Grade, 
       s.Name AS Salesman, 
       s.Location AS SalesmanLocation, 
       s.Commission
FROM Orders o
JOIN Customer c ON o.CustomerID = c.CustomerID
JOIN Salesman s ON o.SalesmanID = s.SalesmanID;
-----
SELECT c.Name AS CustomerName,
       c.Location AS CustomerLocation,
       c.Grade,
       s.Name AS SalesmanName,
       s.Location AS SalesmanLocation
FROM Customer c
JOIN Salesman s ON c.SalesmanID = s.SalesmanID
ORDER BY c.CustomerID ASC;
-----
SELECT c.Name AS CustomerName,
       c.Location AS CustomerLocation,
       c.Grade,
       s.Name AS SalesmanName,
       s.Location AS SalesmanLocation
FROM Customer c
JOIN Salesman s ON c.SalesmanID = s.SalesmanID
WHERE c.Grade < 300 OR c.Grade IS NULL
ORDER BY c.CustomerID ASC;
-----
SELECT c.Name AS CustomerName,
       c.Location AS CustomerLocation,
       o.OrderNo AS OrderNumber,
       o.OrderDate AS OrderDate,
       o.PurchaseAmount AS OrderAmount
FROM Customer c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY o.OrderDate ASC, c.CustomerID ASC;
-----
SELECT c.Name AS CustomerName,
       c.Location AS CustomerLocation,
       o.OrderNo AS OrderNumber,
       o.OrderDate AS OrderDate,
       o.PurchaseAmount AS OrderAmount,
       s.Name AS SalesmanName,
       s.Commission,
       CASE
           WHEN o.SalesmanID IS NULL THEN 'No order placed'
           WHEN o.SalesmanID = c.SalesmanID THEN 'Order placed through assigned salesman'
           ELSE 'Order placed through a different salesman'
       END AS OrderStatus
FROM Customer c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN Salesman s ON o.SalesmanID = s.SalesmanID
ORDER BY c.CustomerID ASC, o.OrderDate ASC;
-----
SELECT s.SalesmanID,
       s.Name AS SalesmanName,
       s.Location AS SalesmanLocation,
       s.Commission,
       CASE
           WHEN c.SalesmanID IS NULL THEN 'No customers assigned'
           ELSE 'Has customers'
       END AS Status
FROM Salesman s
LEFT JOIN Customer c ON s.SalesmanID = c.SalesmanID
GROUP BY s.SalesmanID, s.Name, s.Location, s.Commission, c.SalesmanID
ORDER BY s.SalesmanID ASC;
-----
SELECT s.SalesmanID,
       s.Name AS SalesmanName,
       s.Location AS SalesmanLocation,
       s.Commission,
       c.CustomerID,
       c.Name AS CustomerName,
       c.Location AS CustomerLocation,
       c.Grade,
       o.OrderNo,
       o.OrderDate,
       o.PurchaseAmount
FROM Salesman s
LEFT JOIN Customer c ON s.SalesmanID = c.SalesmanID
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY s.SalesmanID ASC, c.CustomerID ASC, o.OrderDate ASC;
-----
SELECT s.SalesmanID,
       s.Name AS SalesmanName,
       s.Location AS SalesmanLocation,
       s.Commission,
       c.CustomerID,
       c.Name AS CustomerName,
       c.Location AS CustomerLocation,
       c.Grade,
       o.OrderNo,
       o.OrderDate,
       o.PurchaseAmount
FROM Salesman s
LEFT JOIN Customer c ON s.SalesmanID = c.SalesmanID
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID 
    AND (o.PurchaseAmount >= 2000 OR o.OrderNo IS NULL)
WHERE c.Grade IS NOT NULL OR c.CustomerID IS NULL 
ORDER BY s.SalesmanID ASC, c.CustomerID ASC, o.OrderDate ASC;
-----
SELECT COALESCE(c.Name, 'Unknown') AS CustomerName,
       COALESCE(c.Location, 'Unknown') AS City,
       o.OrderNo,
       o.OrderDate,
       o.PurchaseAmount
FROM Orders o
LEFT JOIN Customer c ON o.CustomerID = c.CustomerID
WHERE c.CustomerID IS NOT NULL 
    OR o.CustomerID NOT IN (SELECT CustomerID FROM Customer) 
ORDER BY c.Name ASC, o.OrderDate ASC;
-----
SELECT COALESCE(c.Name, 'Unknown') AS CustomerName,
       COALESCE(c.Location, 'Unknown') AS City,
       o.OrderNo,
       o.OrderDate,
       o.PurchaseAmount
FROM Orders o
LEFT JOIN Customer c ON o.CustomerID = c.CustomerID
WHERE (c.Grade IS NOT NULL AND c.Grade > 0)
    OR (c.CustomerID IS NULL OR c.Grade IS NULL)
ORDER BY c.Name ASC, o.OrderDate ASC;
-----
SELECT s.SalesmanID,
       s.Name AS SalesmanName,
       s.Location AS SalesmanLocation,
       s.Commission,
       c.CustomerID,
       c.Name AS CustomerName,
       c.Location AS CustomerLocation,
       c.Grade
FROM Salesman s
CROSS JOIN Customer c
ORDER BY s.SalesmanID, c.CustomerID;
-----
SELECT s.SalesmanID,
       s.Name AS SalesmanName,
       s.Location AS SalesmanLocation,
       s.Commission,
       c.CustomerID,
       c.Name AS CustomerName,
       c.Location AS CustomerLocation,
       c.Grade
FROM Salesman s
CROSS JOIN Customer c
WHERE s.Location = c.Location
ORDER BY s.SalesmanID, c.CustomerID;
-----
SELECT s.SalesmanID,
       s.Name AS SalesmanName,
       s.Location AS SalesmanLocation,
       s.Commission,
       c.CustomerID,
       c.Name AS CustomerName,
       c.Location AS CustomerLocation,
       c.Grade
FROM Salesman s
CROSS JOIN Customer c
WHERE s.Location IS NOT NULL
    AND c.Grade IS NOT NULL
ORDER BY s.SalesmanID, c.CustomerID;
-----
SELECT s.SalesmanID,
       s.Name AS SalesmanName,
       s.Location AS SalesmanLocation,
       s.Commission,
       c.CustomerID,
       c.Name AS CustomerName,
       c.Location AS CustomerLocation,
       c.Grade
FROM Salesman s
CROSS JOIN Customer c
WHERE s.Location IS NOT NULL
    AND c.Grade IS NOT NULL
    AND s.Location <> c.Location
ORDER BY s.SalesmanID, c.CustomerID;
-----
SELECT i.ProductID,
       i.ProductName,
       i.ProductPrice,
       i.CompanyID,
       c.CompanyName
FROM ItemMaster i
INNER JOIN CompanyMaster c ON i.CompanyID = c.CompanyID
ORDER BY i.ProductID;
-----
SELECT i.ProductName AS ItemName,
       i.ProductPrice AS Price,
       c.CompanyName AS CompanyName
FROM ItemMaster i
INNER JOIN CompanyMaster c ON i.CompanyID = c.CompanyID
ORDER BY i.ProductName;
-----
SELECT c.CompanyName AS CompanyName,
       ROUND(AVG(i.ProductPrice), 2) AS AveragePrice
FROM ItemMaster i
INNER JOIN CompanyMaster c ON i.CompanyID = c.CompanyID
GROUP BY c.CompanyName
ORDER BY AveragePrice DESC;
-----
SELECT c.CompanyName AS CompanyName,
       ROUND(AVG(i.ProductPrice), 2) AS AveragePrice
FROM ItemMaster i
INNER JOIN CompanyMaster c ON i.CompanyID = c.CompanyID
GROUP BY c.CompanyName
HAVING AVG(i.ProductPrice) >= 350
-----
SELECT i.ProductName AS ProductName,
       i.ProductPrice AS ProductPrice,
       c.CompanyName AS CompanyName
FROM ItemMaster i
INNER JOIN CompanyMaster c ON i.CompanyID = c.CompanyID
WHERE i.ProductPrice = (
    SELECT MAX(im.ProductPrice)
    FROM ItemMaster im
    WHERE im.CompanyID = i.CompanyID
);
----
SELECT e.EmployeeID AS EmployeeID,
       e.FirstName AS FirstName,
       e.LastName AS LastName,
       e.DepartmentCode AS DepartmentCode,
       d.DepartmentName AS DepartmentName,
       d.Allotment AS DepartmentAllotment
FROM EmployeeDetails e
INNER JOIN EmployeeDepartment d ON e.DepartmentCode = d.DepartmentCode;

-----
SELECT e.FirstName AS FirstName,
       e.LastName AS LastName,
       d.DepartmentName AS DepartmentName,
       d.Allotment AS SanctionAmount
FROM EmployeeDetails e
INNER JOIN EmployeeDepartment d ON e.DepartmentCode = d.DepartmentCode;


-----
SELECT e.FirstName AS FirstName,
       e.LastName AS LastName
FROM EmployeeDetails e
INNER JOIN EmployeeDepartment d ON e.DepartmentCode = d.DepartmentCode
WHERE d.Allotment > 50000;

-----
SELECT d.DepartmentName
FROM EmployeeDepartment d
INNER JOIN EmployeeDetails e ON d.DepartmentCode = e.DepartmentCode
GROUP BY d.DepartmentName
HAVING COUNT(e.EmployeeID) > 2;



--Tasks-21-3-2-TaslsSQL2-word
--1. Display all information about all salespeople

SELECT * FROM salesman;
--2. Display specific columns (names and commissions) for all salespeople

SELECT name, commission FROM salesman;
--3. Display columns in a specific order for all orders

SELECT ord_date, salesman_id, ord_no, purch_amt FROM orders;
--4. Identify unique salesperson IDs

SELECT DISTINCT salesman_id FROM orders;
--5. Locate salespeople who live in the city of 'Paris'

SELECT name, city FROM salesman WHERE city = 'Paris';
--6. Find customers whose grade is 200

SELECT customer_id, cust_name, city, grade, salesman_id 
FROM customer 
WHERE grade = 200;
--7. Find orders delivered by a salesperson with ID 5001

SELECT ord_no, ord_date, purch_amt 
FROM orders 
WHERE salesman_id = 5001;
--8. Find Nobel Prize winners for the year 1970

SELECT YEAR, SUBJECT, WINNER 
FROM nobel_win 
WHERE YEAR = 1970;
--9. Combine winners in Physics, 1970 and in Economics, 1971

SELECT YEAR, SUBJECT, WINNER, COUNTRY, CATEGORY 
FROM nobel_win 
WHERE (YEAR = 1970 AND SUBJECT = 'Physics') 
   OR (YEAR = 1971 AND SUBJECT = 'Economics');
--10. Combine winners in 'Physiology' before 1971 and winners in 'Peace' on or after 1974

SELECT YEAR, SUBJECT, WINNER, COUNTRY, CATEGORY 
FROM nobel_win 
WHERE (YEAR < 1971 AND SUBJECT = 'Physiology') 
   OR (YEAR >= 1974 AND SUBJECT = 'Peace');

-- Practice1 DDL -----------------------------------------------------------------------------------
-- Task 1: Create TRG_DEPT table
CREATE TABLE TRG_DEPT (
    ID INT,
    NAME VARCHAR(25)
);
-- Confirm table creation
EXEC sp_help TRG_DEPT;

-- Task 2: Populate TRG_DEPT with data from DEPARTMENTS
INSERT INTO TRG_DEPT (ID, NAME)
SELECT DEPARTMENT_ID, DEPARTMENT_NAME FROM DEPARTMENTS;

-- Confirm data insertion
SELECT * FROM TRG_DEPT;

-- Task 3: Create TRG_EMP table
CREATE TABLE TRG_EMP (
    ID INT,
    LAST_NAME VARCHAR(25),
    FIRST_NAME VARCHAR(25),
    DEPT_ID INT
);
-- Confirm table creation
EXEC sp_help TRG_EMP;

-- Task 4: Modify TRG_EMP to allow longer LAST_NAME values
ALTER TABLE TRG_EMP ALTER COLUMN LAST_NAME VARCHAR(50);
-- Confirm modification
EXEC sp_help TRG_EMP;

-- Task 5: Create TRG_EMPLOYEES table with specific columns from EMPLOYEES
SELECT EMPLOYEE_ID AS ID, FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID AS DEPT_ID 
INTO TRG_EMPLOYEES
FROM EMPLOYEES;

-- Confirm table creation
EXEC sp_help TRG_EMPLOYEES;

-- Task 6: Drop TRG_EMP table
DROP TABLE TRG_EMP;
-- Confirm deletion
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TRG_EMP';

-- Task 7: Rename TRG_EMPLOYEES to TRG_EMP
EXEC sp_rename 'TRG_EMPLOYEES', 'TRG_EMP';
-- Confirm renaming
EXEC sp_help TRG_EMP;

-- Task 8: Drop FIRST_NAME column from TRG_EMP
ALTER TABLE TRG_EMP DROP COLUMN FIRST_NAME;
-- Confirm modification
EXEC sp_help TRG_EMP;

-----Scenario-Questions--
--1. Extracting Data with Conditions

SELECT Name 
FROM Employees 
WHERE Department = 'HR' AND Salary > 50000;
--2. Finding Duplicate Records

SELECT CustomerID, COUNT(*) AS DuplicateCount 
FROM Orders 
GROUP BY CustomerID 
HAVING COUNT(*) > 1;
--3. Aggregating Data

SELECT ProductID, SUM(Quantity) AS TotalQuantitySold 
FROM Sales 
GROUP BY ProductID;
--4. Date Range Queries

SELECT * 
FROM Transactions 
WHERE TransactionDate >= DATEADD(DAY, -30, GETDATE());
--5. Updating Records

UPDATE Products 
SET Price = Price * 1.10 
WHERE StockQuantity < 100;

--6. Deleting Specific Records
Delete all users whose status is ‘inactive’ and have not logged in for the past year

DELETE FROM Users 
WHERE Status = 'inactive' AND LastLogin < DATEADD(YEAR, -1, GETDATE());

--7. Joining Multiple Tables

SELECT c.CustomerID, c.Name, SUM(o.TotalAmount) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name;
--8. Subqueries

SELECT Name 
FROM Employees e 
WHERE Salary > (
    SELECT AVG(Salary) 
    FROM Employees 
    WHERE Department = e.Department
);
--9. Handling NULL Values

SELECT ProductName, 
       ISNULL(Discount, 'No Discount') AS Discount
FROM Products;

--10. Ranking and Window Functions
SELECT SaleID, ProductID, SaleAmount, SaleDate,
       RANK() OVER (PARTITION BY ProductID ORDER BY SaleAmount DESC) AS SaleRank
FROM Sales;
--11. Fetch values in test_a that are and are not in test_b without using the NOT keyword
Fetch values in test_a that are not in test_b using a LEFT JOIN

SELECT a.id 
FROM test_a a
LEFT JOIN test_b b ON a.id = b.id
WHERE b.id IS NULL;
Find the 10th highest employee salary from an Employee table
Query to find the 10th highest salary

SELECT DISTINCT Salary 
FROM Employee e1 
WHERE (
    SELECT COUNT(DISTINCT Salary) 
    FROM Employee e2 
    WHERE e2.Salary > e1.Salary
) = 9;  

UPDATE YourTable
SET Col2 = CASE 
               WHEN Col1 = 1 THEN 0 
               WHEN Col1 = 0 THEN 1 
           END;



-- Practice DML-1 -------------------------------------------------------
-- Describe the structure of MY_EMPLOYEE table
EXEC sp_help MY_EMPLOYEE;

-- Insert data without listing columns
INSERT INTO MY_EMPLOYEE VALUES (1, 'Patel', 'Ralph', 'rpatel', 895);

-- Insert data explicitly listing columns
INSERT INTO MY_EMPLOYEE (ID, LAST_NAME, FIRST_NAME, USERID, SALARY)
VALUES (2, 'Dancs', 'Betty', 'bdancs', 860);

-- Confirm additions to the table
SELECT * FROM MY_EMPLOYEE;

-- Insert data using variables and generate USERID dynamically
DECLARE @ID INT, @LAST_NAME VARCHAR(50), @FIRST_NAME VARCHAR(50), @SALARY INT;
SET @ID = 3;
SET @LAST_NAME = 'Smith';
SET @FIRST_NAME = 'John';
SET @SALARY = 950;

INSERT INTO MY_EMPLOYEE (ID, LAST_NAME, FIRST_NAME, USERID, SALARY)
VALUES (@ID, @LAST_NAME, @FIRST_NAME, LEFT(@FIRST_NAME,1) + LEFT(@LAST_NAME,7), @SALARY);

-- Update last name of employee with ID = 3 to Drexler
UPDATE MY_EMPLOYEE 
SET LAST_NAME = 'Drexler' 
WHERE ID = 3;

-- Update salary to 1000 for all employees with a salary less than 900
UPDATE MY_EMPLOYEE 
SET SALARY = 1000 
WHERE SALARY < 900;

-- Delete Betty Dancs from MY_EMPLOYEE table
DELETE FROM MY_EMPLOYEE 
WHERE LAST_NAME = 'Dancs' AND FIRST_NAME = 'Betty';

-- Empty the entire table (delete all records)
DELETE FROM MY_EMPLOYEE;
-- or alternatively
-- TRUNCATE TABLE MY_EMPLOYEE;

--Tasks--20-3-25--
--TASK 01--
CREATE TABLE Member (
    member_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    age INT CHECK(age >10)
);

INSERT INTO Member VALUES
(1, 'Raj', 'Tamilnadu', 22),
(2, 'Shidhi', 'Pondycherry', 28),
(3, 'Logitha', 'Kerala', 25);

UPDATE Member
SET city = 'Hyderabad'
WHERE member_id = 2;

SELECT * FROM Members;

--TASK 02--
CREATE TABLE children (
    id VARCHAR(50),
    name VARCHAR(50),
    grade VARCHAR(50),
    marks INT
);

INSERT INTO children VALUES
(704, 'Grace', 'Grade 8', 99),
(502, 'Cherry', 'Grade 9', 78);

SELECT * FROM children;


UPDATE TOP (1) children
SET id = 12 
WHERE name = 'cherry';

SELECT * FROM children;

--TASK 03--

CREATE TABLE workers (
    id VARCHAR(20),
    name VARCHAR(20) NOT NULL, 
    salary MONEY
);

ALTER TABLE workers
ADD CONSTRAINT chk_salary CHECK (salary > 25000);

CREATE TABLE TRG_DEPT (
    ID INT PRIMARY KEY,
    NAME VARCHAR(25)
);

CREATE TABLE TRG_EMP (
    ID INT PRIMARY KEY,
    LAST_NAME VARCHAR(25),
    FIRST_NAME VARCHAR(25),
    DEPT_ID INT
);

CREATE TABLE TRG_EMPLOYEES (
    ID INT PRIMARY KEY,
    FIRST_NAME VARCHAR(25),
    LAST_NAME VARCHAR(25),
    SALARY DECIMAL(10, 2),
    DEPT_ID INT
);

CREATE TABLE Member (
    member_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    age INT CHECK(age > 10)
);

CREATE TABLE children (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(50),
    grade VARCHAR(50),
    marks INT
);

CREATE TABLE workers (
    id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    salary MONEY,
    CONSTRAINT chk_salary CHECK (salary > 25000)
);
INSERT INTO TRG_DEPT (ID, NAME) VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'IT'),
(4, 'Marketing'),
(5, 'Sales'),
(6, 'Customer Support'),
(7, 'Research and Development'),
(8, 'Logistics'),
(9, 'Legal'),
(10, 'Administration');
INSERT INTO TRG_EMP (ID, LAST_NAME, FIRST_NAME, DEPT_ID) VALUES
(1, 'Doe', 'John', 1),
(2, 'Smith', 'Jane', 2),
(3, 'Brown', 'James', 3),
(4, 'Taylor', 'Emma', 4),
(5, 'Johnson', 'Michael', 5),
(6, 'Williams', 'Sarah', 6),
(7, 'Jones', 'David', 7),
(8, 'Garcia', 'Linda', 8),
(9, 'Martinez', 'Robert', 9),
(10, 'Hernandez', 'Jessica', 10);
INSERT INTO TRG_EMPLOYEES (ID, FIRST_NAME, LAST_NAME, SALARY, DEPT_ID) VALUES
(1, 'Alice', 'Johnson', 50000, 1),
(2, 'Bob', 'Williams', 60000, 2),
(3, 'Charlie', 'Jones', 55000, 3),
(4, 'Daisy', 'Garcia', 70000, 4),
(5, 'Eve', 'Martinez', 65000, 5),
(6, 'Frank', 'Davis', 72000, 6),
(7, 'Grace', 'Lopez', 58000, 7),
(8, 'Henry', 'Gonzalez', 62000, 8),
(9, 'Ivy', 'Wilson', 59000, 9),
(10, 'Jack', 'Anderson', 75000, 10);
INSERT INTO Member (member_id, name, city, age) VALUES
(1, 'Raj', 'Tamilnadu', 22),
(2, 'Shidhi', 'Pondycherry', 28),
(3, 'Logitha', 'Kerala', 25),
(4, 'Anil', 'Delhi', 30),
(5, 'Priya', 'Mumbai', 26),
(6, 'Ravi', 'Bangalore', 35),
(7, 'Neha', 'Chennai', 24),
(8, 'Kiran', 'Hyderabad', 29),
(9, 'Sita', 'Kolkata', 31),
(10, 'Amit', 'Ahmedabad', 27);
INSERT INTO children (id, name, grade, marks) VALUES
('704', 'Grace', 'Grade 8', 99),
('502', 'Cherry', 'Grade 9', 78),
('101', 'Tom', 'Grade 7', 85),
('102', 'Jerry', 'Grade 6', 90),
('103', 'Mickey', 'Grade 8', 88),
('104', 'Donald', 'Grade 9', 92),
('105', 'Pluto', 'Grade 7', 80),
('106', 'Goofy', 'Grade 6', 75),
('107', 'Daisy', 'Grade 8', 95),
('108', 'Minnie', 'Grade 9', 89);
INSERT INTO workers (id, name, salary) VALUES
('W001', 'Alice', 30000),
('W002', 'Bob', 40000),
('W003', 'Charlie', 50000),
('W004', 'Diana', 60000),
('W005', 'Edward', 70000),
('W006', 'Fiona', 80000),
('W007', 'George', 90000),
('W008', 'Hannah', 100000),
('W009', 'Ian', 110000),
('W010', 'Julia', 120000);
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(50),
    City VARCHAR(50),
    Grade INT,
    SalesmanID INT
);
CREATE TABLE Salesman (
    SalesmanID INT PRIMARY KEY,
    Name VARCHAR(50),
    City VARCHAR(50),
    Commission DECIMAL(5, 2)
);
CREATE TABLE Orders (
    OrderNo INT PRIMARY KEY,
    PurchaseAmount DECIMAL(10, 2),
    OrderDate DATE,
    CustomerID INT,
    SalesmanID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (SalesmanID) REFERENCES Salesman(SalesmanID)
);
INSERT INTO Customer (CustomerID, Name, City, Grade, SalesmanID) VALUES
(3001, 'Brad Guzan', 'London', 100, 5005),
(3002, 'Nick Rimando', 'New York', 200, 5001),
(3003, 'Jozy Altidore', 'Moscow', 200, 5007),
(3004, 'Fabian Johnson', 'Paris', 300, 5006),
(3005, 'Graham Zusi', 'California', 200, 5002),
(3006, 'Clint Dempsey', 'Chicago', 250, 5003),
(3007, 'Brad Davis', 'New York', 200, 5001),
(3008, 'Julian Green', 'London', 300, 5002),
(3009, 'Geoff Cameron', 'Berlin', 100, 5003),
(3010, 'Tim Howard', 'New York', 150, 5004);
INSERT INTO Salesman (SalesmanID, Name, City, Commission) VALUES
(5001, 'James Hoog', 'New York', 0.15),
(5002, 'Nail Knite', 'Paris', 0.13),
(5003, 'Lauson Hen', 'San Jose', 0.12),
(5004, 'Pit Alex', 'London', 0.11),
(5005, 'Paul Adam', 'Rome', 0.13),
(5006, 'Mc Lyon', 'Paris', 0.14),
(5007, 'Brad Davis', 'New York', 0.15),
(5008, 'Clint Dempsey', 'Chicago', 0.12),
(5009, 'Graham Zusi', 'California', 0.13),
(5010, 'Tim Howard', 'New York', 0.14);
INSERT INTO Orders (OrderNo, PurchaseAmount, OrderDate, CustomerID, SalesmanID) VALUES
(70001, 150.50, '2012-10-05', 3002, 5001),
(70002, 65.26, '2012-10-05', 3001, 5001),
(70003, 2480.40, '2012-10-10', 3009, 5003),
(70004, 110.50, '2012-08-17', 3009, 5003),
(70005, 2400.60, '2012-07-27', 3007, 5001),
(70006, 270.65, '2012-09-10', 3001, 5005),
(70007, 948.50, '2012-09-10', 3005, 5002),
(70008, 5760.00, '2012-09-10', 3002, 5001),
(70009, 1983.43, '2012-10-10', 3004, 5006),
(70010, 1500.00, '2012-10-12', 3006, 5003);
