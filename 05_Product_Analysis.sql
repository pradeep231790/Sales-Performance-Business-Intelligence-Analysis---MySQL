SELECT
    p.product_id,
    p.product_name,
    p.category,
    COUNT(s.order_id) AS order_count,
    COALESCE(SUM(s.sales_value),0) AS total_revenue,
    COALESCE(AVG(s.sales_value),0) AS average_order_value
FROM products p
LEFT JOIN sales s
    ON p.product_id = s.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY total_revenue DESC;

WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        COALESCE(SUM(s.sales_value),0) AS total_revenue
    FROM products p
    LEFT JOIN sales s
        ON p.product_id = s.product_id
    GROUP BY
        p.product_id,
        p.product_name,
        p.category
)

SELECT
    product_name,
    category,
    total_revenue,
    DENSE_RANK() OVER(
        ORDER BY total_revenue DESC
    ) AS product_rank
FROM product_sales
ORDER BY product_rank;

WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        COALESCE(SUM(s.sales_value),0) AS total_revenue
    FROM products p
    LEFT JOIN sales s
        ON p.product_id = s.product_id
    GROUP BY
        p.product_id,
        p.product_name,
        p.category
)

SELECT
    product_name,
    category,
    total_revenue,
    CASE
        WHEN total_revenue >= 20000
            THEN 'High Revenue'
        WHEN total_revenue >= 10000
            THEN 'Medium Revenue'
        ELSE 'Low Revenue'
    END AS revenue_category
FROM product_sales
ORDER BY total_revenue DESC;

