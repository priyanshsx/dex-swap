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
  - [ ] SushiSwap — identify the main ETH/USDC pool
  - [ ] Curve — identify the relevant pool (Curve's ETH/USDC pools use a different invariant than the others — confirm which pool is most comparable)
  - [ ] Balancer — identify the relevant weighted pool
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