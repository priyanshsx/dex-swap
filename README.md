# DEX Swap 

## Research Question 
Where is the best execution price for a given token pair actually happening, and how much value is retail losing to fragmented liquidity/slippage by not checking? 

V1
- One token pair to start(ETH/USDC): highest liquidity across all three DEXs
- Three venues: Uniswap v3, SushiSwap, and Curve
- One metric: effective execution price for a fixed trade size (the app should specifically answer: what would swapping 10K USDC -> ETH actually cost, accounting for slippage, across each venue)

## Data 
- Dune 
- 

## Things to take care of 
- Decimal mismatches 
- Curve's pricing model differs structurally from Uniswap's constant-product AMM 
- Uniswap v3 has multiple fee-tier pools (0.05%, 0.3%, 1%)