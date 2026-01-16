SELECT
    oord.review_score, 
    -- 实际总物流耗时均值
    AVG(JULIANDAY(ood.order_delivered_customer_date) - JULIANDAY(ood.order_purchase_timestamp)) AS AVG_delivery_days,
    -- 延迟天数均值
    AVG(JULIANDAY(ood.order_delivered_customer_date) - JULIANDAY(ood.order_estimated_delivery_date)) AS AVG_delay_days
FROM olist_orders_dataset ood
JOIN olist_order_reviews_dataset oord ON ood.order_id = oord.order_id 
WHERE ood.order_status = 'delivered'
  AND ood.order_delivered_customer_date IS NOT NULL 
  AND ood.order_estimated_delivery_date IS NOT NULL
GROUP BY 1 
ORDER BY oord.review_score DESC; -- 改为按评分排序，观察延迟的变化趋势