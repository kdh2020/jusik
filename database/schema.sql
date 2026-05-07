CREATE DATABASE IF NOT EXISTS stock_recommendations
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE stock_recommendations;

CREATE TABLE IF NOT EXISTS market_indices (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  code VARCHAR(32) NOT NULL,
  name VARCHAR(100) NOT NULL,
  country VARCHAR(64) NOT NULL,
  currency CHAR(3) NOT NULL,
  timezone VARCHAR(64) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_market_indices_code (code)
);

CREATE TABLE IF NOT EXISTS stocks (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  index_id BIGINT UNSIGNED NOT NULL,
  symbol VARCHAR(32) NOT NULL,
  company_name VARCHAR(160) NOT NULL,
  sector VARCHAR(80) NOT NULL,
  currency CHAR(3) NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_stocks_symbol (symbol),
  KEY idx_stocks_index_id (index_id),
  CONSTRAINT fk_stocks_index_id
    FOREIGN KEY (index_id) REFERENCES market_indices (id)
    ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS recommendation_runs (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  index_id BIGINT UNSIGNED NOT NULL,
  period ENUM('daily', 'weekly') NOT NULL,
  as_of_date DATE NOT NULL,
  model_version VARCHAR(40) NOT NULL DEFAULT 'rules-v1',
  summary VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_runs_index_period_date (index_id, period, as_of_date),
  CONSTRAINT fk_runs_index_id
    FOREIGN KEY (index_id) REFERENCES market_indices (id)
    ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS stock_recommendations (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  run_id BIGINT UNSIGNED NOT NULL,
  stock_id BIGINT UNSIGNED NOT NULL,
  rank_no INT NOT NULL,
  score DECIMAL(5,2) NOT NULL,
  signal VARCHAR(40) NOT NULL,
  target_horizon VARCHAR(40) NOT NULL,
  rationale VARCHAR(500) NOT NULL,
  risk_note VARCHAR(300) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_recommendation_rank (run_id, rank_no),
  KEY idx_recommendations_run_id (run_id),
  CONSTRAINT fk_recommendations_run_id
    FOREIGN KEY (run_id) REFERENCES recommendation_runs (id)
    ON DELETE CASCADE,
  CONSTRAINT fk_recommendations_stock_id
    FOREIGN KEY (stock_id) REFERENCES stocks (id)
    ON DELETE RESTRICT
);
