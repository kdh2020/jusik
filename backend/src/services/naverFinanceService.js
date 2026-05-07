import { recommendations as sampleRecommendations } from '../data/sampleData.js';

const NAVER_MOBILE_BASE_URL = 'https://m.stock.naver.com';
const NAVER_PC_BASE_URL = 'https://finance.naver.com';

const naverHeaders = {
  'User-Agent': 'Mozilla/5.0',
  Referer: 'https://finance.naver.com/'
};

const kospiStocks = [
  { code: '005930', symbol: '005930.KS', companyName: 'Samsung Electronics', sector: 'Technology' },
  { code: '000660', symbol: '000660.KS', companyName: 'SK Hynix', sector: 'Semiconductors' },
  { code: '035420', symbol: '035420.KS', companyName: 'NAVER', sector: 'Internet' },
  { code: '051910', symbol: '051910.KS', companyName: 'LG Chem', sector: 'Materials' },
  { code: '068270', symbol: '068270.KS', companyName: 'Celltrion', sector: 'Healthcare' }
];

const worldIndexSymbols = {
  NIKKEI225: 'NII@NI225',
  SP500: 'SPI@SPX'
};

function toNumber(value) {
  if (value === null || value === undefined) {
    return 0;
  }

  return Number(String(value).replaceAll(',', ''));
}

function clamp(value, min, max) {
  return Math.min(max, Math.max(min, value));
}

function formatDate(value) {
  if (!value) {
    return new Date().toISOString().slice(0, 10);
  }

  if (value.includes('-')) {
    return value;
  }

  return `${value.slice(0, 4)}-${value.slice(4, 6)}-${value.slice(6, 8)}`;
}

async function requestJson(url) {
  const response = await fetch(url, { headers: naverHeaders });

  if (!response.ok) {
    throw new Error(`Naver Finance request failed: ${response.status}`);
  }

  return response.json();
}

async function fetchDomesticHistory(code, pageSize = 10) {
  const url = `${NAVER_MOBILE_BASE_URL}/api/stock/${code}/price?pageSize=${pageSize}&page=1`;
  const rows = await requestJson(url);

  if (!Array.isArray(rows) || rows.length === 0) {
    throw new Error(`No Naver stock price rows for ${code}`);
  }

  return rows.map((row) => ({
    date: row.localTradedAt,
    close: toNumber(row.closePrice),
    open: toNumber(row.openPrice),
    high: toNumber(row.highPrice),
    low: toNumber(row.lowPrice),
    volume: toNumber(row.accumulatedTradingVolume),
    change: toNumber(row.compareToPreviousClosePrice),
    changeRate: Number(row.fluctuationsRatio || 0),
    direction: row.compareToPreviousPrice?.text || ''
  }));
}

async function fetchWorldIndexHistory(symbol) {
  const url = `${NAVER_PC_BASE_URL}/world/worldDayListJson.naver?symbol=${encodeURIComponent(symbol)}&fdtc=0&page=1`;
  const rows = await requestJson(url);

  if (!Array.isArray(rows) || rows.length === 0) {
    throw new Error(`No Naver world index rows for ${symbol}`);
  }

  return rows.map((row) => ({
    date: formatDate(row.xymd),
    close: Number(row.clos || 0),
    open: Number(row.open || 0),
    high: Number(row.high || 0),
    low: Number(row.low || 0),
    volume: Number(row.gvol || 0),
    change: Number(row.diff || 0),
    changeRate: Number(row.rate || 0)
  }));
}

function buildKospiPick(stock, history, period) {
  const latest = history[0];
  const compareIndex = period === 'weekly' ? Math.min(4, history.length - 1) : 1;
  const compare = history[compareIndex] || history[1] || history[0];
  const periodRate = compare.close ? ((latest.close - compare.close) / compare.close) * 100 : latest.changeRate;
  const momentum = period === 'weekly' ? periodRate : latest.changeRate;
  const intradayRange = latest.close ? ((latest.high - latest.low) / latest.close) * 100 : 0;
  const score = clamp(74 + momentum * 3 - intradayRange * 0.4, 55, 96);

  return {
    symbol: stock.symbol,
    companyName: stock.companyName,
    sector: stock.sector,
    score: Number(score.toFixed(1)),
    signal: momentum >= 0 ? 'naver momentum' : 'naver rebound watch',
    targetHorizon: period === 'weekly' ? '1 week' : '1 trading day',
    rationale: `네이버 증권 기준 최근 종가 ${latest.close.toLocaleString()}원, ${period === 'weekly' ? '주간' : '일일'} 변동률 ${momentum.toFixed(2)}%를 반영한 후보입니다.`,
    riskNote: `최근 일중 변동폭이 ${intradayRange.toFixed(2)}%입니다. 공시, 실적, 수급 변화 확인이 필요합니다.`,
    latestPrice: latest.close,
    change: latest.change,
    changeRate: latest.changeRate,
    tradedAt: latest.date,
    naverUrl: `${NAVER_PC_BASE_URL}/item/main.naver?code=${stock.code}`
  };
}

export async function buildNaverRecommendations(market, period) {
  if (market === 'KOSPI') {
    const histories = await Promise.all(
      kospiStocks.map(async (stock) => ({
        stock,
        history: await fetchDomesticHistory(stock.code)
      }))
    );

    const picks = histories
      .map(({ stock, history }) => buildKospiPick(stock, history, period))
      .sort((a, b) => b.score - a.score)
      .slice(0, 3)
      .map((pick, index) => ({ ...pick, rank: index + 1 }));

    return {
      market,
      period,
      asOfDate: picks[0]?.tradedAt || new Date().toISOString().slice(0, 10),
      modelVersion: 'naver-rules-v1',
      summary: '네이버 증권 국내 종목 일별 시세를 기반으로 가격 모멘텀과 변동폭을 점수화했습니다.',
      recommendations: picks
    };
  }

  const symbol = worldIndexSymbols[market];
  const history = await fetchWorldIndexHistory(symbol);
  const latest = history[0];
  const periodCompare = history[period === 'weekly' ? Math.min(4, history.length - 1) : 1] || history[0];
  const periodRate = periodCompare.close ? ((latest.close - periodCompare.close) / periodCompare.close) * 100 : latest.changeRate;

  return {
    market,
    period,
    asOfDate: latest.date,
    modelVersion: 'naver-index-rules-v1',
    summary: `네이버 금융 해외 지수 ${symbol}의 최신 변동률 ${latest.changeRate.toFixed(2)}%와 ${period === 'weekly' ? '주간' : '일일'} 흐름을 추천 점수에 반영했습니다.`,
    marketSignal: {
      latestPrice: latest.close,
      change: latest.change,
      changeRate: latest.changeRate,
      periodRate: Number(periodRate.toFixed(2)),
      naverUrl: `${NAVER_PC_BASE_URL}/world/sise.naver?symbol=${encodeURIComponent(symbol)}`
    },
    recommendations: (sampleRecommendations[market]?.[period] || []).map((pick) => ({
      ...pick,
      score: Number(clamp(pick.score + periodRate * 0.8, 55, 96).toFixed(1)),
      rationale: `${pick.rationale} 네이버 금융 지수 기준 ${period === 'weekly' ? '주간' : '일일'} 변동률 ${periodRate.toFixed(2)}%를 함께 참고했습니다.`,
      naverUrl: `${NAVER_PC_BASE_URL}/world/sise.naver?symbol=${encodeURIComponent(symbol)}`
    }))
  };
}
