WITH monthly_gmv AS (
    SELECT 
        strftime('%Y-%m', o.order_purchase_timestamp) AS month,
        -- 全平台总 GMV
        SUM(oi.price) AS total_gmv,
        -- 仅 garden_tools 类目的 GMV
        SUM(CASE WHEN pcnt.product_category_name_english = 'garden_tools' THEN oi.price ELSE 0 END) AS garden_tools_gmv
        --条件聚合，用于计算特定种类总营收金额
    FROM olist_orders_dataset o
    JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
    JOIN olist_products_dataset p ON oi.product_id = p.product_id
    JOIN product_category_name_translation pcnt ON p.product_category_name = pcnt.product_category_name
    WHERE o.order_status = 'delivered'
      AND strftime('%Y', o.order_purchase_timestamp) = '2017'
    GROUP BY 1
)
SELECT 
    month,
    total_gmv,
    garden_tools_gmv,
    -- 计算贡献率百分比
    ROUND(garden_tools_gmv * 100.0 / total_gmv, 2) AS contribution_rate
FROM monthly_gmv
ORDER BY 2 DESC;