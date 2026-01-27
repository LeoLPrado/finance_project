CREATE TABLE silver_transaction_union AS
SELECT
    b.transaction_id,
    -- hora truncada (para join)
    date_trunc('hour', b.data_hora)           AS data_hora_h,
    -- componentes úteis de data
    (b.data_hora AT TIME ZONE 'UTC')::date    AS data_dia,
    EXTRACT(YEAR  FROM b.data_hora)::int      AS ano,
    EXTRACT(MONTH FROM b.data_hora)::int      AS mes,
    EXTRACT(DAY   FROM b.data_hora)::int      AS dia,
    EXTRACT(HOUR  FROM b.data_hora)::int      AS hora,

    TRIM(b.ativo) AS asset_raw,
    CASE
        WHEN UPPER(TRIM(b.ativo)) = 'BTC'     THEN 'BTC-USD'
    END AS symbol_cotacao_norm,

    b.quantidade,
    b.tipo_operacao,
    b.moeda,
    b.cliente_id,
    b.canal,
    b.mercado
FROM bronze_sales_btc_excel AS b

UNION ALL 

SELECT
    c.transaction_id,
    date_trunc('hour', c.data_hora)           AS data_hora_h,
    (c.data_hora AT TIME ZONE 'UTC')::date    AS data_dia,
    EXTRACT(YEAR  FROM c.data_hora)::int      AS ano,
    EXTRACT(MONTH FROM c.data_hora)::int      AS mes,
    EXTRACT(DAY   FROM c.data_hora)::int      AS dia,
    EXTRACT(HOUR  FROM c.data_hora)::int      AS hora,

    TRIM(c.commodity_code) AS asset_raw,
    CASE
        WHEN UPPER(TRIM(c.commodity_code)) = 'GOLD'    THEN 'GC=F'
        WHEN UPPER(TRIM(c.commodity_code)) = 'OIL'     THEN 'CL=F'
        WHEN UPPER(TRIM(c.commodity_code)) = 'SILVER'  THEN 'SI=F'
    END AS symbol_cotacao_norm,

    c.quantidade,
    c.tipo_operacao,
    c.moeda,
    c.cliente_id,
    c.canal,
    c.mercado
FROM bronze_sales_commodities_sql AS c
;