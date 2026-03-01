Retail Analytics using MySQL

🔍Project Overview

This project focuses on analyzing retail sales data using MySQL to extract meaningful business insights. The goal was to understand sales performance, customer behavior, and product profitability using SQL queries.
 
🎯Business Objectives - 

· Identify top-performing products

· Analyze regional sales performance

· Track monthly revenue trends

· Understand customer purchasing patterns

· Detect low-performing categories

🗂Dataset Description

· Transaction: Records of sales transactions, including transaction ID,
customer ID, product ID, quantity purchased, transaction date, and price.

· Customer Profiles: Information on customers, including customer ID, age,
gender, location, and join date.

. Product Inventory: Data on product inventory, including product ID, product
name, category, stock level, and price.

🛠 Tools & Technologies Used

· MySQL

· SQL (Joins, Group By, Aggregations, Subqueries, Window Functions)

🧠 SQL Concepts Applied

· SELECT, WHERE, ORDER BY

· GROUP BY & HAVING

· INNER JOIN / LEFT JOIN

· Subqueries

· Aggregate Functions (SUM, COUNT, AVG)

· Window Functions (RANK, DENSE_RANK)

· Date Functions


📈 Key Analysis Performed

· We are segmenting customers based on the total quantity of products they have purchased.
· The segmentation is done using specific ranges: "Low", "Med", and "High" based on the total 
  quantity.
· We use data from both customer_profiles and sales_transaction tables to calculate each 
  customer's total quantity purchased.
· After assigning each customer to a segment, we count how many customers fall into each    
  segment.
· This helps us understand customer purchasing behavior and target marketing efforts more   
  effectively.

📊 Key Insights 

· Product Performance: Identifying high and low sales products helps optimize inventory—stock 
  more of what sells and reduce slow-moving items. This also guides targeted marketing for 
  underperforming products.

· Customer Segmentation: Grouping customers by purchase quantity (No Orders, Low, Mid, High 
  Value) enables personalized marketing strategies, improving engagement and satisfaction.

· Customer Behavior: Analyzing repeat purchases and loyalty patterns reveals which customers are   
  most valuable and helps design effective retention programs.

· Data-Driven Decisions: Using SQL for data cleaning and analysis ensures accurate insights, 
  supporting better business decisions across sales, marketing, and inventory management.

· Enhanced Customer Experience: Understanding customer profiles and behaviors allows for       
  tailored offers and improved service, boosting overall customer satisfaction and loyalty.


