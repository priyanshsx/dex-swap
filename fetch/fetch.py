# this fetches the historical tvl for all uniswal v3 pools from defillama 

import pandas as pd 
import numpy as np 
import requests 
import json


url = "https://yields.llama.fi/pools"

response = requests.get(url)

if response.status_code == 200:
    print(f"Successfully fetched data from DeFillama.")
    data = response.json()
else:
    print(f"Error fetching the data from DeFillama.")

# find specific UUIDs per pool 

pool_uuids = []

# ETH/USDC pairs 

target_pools = {

    # ETH/USDC
    ("USDC-WETH", "0.05%"): "0x88e6a0c2ddd26feeb64f039a2c41296fcb3f5640",
    ("WETH-USDC", "0.05%"): "0x88e6a0c2ddd26feeb64f039a2c41296fcb3f5640",
    ("USDC-WETH", "0.3%"):  "0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8",
    ("WETH-USDC", "0.3%"):  "0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8",
    ("USDC-WETH", "0.01%"): "0xe0554a476a092703abdB3Ef35c80e0D76d32939F",
    ("WETH-USDC", "0.01%"): "0xe0554a476a092703abdB3Ef35c80e0D76d32939F",
    ("USDC-WETH", "1%"):    "0x7BeA39867e4169DBe237d55C8242a8f2fcDcc387",
    ("WETH-USDC", "1%"):    "0x7BeA39867e4169DBe237d55C8242a8f2fcDcc387",

    # ETH/USDT
    ("USDT-WETH", "0.05%"): "0x11b815efb8f581194ae79006d24e0d814b7697f6",
    ("WETH-USDT", "0.05%"): "0x11b815efb8f581194ae79006d24e0d814b7697f6",
    ("USDT-WETH", "0.3%"):  "0x4e68Ccd3E89f51C3074ca5072bbAC773960dFa36",
    ("WETH-USDT", "0.3%"):  "0x4e68Ccd3E89f51C3074ca5072bbAC773960dFa36",
    ("USDT-WETH", "0.01%"): "0xc7bBeC68d12a0d1830360F8Ec58fA599bA1b0e9b",
    ("WETH-USDT", "0.01%"): "0xc7bBeC68d12a0d1830360F8Ec58fA599bA1b0e9b"
}

for item in data['data']:

    # checking and filtering for uniswap v3 on ethereum 
    if item.get('project') == 'uniswap-v3' and item.get('chain') == 'Ethereum':

        # extracting tier and symbols from the json object
        tier = item.get('poolMeta')
        symbol = item.get('symbol')

        if (symbol, tier) in target_pools:

            # creating a dict and storing UUIDs 
            pool_uuids.append({
                "uuid": item['pool'],
                "fee_tier": tier, 
                "symbol": symbol, 
                "project_contract_address": target_pools[(symbol, tier)].lower()
            })


# fetch the historical data per UUID 

all_records = []

for pool_info in pool_uuids:
    pool_id = pool_info['uuid']

    # getting response from defillama 
    url = f"https://yields.llama.fi/chart/{pool_id}"
    response = requests.get(url)

    if response.status_code == 200:
        chart_data = response.json()

        # storing all records in the all_records dict
        for entry in chart_data.get('data', []):
            all_records.append({
                "date": entry["timestamp"],
                "tvl_usd": entry['tvlUsd'],
                "symbol": pool_info["symbol"],
                "fee_tier": pool_info["fee_tier"],
                "project_contract_address": pool_info["project_contract_address"]
            })
    else: 
        print(f"Error fetching historical data from DeFillama for UUID: {pool_id}.")

# saving to a csv

df_tvl = pd.DataFrame(all_records)

# ensuring the correct format for time so that easier to merge with csv from dune 
df_tvl['week'] = pd.to_datetime(df_tvl['date']).dt.tz_localize(None).dt.to_period('W').dt.to_timestamp()
df_tvl_weekly = (df_tvl.groupby(['week', 'project_contract_address', 'symbol', 'fee_tier'])['tvl_usd'].mean().reset_index())
df_tvl_weekly.to_csv('/home/priyansh/Documents/d/dex_swap/raw_data/df_tvl_weekly.csv', index=False)
