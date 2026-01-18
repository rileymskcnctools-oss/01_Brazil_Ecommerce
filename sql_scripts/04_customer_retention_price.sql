-- 专题四：用户购买频次与价格关联查询
SELECT 
    c.customer_unique_id,
    COUNT(distinct o.order_id) AS purchase_count,       -- 计算回购频次
    AVG(oi.price) AS avg_item_price,                    -- 该用户的平均消费水平
    SUM(oi.price) AS total_spend                        -- 总贡献额
FROM olist_orders_dataset o
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id        -- 获取唯一用户ID
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id          -- 获取价格信息
WHERE o.order_status = 'delivered'                                     -- 排除无效订单
GROUP BY c.customer_unique_id                                          -- 按用户聚合
ORDER BY purchase_count DESC;                                          -- 按回购次数排序