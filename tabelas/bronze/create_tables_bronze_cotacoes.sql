-- BRONZE • CLIENTES
-- PK própria + ID de origem preservado
CREATE TABLE IF NOT EXISTS bronze_customers (
  bronze_customer_id BIGSERIAL PRIMARY KEY,   -- PK da camada Bronze (surrogate)
  customer_id        TEXT NOT NULL,           -- ID de origem (ex.: C001)
  customer_name      VARCHAR(200) NOT NULL,
  documento          VARCHAR(32),
  segmento           VARCHAR(64),
  pais               VARCHAR(64),
  estado             VARCHAR(16),
  cidade             VARCHAR(100),
  created_at         TIMESTAMPTZ NOT NULL
);




-- BRONZE • VENDAS BTC (sem preço unitário)
-- PK própria + transaction_id de origem preservado
CREATE TABLE IF NOT EXISTS bronze_sales_btc_excel (
  bronze_sales_btc_id BIGSERIAL PRIMARY KEY,  -- PK append-only
  transaction_id      TEXT NOT NULL,          -- ID da planilha/origem
  data_hora           TIMESTAMPTZ NOT NULL,
  ativo               VARCHAR(16) NOT NULL,   -- "BTC"
  quantidade          NUMERIC(18,6) NOT NULL CHECK (quantidade > 0),
  tipo_operacao       VARCHAR(10) NOT NULL CHECK (tipo_operacao IN ('COMPRA','VENDA')),
  moeda               VARCHAR(10) NOT NULL,
  cliente_id          TEXT,                   -- referencia ao customer_id da origem
  canal               VARCHAR(32),
  mercado             VARCHAR(8),
  arquivo_origem      VARCHAR(256),
  importado_em        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


-- BRONZE • VENDAS COMMODITIES (sem preço unitário)
-- PK própria + transaction_id de origem preservado
CREATE TABLE IF NOT EXISTS bronze_sales_commodities_sql (
  bronze_sales_comm_id BIGSERIAL PRIMARY KEY, -- PK append-only
  transaction_id       TEXT NOT NULL,         -- ID da origem transacional
  data_hora            TIMESTAMPTZ NOT NULL,
  commodity_code       VARCHAR(20) NOT NULL,  -- GOLD, OIL, COFFEE, SILVER...
  quantidade           NUMERIC(18,6) NOT NULL CHECK (quantidade > 0),
  tipo_operacao        VARCHAR(10) NOT NULL CHECK (tipo_operacao IN ('COMPRA','VENDA')),
  unidade              VARCHAR(16) NOT NULL,  -- kg, bbl, oz...
  moeda                VARCHAR(10) NOT NULL,
  cliente_id           TEXT,                  -- referencia ao customer_id da origem
  canal                VARCHAR(32),
  mercado              VARCHAR(8),
  arquivo_origem       VARCHAR(256),
  importado_em         TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
