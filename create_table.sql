CREATE TABLE IF NOT EXISTS public.cotacoes (
    id                  BIGSERIAL PRIMARY KEY,
    ativo               TEXT NOT NULL,
    preco               NUMERIC(18,6) NOT NULL,
    moeda               CHAR(3) NOT NULL DEFAULT 'USD',
    horario_coleta      TIMESTAMP NOT NULL,
    inserido_em         TIMESTAMP NOT NULL
);