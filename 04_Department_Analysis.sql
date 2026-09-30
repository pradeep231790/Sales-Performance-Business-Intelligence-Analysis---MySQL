SELECT
    e.department,
    COALESCE(SUM(s.sales_value),0) AS total_revenue,
    COUNT(DISTINCT e.employee_id) AS employee_count
FROM employees e
LEFT JOIN sales s
    ON e.employee_id = s.employee_id
GROUP BY e.department
ORDER BY total_revenue DESC;

SELECT
    e.department,
    COALESCE(SUM(s.sales_value),0) AS total_revenue,
    COUNT(DISTINCT e.employee_id) AS employee_count,
    ROUND(
        COALESCE(SUM(s.sales_value),0) /
        NULLIF(COUNT(DISTINCT e.employee_id),0),
        2
    ) AS average_employee_revenue
FROM employees e
LEFT JOIN sales s
    ON e.employee_id = s.employee_id
GROUP BY e.department
ORDER BY total_revenue DESC;

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
    total_revenue,
    DENSE_RANK() OVER(
        ORDER BY total_revenue DESC
    ) AS department_rank
FROM department_sales
ORDER BY department_rank;

