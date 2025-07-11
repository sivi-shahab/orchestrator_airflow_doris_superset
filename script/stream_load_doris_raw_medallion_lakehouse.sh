## raw.users (CSV)
curl --location-trusted \
  -u root:"" \
  -H "Expect:100-continue" \
  -H "column_separator:," \
  -H "columns:user_id,email_hash,registration_date,country_code,age_group,account_tier,kyc_status,account_status,last_login_date,total_deposits,total_withdrawals,current_balance,is_copy_trader,referral_code" \
  -T /home/administrator/data/files/users.csv \
  -H "max_filter_ratio:0.1" \
  -XPUT http://localhost:8030/api/raw/users/_stream_load

## raw.trading_transactions (CSV)
curl --location-trusted \
  -u root:"" \
  -H "Expect:100-continue" \
  -H "column_separator:," \
  -H "columns:trade_id,user_id,symbol,side,leverage,open_time,close_time,duration_minutes,pnl_usd,commission_usd,swap_usd,trade_status,platform" \
  -T /home/administrator/data/files/trading_transactions.csv \
  -H "max_filter_ratio:0.1" \
  -XPUT http://localhost:8030/api/raw/trading_transactions/_stream_load

## raw.trading_instruments (CSV)
curl --location-trusted \
  -u root:"" \
  -H "Expect:100-continue" \
  -H "column_separator:," \
  -H "columns:symbol,name,category,exchange,currency,min_trade_amount,leverage_available,spread_pips,is_tradeable,created_date" \
  -T /home/administrator/data/files/trading_instruments.csv \
  -H "max_filter_ratio:0.1" \
  -XPUT http://localhost:8030/api/raw/trading_instruments/_stream_load

## raw.payment_transactions (CSV)
curl --location-trusted \
  -u root:"" \
  -H "Expect:100-continue" \
  -H "column_separator:," \
  -H "columns:payment_id,user_id,transaction_type,amount,currency,amount_usd,payment_method,status,transaction_date,processing_time_hours,fee_usd,exchange_rate,payment_provider" \
  -T /home/administrator/data/files/payment_transactions.csv \
  -H "max_filter_ratio:0.1" \
  -XPUT http://localhost:8030/api/raw/payment_transactions/_stream_load

## raw.market_data_ohlcv (JSON)
curl --location-trusted \
  -u root:"" \
  -H "Expect:100-continue" \
  -H "format: json" \
  -H "strip_outer_array: true" \
  -H "read_json_by_line: false" \
  -H "columns: symbol, date, ohlc, volume, spread" \
  -H "max_filter_ratio: 0.1" \
  -T /home/administrator/data/files/market_data_ohlcv.json \
  -XPUT http://localhost:8030/api/raw/market_data_ohlcv/_stream_load

## raw.copy_trading (CSV)
curl --location-trusted \
  -u root:"" \
  -H "Expect:100-continue" \
  -H "column_separator:," \
  -H "columns:copy_id,follower_user_id,trader_user_id,start_date,end_date,copy_percentage,max_copy_amount,total_copied_trades,total_pnl_usd,is_active,stop_loss_enabled,take_profit_enabled" \
  -T /home/administrator/data/files/copy_trading.csv \
  -H "max_filter_ratio:0.1" \
  -XPUT http://localhost:8030/api/raw/copy_trading/_stream_load