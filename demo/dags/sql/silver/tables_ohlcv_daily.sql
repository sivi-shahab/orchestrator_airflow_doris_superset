INSERT INTO refined.ohlcv_daily
SELECT
    symbol,
    date,
    get_json_double(ohlc, '$.open') AS open,
    get_json_double(ohlc, '$.high') AS high,
    get_json_double(ohlc, '$.low') AS low,
    get_json_double(ohlc, '$.close') AS close,
    volume AS total_volume,
    spread AS avg_spread
FROM raw.market_data_ohlcv;