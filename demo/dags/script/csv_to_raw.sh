#!/bin/bash

BASE_PATH=/home/administrator/airflow/dags/input

## raw.market_data_ohlcv (JSON)
curl --location-trusted \
  -u root:"" \
  -H "Expect:100-continue" \
  -H "format: json" \
  -H "strip_outer_array: true" \
  -H "read_json_by_line: false" \
  -H "columns: symbol, date, ohlc, volume, spread" \
  -H "max_filter_ratio: 0.1" \
  -T $BASE_PATH/market_data_ohlcv.json \
  -XPUT http://157.10.161.146:8030/api/raw/market_data_ohlcv/_stream_load