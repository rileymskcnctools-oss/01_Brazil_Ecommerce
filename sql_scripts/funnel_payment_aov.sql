-- 计算各支付方式的订单占比及客单价(AOV)
SELECT 
    payment_type, 
    COUNT(order_id) AS total_orders,
    SUM(payment_value) AS total_revenue,
    AVG(payment_value) AS avg_order_value -- 别名不能有空格，防止 Python 报错
FROM olist_order_payments_dataset
GROUP BY 1
ORDER BY total_revenue DESC;