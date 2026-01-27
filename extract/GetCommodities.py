import yfinance as yf # pandas e requests ja estao importados
from datetime import datetime
import pandas as pd

def get_commodities_df():

    comm_sym = ['GC=F', 'CL=F', 'SI=F']

    # pegando os valores de abertura, max, min, fechamento no perido de um dia no intevalo de 1 minuto
    # Quero apenas o ultimo valor de fechamento(Close)

    dfs = []
    for sym in comm_sym:
        df = yf.Ticker(sym).history(period='1d', interval='1m')[['Close']].tail(1)
        df = df.rename(columns={'Close': 'preco'})
        df['ativo'] = sym
        df['moeda'] = 'USD'
        df['horario_coleta'] = datetime.now()
        df = df[['ativo', 'preco', 'moeda', 'horario_coleta']]
        dfs.append(df)

    df_commodities = pd.concat(dfs, ignore_index=True)
        
    return df_commodities