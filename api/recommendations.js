import { recommendations as sampleRecommendations } from '../backend/src/data/sampleData.js';
import { buildNaverRecommendations } from '../backend/src/services/naverFinanceService.js';

const allowedMarkets = new Set(['KOSPI', 'NIKKEI225', 'SP500']);
const allowedPeriods = new Set(['daily', 'weekly']);

export default async function handler(req, res) {
  const market = allowedMarkets.has(req.query.market) ? req.query.market : 'KOSPI';
  const period = allowedPeriods.has(req.query.period) ? req.query.period : 'daily';

  try {
    const data = await buildNaverRecommendations(market, period);

    res.status(200).json({
      data,
      source: data.dataSources?.includes('daum') ? 'naver-daum-finance' : 'naver-finance'
    });
  } catch (error) {
    console.warn(`Falling back from Naver Finance data: ${error.message}`);

    res.status(200).json({
      data: {
        market,
        period,
        asOfDate: new Date().toISOString().slice(0, 10),
        modelVersion: 'sample-rules-v1',
        summary: 'Naver Finance data was unavailable, so bundled sample recommendations are shown.',
        recommendations: sampleRecommendations[market]?.[period] || []
      },
      source: 'sample-data'
    });
  }
}
