SELECT
    e.employee_id,
    e.employee_name,
    e.department,
    COUNT(s.order_id) AS order_count,
    COALESCE(SUM(s.sales_value),0) AS total_sales,
    COALESCE(AVG(s.sales_value),0) AS average_order_value
FROM employees e
LEFT JOIN sales s
    ON e.employee_id = s.employee_id
GROUP BY
    e.employee_id,
    e.employee_name,
    e.department
ORDER BY total_sales DESC;

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
    ) AS company_rank
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
    total_sales,
    ROUND(
        total_sales * 100.0 /
        SUM(total_sales) OVER(),
        2
    ) AS revenue_contribution_pct
FROM employee_sales
ORDER BY total_sales DESC;

