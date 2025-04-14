USE TechShop;
-- task 1
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    Address VARCHAR(255)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100),
    Description TEXT,
    Price DECIMAL(10, 2)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT,
    QuantityInStock INT,
    LastStockUpdate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Customers (FirstName, LastName, Email, Phone, Address) VALUES
('Ravi', 'Kumar', 'ravi.kumar@email.com', '9876543210', 'Chennai'),
('Sneha', 'Patel', 'sneha.patel@email.com', '9123456789', 'Mumbai'),
('Arjun', 'Singh', 'arjun.singh@email.com', '9988776655', 'Delhi'),
('Anjali', 'Sharma', 'anjali.sharma@email.com', '9871234567', 'Bangalore'),
('Karan', 'Mehta', 'karan.mehta@email.com', '9966554433', 'Hyderabad'),
('Meena', 'Nair', 'meena.nair@email.com', '9856123487', 'Kochi'),
('Rahul', 'Verma', 'rahul.verma@email.com', '9988123456', 'Pune'),
('Priya', 'Rao', 'priya.rao@email.com', '9867543210', 'Ahmedabad'),
('Varun', 'Gupta', 'varun.gupta@email.com', '9877899001', 'Jaipur'),
('Neha', 'Yadav', 'neha.yadav@email.com', '9123678945', 'Lucknow');

INSERT INTO Products (ProductName, Description, Price) VALUES
('Laptop', 'Intel i5, 8GB RAM, 512GB SSD', 55000.00),
('Smartphone', '6.5" Display, 128GB', 22000.00),
('Tablet', '10" Display, Wi-Fi + LTE', 18000.00),
('Smartwatch', 'Fitness tracker, Heart rate monitor', 7000.00),
('Headphones', 'Noise cancelling', 3500.00),
('Bluetooth Speaker', 'Portable speaker', 2500.00),
('Monitor', '24" LED Display', 10500.00),
('Keyboard', 'Mechanical Keyboard', 3000.00),
('Mouse', 'Wireless Mouse', 1200.00),
('Charger', '65W Fast Charger', 1500.00);

INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) VALUES
(1, '2024-03-01', 57000.00),
(2, '2024-03-05', 22000.00),
(3, '2024-03-06', 4500.00),
(4, '2024-03-10', 18000.00),
(5, '2024-03-11', 36000.00),
(6, '2024-03-12', 5000.00),
(7, '2024-03-14', 1500.00),
(8, '2024-03-15', 4000.00),
(9, '2024-03-16', 10500.00),
(10, '2024-03-18', 22000.00);

INSERT INTO OrderDetails (OrderID, ProductID, Quantity) VALUES
(1, 1, 1),
(1, 10, 2),
(2, 2, 1),
(3, 5, 1),
(4, 3, 1),
(5, 1, 1),
(5, 7, 1),
(6, 4, 1),
(7, 10, 1),
(8, 5, 1);

INSERT INTO Inventory (ProductID, QuantityInStock, LastStockUpdate) VALUES
(1, 15, '2024-03-01'),
(2, 30, '2024-03-05'),
(3, 20, '2024-03-06'),
(4, 25, '2024-03-07'),
(5, 50, '2024-03-10'),
(6, 40, '2024-03-10'),
(7, 18, '2024-03-11'),
(8, 35, '2024-03-12'),
(9, 45, '2024-03-13'),
(10, 60, '2024-03-14');

-- task 2
-- 1.Names and emails of all customers
SELECT FirstName, LastName, Email FROM Customers;

-- 2.Orders with order dates and customer names
SELECT o.OrderID, o.OrderDate, c.FirstName, c.LastName
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID;

-- 3.Insert a new customer
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address)
VALUES ('Divya', 'Krishnan', 'divya.k@email.com', '9876567890', 'Coimbatore');

-- 4.Update all product prices by increasing 10%
UPDATE Products
SET Price = Price * 1.10;

-- 5.Delete specific order and its details (input: OrderID)
SET @OrderID = 3;
DELETE FROM OrderDetails WHERE OrderID = @OrderID;
DELETE FROM Orders WHERE OrderID = @OrderID;

-- 6.Insert a new order
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
VALUES (2, CURDATE(), 15000.00);

-- 7.Update contact info of a customer (input: ID)
UPDATE Customers
SET Email = 'new.email@email.com', Address = 'New Address'
WHERE CustomerID = 5;

-- 8.Recalculate and update order total using OrderDetails
UPDATE Orders o
JOIN (
    SELECT OrderID, SUM(Quantity * p.Price) AS Total
    FROM OrderDetails od
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY OrderID
) AS calc ON o.OrderID = calc.OrderID
SET o.TotalAmount = calc.Total;

-- 9.Delete all orders and details for a customer (input: CustomerID)
SET @CID = 6;
DELETE FROM OrderDetails WHERE OrderID IN (
    SELECT OrderID FROM Orders WHERE CustomerID = @CID
);
DELETE FROM Orders WHERE CustomerID = @CID;

-- 10.Insert new product
INSERT INTO Products (ProductName, Description, Price)
VALUES ('Webcam', 'HD 1080p USB webcam with mic', 3500.00);

-- 11.Update order status (if added Status column)
DESCRIBE Orders;
ALTER TABLE Orders
ADD COLUMN Status VARCHAR(50) DEFAULT 'Pending';
UPDATE Orders
SET Status = 'Shipped'
WHERE OrderID = 1;

-- 12.Update number of orders in Customers (needs OrderCount column)
-- Assuming OrderCount INT column exists
ALTER TABLE Customers
ADD COLUMN OrderCount INT DEFAULT 0;

UPDATE Customers c
JOIN (
    SELECT CustomerID, COUNT(*) AS cnt
    FROM Orders
    GROUP BY CustomerID
) AS t ON c.CustomerID = t.CustomerID
SET c.OrderCount = t.cnt;

-- task 3
-- 1.All orders with customer info 
SELECT o.OrderID, o.OrderDate, c.FirstName, c.LastName
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID;

-- 2.Total revenue per product
SELECT p.ProductName, SUM(od.Quantity * p.Price) AS Revenue
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName;

-- 3.Customers who made at least one purchase
SELECT DISTINCT c.FirstName, c.LastName, c.Email, c.Phone
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 4.Most popular product (highest quantity ordered)
SELECT p.ProductName, SUM(od.Quantity) AS TotalOrdered
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalOrdered DESC
LIMIT 1;

-- 5.Gadgets with their categories (if category column added)
-- If Product table has Category column
ALTER TABLE Products
ADD COLUMN Category VARCHAR(50);
SELECT ProductName, Category FROM Products
LIMIT 0, 1000;

-- 6.Average order value per customer
SELECT c.FirstName, c.LastName, AVG(o.TotalAmount) AS AvgOrderValue
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID;

-- 7.Order with highest total
SELECT o.OrderID, c.FirstName, c.LastName, o.TotalAmount
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
ORDER BY o.TotalAmount DESC
LIMIT 1;

-- 8.Number of times each product ordered
SELECT p.ProductName, COUNT(*) AS TimesOrdered
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName;

-- 9.Customers who purchased a specific product (input name)
SET @Product = 'Laptop';
SELECT DISTINCT c.FirstName, c.LastName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE p.ProductName = @Product;

-- 10.Revenue in specific period (input dates)
SET @startDate = '2024-03-01';
SET @endDate = '2024-03-15';

SELECT SUM(TotalAmount) AS TotalRevenue
FROM Orders
WHERE OrderDate BETWEEN @startDate AND @endDate;

-- task 4
-- 1.Customers with no orders
SELECT * FROM Customers
WHERE CustomerID NOT IN (
    SELECT DISTINCT CustomerID FROM Orders
);

-- 2.Total number of products
SELECT COUNT(*) AS TotalProducts FROM Products;

-- 3.Total revenue of TechShop
SELECT SUM(TotalAmount) AS Revenue FROM Orders;

-- 4.Avg quantity ordered for specific category (needs category)
-- Assuming Category column exists
SET @Category = 'Smartphones';

SELECT AVG(od.Quantity) AS AvgQuantity
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
WHERE p.Category = @Category;

-- 5.Total revenue by specific customer (input ID)
SET @CID = 2;

SELECT SUM(TotalAmount) AS CustomerRevenue
FROM Orders
WHERE CustomerID = @CID;

-- 6.Customers with most orders
SELECT c.FirstName, c.LastName, COUNT(*) AS OrderCount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
ORDER BY OrderCount DESC
LIMIT 1;

-- 7.Most popular product category
-- If Products table has Category
SELECT Category, SUM(od.Quantity) AS TotalQty
FROM Products p
JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY Category
ORDER BY TotalQty DESC
LIMIT 1;

-- 8.Customer who spent the most
SELECT c.FirstName, c.LastName, SUM(o.TotalAmount) AS Spent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
ORDER BY Spent DESC
LIMIT 1;

-- 9.Average order value (overall)
SELECT AVG(TotalAmount) AS AvgOrderValue FROM Orders;

-- 10.Order count per customer
SELECT c.FirstName, c.LastName, COUNT(o.OrderID) AS OrderCount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID;
