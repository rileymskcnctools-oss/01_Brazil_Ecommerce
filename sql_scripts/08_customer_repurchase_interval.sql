/* 业务背景：分析复购用户的回流周期
   技术核心：ROW_NUMBER (标记序号) + LAG (跨行取值)
*/

WITH user_order_flow AS (
    SELECT 
        c.customer_unique_id,
        o.order_purchase_timestamp,
        -- 1. 标记这是该用户的第几单
        ROW_NUMBER() OVER(PARTITION BY c.customer_unique_id ORDER BY o.order_purchase_timestamp) AS order_seq,
        -- 2. 获取该用户上一单的时间
        LAG(o.order_purchase_timestamp) OVER(PARTITION BY c.customer_unique_id ORDER BY o.order_purchase_timestamp) AS prev_order_time
    FROM olist_orders_dataset o
    JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
)
SELECT 
    customer_unique_id,
    order_seq,
    order_purchase_timestamp,
    prev_order_time,
    -- 3. 计算两次下单的日期差（以天为单位）
    julianday(order_purchase_timestamp) - julianday(prev_order_time) AS days_since_prior_order
FROM user_order_flow
WHERE order_seq > 1; -- 只看复购行为（即第2单及以上）