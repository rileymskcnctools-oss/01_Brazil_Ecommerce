SELECT order_status, COUNT(order_id) as total_orders
FROM olist_orders_dataset
GROUP BY 1 ORDER BY 2 DESC;

-- 重点关注别名，避免 Python 报 KeyError
SELECT payment_type, 
       COUNT(order_id) as order_count, 
       AVG(payment_value) as avg_payment_value
FROM olist_order_payments_dataset
GROUP BY 1 ORDER BY avg_payment_value DESC ;