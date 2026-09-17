# this script helps debug the curve address 0xd51a44d3fae010294c616388b506acda1bfaae46 which has been 
# causing NULL tvl_usd values in our final merged table in db 

import requests 

url = "https://yields.llama.fi/pools"
response = requests.get(url)

if response.status_code == 200:
    print("Fetching API details...\n")
    data = response.json().get("data", [])

    # Search for Ethereum Curve pools that have USDT and WBTC in their symbol
    for pool in data:
        chain = pool.get('chain', '')
        project = pool.get('project', '').lower()
        symbol = pool.get('symbol', '').lower()
        
        if chain == 'Ethereum' and 'curve' in project:
            if 'usdt' in symbol and 'wbtc' in symbol:
                print(f"Project: {pool.get('project')}")
                print(f"Symbol: {pool.get('symbol')}")
                print(f"poolMeta: {pool.get('poolMeta')}")
                print(f"UUID: {pool.get('pool')}")
else:
    print("Failed to fetch from defillama.")

