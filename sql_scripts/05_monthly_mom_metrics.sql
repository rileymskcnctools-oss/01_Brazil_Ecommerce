WITH MonthlyStats AS (
    SELECT 
        strftime('%Y-%m', o.order_purchase_timestamp) AS month,
        SUM(i.price) AS current_month_gmv,
        COUNT(DISTINCT o.order_id) AS order_volume
    FROM olist_orders_dataset o
    JOIN olist_order_items_dataset i ON o.order_id = i.order_id
    WHERE o.order_status = 'delivered'
    -- 这里不要过滤 2017，确保能抓到 2016-12
    GROUP BY 1
)
SELECT 
    month,
    current_month_gmv,
    order_volume,
    LAG(current_month_gmv) OVER (ORDER BY month) AS last_month_gmv
FROM MonthlyStats
