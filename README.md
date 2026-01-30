# 📈 Financial Data Warehouse: Medallion Architecture

![Status](https://img.shields.io/badge/Status-Em_Desenvolvimento-yellow)
![Python](https://img.shields.io/badge/Python-3.10+-blue)
![SQL](https://img.shields.io/badge/SQL-Postgres-orange)
![Supabase](https://img.shields.io/badge/Data_Warehouse-Supabase-green)

## 📖 Sobre o Projeto

Este projeto consiste na implementação de um **Data Warehouse** focado em análise de ativos financeiros (Commodities e Criptomoedas). O objetivo principal é centralizar transações de diferentes naturezas e cruzá-las com dados de mercado históricos para gerar insights precisos sobre a evolução patrimonial.

A arquitetura segue o padrão **Medallion (Bronze, Silver, Gold)**, garantindo a rastreabilidade, limpeza e organização dos dados desde a ingestão bruta até a camada de análise.

---

## 🎯 Qual problema este projeto resolve?

Investidores frequentemente sofrem com a fragmentação de dados:
1.  As transações ficam espalhadas em planilhas ou corretoras diferentes.
2.  **O problema do "Snapshot":** A maioria das ferramentas simples calcula o patrimônio com base no preço *atual*. Este projeto resolve a necessidade de **Análise Histórica**.
3.  **Distorção Temporal:** Para saber se um investimento foi bom, é necessário cruzar o momento exato da compra com a cotação daquele instante.

Este pipeline resolve isso ao capturar cotações **hora a hora**, permitindo reconstruir a "foto" da carteira em qualquer momento do passado, e não apenas no presente.

---

## 🏗️ Arquitetura da Solução

O projeto está estruturado em uma arquitetura de camadas (Medallion) hospedada no **Supabase (PostgreSQL)**:

### 1. Ingestão (Extract & Load)
Scripts em **Python** rodam periodicamente (atualmente a cada 1 hora) conectando-se a APIs externas:
* **yFinance:** Para dados de Commodities (Ouro, Petróleo, Prata).
* **Bitcoin API:** Para dados específicos do bitcoin.

### 2. Camada Bronze (Raw)
Dados brutos, armazenados exatamente como chegam da fonte. O foco é alta velocidade de escrita e histórico imutável.
* `bronze_cotacoes`: Histórico de preços hora a hora.
* `bronze_sales_btc_excel`: Transações de BTC (origem manual/planilha).
* `bronze_sales_commodities`: Transações de commodities.
* `bronze_customer`: Dados cadastrais de clientes.

### 3. Camada Silver (Cleaned & Enriched)
Onde ocorre a mágica da transformação e limpeza:
* **Padronização:** Tipagem de dados (Casting).
* **Enriquecimento:** `silver_prices_hourly` consolida os preços.
* **Unificação:** `silver_transaction_union` unifica as vendas de BTC e Commodities em um esquema único.
* **Point-in-Time Join:** Cruzamento inteligente entre a data da transação e a cotação daquela hora específica na `silver_sales_enriched`.

### 4. Camada Gold (Business)
Dados agregados prontos para consumo por ferramentas de BI ou Dashboards.
* `gold_KPI_bycustomer`: Performance consolidada por cliente.
* `gold_last7_vendas`: Visão temporal dos ativos nos últimos 7 dias (SCD Tipo 2).

---

## 🚀 Stack Tecnológico

* **Linguagem:** Python (Pandas, Requests), SQL.
* **Banco de Dados:** PostgreSQL (via Supabase).
* **Conceitos:** Data Warehousing, ETL/ELT, Medallion Architecture.

---

## 🔮 Roadmap e Próximos Passos

Este projeto está em evolução constante para se adequar às melhores práticas de Engenharia de Dados.

- [ ] **Orquestração com Apache Airflow:**
    * Substituir a execução cronológica simples por DAGs no Airflow.
    * Alertas de falha e retries automáticos.

- [ ] **Transformação com dbt (data build tool):**
    * Migrar as queries SQL hardcoded para modelos dbt.

- [ ] **Visualização:**
    * Conectar a camada Gold ao Power BI ou Streamlit.

---