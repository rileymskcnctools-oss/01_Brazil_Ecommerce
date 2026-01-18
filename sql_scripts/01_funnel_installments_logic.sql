-- 分析分期期数与订单金额的分段关系
SELECT 
    CASE 
        WHEN payment_installments = 1 THEN '01_Full_Payment'
        WHEN payment_installments <= 3 THEN '02_Short_Installment(2-3)'
        WHEN payment_installments <= 6 THEN '03_Mid_Installment(4-6)'
        ELSE '04_Long_Installment(7+)'
    END AS installment_group,
    COUNT(order_id) AS order_count,
    AVG(payment_value) AS avg_payment
FROM olist_order_payments_dataset
GROUP BY 1
ORDER BY 1;