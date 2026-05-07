USE stock_recommendations;

INSERT INTO market_indices (code, name, country, currency, timezone)
VALUES
  ('KOSPI', 'KOSPI', 'South Korea', 'KRW', 'Asia/Seoul'),
  ('NIKKEI225', 'Nikkei 225', 'Japan', 'JPY', 'Asia/Tokyo'),
  ('SP500', 'S&P 500', 'United States', 'USD', 'America/New_York')
ON DUPLICATE KEY UPDATE name = VALUES(name);

INSERT INTO stocks (index_id, symbol, company_name, sector, currency)
SELECT id, '005930.KS', 'Samsung Electronics', 'Technology', 'KRW' FROM market_indices WHERE code = 'KOSPI'
ON DUPLICATE KEY UPDATE company_name = VALUES(company_name);
INSERT INTO stocks (index_id, symbol, company_name, sector, currency)
SELECT id, '000660.KS', 'SK Hynix', 'Semiconductors', 'KRW' FROM market_indices WHERE code = 'KOSPI'
ON DUPLICATE KEY UPDATE company_name = VALUES(company_name);
INSERT INTO stocks (index_id, symbol, company_name, sector, currency)
SELECT id, '035420.KS', 'NAVER', 'Internet', 'KRW' FROM market_indices WHERE code = 'KOSPI'
ON DUPLICATE KEY UPDATE company_name = VALUES(company_name);
INSERT INTO stocks (index_id, symbol, company_name, sector, currency)
SELECT id, '051910.KS', 'LG Chem', 'Materials', 'KRW' FROM market_indices WHERE code = 'KOSPI'
ON DUPLICATE KEY UPDATE company_name = VALUES(company_name);
INSERT INTO stocks (index_id, symbol, company_name, sector, currency)
SELECT id, '068270.KS', 'Celltrion', 'Healthcare', 'KRW' FROM market_indices WHERE code = 'KOSPI'
ON DUPLICATE KEY UPDATE company_name = VALUES(company_name);

INSERT INTO stocks (index_id, symbol, company_name, sector, currency)
SELECT id, '7203.T', 'Toyota Motor', 'Automobiles', 'JPY' FROM market_indices WHERE code = 'NIKKEI225'
ON DUPLICATE KEY UPDATE company_name = VALUES(company_name);
INSERT INTO stocks (index_id, symbol, company_name, sector, currency)
SELECT id, '6758.T', 'Sony Group', 'Consumer Electronics', 'JPY' FROM market_indices WHERE code = 'NIKKEI225'
ON DUPLICATE KEY UPDATE company_name = VALUES(company_name);
INSERT INTO stocks (index_id, symbol, company_name, sector, currency)
SELECT id, '9984.T', 'SoftBank Group', 'Telecom and Investments', 'JPY' FROM market_indices WHERE code = 'NIKKEI225'
ON DUPLICATE KEY UPDATE company_name = VALUES(company_name);
INSERT INTO stocks (index_id, symbol, company_name, sector, currency)
SELECT id, '8035.T', 'Tokyo Electron', 'Semiconductor Equipment', 'JPY' FROM market_indices WHERE code = 'NIKKEI225'
ON DUPLICATE KEY UPDATE company_name = VALUES(company_name);
INSERT INTO stocks (index_id, symbol, company_name, sector, currency)
SELECT id, '4063.T', 'Shin-Etsu Chemical', 'Chemicals', 'JPY' FROM market_indices WHERE code = 'NIKKEI225'
ON DUPLICATE KEY UPDATE company_name = VALUES(company_name);

INSERT INTO stocks (index_id, symbol, company_name, sector, currency)
SELECT id, 'MSFT', 'Microsoft', 'Technology', 'USD' FROM market_indices WHERE code = 'SP500'
ON DUPLICATE KEY UPDATE company_name = VALUES(company_name);
INSERT INTO stocks (index_id, symbol, company_name, sector, currency)
SELECT id, 'NVDA', 'NVIDIA', 'Semiconductors', 'USD' FROM market_indices WHERE code = 'SP500'
ON DUPLICATE KEY UPDATE company_name = VALUES(company_name);
INSERT INTO stocks (index_id, symbol, company_name, sector, currency)
SELECT id, 'LLY', 'Eli Lilly', 'Healthcare', 'USD' FROM market_indices WHERE code = 'SP500'
ON DUPLICATE KEY UPDATE company_name = VALUES(company_name);
INSERT INTO stocks (index_id, symbol, company_name, sector, currency)
SELECT id, 'JPM', 'JPMorgan Chase', 'Financials', 'USD' FROM market_indices WHERE code = 'SP500'
ON DUPLICATE KEY UPDATE company_name = VALUES(company_name);
INSERT INTO stocks (index_id, symbol, company_name, sector, currency)
SELECT id, 'XOM', 'Exxon Mobil', 'Energy', 'USD' FROM market_indices WHERE code = 'SP500'
ON DUPLICATE KEY UPDATE company_name = VALUES(company_name);

INSERT INTO recommendation_runs (index_id, period, as_of_date, model_version, summary)
SELECT id, 'daily', CURRENT_DATE, 'rules-v1', 'KOSPI daily reference picks based on momentum and relative strength.' FROM market_indices WHERE code = 'KOSPI'
ON DUPLICATE KEY UPDATE summary = VALUES(summary);
INSERT INTO recommendation_runs (index_id, period, as_of_date, model_version, summary)
SELECT id, 'weekly', CURRENT_DATE, 'rules-v1', 'KOSPI weekly reference picks based on quality, sector rotation, and risk balance.' FROM market_indices WHERE code = 'KOSPI'
ON DUPLICATE KEY UPDATE summary = VALUES(summary);
INSERT INTO recommendation_runs (index_id, period, as_of_date, model_version, summary)
SELECT id, 'daily', CURRENT_DATE, 'rules-v1', 'Nikkei 225 daily reference picks based on export sensitivity and momentum.' FROM market_indices WHERE code = 'NIKKEI225'
ON DUPLICATE KEY UPDATE summary = VALUES(summary);
INSERT INTO recommendation_runs (index_id, period, as_of_date, model_version, summary)
SELECT id, 'weekly', CURRENT_DATE, 'rules-v1', 'Nikkei 225 weekly reference picks based on sector leadership and macro balance.' FROM market_indices WHERE code = 'NIKKEI225'
ON DUPLICATE KEY UPDATE summary = VALUES(summary);
INSERT INTO recommendation_runs (index_id, period, as_of_date, model_version, summary)
SELECT id, 'daily', CURRENT_DATE, 'rules-v1', 'S&P 500 daily reference picks based on quality growth and momentum.' FROM market_indices WHERE code = 'SP500'
ON DUPLICATE KEY UPDATE summary = VALUES(summary);
INSERT INTO recommendation_runs (index_id, period, as_of_date, model_version, summary)
SELECT id, 'weekly', CURRENT_DATE, 'rules-v1', 'S&P 500 weekly reference picks based on quality, balance, and inflation sensitivity.' FROM market_indices WHERE code = 'SP500'
ON DUPLICATE KEY UPDATE summary = VALUES(summary);

INSERT INTO stock_recommendations (run_id, stock_id, rank_no, score, signal, target_horizon, rationale, risk_note)
SELECT r.id, s.id, 1, 87.40, 'momentum', '1 trading day', '반도체 대형주 수급과 지수 민감도가 높아 단기 반등 구간에서 우선 관찰할 후보입니다.', '메모리 가격, 환율, 외국인 수급 변화에 민감합니다.'
FROM recommendation_runs r JOIN market_indices i ON i.id = r.index_id JOIN stocks s ON s.symbol = '005930.KS'
WHERE i.code = 'KOSPI' AND r.period = 'daily' AND r.as_of_date = CURRENT_DATE
ON DUPLICATE KEY UPDATE score = VALUES(score), rationale = VALUES(rationale);
INSERT INTO stock_recommendations (run_id, stock_id, rank_no, score, signal, target_horizon, rationale, risk_note)
SELECT r.id, s.id, 2, 84.10, 'relative strength', '1 trading day', 'AI 서버 수요 기대와 업종 모멘텀이 강해 KOSPI 내 단기 상대강도 후보로 분류됩니다.', '업황 기대가 선반영된 경우 변동성이 커질 수 있습니다.'
FROM recommendation_runs r JOIN market_indices i ON i.id = r.index_id JOIN stocks s ON s.symbol = '051910.KS'
WHERE i.code = 'KOSPI' AND r.period = 'daily' AND r.as_of_date = CURRENT_DATE
ON DUPLICATE KEY UPDATE score = VALUES(score), rationale = VALUES(rationale);
INSERT INTO stock_recommendations (run_id, stock_id, rank_no, score, signal, target_horizon, rationale, risk_note)
SELECT r.id, s.id, 3, 78.60, 'mean reversion', '1 trading day', '플랫폼 대형주 중 낙폭 대비 반등 여지가 있어 단기 순환매 후보로 볼 수 있습니다.', '광고 경기와 규제 이슈를 함께 확인해야 합니다.'
FROM recommendation_runs r JOIN market_indices i ON i.id = r.index_id JOIN stocks s ON s.symbol = '068270.KS'
WHERE i.code = 'KOSPI' AND r.period = 'daily' AND r.as_of_date = CURRENT_DATE
ON DUPLICATE KEY UPDATE score = VALUES(score), rationale = VALUES(rationale);

INSERT INTO stock_recommendations (run_id, stock_id, rank_no, score, signal, target_horizon, rationale, risk_note)
SELECT r.id, s.id, 1, 89.20, 'quality momentum', '1 week', '시가총액 비중, 실적 가시성, 글로벌 반도체 흐름을 반영한 주간 핵심 후보입니다.', '실적 발표와 거시 이벤트 전후로 포지션 크기를 보수적으로 조절해야 합니다.'
FROM recommendation_runs r JOIN market_indices i ON i.id = r.index_id JOIN stocks s ON s.symbol = '005930.KS'
WHERE i.code = 'KOSPI' AND r.period = 'weekly' AND r.as_of_date = CURRENT_DATE
ON DUPLICATE KEY UPDATE score = VALUES(score), rationale = VALUES(rationale);
INSERT INTO stock_recommendations (run_id, stock_id, rank_no, score, signal, target_horizon, rationale, risk_note)
SELECT r.id, s.id, 2, 81.30, 'turnaround watch', '1 week', '소재 업종 회복 기대가 붙을 때 주간 관찰 리스트에 올릴 수 있는 후보입니다.', '배터리 소재 수요와 원재료 가격 변동을 확인해야 합니다.'
FROM recommendation_runs r JOIN market_indices i ON i.id = r.index_id JOIN stocks s ON s.symbol = '000660.KS'
WHERE i.code = 'KOSPI' AND r.period = 'weekly' AND r.as_of_date = CURRENT_DATE
ON DUPLICATE KEY UPDATE score = VALUES(score), rationale = VALUES(rationale);
INSERT INTO stock_recommendations (run_id, stock_id, rank_no, score, signal, target_horizon, rationale, risk_note)
SELECT r.id, s.id, 3, 79.80, 'defensive growth', '1 week', '방어적 성장주 성격이 있어 지수 변동성이 커질 때 상대적으로 관찰 가치가 있습니다.', '바이오시밀러 가격 경쟁과 승인 이벤트 리스크가 있습니다.'
FROM recommendation_runs r JOIN market_indices i ON i.id = r.index_id JOIN stocks s ON s.symbol = '035420.KS'
WHERE i.code = 'KOSPI' AND r.period = 'weekly' AND r.as_of_date = CURRENT_DATE
ON DUPLICATE KEY UPDATE score = VALUES(score), rationale = VALUES(rationale);

INSERT INTO stock_recommendations (run_id, stock_id, rank_no, score, signal, target_horizon, rationale, risk_note)
SELECT r.id, s.id, 1, 85.50, 'yen sensitivity', '1 trading day', '엔화와 수출주 흐름을 함께 볼 때 단기 시장 대표 후보로 적합합니다.', '환율 급변과 글로벌 자동차 수요 둔화에 유의해야 합니다.'
FROM recommendation_runs r JOIN market_indices i ON i.id = r.index_id JOIN stocks s ON s.symbol = '7203.T'
WHERE i.code = 'NIKKEI225' AND r.period = 'daily' AND r.as_of_date = CURRENT_DATE
ON DUPLICATE KEY UPDATE score = VALUES(score), rationale = VALUES(rationale);
INSERT INTO stock_recommendations (run_id, stock_id, rank_no, score, signal, target_horizon, rationale, risk_note)
SELECT r.id, s.id, 2, 82.90, 'breakout watch', '1 trading day', '엔터테인먼트와 전자 부문 기대가 함께 반영되는 대형 성장 후보입니다.', '콘텐츠 실적과 글로벌 소비 둔화에 영향을 받습니다.'
FROM recommendation_runs r JOIN market_indices i ON i.id = r.index_id JOIN stocks s ON s.symbol = '8035.T'
WHERE i.code = 'NIKKEI225' AND r.period = 'daily' AND r.as_of_date = CURRENT_DATE
ON DUPLICATE KEY UPDATE score = VALUES(score), rationale = VALUES(rationale);
INSERT INTO stock_recommendations (run_id, stock_id, rank_no, score, signal, target_horizon, rationale, risk_note)
SELECT r.id, s.id, 3, 80.20, 'high beta', '1 trading day', '기술주 투자심리 개선 시 지수 대비 탄력적인 움직임을 기대할 수 있습니다.', '보유 투자자산 평가 변동성이 큽니다.'
FROM recommendation_runs r JOIN market_indices i ON i.id = r.index_id JOIN stocks s ON s.symbol = '4063.T'
WHERE i.code = 'NIKKEI225' AND r.period = 'daily' AND r.as_of_date = CURRENT_DATE
ON DUPLICATE KEY UPDATE score = VALUES(score), rationale = VALUES(rationale);

INSERT INTO stock_recommendations (run_id, stock_id, rank_no, score, signal, target_horizon, rationale, risk_note)
SELECT r.id, s.id, 1, 88.60, 'sector leadership', '1 week', '반도체 장비 업종 강세가 이어질 때 주간 리더 후보로 분류됩니다.', '수출 규제와 설비투자 사이클 변화에 취약합니다.'
FROM recommendation_runs r JOIN market_indices i ON i.id = r.index_id JOIN stocks s ON s.symbol = '6758.T'
WHERE i.code = 'NIKKEI225' AND r.period = 'weekly' AND r.as_of_date = CURRENT_DATE
ON DUPLICATE KEY UPDATE score = VALUES(score), rationale = VALUES(rationale);
INSERT INTO stock_recommendations (run_id, stock_id, rank_no, score, signal, target_horizon, rationale, risk_note)
SELECT r.id, s.id, 2, 84.70, 'quality value', '1 week', '실적 안정성과 주주환원 기대를 함께 볼 수 있는 대표 대형주입니다.', '엔화 강세 전환 시 투자심리가 약해질 수 있습니다.'
FROM recommendation_runs r JOIN market_indices i ON i.id = r.index_id JOIN stocks s ON s.symbol = '7203.T'
WHERE i.code = 'NIKKEI225' AND r.period = 'weekly' AND r.as_of_date = CURRENT_DATE
ON DUPLICATE KEY UPDATE score = VALUES(score), rationale = VALUES(rationale);
INSERT INTO stock_recommendations (run_id, stock_id, rank_no, score, signal, target_horizon, rationale, risk_note)
SELECT r.id, s.id, 3, 80.50, 'steady compounder', '1 week', '소재와 반도체 밸류체인을 함께 반영하는 안정적 후보입니다.', '글로벌 제조업 지표 부진 시 모멘텀이 둔화될 수 있습니다.'
FROM recommendation_runs r JOIN market_indices i ON i.id = r.index_id JOIN stocks s ON s.symbol = '9984.T'
WHERE i.code = 'NIKKEI225' AND r.period = 'weekly' AND r.as_of_date = CURRENT_DATE
ON DUPLICATE KEY UPDATE score = VALUES(score), rationale = VALUES(rationale);

INSERT INTO stock_recommendations (run_id, stock_id, rank_no, score, signal, target_horizon, rationale, risk_note)
SELECT r.id, s.id, 1, 88.10, 'quality momentum', '1 trading day', '클라우드와 AI 기대가 지속될 때 S&P 500 내 단기 핵심 후보로 적합합니다.', '대형 기술주 밸류에이션 부담과 금리 변화에 민감합니다.'
FROM recommendation_runs r JOIN market_indices i ON i.id = r.index_id JOIN stocks s ON s.symbol = 'MSFT'
WHERE i.code = 'SP500' AND r.period = 'daily' AND r.as_of_date = CURRENT_DATE
ON DUPLICATE KEY UPDATE score = VALUES(score), rationale = VALUES(rationale);
INSERT INTO stock_recommendations (run_id, stock_id, rank_no, score, signal, target_horizon, rationale, risk_note)
SELECT r.id, s.id, 2, 87.60, 'growth momentum', '1 trading day', 'AI 반도체 수요 기대가 강한 구간에서 단기 모멘텀 후보로 분류됩니다.', '기대치가 높아 실적 이벤트 전후 변동성이 큽니다.'
FROM recommendation_runs r JOIN market_indices i ON i.id = r.index_id JOIN stocks s ON s.symbol = 'JPM'
WHERE i.code = 'SP500' AND r.period = 'daily' AND r.as_of_date = CURRENT_DATE
ON DUPLICATE KEY UPDATE score = VALUES(score), rationale = VALUES(rationale);
INSERT INTO stock_recommendations (run_id, stock_id, rank_no, score, signal, target_horizon, rationale, risk_note)
SELECT r.id, s.id, 3, 82.40, 'defensive growth', '1 trading day', '헬스케어 성장주 성격으로 기술주 쏠림 완화 시 대안 후보가 될 수 있습니다.', '임상, 규제, 약가 관련 뉴스에 영향을 받습니다.'
FROM recommendation_runs r JOIN market_indices i ON i.id = r.index_id JOIN stocks s ON s.symbol = 'XOM'
WHERE i.code = 'SP500' AND r.period = 'daily' AND r.as_of_date = CURRENT_DATE
ON DUPLICATE KEY UPDATE score = VALUES(score), rationale = VALUES(rationale);

INSERT INTO stock_recommendations (run_id, stock_id, rank_no, score, signal, target_horizon, rationale, risk_note)
SELECT r.id, s.id, 1, 90.30, 'compounder', '1 week', '실적 안정성과 AI 인프라 노출을 동시에 가진 주간 대표 후보입니다.', '거시 금리 상승 시 성장주 전반의 할인율 부담이 커질 수 있습니다.'
FROM recommendation_runs r JOIN market_indices i ON i.id = r.index_id JOIN stocks s ON s.symbol = 'MSFT'
WHERE i.code = 'SP500' AND r.period = 'weekly' AND r.as_of_date = CURRENT_DATE
ON DUPLICATE KEY UPDATE score = VALUES(score), rationale = VALUES(rationale);
INSERT INTO stock_recommendations (run_id, stock_id, rank_no, score, signal, target_horizon, rationale, risk_note)
SELECT r.id, s.id, 2, 82.70, 'macro balance', '1 week', '금융 섹터로 포트폴리오 균형을 맞출 때 관찰할 수 있는 대형주입니다.', '신용 비용과 경기 둔화 신호를 함께 봐야 합니다.'
FROM recommendation_runs r JOIN market_indices i ON i.id = r.index_id JOIN stocks s ON s.symbol = 'NVDA'
WHERE i.code = 'SP500' AND r.period = 'weekly' AND r.as_of_date = CURRENT_DATE
ON DUPLICATE KEY UPDATE score = VALUES(score), rationale = VALUES(rationale);
INSERT INTO stock_recommendations (run_id, stock_id, rank_no, score, signal, target_horizon, rationale, risk_note)
SELECT r.id, s.id, 3, 79.90, 'inflation hedge', '1 week', '유가 상승 또는 인플레이션 재부각 구간에서 방어적 후보로 활용할 수 있습니다.', '원유 가격 급락과 정책 변화에 민감합니다.'
FROM recommendation_runs r JOIN market_indices i ON i.id = r.index_id JOIN stocks s ON s.symbol = 'LLY'
WHERE i.code = 'SP500' AND r.period = 'weekly' AND r.as_of_date = CURRENT_DATE
ON DUPLICATE KEY UPDATE score = VALUES(score), rationale = VALUES(rationale);
