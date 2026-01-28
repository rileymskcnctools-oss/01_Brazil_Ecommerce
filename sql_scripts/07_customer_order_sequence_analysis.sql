/* 业务背景：识别用户下单顺序，区分首单与复购行为
   技术核心：ROW_NUMBER() 窗口函数
*/

WITH order_sequence AS (
    SELECT 
        customer_unique_id,
        order_id,
        order_purchase_timestamp,
        -- 为每个用户的订单按时间排序，生成序号
        ROW_NUMBER() OVER(
            PARTITION BY customer_unique_id 
            ORDER BY order_purchase_timestamp ASC
        ) AS order_number
    FROM olist_orders_dataset o
    JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
    WHERE order_status = 'delivered'
)
SELECT 
    order_number,
    COUNT(order_id) AS total_orders,
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM order_sequence
GROUP BY 1
ORDER BY 1;