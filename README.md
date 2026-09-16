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
 

## Data 
- Dune 
- 

## Things to take care of 
- Decimal mismatches 
- Curve's pricing model differs structurally from Uniswap's constant-product AMM 
- Uniswap v3 has multiple fee-tier pools (0.05%, 0.3%, 1%)