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

target_sushiswap = [
    item for item in data["data"]
    if item.get("project") == "sushiswap" and item.get("chain") == "Ethereum" and item.get("symbol") == "WETH-USDT"
]

print(f"found {len(target_sushiswap)} Sushiswap pools")
print(json.dumps(target_sushiswap[:3], indent=2))