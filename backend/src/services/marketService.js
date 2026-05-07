import { getPool } from '../db.js';
import { indices as sampleIndices, recommendations as sampleRecommendations } from '../data/sampleData.js';
import { buildNaverRecommendations } from './naverFinanceService.js';

const today = () => new Date().toISOString().slice(0, 10);

export async function listIndices(useDatabase) {
  if (!useDatabase) {
    return sampleIndices;
  }

  const [rows] = await getPool().query(
    `SELECT code, name, country, currency, timezone
     FROM market_indices
     ORDER BY FIELD(code, 'KOSPI', 'NIKKEI225', 'SP500')`
  );

  return rows;
}

export async function listRecommendations({ market, period, useDatabase }) {
  try {
    const naverData = await buildNaverRecommendations(market, period);
    return naverData;
  } catch (error) {
    console.warn(`Falling back from Naver Finance data: ${error.message}`);
  }

  if (!useDatabase) {
    return {
      market,
      period,
      asOfDate: today(),
      modelVersion: 'sample-rules-v1',
      summary: `${market} ${period} reference picks from bundled sample data.`,
      recommendations: sampleRecommendations[market]?.[period] || []
    };
  }

  const [runs] = await getPool().query(
    `SELECT r.id, r.as_of_date AS asOfDate, r.model_version AS modelVersion, r.summary
     FROM recommendation_runs r
     INNER JOIN market_indices i ON i.id = r.index_id
     WHERE i.code = :market AND r.period = :period
     ORDER BY r.as_of_date DESC, r.created_at DESC
     LIMIT 1`,
    { market, period }
  );

  if (runs.length === 0) {
    return {
      market,
      period,
      asOfDate: today(),
      modelVersion: 'empty',
      summary: 'No database recommendations found for this market and period.',
      recommendations: []
    };
  }

  const [rows] = await getPool().query(
    `SELECT
       sr.rank_no AS rank,
       s.symbol,
       s.company_name AS companyName,
       s.sector,
       sr.score,
       sr.signal,
       sr.target_horizon AS targetHorizon,
       sr.rationale,
       sr.risk_note AS riskNote
     FROM stock_recommendations sr
     INNER JOIN stocks s ON s.id = sr.stock_id
     WHERE sr.run_id = :runId
     ORDER BY sr.rank_no ASC`,
    { runId: runs[0].id }
  );

  return {
    market,
    period,
    asOfDate: runs[0].asOfDate,
    modelVersion: runs[0].modelVersion,
    summary: runs[0].summary,
    recommendations: rows.map((row) => ({
      ...row,
      score: Number(row.score)
    }))
  };
}
