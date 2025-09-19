-- Uniswap V3 Substreams Database Schema
-- 基于 schema.graphql 生成的 PostgreSQL DDL

-- 创建必要的扩展
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";

-- Bundle表 - 用于USD计算
CREATE TABLE IF NOT EXISTS bundle (
    id VARCHAR PRIMARY KEY,
    eth_price_usd NUMERIC
);

-- Factory表 - 工厂信息
CREATE TABLE IF NOT EXISTS factory (
    id VARCHAR PRIMARY KEY,
    pool_count NUMERIC,
    tx_count NUMERIC,
    total_volume_usd NUMERIC,
    total_volume_eth NUMERIC,
    untracked_volume_usd NUMERIC,
    total_fees_usd NUMERIC,
    total_fees_eth NUMERIC,
    total_value_locked_usd NUMERIC,
    total_value_locked_eth NUMERIC,
    total_value_locked_usd_untracked NUMERIC,
    total_value_locked_eth_untracked NUMERIC,
    owner VARCHAR
);

-- Token表 - 代币信息
CREATE TABLE IF NOT EXISTS token (
    id VARCHAR PRIMARY KEY,
    symbol VARCHAR,
    name VARCHAR,
    decimals NUMERIC,
    total_supply NUMERIC,
    volume NUMERIC,
    volume_usd NUMERIC,
    untracked_volume_usd NUMERIC,
    fees_usd NUMERIC,
    tx_count NUMERIC,
    pool_count NUMERIC,
    total_value_locked NUMERIC,
    total_value_locked_usd NUMERIC,
    total_value_locked_usd_untracked NUMERIC,
    derived_eth NUMERIC,
    whitelist_pools VARCHAR
);

-- Pool表 - 池子信息
CREATE TABLE IF NOT EXISTS pool (
    id VARCHAR PRIMARY KEY,
    created_at_timestamp NUMERIC,
    created_at_block_number NUMERIC,
    token_0 VARCHAR,
    token_1 VARCHAR,
    fee_tier NUMERIC,
    liquidity NUMERIC,
    sqrt_price NUMERIC,
    fee_growth_global_0x128 NUMERIC,
    fee_growth_global_1x128 NUMERIC,
    token_0_price NUMERIC,
    token_1_price NUMERIC,
    tick NUMERIC,
    observation_index NUMERIC,
    volume_token_0 NUMERIC,
    volume_token_1 NUMERIC,
    volume_usd NUMERIC,
    untracked_volume_usd NUMERIC,
    fees_usd NUMERIC,
    tx_count NUMERIC,
    total_value_locked_token_0 NUMERIC,
    total_value_locked_token_1 NUMERIC,
    total_value_locked_eth NUMERIC,
    total_value_locked_usd NUMERIC,
    total_value_locked_eth_untracked NUMERIC,
    total_value_locked_usd_untracked NUMERIC,
    collected_fees_token_0 NUMERIC,
    collected_fees_token_1 NUMERIC,
    collected_fees_usd NUMERIC,
    liquidity_provider_count NUMERIC
);

-- Tick表 - 价格刻度信息
CREATE TABLE IF NOT EXISTS tick (
    id VARCHAR PRIMARY KEY,
    pool_address VARCHAR,
    tick_idx NUMERIC,
    pool VARCHAR,
    liquidity_gross NUMERIC,
    liquidity_net NUMERIC,
    price_0 NUMERIC,
    price_1 NUMERIC,
    volume_token_0 NUMERIC,
    volume_token_1 NUMERIC,
    volume_usd NUMERIC,
    untracked_volume_usd NUMERIC,
    fees_usd NUMERIC,
    collected_fees_token_0 NUMERIC,
    collected_fees_token_1 NUMERIC,
    collected_fees_usd NUMERIC,
    created_at_timestamp NUMERIC,
    created_at_block_number NUMERIC,
    liquidity_provider_count NUMERIC,
    fee_growth_outside_0x128 NUMERIC,
    fee_growth_outside_1x128 NUMERIC
);

-- Position表 - 仓位信息
CREATE TABLE IF NOT EXISTS position (
    id VARCHAR PRIMARY KEY,
    owner BYTEA,
    pool VARCHAR,
    token_0 VARCHAR,
    token_1 VARCHAR,
    tick_lower VARCHAR,
    tick_upper VARCHAR,
    liquidity NUMERIC,
    deposited_token_0 NUMERIC,
    deposited_token_1 NUMERIC,
    withdrawn_token_0 NUMERIC,
    withdrawn_token_1 NUMERIC,
    collected_fees_token_0 NUMERIC,
    collected_fees_token_1 NUMERIC,
    transaction VARCHAR,
    fee_growth_inside_0_last_x128 NUMERIC,
    fee_growth_inside_1_last_x128 NUMERIC
);

-- PositionSnapshot表 - 仓位快照
CREATE TABLE IF NOT EXISTS position_snapshot (
    id VARCHAR PRIMARY KEY,
    owner BYTEA,
    pool VARCHAR,
    position VARCHAR,
    block_number NUMERIC,
    timestamp NUMERIC,
    liquidity NUMERIC,
    deposited_token_0 NUMERIC,
    deposited_token_1 NUMERIC,
    withdrawn_token_0 NUMERIC,
    withdrawn_token_1 NUMERIC,
    collected_fees_token_0 NUMERIC,
    collected_fees_token_1 NUMERIC,
    transaction VARCHAR,
    fee_growth_inside_0_last_x128 NUMERIC,
    fee_growth_inside_1_last_x128 NUMERIC
);

-- Transaction表 - 交易信息
CREATE TABLE IF NOT EXISTS transaction (
    id VARCHAR PRIMARY KEY,
    block_number NUMERIC,
    timestamp NUMERIC,
    gas_used NUMERIC,
    gas_price NUMERIC
);

-- Mint表 - 铸造事件
CREATE TABLE IF NOT EXISTS mint (
    id VARCHAR PRIMARY KEY,
    transaction VARCHAR,
    timestamp NUMERIC,
    pool VARCHAR,
    token_0 VARCHAR,
    token_1 VARCHAR,
    owner BYTEA,
    sender BYTEA,
    origin BYTEA,
    amount NUMERIC,
    amount_0 NUMERIC,
    amount_1 NUMERIC,
    amount_usd NUMERIC,
    tick_lower NUMERIC,
    tick_upper NUMERIC,
    log_index NUMERIC
);

-- Burn表 - 销毁事件
CREATE TABLE IF NOT EXISTS burn (
    id VARCHAR PRIMARY KEY,
    transaction VARCHAR,
    pool VARCHAR,
    token_0 VARCHAR,
    token_1 VARCHAR,
    timestamp NUMERIC,
    owner BYTEA,
    origin BYTEA,
    amount NUMERIC,
    amount_0 NUMERIC,
    amount_1 NUMERIC,
    amount_usd NUMERIC,
    tick_lower NUMERIC,
    tick_upper NUMERIC,
    log_index NUMERIC
);

-- Swap表 - 交换事件
CREATE TABLE IF NOT EXISTS swap (
    id VARCHAR PRIMARY KEY,
    transaction VARCHAR,
    timestamp NUMERIC,
    pool VARCHAR,
    token_0 VARCHAR,
    token_1 VARCHAR,
    sender BYTEA,
    recipient BYTEA,
    origin BYTEA,
    amount_0 NUMERIC,
    amount_1 NUMERIC,
    amount_usd NUMERIC,
    sqrt_price_x96 NUMERIC,
    tick NUMERIC,
    log_index NUMERIC
);

-- Collect表 - 收集费用事件
CREATE TABLE IF NOT EXISTS collect (
    id VARCHAR PRIMARY KEY,
    transaction VARCHAR,
    timestamp NUMERIC,
    pool VARCHAR,
    owner BYTEA,
    amount_0 NUMERIC,
    amount_1 NUMERIC,
    amount_usd NUMERIC,
    tick_lower NUMERIC,
    tick_upper NUMERIC,
    log_index NUMERIC
);

-- Flash表 - 闪电贷事件
CREATE TABLE IF NOT EXISTS flash (
    id VARCHAR PRIMARY KEY,
    transaction VARCHAR,
    timestamp NUMERIC,
    pool VARCHAR,
    sender BYTEA,
    recipient BYTEA,
    amount_0 NUMERIC,
    amount_1 NUMERIC,
    amount_usd NUMERIC,
    amount_0_paid NUMERIC,
    amount_1_paid NUMERIC,
    log_index NUMERIC
);

-- UniswapDayData表 - 每日数据
CREATE TABLE IF NOT EXISTS uniswap_day_data (
    id VARCHAR PRIMARY KEY,
    date INTEGER,
    volume_eth NUMERIC,
    volume_usd NUMERIC,
    volume_usd_untracked NUMERIC,
    total_value_locked_usd NUMERIC,
    fees_usd NUMERIC,
    tx_count NUMERIC
);

-- PoolDayData表 - 池子每日数据
CREATE TABLE IF NOT EXISTS pool_day_data (
    id VARCHAR PRIMARY KEY,
    date INTEGER,
    pool VARCHAR,
    liquidity NUMERIC,
    sqrt_price NUMERIC,
    token_0_price NUMERIC,
    token_1_price NUMERIC,
    tick NUMERIC,
    fee_growth_global_0x128 NUMERIC,
    fee_growth_global_1x128 NUMERIC,
    total_value_locked_usd NUMERIC,
    volume_token_0 NUMERIC,
    volume_token_1 NUMERIC,
    volume_usd NUMERIC,
    fees_usd NUMERIC,
    tx_count NUMERIC,
    open NUMERIC,
    high NUMERIC,
    low NUMERIC,
    close NUMERIC
);

-- PoolHourData表 - 池子每小时数据
CREATE TABLE IF NOT EXISTS pool_hour_data (
    id VARCHAR PRIMARY KEY,
    period_start_unix INTEGER,
    pool VARCHAR,
    liquidity NUMERIC,
    sqrt_price NUMERIC,
    token_0_price NUMERIC,
    token_1_price NUMERIC,
    tick NUMERIC,
    fee_growth_global_0x128 NUMERIC,
    fee_growth_global_1x128 NUMERIC,
    total_value_locked_usd NUMERIC,
    volume_token_0 NUMERIC,
    volume_token_1 NUMERIC,
    volume_usd NUMERIC,
    fees_usd NUMERIC,
    tx_count NUMERIC,
    open NUMERIC,
    high NUMERIC,
    low NUMERIC,
    close NUMERIC
);

-- TokenDayData表 - 代币每日数据
CREATE TABLE IF NOT EXISTS token_day_data (
    id VARCHAR PRIMARY KEY,
    date INTEGER,
    token VARCHAR,
    volume NUMERIC,
    volume_usd NUMERIC,
    volume_usd_untracked NUMERIC,
    total_value_locked NUMERIC,
    total_value_locked_usd NUMERIC,
    price_usd NUMERIC,
    fees_usd NUMERIC,
    open NUMERIC,
    high NUMERIC,
    low NUMERIC,
    close NUMERIC
);

-- TokenHourData表 - 代币每小时数据
CREATE TABLE IF NOT EXISTS token_hour_data (
    id VARCHAR PRIMARY KEY,
    period_start_unix INTEGER,
    token VARCHAR,
    volume NUMERIC,
    volume_usd NUMERIC,
    volume_usd_untracked NUMERIC,
    total_value_locked NUMERIC,
    total_value_locked_usd NUMERIC,
    price_usd NUMERIC,
    fees_usd NUMERIC,
    open NUMERIC,
    high NUMERIC,
    low NUMERIC,
    close NUMERIC
);

-- 创建基本索引
CREATE INDEX IF NOT EXISTS idx_factory_id ON factory(id);
CREATE INDEX IF NOT EXISTS idx_token_id ON token(id);
CREATE INDEX IF NOT EXISTS idx_pool_id ON pool(id);
CREATE INDEX IF NOT EXISTS idx_tick_id ON tick(id);
CREATE INDEX IF NOT EXISTS idx_position_id ON position(id);
CREATE INDEX IF NOT EXISTS idx_transaction_id ON transaction(id);
CREATE INDEX IF NOT EXISTS idx_mint_id ON mint(id);
CREATE INDEX IF NOT EXISTS idx_burn_id ON burn(id);
CREATE INDEX IF NOT EXISTS idx_swap_id ON swap(id);
CREATE INDEX IF NOT EXISTS idx_collect_id ON collect(id);
CREATE INDEX IF NOT EXISTS idx_flash_id ON flash(id);

-- 创建外键索引
CREATE INDEX IF NOT EXISTS idx_pool_token_0 ON pool(token_0);
CREATE INDEX IF NOT EXISTS idx_pool_token_1 ON pool(token_1);
CREATE INDEX IF NOT EXISTS idx_tick_pool ON tick(pool);
CREATE INDEX IF NOT EXISTS idx_position_pool ON position(pool);
CREATE INDEX IF NOT EXISTS idx_mint_pool ON mint(pool);
CREATE INDEX IF NOT EXISTS idx_burn_pool ON burn(pool);
CREATE INDEX IF NOT EXISTS idx_swap_pool ON swap(pool);
CREATE INDEX IF NOT EXISTS idx_collect_pool ON collect(pool);
CREATE INDEX IF NOT EXISTS idx_flash_pool ON flash(pool);

-- 创建时间索引
CREATE INDEX IF NOT EXISTS idx_pool_timestamp ON pool(created_at_timestamp);
CREATE INDEX IF NOT EXISTS idx_transaction_timestamp ON transaction(timestamp);
CREATE INDEX IF NOT EXISTS idx_mint_timestamp ON mint(timestamp);
CREATE INDEX IF NOT EXISTS idx_burn_timestamp ON burn(timestamp);
CREATE INDEX IF NOT EXISTS idx_swap_timestamp ON swap(timestamp);
CREATE INDEX IF NOT EXISTS idx_collect_timestamp ON collect(timestamp);
CREATE INDEX IF NOT EXISTS idx_flash_timestamp ON flash(timestamp);

-- 创建数值索引
CREATE INDEX IF NOT EXISTS idx_pool_volume_usd ON pool(volume_usd);
CREATE INDEX IF NOT EXISTS idx_pool_liquidity ON pool(liquidity);
CREATE INDEX IF NOT EXISTS idx_token_volume_usd ON token(volume_usd);
CREATE INDEX IF NOT EXISTS idx_token_total_value_locked_usd ON token(total_value_locked_usd);
