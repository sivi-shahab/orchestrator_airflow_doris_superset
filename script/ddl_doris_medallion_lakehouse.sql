-- ============================================
-- APACHE DORIS MEDALLION ARCHITECTURE (BRONZE → SILVER → GOLD)
-- DATABASES: raw, refined, business
-- Created By: Wandhana Kurnia (Projek Freedom Open Source)
-- ============================================

-- DATABASE CREATION (Doris uses databases instead of schemas)
CREATE DATABASE IF NOT EXISTS raw;
CREATE DATABASE IF NOT EXISTS refined;
CREATE DATABASE IF NOT EXISTS business;

-- ============================================
-- 🥉 BRONZE LAYER (DATABASE: raw)
-- ============================================

-- Users table
CREATE TABLE raw.users (
    user_id VARCHAR(50),
    email_hash VARCHAR(255),
    registration_date DATE,
    country_code VARCHAR(10),
    age_group VARCHAR(20),
    account_tier VARCHAR(20),
    kyc_status VARCHAR(20),
    account_status VARCHAR(20),
    last_login_date DATE,
    total_deposits DECIMAL(16,2),
    total_withdrawals DECIMAL(16,2),
    current_balance DECIMAL(16,2),
    is_copy_trader BOOLEAN,
    referral_code VARCHAR(50)
) 
DUPLICATE KEY(user_id)
DISTRIBUTED BY HASH(user_id) BUCKETS 10
PROPERTIES (
    "replication_allocation" = "tag.location.default: 1"
);

-- Trading transactions table
CREATE TABLE raw.trading_transactions (
    trade_id VARCHAR(50),
    user_id VARCHAR(50),
    symbol VARCHAR(20),
    side VARCHAR(10),
    leverage BIGINT,
    open_time DATETIME,
    close_time DATETIME,
    duration_minutes BIGINT,
    pnl_usd DECIMAL(16,2),
    commission_usd DECIMAL(16,2),
    swap_usd DECIMAL(16,2),
    trade_status VARCHAR(20),
    platform VARCHAR(50)
) 
DUPLICATE KEY(trade_id)
DISTRIBUTED BY HASH(trade_id) BUCKETS 10
PROPERTIES (
    "replication_allocation" = "tag.location.default: 1"
);

-- Trading instruments table
CREATE TABLE raw.trading_instruments (
    symbol VARCHAR(20),
    name VARCHAR(100),
    category VARCHAR(50),
    exchange VARCHAR(50),
    currency VARCHAR(10),
    min_trade_amount BIGINT,
    leverage_available BIGINT,
    spread_pips DECIMAL(7,5),
    is_tradeable BOOLEAN,
    created_date DATE
) 
DUPLICATE KEY(symbol)
DISTRIBUTED BY HASH(symbol) BUCKETS 10
PROPERTIES (
    "replication_allocation" = "tag.location.default: 1"
);

-- Payment transactions table
CREATE TABLE raw.payment_transactions (
    payment_id VARCHAR(50),
    user_id VARCHAR(50),
    transaction_type VARCHAR(20),
    amount DECIMAL(16,2),
    currency VARCHAR(10),
    amount_usd DECIMAL(16,2),
    payment_method VARCHAR(50),
    status VARCHAR(20),
    transaction_date DATETIME,
    processing_time_hours DECIMAL(16,2),
    fee_usd DECIMAL(16,2),
    exchange_rate DECIMAL(7,5),
    payment_provider VARCHAR(50)
) 
DUPLICATE KEY(payment_id)
DISTRIBUTED BY HASH(payment_id) BUCKETS 10
PROPERTIES (
    "replication_allocation" = "tag.location.default: 1"
);

-- Market data OHLCV table
CREATE TABLE raw.market_data_ohlcv (
    symbol VARCHAR(20),
    date DATE,
    ohlc JSON,                     -- store nested object here
    volume DECIMAL(16,2),
    spread DECIMAL(7,5)
)
DUPLICATE KEY(symbol, date)
DISTRIBUTED BY HASH(symbol) BUCKETS 10
PROPERTIES (
    "replication_allocation" = "tag.location.default: 1"
);

-- Copy trading table
CREATE TABLE raw.copy_trading (
    copy_id VARCHAR(50),
    follower_user_id VARCHAR(50),
    trader_user_id VARCHAR(50),
    start_date DATE,
    end_date DATE,
    copy_percentage BIGINT,
    max_copy_amount DECIMAL(16,2),
    total_copied_trades BIGINT,
    total_pnl_usd DECIMAL(16,2),
    is_active BOOLEAN,
    stop_loss_enabled BOOLEAN,
    take_profit_enabled BOOLEAN
) 
DUPLICATE KEY(copy_id)
DISTRIBUTED BY HASH(copy_id) BUCKETS 10
PROPERTIES (
    "replication_allocation" = "tag.location.default: 1"
);

-- ============================================
-- 🥈 SILVER LAYER DDL (DATABASE: refined)
-- ============================================

-- Users enriched table
CREATE TABLE refined.users_enriched (
    user_id VARCHAR(50),
    email_hash VARCHAR(255),
    registration_date DATE,
    country_code VARCHAR(10),
    age_group VARCHAR(20),
    account_tier VARCHAR(20),
    kyc_status VARCHAR(20),
    account_status VARCHAR(20),
    last_login_date DATE,
    total_deposits DECIMAL(16,2),
    total_withdrawals DECIMAL(16,2),
    current_balance DECIMAL(16,2),
    is_copy_trader BOOLEAN,
    referral_code VARCHAR(50),
    net_funding DECIMAL(16,2),
    is_kyc_verified BOOLEAN,
    activity_status VARCHAR(20)
) 
DUPLICATE KEY(user_id)
DISTRIBUTED BY HASH(user_id) BUCKETS 10
PROPERTIES (
    "replication_allocation" = "tag.location.default: 1"
);

-- Trading transactions enriched table
CREATE TABLE refined.trading_transactions_enriched (
    trade_id VARCHAR(50),
    user_id VARCHAR(50),
    symbol VARCHAR(20),
    side VARCHAR(10),
    leverage BIGINT,
    open_time DATETIME,
    close_time DATETIME,
    duration_minutes BIGINT,
    pnl_usd DECIMAL(16,2),
    commission_usd DECIMAL(16,2),
    swap_usd DECIMAL(7,5),
    trade_status VARCHAR(20),
    platform VARCHAR(50),
    instrument_name VARCHAR(100),
    net_profit DECIMAL(16,2),
    trade_duration_type VARCHAR(20)
) 
DUPLICATE KEY(trade_id)
DISTRIBUTED BY HASH(trade_id) BUCKETS 10
PROPERTIES (
    "replication_allocation" = "tag.location.default: 1"
);

-- Payment transactions cleaned table
CREATE TABLE refined.payment_transactions_cleaned (
    payment_id VARCHAR(50),
    user_id VARCHAR(50),
    transaction_type VARCHAR(20),
    amount DECIMAL(16,2),
    currency VARCHAR(10),
    amount_usd DECIMAL(16,2),
    payment_method VARCHAR(50),
    status VARCHAR(20),
    transaction_date DATETIME,
    processing_time_hours DECIMAL(16,2),
    fee_usd DECIMAL(16,2),
    exchange_rate DECIMAL(7,5),
    payment_provider VARCHAR(50),
    status_cleaned VARCHAR(20),
    net_amount_usd DECIMAL(16,2),
    processing_speed VARCHAR(20)
) 
DUPLICATE KEY(payment_id)
DISTRIBUTED BY HASH(payment_id) BUCKETS 10
PROPERTIES (
    "replication_allocation" = "tag.location.default: 1"
);

-- Copy trading profiles table
CREATE TABLE refined.copy_trading_profiles (
    trader_user_id VARCHAR(50),
    total_followers BIGINT,
    active_copies BIGINT,
    total_pnl_generated DECIMAL(16,2),
    avg_copy_percentage DECIMAL(7,5)
) 
DUPLICATE KEY(trader_user_id)
DISTRIBUTED BY HASH(trader_user_id) BUCKETS 10
PROPERTIES (
    "replication_allocation" = "tag.location.default: 1"
);

-- Trade summary by user day table
CREATE TABLE refined.trade_summary_by_user_day (
    user_id VARCHAR(50),
    trade_day DATE,
    trades_count BIGINT,
    total_pnl_usd DECIMAL(16,2),
    total_fees DECIMAL(16,2)
) 
DUPLICATE KEY(user_id, trade_day)
DISTRIBUTED BY HASH(user_id) BUCKETS 10
PROPERTIES (
    "replication_allocation" = "tag.location.default: 1"
);

-- OHLCV daily summary table
CREATE TABLE refined.ohlcv_daily (
    symbol VARCHAR(20),
    date DATE,
    open DECIMAL(16,2),
    high DECIMAL(16,2),
    low DECIMAL(16,2),
    close DECIMAL(16,2),
    total_volume DECIMAL(16,2),
    avg_spread DECIMAL(7,5)
) 
DUPLICATE KEY(symbol, date)
DISTRIBUTED BY HASH(symbol) BUCKETS 10
PROPERTIES (
    "replication_allocation" = "tag.location.default: 1"
);

-- ============================================
-- 🥇 GOLD LAYER DDL (DATABASE: business)
-- ============================================

-- User lifetime value table
CREATE TABLE business.user_lifetime_value (
    user_id VARCHAR(50),
    account_tier VARCHAR(20),
    country_code VARCHAR(10),
    total_trades BIGINT,
    total_net_profit DECIMAL(16,2),
    gross_pnl DECIMAL(16,2),
    total_fees DECIMAL(16,2),
    total_deposits DECIMAL(16,2),
    total_withdrawals DECIMAL(16,2),
    current_balance DECIMAL(16,2),
    roi_ratio DECIMAL(16,2),
    trader_type VARCHAR(20)
) 
DUPLICATE KEY(user_id)
DISTRIBUTED BY HASH(user_id) BUCKETS 10
PROPERTIES (
    "replication_allocation" = "tag.location.default: 1"
);

-- Copy trading leaderboard table
CREATE TABLE business.copy_trading_leaderboard (
    trader_user_id VARCHAR(50),
    total_followers BIGINT,
    active_copies BIGINT,
    total_pnl_generated DECIMAL(16,2),
    avg_copy_percentage DECIMAL(7,5),
    pnl_rank BIGINT,
    followers_rank BIGINT
) 
DUPLICATE KEY(trader_user_id)
DISTRIBUTED BY HASH(trader_user_id) BUCKETS 10
PROPERTIES (
    "replication_allocation" = "tag.location.default: 1"
);

-- Daily trading activity summary table
CREATE TABLE business.daily_trading_activity_summary (
    trade_day DATE,
    active_traders BIGINT,
    total_trades BIGINT,
    total_pnl DECIMAL(16,2),
    total_fees DECIMAL(16,2)
) 
DUPLICATE KEY(trade_day)
DISTRIBUTED BY HASH(trade_day) BUCKETS 10
PROPERTIES (
    "replication_allocation" = "tag.location.default: 1"
);

-- Payment efficiency summary table
CREATE TABLE business.payment_efficiency_summary (
    payment_method VARCHAR(50),
    processing_speed VARCHAR(20),
    tx_count BIGINT,
    total_volume_usd DECIMAL(16,2),
    avg_fee_usd DECIMAL(16,2)
) 
DUPLICATE KEY(payment_method, processing_speed)
DISTRIBUTED BY HASH(payment_method) BUCKETS 10
PROPERTIES (
    "replication_allocation" = "tag.location.default: 1"
);

-- Instrument performance summary table
CREATE TABLE business.instrument_performance_summary (
    symbol VARCHAR(20),
    instrument_name VARCHAR(100),
    total_trades BIGINT,
    total_net_profit DECIMAL(16,2),
    avg_gross_pnl DECIMAL(16,2),
    avg_duration DECIMAL(16,2),
    unique_traders BIGINT
) 
DUPLICATE KEY(symbol)
DISTRIBUTED BY HASH(symbol) BUCKETS 10
PROPERTIES (
    "replication_allocation" = "tag.location.default: 1"
);

-- Market volatility summary table
CREATE TABLE business.market_volatility_summary (
    symbol VARCHAR(20),
    avg_daily_range DECIMAL(16,2),
    avg_volume DECIMAL(16,2),
    volatility_index DECIMAL(16,2)
) 
DUPLICATE KEY(symbol)
DISTRIBUTED BY HASH(symbol) BUCKETS 10
PROPERTIES (
    "replication_allocation" = "tag.location.default: 1"
);