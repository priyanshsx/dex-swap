# DEX Swap 

## Research Question 
Under calm vs. stressed market conditions over the past year, which venue (Uniswap v3, SushiSwap, Curve) has provided the most consistent best execution for ETH/USDC. Further, it answers the questions: 
- how much would a trader lose by routing to a single 'default' venue instead of dynamically switching based on conditions? 
- how much slippage (in total) would a trader have paid based on trader categories (from $100 to $10K)

### Research points 
1. Execution quality by regime: compute effective price/slippage per venue for a fixed trade size, then split the entire year into calm vs. volatile windows (using realized volatility or a VIX-style rolling measure as a regime classifier). 
2. Liquidity depth over time as its own variable: Using pool TVL/reserves for each venue across the year, not just swap-level execution data. 
3. Free-tier fragmentation cost (Uniswap-specific): Uniswap v3 splits liquidity across multiple fee tiers for the same pair. This analysis quantifies how much execution quality is lost when liquidity is fragmented across tiers vs. concentrated. 
4. Consistency/reliability: this analysis reports variance of execution quality per venue. 
5. Behavior around specific named events: Sharp BTC drawdown in October 2025, liquidation cascades etc. 
6. Comparisons against 1inch's historical quoted price for the same pair/size where available

### Methodology 

**Data Extraction**

Since the DEXs offering volume can change dynamically, this research specifically picked three of the biggest and most-known venues for v1: Uniswap V3, PancakeSwap, and Curve. Chains categorized by volume can be found on [DeFiLlama](https://defillama.com/dexs/chain/ethereum) and [Coingecko](https://www.coingecko.com/en/exchanges/decentralized/ethereum).

Each of Uniswap's fee tiers (0.05%), (0.3%), and 1% were each treated as independent liquidity venues for ease of analysis. 

Uniswap Pools 
The following pools were selected from the list of [available pools](https://app.uniswap.org/explore/pools) on Uniswap for ETH/USDC and ETH/USDT pairs on Uniswap v3: 
- ETH/USDC uniswapv3_0.05: 0x88e6A0c2dDD26FEEb64F039a2c41296FcB3f5640
- ETH/USDC uniswapv3_0.3: 0x8ad599c3A0ff1De082011EFDDc58f1908eb6e6D8
- ETH/USDC uniswapv3_0.01: 0xE0554a476A092703abdB3Ef35c80e0D76d32939F
- ETH/USDC uniswapv3_1: 0x7BeA39867e4169DBe237d55C8242a8f2fcDcc387
- ETH/USDT uniswapv3_0.05: 0x11b815efB8f581194ae79006d24E0d814B7697F6
- ETH/USDT uniswapv3_0.3: 0x4e68Ccd3E89f51C3074ca5072bbAC773960dFa36
- ETH/USDT uniswapv3_0.01: 0xc7bBeC68d12a0d1830360F8Ec58fA599bA1b0e9b 

Total Pool TVL
Instead of measuring tick-wise liquidity, this investigation considers Total Pool TVL as a proxy for the overall pool depth across fee tiers. Pool TVL is calculated using the given formula: 
Pool TVL = (WETH Balance * ETH Price) + USDC Balance 

While sourcing historical data for pool tvl, I took the liberty of assuming that tvl_usd (a column from Dune's table) is the accurate source of tvl. Further, the liberty to assume that 50% of the tvl was in eth and the remaining 50% in usd was also exercised. 

Historical TVL sourcing: I couldn't find historical TVL data from Dune for Uniswap v3. And hence, I was unable to use that for tvl data. Instead, I found it on [DeFillama's docs](https://api-docs.defillama.com/#tag/yields/get/chart/{pool}). 

The project UUIDs were extracted from defillama's data and then stored by adding the project_contract_address separately. 

SQL Database 
The tables were pulled from Dune and DeFillama and both were joined on project_contract_address and week to create a merged table for further analysis. 

Null Values 
WHile pulling data from DeFillama, it was observed that several NULL values had crept in the database for Curve and SushiSwap. This meant that we hadn't been able to fetch accurate data from DeFiLlama itself. 

To effectively delineate calm vs stressed market periods, Kwant Terminal was used to extract ETH/USD data for the past year. 

**Analysis**

1. VWAP and Execution Drag 
This analysis compares the weekly VWAP to the executed price per trade to identify the execution drag. 

2. Identifying Market Regimes 
By effectively identifying market regimes through the previous year, we're computing what market regime affected the execution price the most. We use annualized realized volatility of the ETH-USD pair (sourced via the Kwant Terminal). 

3. Liquidity Turnover Ratio
This helps us compute how much liquidity helps in executing trades across various venues. A high turnover ratio in calm markets is healthy but the same during a market crash can impact swap execution. 

4. HHI (Herfindahl-Hirschman Index) for fee-tier fragmentation 
The HHI index helps us determine how concentrated or fragmented the liquidity is across all the analyzed venues. This gives us an insight into how much larger-quantity swaps suffer when routing their swaps when HHI is low. 

---

## Phase 1: Data Sourcing

- [ ] Explore Dune's public dashboards for Uniswap v3, SushiSwap, Curve, and Balancer swap data — fork existing queries rather than writing from scratch
- [ ] Identify the correct pool(s) for ETH/USDC on each venue:
  - [ ] Uniswap v3 — note the fee tier(s) available (0.05%, 0.3%, 1%); decide whether to track the deepest tier only or all tiers
  - [ ] PancakeSwap — identify the main ETH/USDC pool
  - [ ] Curve — identify the relevant pool (Curve's ETH/USDC pools use a different invariant than the others — confirm which pool is most comparable)
- [ ] Pull 1 year of swap-level data per venue via the Dune API (swap size, price, timestamp, pool reserves at time of swap if available)
- [ ] Pull 1 year of pool TVL/reserves data per venue (separate from swap-level data — needed for the liquidity-depth analysis)
- [ ] Cache all raw pulls locally (CSV or SQLite) so you're not re-querying Dune every time you rerun analysis

---


## Data 
- Dune 
- 

## Things to take care of 
- Decimal mismatches 
- Curve's pricing model differs structurally from Uniswap's constant-product AMM 
- Uniswap v3 has multiple fee-tier pools (0.05%, 0.3%, 1%)