CREATE TABLE IF NOT EXISTS silver_sales_enriched AS
SELECT t1.transaction_id,
  t1.data_hora_h,
  t1.data_dia,t1.ano,t1.mes,t1.dia,t1.hora,
  t1.asset_raw,
  t1.symbol_cotacao_norm,
  t1.quantidade,
  t1.tipo_operacao,
  t1.moeda,
  t1.cliente_id,
  t1.canal,
  t1.mercado,

  t2.preco AS preco_unitario,
 
  t1.quantidade * t2.preco AS total_abs,

  t1.quantidade * t2.preco * CASE
     WHEN t1.tipo_operacao = 'VENDA' THEN 1
     WHEN t1.tipo_operacao = 'COMPRA' THEN -1
     ELSE NULL END AS total_based_type

FROM silver_transaction_union AS t1

LEFT JOIN silver_prices_hourly AS t2
ON t1.data_hora_h = t2.horario_coleta
AND t1.symbol_cotacao_norm = t2.ativo
AND t1.moeda = 'USD'

ORDER BY t1.transaction_id;