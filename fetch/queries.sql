-- this doc tracks queries passed into Dune's SQL to extract 1-year historical data 
-- relevant pools sourced from cryptokoryo's dashboard: 
-- NB: data that we need: 
-- swap level: swap size, trade size, venue identifier, execution price, timestamp, 
-- pool reserves at time of swap if available
-- 1 year of pool/tvl reserves per venue 


-- uniswap 
-- contract addresses 
-- ETH/USDC uniswapv3_0.05: 0x88e6A0c2dDD26FEEb64F039a2c41296FcB3f5640
-- ETH/USDC uniswapv3_0.3: 0x8ad599c3A0ff1De082011EFDDc58f1908eb6e6D8
-- ETH/USDC uniswapv3_0.01: 0xE0554a476A092703abdB3Ef35c80e0D76d32939F
-- ETH/USDC uniswapv3_1.0: 0x7BeA39867e4169DBe237d55C8242a8f2fcDcc387
-- ETH/USDT uniswapv3_0.05: 0x11b815efB8f581194ae79006d24E0d814B7697F6
-- ETH/USDT uniswapv3_0.3: 0x4e68Ccd3E89f51C3074ca5072bbAC773960dFa36
-- ETH/USDT uniswapv3_0.01: 0xc7bBeC68d12a0d1830360F8Ec58fA599bA1b0e9b

-- swap details
    -- dex.trades
        -- blockchain = ethereum
        -- project, token_bought_symbol, token_sold_symbol, token_pair
        -- token_bought_amount, token_sold_amount, amount_usd, project_contract_address, 
        -- tx_hash
-- liquidity details 