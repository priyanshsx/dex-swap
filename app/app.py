import pandas as pd 
import numpy as np 
import plotly.graph_objects as go 
from plotly.subplots import make_subplots

# query data from dune and export as csv 
# timeline: past 90 days 
# to pull: block_time, project, amount_usd, token_bought_amount, token_sold_amount, fee tier (uniswap v3)
# from projects: uniswap, sushiswap, curve 