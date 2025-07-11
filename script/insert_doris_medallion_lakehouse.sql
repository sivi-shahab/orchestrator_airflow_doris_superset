-- ============================================
-- 🥈 SILVER LAYER INSERTS (DATABASE: refined)
-- ============================================

-- Users enriched
INSERT INTO refined.users_enriched
SELECT
    user_id,
    email_hash,
    registration_date,
    country_code,
    age_group,
    account_tier,
    kyc_status,
    account_status,
    last_login_date,
    total_deposits,
    total_withdrawals,
    current_balance,
    is_copy_trader,
    referral_code,
    (total_deposits - total_withdrawals) AS net_funding,
    CASE WHEN kyc_status = 'approved' THEN TRUE ELSE FALSE END AS is_kyc_verified,
    CASE 
        WHEN last_login_date < DATE_SUB(CURDATE(), INTERVAL 30 DAY) THEN 'inactive'
        WHEN last_login_date < DATE_SUB(CURDATE(), INTERVAL 7 DAY) THEN 'dormant'
        ELSE 'active'
    END AS activity_status
FROM raw.users;

-- Trading transactions enriched
INSERT INTO refined.trading_transactions_enriched
SELECT
    t.trade_id,
    t.user_id,
    t.symbol,
    t.side,
    t.leverage,
    t.open_time,
    t.close_time,
    t.duration_minutes,
    t.pnl_usd,
    t.commission_usd,
    t.swap_usd,
    t.trade_status,
    t.platform,
    COALESCE(i.name, t.symbol) AS instrument_name,
    (t.pnl_usd - t.commission_usd - t.swap_usd) AS net_profit,
    CASE
        WHEN t.duration_minutes < 15 THEN 'scalping'
        WHEN t.duration_minutes < 240 THEN 'short-term'
        ELSE 'long-term'
    END AS trade_duration_type
FROM raw.trading_transactions t
LEFT JOIN raw.trading_instruments i ON t.symbol = i.symbol;

-- Payment transactions cleaned
INSERT INTO refined.payment_transactions_cleaned
SELECT
    payment_id,
    user_id,
    transaction_type,
    amount,
    currency,
    amount_usd,
    payment_method,
    status,
    transaction_date,
    processing_time_hours,
    fee_usd,
    exchange_rate,
    payment_provider,
    LOWER(TRIM(status)) AS status_cleaned,
    (amount_usd - fee_usd) AS net_amount_usd,
    CASE 
        WHEN processing_time_hours <= 1 THEN 'fast'
        WHEN processing_time_hours <= 12 THEN 'moderate'
        ELSE 'slow'
    END AS processing_speed
FROM raw.payment_transactions;

-- Copy trading profiles
INSERT INTO refined.copy_trading_profiles
SELECT
    trader_user_id,
    COUNT(DISTINCT follower_user_id) as total_followers,
    SUM(CASE WHEN is_active THEN 1 ELSE 0 END) as active_copies,
    SUM(total_pnl_usd) as total_pnl_generated,
    AVG(copy_percentage) as avg_copy_percentage
FROM raw.copy_trading
GROUP BY trader_user_id;

-- Trade summary by user day
INSERT INTO refined.trade_summary_by_user_day
SELECT
    user_id,
    DATE(open_time) as trade_day,
    COUNT(*) as trades_count,
    SUM(pnl_usd) as total_pnl_usd,
    SUM(commission_usd + swap_usd) as total_fees
FROM raw.trading_transactions
GROUP BY user_id, DATE(open_time);

-- OHLCV daily summary
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

-- ============================================
-- 🥇 GOLD LAYER INSERTS (DATABASE: business)
-- ============================================

-- User lifetime value
INSERT INTO business.user_lifetime_value
SELECT
    u.user_id,
    u.account_tier,
    u.country_code,
    COUNT(t.trade_id) AS total_trades,
    COALESCE(SUM(t.net_profit), 0) AS total_net_profit,
    COALESCE(SUM(t.pnl_usd), 0) AS gross_pnl,
    COALESCE(SUM(t.commission_usd + t.swap_usd), 0) AS total_fees,
    COALESCE(p.total_deposits, 0) AS total_deposits,
    COALESCE(p.total_withdrawals, 0) AS total_withdrawals,
    u.current_balance,
    CASE 
        WHEN COALESCE(p.total_deposits, 0) > 0 
        THEN COALESCE(SUM(t.net_profit), 0) / p.total_deposits
        ELSE NULL 
    END AS roi_ratio,
    CASE 
        WHEN COALESCE(SUM(t.net_profit), 0) > 0 THEN 'profitable'
        WHEN COALESCE(SUM(t.net_profit), 0) < 0 THEN 'losing'
        ELSE 'neutral'
    END AS trader_type
FROM refined.users_enriched u
LEFT JOIN refined.trading_transactions_enriched t ON u.user_id = t.user_id
LEFT JOIN (
    SELECT 
        user_id,
        SUM(CASE WHEN transaction_type = 'Deposit' THEN amount_usd ELSE 0 END) AS total_deposits,
        SUM(CASE WHEN transaction_type = 'Withdrawal' THEN amount_usd ELSE 0 END) AS total_withdrawals
    FROM refined.payment_transactions_cleaned
    GROUP BY user_id
) p ON u.user_id = p.user_id
GROUP BY u.user_id, u.account_tier, u.country_code, p.total_deposits, p.total_withdrawals, u.current_balance;

-- Copy trading leaderboard
INSERT INTO business.copy_trading_leaderboard
SELECT
    trader_user_id,
    total_followers,
    active_copies,
    total_pnl_generated,
    avg_copy_percentage,
    RANK() OVER (ORDER BY total_pnl_generated DESC) AS pnl_rank,
    RANK() OVER (ORDER BY total_followers DESC, active_copies DESC) AS followers_rank
FROM refined.copy_trading_profiles
WHERE total_followers >= 1;

-- Daily trading activity summary
INSERT INTO business.daily_trading_activity_summary
SELECT
    trade_day,
    COUNT(DISTINCT user_id) AS active_traders,
    SUM(trades_count) AS total_trades,
    SUM(total_pnl_usd) AS total_pnl,
    SUM(total_fees) AS total_fees
FROM refined.trade_summary_by_user_day
GROUP BY trade_day;

-- Payment efficiency summary
INSERT INTO business.payment_efficiency_summary
SELECT
    payment_method,
    processing_speed,
    COUNT(*) AS tx_count,
    SUM(net_amount_usd) AS total_volume_usd,
    AVG(fee_usd) AS avg_fee_usd
FROM refined.payment_transactions_cleaned
GROUP BY payment_method, processing_speed;

-- Instrument performance summary
INSERT INTO business.instrument_performance_summary
SELECT
    symbol,
    instrument_name,
    COUNT(*) AS total_trades,
    SUM(net_profit) AS total_net_profit,
    AVG(pnl_usd) AS avg_gross_pnl,
    AVG(duration_minutes) AS avg_duration,
    COUNT(DISTINCT user_id) AS unique_traders
FROM refined.trading_transactions_enriched
GROUP BY symbol, instrument_name;

-- Market volatility summary
INSERT INTO business.market_volatility_summary
SELECT
    symbol,
    AVG(high - low) AS avg_daily_range,
    AVG(total_volume) AS avg_volume,
    STDDEV_POP(close) AS volatility_index
FROM refined.ohlcv_daily
GROUP BY symbol;