SELECT payment_type, COUNT(*) as order_count 
FROM olist_order_payments_dataset oopd 
GROUP BY 1;