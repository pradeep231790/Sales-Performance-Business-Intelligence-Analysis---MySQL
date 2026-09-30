SELECT COUNT(*) AS total_employees
FROM employees;

SELECT COUNT(*) AS total_products
FROM products;

SELECT COUNT(*) AS total_orders
FROM sales;

SELECT COUNT(DISTINCT department) AS total_departments
FROM employees;

SELECT COUNT(DISTINCT category) AS total_categories
FROM products;

SELECT
    COALESCE(SUM(sales_value),0) AS total_revenue
FROM sales;

SELECT
    COALESCE(AVG(sales_value),0) AS average_order_value
FROM sales;

SELECT
    MAX(sales_value) AS highest_order_value,
    MIN(sales_value) AS lowest_order_value
FROM sales;

