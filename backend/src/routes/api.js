import { Router } from 'express';
import { z } from 'zod';
import { canUseDatabase } from '../db.js';
import { listIndices, listRecommendations } from '../services/marketService.js';

const router = Router();

const recommendationQuerySchema = z.object({
  market: z.enum(['KOSPI', 'NIKKEI225', 'SP500']).default('KOSPI'),
  period: z.enum(['daily', 'weekly']).default('daily')
});

router.get('/health', async (_req, res) => {
  const database = await canUseDatabase();

  res.json({
    status: 'ok',
    database: database ? 'connected' : 'sample-data',
    timestamp: new Date().toISOString()
  });
});

router.get('/indices', async (_req, res, next) => {
  try {
    const useDatabase = await canUseDatabase();
    const data = await listIndices(useDatabase);
    res.json({ data, source: useDatabase ? 'mysql' : 'sample-data' });
  } catch (error) {
    next(error);
  }
});

router.get('/recommendations', async (req, res, next) => {
  try {
    const query = recommendationQuerySchema.parse(req.query);
    const useDatabase = await canUseDatabase();
    const data = await listRecommendations({ ...query, useDatabase });
    const source = data.dataSources?.includes('daum') ? 'naver-daum-finance' : (data.modelVersion?.startsWith('naver') ? 'naver-finance' : (useDatabase ? 'mysql' : 'sample-data'));

    res.json({ data, source });
  } catch (error) {
    next(error);
  }
});

export default router;
