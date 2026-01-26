import requests
from datetime import datetime
import pandas as pd

def get_btc_df():

    url = 'https://api.coinbase.com/v2/prices/spot'

    response = requests.get(url)
    data = response.json()

    preco = float(data['data']['amount'])
    ativo = data['data']['base']
    moeda = data['data']['currency']
    horario_coleta = datetime.now()

    df = pd.DataFrame([{
        'preco': preco, 
        'ativo': ativo,
        'moeda': moeda,
        'horario_coleta': horario_coleta
    }])
    
    return df