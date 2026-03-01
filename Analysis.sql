use new_schema;
set sql_safe_updates = 0;

select*from customer_profiles;
select*from product_inventory;
select*from sales_transaction;

-- Renaming column name --
alter table sales_transaction rename column ï»¿TransactionID to TransactionID;
select*from sales_transaction;
alter table product_inventory rename column ï»¿ProductID to ProductID;
select*from product_inventory;
alter table customer_profiles rename column ï»¿CustomerID to CustomerID;
select*from customer_profiles;

-- Checking for duplicates -- 
select TransactionID, COUNT(*) from Sales_transaction
group by TransactionID
having COUNT(*) >1;
--
Create table sales_transaction_unique as select distinct * from Sales_transaction;
--
Drop table Sales_transaction;
alter table sales_transaction_unique
rename to Sales_transaction;
--
select * from Sales_transaction;

-- 2 --
select ProductID, count(*) from product_inventory
group by ProductID
having count(*)>1;
-- no dupes--

-- 3 --
select CustomerID, count(*) from customer_profiles
group by CustomerID
having count(*)>1;
-- no dupes --

-- identifying the discrepancies in the price of the same product in "sales_transaction" and "product_inventory" tables -- 
select st.TransactionID, st.Price as TransactionPrice, p.Price as InventoryPrice
From sales_transaction st
JOIN product_inventory p ON st.ProductID = p.ProductID
WHERE st.Price <> p.Price; 
--
UPDATE sales_transaction st
JOIN product_inventory p ON st.ProductID = p.ProductID
SET st.Price = p.Price
WHERE st.Price <> p.Price;
--
SELECT * FROM sales_transaction ;

-- Null Values/dealing with empty values
Select COUNT(*)
From customer_profiles 
Where Location Is  null;
--
Update customer_profiles
Set Location = 'Unknown'
Where Location = '';
--
select * from customer_profiles;

-- Cleaning Date format --
Select * from sales_transaction ;

Create table sales_transaction_updated as select *, 
cast(TransactionDate as date) as TransactionDate_updated
from sales_transaction;

drop table sales_transaction;

alter table sales_transaction_updated
rename to sales_transaction;

select * from sales_transaction; 

-- summarizing the total sales and quantities sold per product by the company --
select ProductID, Round(sum(QuantityPurchased*price),2) as TotalSales, sum(QuantityPurchased) as TotalQuantitiesSold
from sales_transaction
group by ProductID
order by TotalSales desc;

-- Purchase Frequency --
Select CustomerID, Count(*) as NumberOfTransactions
from sales_transaction
group by CustomerID
order by NumberOfTransactions desc;

-- Product Category Performance -- 
select * from sales_transaction;
select * from product_inventory;
 
select p.Category, Sum(st.QuantityPurchased) as TotalUnitsSold, Round(Sum(st.QuantityPurchased*st.Price),2) as TotalSales
from sales_transaction st
join product_inventory p
on st.ProductID = p.ProductID
group by p.Category
order by TotalSales desc;
--

-- High Sale Products -- 
select * from sales_transaction;
select ProductID, round(sum(QuantityPurchased*Price),2) as TotalRevenue
from sales_transaction
group by ProductID
order by TotalRevenue desc
limit 10;

-- Low Selling Products --
select * from sales_transaction;
Select ProductID, sum(QuantityPurchased) AS TotalUnitsSold
from Sales_transaction 
group by ProductId
having TotalUnitsSold >0
order by TotalUnitsSold asc
limit 10;

-- Sales Trends --
select * from sales_transaction;
select Cast(TransactionDate as date) as DATETRANS,
Count(QuantityPurchased) as Transaction_Count,
Sum(QuantityPurchased) as TotalUnitsSold,
Round(sum(Price*QuantityPurchased),2) as TotalSales
From sales_transaction
group by DATETRANS
order by DATETRANS desc;

-- Growth Rate of sales --
select * from sales_transaction;
With MOM as(
    Select month(TransactionDate) as Month, Round(sum(Price*QuantityPurchased),2) as total_sales
    from Sales_transaction
    Group by month(TransactionDate)
)
Select Month, total_sales, Lag(total_sales) over(Order by Month) as previous_month_sales,
Round(((total_sales - lag(total_sales)over (Order by Month))/
lag(total_sales)over (Order by Month)*100),2) as mom_growth_percentage
from MOM 
order by Month;

-- High Purchase Frequency -- 
Select CustomerID, Count(TransactionID) as NumberOfTransactions,
Round(Sum(QuantityPurchased*Price),2) as TotalSpent
from Sales_transaction
group by CustomerID
having NumberOfTransactions >10 and TotalSpent >1000
Order by TotalSpent desc;

-- Casual Customers --
Select CustomerID, Count(TransactionID) as NumberOfTransactions,
Round(Sum(QuantityPurchased*Price),2) as TotalSpent
from Sales_transaction
group by CustomerID
having NumberOfTransactions <=2 
Order by NumberOfTransactions asc, TotalSpent desc;

-- Repeat Purchases --
select CustomerID, ProductID, Count(*) as TimesPurchased
from Sales_transaction
group by CustomerID, ProductID
Having TimesPurchased >1
order by TimesPurchased desc;

-- Loyalty Indicators --
select
    CustomerID,
    DATE_FORMAT(min(TransactionDate), '%Y-%m-%d') as FirstPurchase,
    DATE_FORMAT(max(TransactionDate), '%Y-%m-%d') as LastPurchase,
    (MAX(TransactionDate)) - (MIN(TransactionDate)) as DaysBetweenPurchases
from Sales_transaction
Group by  CustomerID
having  DaysBetweenPurchases > 0
order by DaysBetweenPurchases desc;

-- Customer Segmentation --
with customer_totals as(
    Select cp.CustomerID,
    sum(st.QuantityPurchased) as Total_quantity
    from Customer_profiles cp 
    join sales_transaction st  on cp.CustomerID=st.CustomerID
    group by cp.CustomerID
)

    Select 
    CASE
        WHEN COALESCE(Total_quantity, 0) BETWEEN 11 AND 30 THEN 'Med' 
        WHEN COALESCE(Total_quantity, 0) BETWEEN 1 AND 10 THEN 'Low'
        ELSE 'High'

END as Customersegment, Count(*) 
    from customer_totals

group by Customersegment;

-- Interpretation --
-- The case study is about segmenting customers based on their purchasing behavior. By analyzing the total quantity of products each customer has bought, we can group them into different segments: Low, Medium, and High.
-- This segmentation helps the business understand its customer base better and design targeted marketing strategies for each group. For example, “High” segment customers might get loyalty rewards, while “Low” segment customers could receive special offers to encourage more purchases.
-- The process involves joining customer and transaction data, calculating total purchases per customer, assigning each to a segment based on defined thresholds, and finally counting how many customers fall into each segment.
-- The result is a summary table showing the number of customers in each segment, which is valuable for making data-driven marketing decisions.
