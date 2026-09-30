SELECT
    e.employee_name,
    e.department,
    p.product_name,
    p.category,
    COALESCE(SUM(s.sales_value),0) AS total_sales
FROM sales s
JOIN employees e
    ON s.employee_id = e.employee_id
JOIN products p
    ON s.product_id = p.product_id
GROUP BY
    e.employee_id,
    e.employee_name,
    e.department,
    p.product_id,
    p.product_name,
    p.category
ORDER BY total_sales DESC;

WITH employee_product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        e.employee_id,
        e.employee_name,
        SUM(s.sales_value) AS total_sales
    FROM sales s
    JOIN employees e
        ON s.employee_id = e.employee_id
    JOIN products p
        ON s.product_id = p.product_id
    GROUP BY
        p.product_id,
        p.product_name,
        p.category,
        e.employee_id,
        e.employee_name
),

ranked_sales AS (
    SELECT
        product_name,
        category,
        employee_name,
        total_sales,
        DENSE_RANK() OVER(
            PARTITION BY product_id
            ORDER BY total_sales DESC
        ) AS product_rank
    FROM employee_product_sales
)

SELECT
    product_name,
    category,
    employee_name,
    total_sales,
    product_rank
FROM ranked_sales
WHERE product_rank = 1
ORDER BY total_sales DESC;

WITH employee_product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        e.employee_id,
        e.employee_name,
        SUM(s.sales_value) AS total_sales
    FROM sales s
    JOIN employees e
        ON s.employee_id = e.employee_id
    JOIN products p
        ON s.product_id = p.product_id
    GROUP BY
        p.product_id,
        p.product_name,
        p.category,
        e.employee_id,
        e.employee_name
),

ranked_sales AS (
    SELECT
        product_name,
        category,
        employee_name,
        total_sales,
        DENSE_RANK() OVER(
            PARTITION BY product_id
            ORDER BY total_sales DESC
        ) AS product_rank
    FROM employee_product_sales
)

SELECT *
FROM ranked_sales
WHERE product_rank <= 2
ORDER BY product_name, product_rank;

