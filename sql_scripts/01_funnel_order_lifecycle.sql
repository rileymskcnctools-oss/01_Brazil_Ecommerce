-- 统计各状态订单量，构建漏斗基础
SELECT order_status, COUNT(order_id) as total_orders
FROM olist_orders_dataset
GROUP BY 1 ORDER BY 2 DESC;




