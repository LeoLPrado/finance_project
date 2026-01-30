CREATE OR REPLACE VIEW gold_last7_vendas AS
SELECT 
  data_dia::date AS data,
  symbol_cotacao_norm AS ativo,
  SUM(total_abs) AS volume_diario,
  SUM(total_based_type) AS fluxo_liquido,
  COUNT(DISTINCT transaction_id) AS qtd_transacao

FROM silver_sales_enriched
WHERE data_hora_h >= current_date - INTERVAL '6 days'
GROUP BY data_dia, symbol_cotacao_norm;