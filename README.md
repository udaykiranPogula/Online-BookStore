# Online-BookStore Analysis(MySQL)

## Project Overview

**Project Title**: Online Bookstore Analysis  
**Level**: Intermediate  
**Database**: `Online_Bookstore`

This project demonstrates end-to-end SQL skills to analyze an online bookstore business. The goal is to design and implement a database system, clean the data, and generate insights through SQL queries using real-world business questions. It’s ideal for SQL learners looking to solidify practical concepts such as JOINs, aggregations, window functions, and views.

## Objectives

1. **Database Setup**: Create and structure a bookstore database with data from books, customers, and orders.
2. **Data Cleaning**: Identify and fix null values, duplicates, and incorrect data types.
3. **EDA (Exploratory Data Analysis)**: Explore customer behavior, book sales, revenue, and product performance.
4. **Insight Generation**: Answer business-focused SQL questions and generate analytical summaries.

## Project Structure

### 1. Database Setup

- **Database Creation**:
```sql
CREATE DATABASE Online_Bookstore;
```

**2.Import CSVs
  Use the MySQL Workbench Table Data Import Wizard to load:**

- Books.csv → Books table

- Customers.csv → Customers table

- Orders.csv → Orders table

**3.Schema Corrections**:
```sql
ALTER TABLE Books MODIFY Published_Year YEAR;
ALTER TABLE Orders MODIFY Order_Date DATE;

--  Establishing the Relationship across the tables 
ALTER TABLE Books ADD PRIMARY KEY (Book_ID);
ALTER TABLE Customers ADD PRIMARY KEY (Customer_ID);
ALTER TABLE Orders ADD PRIMARY KEY (Order_ID);
ALTER TABLE Orders ADD CONSTRAINT FK_CUSTOMERS FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID);
ALTER TABLE Orders ADD CONSTRAINT FK_BOOKS FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID);
```

### 2. Data Cleaning

- Checked for nulls and invalid records:
```sql
-- Books with NULLs
SELECT 
  SUM(CASE WHEN Title IS NULL THEN 1 ELSE 0 END) AS Title_nulls,
  SUM(CASE WHEN Author IS NULL THEN 1 ELSE 0 END) AS Author_nulls,
  SUM(CASE WHEN Genre IS NULL THEN 1 ELSE 0 END) AS Genre_nulls,
  SUM(CASE WHEN Published_Year IS NULL THEN 1 ELSE 0 END) AS year_nulls,
  SUM(CASE WHEN Price IS NULL THEN 1 ELSE 0 END) AS price_nulls,
  SUM(CASE WHEN stock IS NULL THEN 1 ELSE 0 END) AS stock_nulls
FROM Books;

-- Custmers with NULLs
select
  SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
  SUM(CASE WHEN Email IS NULL THEN 1 ELSE 0 END) AS Email_nulls,
  SUM(CASE WHEN Phone IS NULL THEN 1 ELSE 0 END) AS Phone_nulls,
  SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS city_nulls,
  SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS Country_nulls
from Customers;

-- Orders with NULLs
select 
  SUM(CASE WHEN Order_id IS NULL THEN 1 ELSE 0 END) AS OI_nulls,
  SUM(CASE WHEN Customer_id IS NULL THEN 1 ELSE 0 END) AS ci_nulls,
  SUM(CASE WHEN Book_Id IS NULL THEN 1 ELSE 0 END) AS bi_nulls,
  SUM(CASE WHEN Order_date IS NULL THEN 1 ELSE 0 END) AS Odate_nulls,
  SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS Q_nulll,
  sum(case when Total_amount is null then 1 else 0 end) as Am_null
from Orders;


-- Orders with negative values
SELECT * FROM Orders WHERE Quantity < 0 OR Total_Amount < 0;
```

- Identified duplicates and corrected them:
```sql
SELECT 
    order_id, customer_id, book_id,order_date, quantity, Total_Amount, COUNT(*) AS duplicate_count
FROM 
    orders
GROUP BY 
    order_id, customer_id, book_id, order_date, quantity, Total_Amount
HAVING 
    COUNT(*) > 1;
```

### 3. Data Analysis & Insights

Here are some of the business-driven SQL questions answered:

1.**List all books along with their price and stock.**
```sql
SELECT Title, Price ,stock From  Books;
```
2. **What are the countries where the order are places**
```sql
SELECT DISTINCT country
FROM customers
ORDER BY country;

```
3. **Which books are priced above ₹30?**
```sql
SELECT *
FROM books
WHERE price > 30;
```
4. **Top 5 customers who placed the most orders**
``` sql
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
```
5. **Books that are out of stock**
```sql
SELECT *
FROM books
WHERE stock = 0;
```

6. **Total Revenue by Genre**:
```sql
SELECT Genre, ROUND(SUM(Total_Amount),2) AS Revenue
FROM Books b
JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY Genre;
```
7. **Total Books sold from each genre order by Books sold.**
```sql
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
```

8. **Top Selling Books**:
```sql
SELECT Title, SUM(Quantity) AS Books_Sold
FROM Books b
JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY Title
ORDER BY Books_Sold DESC
LIMIT 5;
```
9. **List each customer’s total number of books ordered**
```sql
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
```
10. **Total Revenue Per Customer**
```sql
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
```
11. **Top 5 Countries with Orders and Revenue**
```sql
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
```
12. **Top Cities by Orders**
```sql
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
```
13. ** Total Number of Books Sold per Author**
```sql
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
```

14. **Monthly Sales Trend**:
```sql
SELECT MONTHNAME(Order_Date) AS Month, SUM(Quantity) AS Orders
FROM Orders
GROUP BY Month
ORDER BY Orders DESC;
```
-- 15).Day with Highest Number of Orders
```sql
SELECT 
    day(Order_Date) Days,
    COUNT(*) AS Total_Orders
FROM Orders
GROUP BY Days
ORDER BY Days DESC
LIMIT 1;
```

16. **Customer Who Made First Order**:
```sql
SELECT c.Name, o.Order_Date
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
ORDER BY o.Order_Date ASC
LIMIT 1;
```
17.  **Customers Who Never Placed an Order**
```sql
SELECT count(*) 
FROM Customers
WHERE Customer_ID NOT IN (
    SELECT DISTINCT Customer_ID FROM Orders
);
```
18. **Books That Have Never Been Sold**
```  sql
SELECT count(*) 
FROM Books
WHERE Book_ID NOT IN (
    SELECT DISTINCT Book_ID FROM Orders
);
```
19. **Customers Who Ordered the Most Expensive Book**
```sql
 SELECT 
    c.Name,b.Title,b.Price
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
JOIN Customers c ON o.Customer_ID = c.Customer_ID
WHERE b.Price = (SELECT MAX(Price) FROM Books);
```
20. **Rank Customers Based on Total Spending (Window Function)*?*
```sql
SELECT 
    c.Name,
    SUM(o.Total_Amount) AS TotalSpent,
    RANK() OVER (ORDER BY SUM(o.Total_Amount) DESC) AS SpendingRank
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Name;
```
-- 21). Cumulative Monthly Sales
```sql
SELECT 
    DATE_FORMAT(Order_Date, '%Y-%m') AS Month,
    SUM(Quantity) AS Monthly_Sales,
    SUM(SUM(Quantity)) OVER (ORDER BY DATE_FORMAT(Order_Date, '%Y-%m')) AS Cumulative_Sales
FROM Orders
GROUP BY Month;
```
22. **Top 3 Best-Selling Books per Genre**
```sql
SELECT * FROM (
    SELECT 
        b.Genre,b.Title,SUM(o.Quantity) AS Books_Sold,
        RANK() OVER (PARTITION BY b.Genre ORDER BY SUM(o.Quantity) DESC) AS GenreRank
    FROM Books b
    JOIN Orders o ON b.Book_ID = o.Book_ID
    GROUP BY b.Genre, b.Title
) ranked
WHERE GenreRank <= 3;
```


23. **Top Customers by Spending**:
```sql
SELECT c.Name, SUM(o.Total_Amount) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID
ORDER BY TotalSpent DESC
LIMIT 5;
```

24. **View: Customer Spending Summary**:
```sql
CREATE VIEW CustomerSpending AS
SELECT c.Customer_ID, c.Name, SUM(b.Price * o.Quantity) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY c.Customer_ID, c.Name;
```

## Reports

- **Revenue Summary**: Sales and revenue per genre, book, and customer.
- **Trend Analysis**: Monthly trends and first purchase behaviors.
- **Customer Insights**: Highest spending customers and location-based insights.

---
## 📊 Insights

- 📚 **Best-Selling Authors**: Patrick Contreras and Melissa Taylor are among the top authors by total book sales.
- 💸 **Top Revenue Genres**: Genres like Fiction, Fantasy, and Non-Fiction generated the highest revenues.
- 📆 **Peak Sales Periods**: The majority of sales occurred mid-year, suggesting strong seasonal demand.
- 🌍 **Customer Geography**: Orders span globally; certain cities show higher concentration — useful for regional campaigns.
- 🧑‍💼 **Top Customers**: A small set of customers contribute a significant portion of the total revenue — potential for loyalty rewards.
- 🛒 **Stock & Inventory**: Some books are running low or out of stock, indicating the need for inventory restocking strategies.

## 🧾 Conclusion

This SQL project delivers a comprehensive analysis of a fictional bookstore’s operations using structured relational data. It demonstrates how SQL helps:

- Build and normalize databases  
- Clean and validate records  
- Derive customer and sales insights  
- Execute real-world business analysis with joins, subqueries, aggregations, and window functions  

The findings are valuable for improving inventory, targeting marketing, and enhancing customer experience. This makes the project an ideal portfolio piece for aspiring SQL data analysts.

## How to Use

1. Import the `Online_Booksshop.sql` script into MySQL Workbench.
2. Use the `Table Data Import Wizard` to upload `Books.csv`, `Orders.csv`, and `Customers.csv`.
3. Run the analytical queries to explore the data.
4. Modify or extend the analysis for new business questions.

## Author - Uday Kiran Pogula

This project is a part of my data analytics portfolio.  
If you found it useful or have feedback, feel free to connect!

