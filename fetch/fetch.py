# this fetches the historical tvl for all uniswal v3 pools from defillama 

import pandas as pd 
import numpy as np 
import requests 


url = "https://yields.llama.fi/pools"

response = requests.get(url)

if response.status_code == 200:
    print(f"Successfully fetched data.")
else:
    print(f"Error fetching the data.")

data = response.json()

# iterating through data to find specific UUIDs 