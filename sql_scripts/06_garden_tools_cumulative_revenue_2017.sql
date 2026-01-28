/* 业务背景：计算核心类目 garden_tools 的年度业绩达成情况
技术核心：SUM() OVER() 窗口函数
*/

WITH monthly_revenue AS (
    -- 第一层：基础聚合，获取每月营收
    SELECT 
        strftime('%Y-%m', o.order_purchase_timestamp) AS month,
        SUM(oi.price) AS monthly_sales
    FROM olist_orders_dataset o
    JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
    JOIN olist_products_dataset p ON oi.product_id = p.product_id
    JOIN product_category_name_translation pcnt ON p.product_category_name = pcnt.product_category_name
    WHERE pcnt.product_category_name_english = 'garden_tools'
      AND strftime('%Y', o.order_purchase_timestamp) = '2017'
    GROUP BY 1
)
SELECT 
    month,
    monthly_sales,
    -- 核心逻辑：从第一行累加至当前行，计算 Running Total
    SUM(monthly_sales) OVER ( ORDER BY month ) AS running_total_gmv,
    -- 进阶：计算每个月对年终总目标的贡献占比
    ROUND(monthly_sales  / SUM(monthly_sales) OVER()* 100.0, 2) || '%' AS monthly_contribution_to_annual
FROM monthly_revenue;