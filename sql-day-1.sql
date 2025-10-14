-- Products Table
CREATE TABLE Products(
  Product_Id NUMBER PRIMARY KEY,
  Product_Name VARCHAR2(40) NOT NULL,
  Category VARCHAR(20) NOT NULL,
  Price NUMBER CHECK(Price > 0),
  Stock_Quantity NUMBER DEFAULT 0 CHECK(Stock_Quantity > 0)
);

--Customers Table
CREATE TABLE Customers(
  Customer_Id NUMBER PRIMARY KEY,
  First_Name VARCHAR2(20) NOT NULL,
  Last_Name VARCHAR2(20) NOT NULL,
  Customer_Email VARCHAR2(40) UNIQUE NOT NULL,
  Customer_Phone VARCHAR(15)
);

-- Orders Table
CREATE TABLE Orders(
  Order_Id NUMBER PRIMARY KEY,
  Customer_Id NUMBER NOT NULL,
  Purchase_Date DATE DEFAULT SYSDATE,
  Order_Total NUMBER CHECK (Order_Total > 0),
  CONSTRAINT fk_cust_id FOREIGN KEY (Customer_Id) REFERENCES Customers(Customer_Id)
);

-- Order Details Table
CREATE TABLE OrderDetails(
  Order_Detail_Id NUMBER PRIMARY KEY,
  Order_Id NUMBER NOT NULL,
  Product_Id NUMBER NOT NULL,
  Quantity NUMBER CHECK (Quantity > 0),
  CONSTRAINT fk_prod_id FOREIGN KEY (Product_Id) REFERENCES Products(Product_Id),
  CONSTRAINT fk_order_id FOREIGN KEY (Order_Id) REFERENCES Orders(Order_Id)
);

-- insert commands for tables
-- 1. Products Table
INSERT INTO Products VALUES(1, 'ASUS ROG 1', 'Gaming Laptop', 12345, 10);
INSERT INTO Products VALUES(2, 'IPHONE 16 PRO', 'Smartphone', 1234, 10);
INSERT INTO Products VALUES(3, 'MacBook Air', 'Laptop', 82340, 10);
INSERT INTO Products VALUES(4, 'Dell XPS 15', 'Laptop', 75000, 15);

-- 2. Customers Table
INSERT INTO Customers VALUES(101, 'Arjun', 'Sharma', 'arjun.sharma@example.com', '9876543210');
INSERT INTO Customers VALUES(102, 'Priya', 'Singh', 'priya.singh@example.com', '8765432109');
INSERT INTO Customers VALUES(103, 'Amit', 'Verma', 'amit.verma@example.com', '7654321098');

-- 3. Orders Table
INSERT INTO Orders VALUES(201, 101, TO_DATE('2025-10-14', 'YYYY-MM-DD'), 12345);
INSERT INTO Orders VALUES(202, 102, TO_DATE('2025-10-14', 'YYYY-MM-DD'), 1234);
INSERT INTO Orders VALUES(203, 103, TO_DATE('2025-10-14', 'YYYY-MM-DD'), 164680); 

-- 4. OrderDetails Table
INSERT INTO OrderDetails VALUES(301, 201, 1, 1); 
INSERT INTO OrderDetails VALUES(302, 202, 2, 1); 
INSERT INTO OrderDetails VALUES(303, 203, 3, 2); 

-- Other Required Queries
--1. Retrieve Product with low stock quantity
SELECT * FROM Products WHERE Stock_Quantity < 20;

--2. To get amount spent by each customer
SELECT First_Name, SUM(O.Order_Total) as Total_Amount_Spent FROM Customers C INNER JOIN Orders O on C.Customer_Id = O.Customer_Id GROUP BY C.First_Name; 
