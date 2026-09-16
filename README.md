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

### To learn before starting project: 

1. Blockchain/DeFi mechanics: Constant-product AMM math (Uniswap/Sushi) vs. Curve's stableswap invariant vs. Balancer's weighted-pool math; token decimals (ERC-20 basics) — the 6 vs. 18 decimal trap; what "liquidity pool," "TVL," and "fee tier" actually mean mechanically
2. Data/API skills: REST API basics: pagination, rate limits, auth headers (for Dune + 1inch APIs)
JSON parsing into DataFrames
3. Pandas (the specific operations this project needs); resample() and rolling windows (for regime classification, rolling volatility); Merging/joining on timestamp across multiple sources; Handling missing/gapped time-series data

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