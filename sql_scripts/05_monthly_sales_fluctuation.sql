/* 专题五：月度销售额波动与因素拆解
目的：分析营收增长趋势，拆解订单量与客单价的贡献度
*/

SELECT 
    strftime('%Y-%m', o.order_purchase_timestamp) AS month_idx,
    -- 核心指标：总营收
    SUM(p.payment_value) AS total_revenue,
    -- 核心指标：订单量
    COUNT(DISTINCT o.order_id) AS order_count,
    -- 核心指标：平均客单价 (AOV)
    SUM(p.payment_value) / COUNT(DISTINCT o.order_id) AS avg_order_value
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 1;