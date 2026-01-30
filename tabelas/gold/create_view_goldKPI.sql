CREATE OR REPLACE VIEW gold_KPI_bycustomer AS
SELECT 
  t2.customer_id, t2.customer_name,
  SUM(t1.total_abs) AS fluxo_liquido_usd,
  SUM(t1.total_based_type) AS volume_total_usd,
  COUNT(distinct t1.transaction_id) AS transacoes

FROM silver_sales_enriched AS t1
LEFT JOIN bronze_customers AS t2
ON t1.cliente_id = t2.customer_id

GROUP BY t2.customer_id, t2.customer_name;