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

target_curve = [
    item for item in data["data"]
    if item.get("project") == "curve-dex" and item.get("chain") == "Ethereum" and item.get("symbol") == "USDC-WBTC-WETH"
]

print(f"found {len(target_curve)} Curve pools")
print(json.dumps(target_curve[:3], indent=2))