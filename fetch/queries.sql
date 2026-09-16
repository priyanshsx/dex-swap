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

-- sushiswap 
-- contract addresses 
-- USDC/ETH sushiv2: 0x397FF1542f962076d0BFE58eA045FfA2d347ACa0
-- ETH/USDT sushiv3: 0x06da0fd433C1A5d7a4faA01111c044910A184553 

-- curve 
-- tricryptousdc/usdcwbtcweth: 0x7f86bf177dd4f3494b841a37e810a34dd56c829b
-- tricrypto2 / usdt/wbtc/weth: 0xD51a44d3FaE010294C616388b506AcdA1bfAAE46
-- tricrypto usdt: 0xf5f5B97624542D72A9E06f04804Bf81baA15e2B4

SELECT 
    DATE_TRUNC('week', block_time) AS week,

    CASE
        -- uniswap addresses
        WHEN project_contract_address = 0x88e6A0c2dDD26FEEb64F039a2c41296FcB3f5640 THEN 'uniswap_v3_0.05_ethusdc'
        WHEN project_contract_address = 0x8ad599c3A0ff1De082011EFDDc58f1908eb6e6D8 THEN 'uniswap_v3_0.3_ethusdc'
        WHEN project_contract_address = 0xE0554a476A092703abdB3Ef35c80e0D76d32939F THEN 'uniswap_v3_0.01_ethusdc'
        WHEN project_contract_address = 0x7BeA39867e4169DBe237d55C8242a8f2fcDcc387 THEN 'uniswap_v3_1.0_ethusdc'
        WHEN project_contract_address = 0x11b815efB8f581194ae79006d24E0d814B7697F6 THEN 'uniswap_v3_0.05_ethusdt'
        WHEN project_contract_address = 0x4e68Ccd3E89f51C3074ca5072bbAC773960dFa36 THEN 'uniswap_v3_0.3_ethusdt'
        WHEN project_contract_address = 0xc7bBeC68d12a0d1830360F8Ec58fA599bA1b0e9b THEN 'uniswap_v3_0.01_ethusdt'
        
        -- sushiswap addresses 
        WHEN project_contract_address = 0x397FF1542f962076d0BFE58eA045FfA2d347ACa0 THEN 'sushiv2_usdceth'
        WHEN project_contract_address = 0x06da0fd433C1A5d7a4faA01111c044910A184553 THEN 'sushiv2_ethusdt'

        -- curve addresses 
        WHEN project_contract_address = 0x7f86bf177dd4f3494b841a37e810a34dd56c829b THEN 'curve_usdcwbtcweth'
        WHEN project_contract_address = 0xD51a44d3FaE010294C616388b506AcdA1bfAAE46 THEN 'curve_usdtwbtcweth'
        WHEN project_contract_address = 0xf5f5B97624542D72A9E06f04804Bf81baA15e2B4 THEN 'curve_usdt'
    END AS venue,

    CASE
        WHEN amount_usd <  1000   THEN '0.5k-1k'
        WHEN amount_usd <  10000  THEN '1k-10k'
        WHEN amount_usd <  100000 THEN '10k-100k'
        ELSE '100k+'
    END AS size_bucket,

    COUNT(*) AS swap_count,
    SUM(amount_usd) AS total_volume_usd,
    SUM(token_bought_amount) AS total_token_bought,
    SUM(token_sold_amount) AS total_token_sold,
    project_contract_address AS project_contract_address

FROM dex.trades 

WHERE 
    blockchain = 'ethereum' AND 
    project IN ('uniswap', 'sushiswap', 'curve') AND 
    project_contract_address IN (
        0x88e6A0c2dDD26FEEb64F039a2c41296FcB3f5640,
        0x8ad599c3A0ff1De082011EFDDc58f1908eb6e6D8,
        0xE0554a476A092703abdB3Ef35c80e0D76d32939F,
        0x7BeA39867e4169DBe237d55C8242a8f2fcDcc387,
        0x11b815efB8f581194ae79006d24E0d814B7697F6,
        0x4e68Ccd3E89f51C3074ca5072bbAC773960dFa36,
        0xc7bBeC68d12a0d1830360F8Ec58fA599bA1b0e9b,
        0x397FF1542f962076d0BFE58eA045FfA2d347ACa0,
        0x06da0fd433C1A5d7a4faA01111c044910A184553,
        0x7f86bf177dd4f3494b841a37e810a34dd56c829b,
        0xD51a44d3FaE010294C616388b506AcdA1bfAAE46,
        0xf5f5B97624542D72A9E06f04804Bf81baA15e2B4
    ) AND 
    block_time >= CAST('2025-07-16' AS TIMESTAMP) AND 
    amount_usd >= 500

GROUP BY 1, 2, 3
ORDER BY week, venue, size_bucket

-- joining the two tables in duckdb
CREATE TABLE merged AS 
SELECT 
    dune.venue, 
    dune.size_bucket,
    dune.project_contract_address, 
    dune.swap_count, 
    dune.total_volume_usd, 
    dune.total_token_bought, 
    dune.total_token_sold,
    tvl.tvl_usd, 
    tvl.fee_tier

FROM dune_swap_data_updated AS dune
LEFT JOIN df_tvl_weekly AS tvl
ON LOWER(dune.project_contract_address) = LOWER(tvl.project_contract_address)
AND dune.week = tvl.week  















-- ================================ can delete later ====================================
-- (not needed) liquidity details (curve, sushiswap) 
    -- table to use: dex.pools_metrics_daily 
        -- blockchain, project, pool_symbol, pool_type, swap_amount_usd, tvl_usd, tvl_eth,
        -- block_date
        -- NB: the dex.pools_metrics_daily doesn't contain data for uniswap 
        -- all columns for this table: blockchain, project, version, block_date, project_contract_address, pool_symbol, pool_type, swap_amount_usd, tvl_usd, tvl_eth, fee_amount_usd  