INSERT INTO business.market_volatility_summary
SELECT
    symbol,
    AVG(high - low) AS avg_daily_range,
    AVG(total_volume) AS avg_volume,
    STDDEV_POP(close) AS volatility_index
FROM refined.ohlcv_daily
GROUP BY symbol