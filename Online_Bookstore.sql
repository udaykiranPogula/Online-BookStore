-- Step 1: Create a Database:
Create Database Online_Bookstore;

-- Use the Table Data Import Wizard in MySQL Workbench for each table.

-- Step 2: Understand the Schema
Select * from Books;
select  * from Customers;
select * from  Orders;

-- Step 3: Data Preprocessing & Handling

-- changing the data Types of the Columns and changing them Accordingly to the correct way 
Describe Books;
Alter table Books 
Modify column Published_Year YEAR;

Describe Orders;
Alter Table Orders
modify column Order_Date date;

--  Establishing the Relationship across the tables 
ALTER TABLE Books ADD PRIMARY KEY (Book_id);
ALTER TABLE  Customers ADD PRIMARY KEY (Customer_ID);

ALTER TABLE Orders ADD CONSTRAINT FK_CUSTOMERS FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMERS(CUSTOMER_ID);
ALTER TABLE ORDERS ADD CONSTRAINT FK_BOOKS FOREIGN KEY (BOOK_ID) REFERENCES BOOKS(BOOK_ID);

-- Find NULLs in a Specific Column
SELECT 
  SUM(CASE WHEN Title IS NULL THEN 1 ELSE 0 END) AS Title_nulls,
  SUM(CASE WHEN Author IS NULL THEN 1 ELSE 0 END) AS Author_nulls,
  SUM(CASE WHEN Genre IS NULL THEN 1 ELSE 0 END) AS Genre_nulls,
  SUM(CASE WHEN Published_Year IS NULL THEN 1 ELSE 0 END) AS year_nulls,
  SUM(CASE WHEN Price IS NULL THEN 1 ELSE 0 END) AS price_nulls,
  SUM(CASE WHEN stock IS NULL THEN 1 ELSE 0 END) AS stock_nulls
FROM Books;

select
  SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
  SUM(CASE WHEN Email IS NULL THEN 1 ELSE 0 END) AS Email_nulls,
  SUM(CASE WHEN Phone IS NULL THEN 1 ELSE 0 END) AS Phone_nulls,
  SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS city_nulls,
  SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS Country_nulls
from Customers;

select 
  SUM(CASE WHEN Order_id IS NULL THEN 1 ELSE 0 END) AS OI_nulls,
  SUM(CASE WHEN Customer_id IS NULL THEN 1 ELSE 0 END) AS ci_nulls,
  SUM(CASE WHEN Book_Id IS NULL THEN 1 ELSE 0 END) AS bi_nulls,
  SUM(CASE WHEN Order_date IS NULL THEN 1 ELSE 0 END) AS Odate_nulls,
  SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS Q_nulll,
  sum(case when Total_amount is null then 1 else 0 end) as Am_null
from Orders;

-- Find Duplicated Rows 
SELECT 
    order_id, customer_id, book_id,order_date, quantity, Total_Amount, COUNT(*) AS duplicate_count
FROM 
    orders
GROUP BY 
    order_id, customer_id, book_id, order_date, quantity, Total_Amount
HAVING 
    COUNT(*) > 1;


-- Invalid data (e.g., negative prices or stock)
select * from orders where Quantity <0 or Total_Amount < 0;
select * from books where Price < 0 or Stock <0;

-- Step 4: Insights

-- 1) List all books along with their price and stock.
SELECT Title, Price ,stock From  Books;

-- 2) What are the countries where the order are places
SELECT DISTINCT country
FROM customers
ORDER BY country;


-- 3) Which books are priced above ₹30?
SELECT *
FROM books
WHERE price > 30;

-- 4) Top 5 customers who placed the most orders.
SELECT 
    customer_id, 
    SUM(quantity) AS total_order_quantity
FROM 
    orders
GROUP BY 
    customer_id
ORDER BY 
    total_order_quantity DESC
LIMIT 5;

-- 5)  Books that are out of stock.
SELECT *
FROM books
WHERE stock = 0;

-- 6) Total revenue generated from each genre.
select b.Genre , round(sum(Total_Amount) ,2) as `Total Revenue` from Books b
join Orders o on b.book_id = o.book_id 
group by genre order by `Total Revenue` desc ;

-- 7) Total Books sold from each genre.
SELECT 
    b.genre, 
    SUM(o.quantity) AS `Books Sold`
FROM 
    books b
JOIN 
    orders o ON b.book_id = o.book_id
GROUP BY 
    b.genre
ORDER BY 
    `Books Sold` DESC;


-- 8) Top Selling Books
SELECT Title, SUM(Quantity) AS Books_Sold
FROM Books b
JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY Title
ORDER BY Books_Sold DESC
LIMIT 5;

-- 9)List each customer’s total number of books ordered.
SELECT 
    c.customer_id, 
    c.name, 
    SUM(o.quantity) AS total_books_ordered
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.name
ORDER BY 
    total_books_ordered DESC;

-- 10) Total Revenue Per Customer
SELECT 
    c.customer_id, c.name, SUM(o.total_amount) AS total_revenue
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.name
ORDER BY 
    total_revenue DESC;

-- 11) Top 5 Countries with orders and revenu 
SELECT 
    c.country,COUNT(o.order_id) AS total_orders,SUM(o.total_amount) AS total_revenue
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.country
ORDER BY 
    total_revenue DESC,
    c.country ASC
LIMIT 5;


-- 12) Top Cities by Orders
SELECT 
    c.city,c.country,SUM(o.quantity) AS total_orders
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.city, c.country
ORDER BY 
    total_orders DESC;


-- 13) Total Number of Books Sold per Author
SELECT 
    b.author, SUM(o.quantity) AS books_sold
FROM 
    books b
JOIN 
    orders o ON b.book_id = o.book_id
GROUP BY 
    b.author
ORDER BY 
    books_sold DESC;

 
-- 14.Monthly Sales Trend:
SELECT MONTHNAME(Order_Date) AS Month, SUM(Quantity) AS Orders
FROM Orders
GROUP BY Month
ORDER BY Orders DESC;

-- 15).Day with Highest Number of Orders
SELECT 
    day(Order_Date) Days,
    COUNT(*) AS Total_Orders
FROM Orders
GROUP BY Days
ORDER BY Days DESC
LIMIT 1;

 -- 16) Customer Who Made the First-Ever Order
SELECT 
    o.Order_ID,
    c.Name,
    o.Order_Date
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
ORDER BY o.Order_Date ASC
LIMIT 1;

-- 17).Customers Who Never Placed an Order
SELECT count(*) 
FROM Customers
WHERE Customer_ID NOT IN (
    SELECT DISTINCT Customer_ID FROM Orders
);

-- 18) Books That Have Never Been Sold
SELECT count(*) 
FROM Books
WHERE Book_ID NOT IN (
    SELECT DISTINCT Book_ID FROM Orders
);

 -- 19).Customers Who Ordered the Most Expensive Book
 SELECT 
    c.Name,
    b.Title,
    b.Price
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
JOIN Customers c ON o.Customer_ID = c.Customer_ID
WHERE b.Price = (SELECT MAX(Price) FROM Books);

-- 20) Rank Customers Based on Total Spending (Window Function)
SELECT 
    c.Name,
    SUM(o.Total_Amount) AS TotalSpent,
    RANK() OVER (ORDER BY SUM(o.Total_Amount) DESC) AS SpendingRank
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Name;

-- 21). Cumulative Monthly Sales
SELECT 
    DATE_FORMAT(Order_Date, '%Y-%m') AS Month,
    SUM(Quantity) AS Monthly_Sales,
    SUM(SUM(Quantity)) OVER (ORDER BY DATE_FORMAT(Order_Date, '%Y-%m')) AS Cumulative_Sales
FROM Orders
GROUP BY Month;

-- 22). Top 3 Best-Selling Books per Genre
SELECT * FROM (
    SELECT 
        b.Genre,
        b.Title,
        SUM(o.Quantity) AS Books_Sold,
        RANK() OVER (PARTITION BY b.Genre ORDER BY SUM(o.Quantity) DESC) AS GenreRank
    FROM Books b
    JOIN Orders o ON b.Book_ID = o.Book_ID
    GROUP BY b.Genre, b.Title
) ranked
WHERE GenreRank <= 3;

-- 23.Top Customers by Spending:
SELECT c.Name, SUM(o.Total_Amount) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID
ORDER BY TotalSpent DESC
LIMIT 5;

-- 24) Create a view of customer spending summary: 

CREATE VIEW CustomerSpending AS
SELECT 
    c.Customer_ID, 
    c.Name, 
    SUM(b.Price * o.Quantity) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY c.Customer_ID, c.Name;


