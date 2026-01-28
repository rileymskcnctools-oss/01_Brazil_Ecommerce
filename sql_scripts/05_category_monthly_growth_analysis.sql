WITH monthly_sales AS (
    -- 第一层：基础聚合
    SELECT 
        strftime('%Y-%m', order_purchase_timestamp) AS month,
        pcnt.product_category_name_english AS category,
        SUM(price) AS monthly_revenue
    FROM olist_orders_dataset o
    JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
    JOIN olist_products_dataset opd ON opd.product_id =oi.product_id 
    JOIN product_category_name_translation pcnt ON pcnt.product_category_name=opd.product_category_name 
    WHERE o.order_status = 'delivered'
      AND strftime('%Y', o.order_purchase_timestamp) = '2017'
    GROUP BY 1,2
),
lag_prepared AS (
    -- 第二层：专门处理窗口函数，并起好别名
    SELECT 
        month,
        monthly_revenue,
        category,
        LAG(monthly_revenue) OVER (PARTITION BY category ORDER BY month) AS last_monthly_revenue
    FROM monthly_sales
)
-- 第三层：进行业务运算，逻辑清晰且避免重复计算
SELECT 
    month,
    category,
    monthly_revenue,
    IFNULL(last_monthly_revenue, 0) AS last_monthly_revenue,
    -- 增加 CASE WHEN 防止首月分母为 0 导致的报错
    CASE 
        WHEN last_monthly_revenue IS NULL THEN '0.00%' 
        ELSE ROUND((monthly_revenue - last_monthly_revenue) * 100.0 / last_monthly_revenue, 2) || '%' 
    END AS growth_pct
FROM lag_prepared;