import pandas as pd
import os
import time
from extract.GetCommodities import get_commodities_df
from extract.GetBTC import get_btc_df
from sqlalchemy import create_engine
from dotenv import load_dotenv


# Carregar variaveis do .env
load_dotenv()

# Configuracoes do banco
DB_USER = os.getenv('user')
DB_PASSWORD = os.getenv('password')
DB_HOST = os.getenv('host')
DB_PORT = os.getenv('port')
DB_NAME = os.getenv('dbname')

# Conexao com banco
DATABASE_URL = f'postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}'
engine = create_engine(DATABASE_URL)

SLEEP_SECONDS = 60

if __name__ == '__main__':
    while True:

        # Coleta
        df_btc = get_btc_df()
        df_commodities = get_commodities_df()

        # Juntar os dados do BTC com os dados das commodities
        df = pd.concat([df_btc, df_commodities], ignore_index=True)

        
        df.to_sql('cotacoes', engine, if_exists='append', index=False)

        print('Cotacoes inseridas no banco com sucesso')

        # Espera para o proximo ciclo
        time.sleep(SLEEP_SECONDS)