/* 专题三：地域维度物流表现分析
目的：找出物流耗时最长的省份（州），为仓库布局提供数据支持
*/

SELECT 
    c.customer_state,
    -- 订单量，用于衡量样本代表性
    COUNT(ood.order_id) AS total_orders,
    -- 平均送达天数（实际耗时）
    AVG(JULIANDAY(ood.order_delivered_customer_date) - JULIANDAY(ood.order_purchase_timestamp)) AS avg_delivery_days,
    -- 平均延迟天数（负数为提前）
    AVG(JULIANDAY(ood.order_delivered_customer_date) - JULIANDAY(ood.order_estimated_delivery_date)) AS avg_delay_days,
    -- 平均评分
    AVG(oord.review_score) AS avg_review_score
FROM olist_orders_dataset ood
JOIN olist_customers_dataset c ON ood.customer_id = c.customer_id
JOIN olist_order_reviews_dataset oord ON ood.order_id = oord.order_id
WHERE ood.order_status = 'delivered'
  AND ood.order_delivered_customer_date IS NOT NULL
GROUP BY 1
-- 过滤掉订单量极少的州，避免异常值干扰均值
HAVING total_orders > 50
ORDER BY avg_delivery_days DESC;