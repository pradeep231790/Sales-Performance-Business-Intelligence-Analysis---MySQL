WITH employee_sales AS (
    SELECT
        e.employee_id,
        e.employee_name,
        e.department,
        COALESCE(SUM(s.sales_value),0) AS total_sales
    FROM employees e
    LEFT JOIN sales s
        ON e.employee_id = s.employee_id
    GROUP BY
        e.employee_id,
        e.employee_name,
        e.department
)

SELECT
    employee_name,
    department,
    total_sales,

    DENSE_RANK() OVER(
        ORDER BY total_sales DESC
    ) AS company_rank,

    DENSE_RANK() OVER(
        PARTITION BY department
        ORDER BY total_sales DESC
    ) AS department_rank,

    ROUND(
        total_sales * 100.0 /
        SUM(total_sales) OVER(),
        2
    ) AS company_contribution_pct

FROM employee_sales
ORDER BY company_rank;

WITH employee_sales AS (
    SELECT
        e.employee_id,
        e.employee_name,
        e.department,
        COALESCE(SUM(s.sales_value),0) AS total_sales
    FROM employees e
    LEFT JOIN sales s
        ON e.employee_id = s.employee_id
    GROUP BY
        e.employee_id,
        e.employee_name,
        e.department
)

SELECT
    employee_name,
    department,
    total_sales
FROM employee_sales
WHERE total_sales > (
    SELECT AVG(total_sales)
    FROM employee_sales
)
ORDER BY total_sales DESC;

WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        COALESCE(SUM(s.sales_value),0) AS total_sales
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
    total_sales,

    ROUND(
        total_sales * 100.0 /
        SUM(total_sales) OVER(),
        2
    ) AS contribution_pct,

    DENSE_RANK() OVER(
        ORDER BY total_sales DESC
    ) AS product_rank

FROM product_sales
ORDER BY product_rank;

WITH department_sales AS (
    SELECT
        e.department,
        COALESCE(SUM(s.sales_value),0) AS total_revenue
    FROM employees e
    LEFT JOIN sales s
        ON e.employee_id = s.employee_id
    GROUP BY e.department
)

SELECT
    department,
    total_revenue
FROM department_sales
WHERE total_revenue > (
    SELECT AVG(total_revenue)
    FROM department_sales
)
ORDER BY total_revenue DESC;

