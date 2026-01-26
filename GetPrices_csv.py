import pandas as pd
import os
import time
from GetCommodities import get_commodities_df
from GetBTC import get_btc_df

SLEEP_SECONDS = 60
CSV_PATH = 'cotacoes.csv'

# Garantindo cabecario na primeira execucao:
if not os.path.exists(CSV_PATH):
    cols = ['ativo', 'preco', 'moeda', 'horario_coleta']
    pd.DataFrame(columns=cols).to_csv(CSV_PATH, header=True, index=False)

# Pegando as cotacoes a cada 1 minuto e jogando no csv
while True:

    df_btc = get_btc_df()
    df_commodities = get_commodities_df()

    df = pd.concat([df_btc, df_commodities], ignore_index=True)

    # mode = 'a' para fazer append ao inves de overwrite
    df.to_csv(CSV_PATH, mode='a', header=False, index=False)

    time.sleep(SLEEP_SECONDS)
    print('Adicionando as cotacoes')