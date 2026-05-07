export const indices = [
  {
    code: 'KOSPI',
    name: 'KOSPI',
    country: 'South Korea',
    currency: 'KRW',
    timezone: 'Asia/Seoul'
  },
  {
    code: 'NIKKEI225',
    name: 'Nikkei 225',
    country: 'Japan',
    currency: 'JPY',
    timezone: 'Asia/Tokyo'
  },
  {
    code: 'SP500',
    name: 'S&P 500',
    country: 'United States',
    currency: 'USD',
    timezone: 'America/New_York'
  }
];

export const recommendations = {
  KOSPI: {
    daily: [
      {
        rank: 1,
        symbol: '005930.KS',
        companyName: 'Samsung Electronics',
        sector: 'Technology',
        score: 87.4,
        signal: 'momentum',
        targetHorizon: '1 trading day',
        rationale: '반도체 대형주 수급과 지수 민감도가 높아 단기 반등 구간에서 우선 관찰할 후보입니다.',
        riskNote: '메모리 가격, 환율, 외국인 수급 변화에 민감합니다.'
      },
      {
        rank: 2,
        symbol: '000660.KS',
        companyName: 'SK Hynix',
        sector: 'Semiconductors',
        score: 84.1,
        signal: 'relative strength',
        targetHorizon: '1 trading day',
        rationale: 'AI 서버 수요 기대와 업종 모멘텀이 강해 KOSPI 내 단기 상대강도 후보로 분류됩니다.',
        riskNote: '업황 기대가 선반영된 경우 변동성이 커질 수 있습니다.'
      },
      {
        rank: 3,
        symbol: '035420.KS',
        companyName: 'NAVER',
        sector: 'Internet',
        score: 78.6,
        signal: 'mean reversion',
        targetHorizon: '1 trading day',
        rationale: '플랫폼 대형주 중 낙폭 대비 반등 여지가 있어 단기 순환매 후보로 볼 수 있습니다.',
        riskNote: '광고 경기와 규제 이슈를 함께 확인해야 합니다.'
      }
    ],
    weekly: [
      {
        rank: 1,
        symbol: '005930.KS',
        companyName: 'Samsung Electronics',
        sector: 'Technology',
        score: 89.2,
        signal: 'quality momentum',
        targetHorizon: '1 week',
        rationale: '시가총액 비중, 실적 가시성, 글로벌 반도체 흐름을 반영한 주간 핵심 후보입니다.',
        riskNote: '실적 발표와 거시 이벤트 전후로 포지션 크기를 보수적으로 조절해야 합니다.'
      },
      {
        rank: 2,
        symbol: '051910.KS',
        companyName: 'LG Chem',
        sector: 'Materials',
        score: 81.3,
        signal: 'turnaround watch',
        targetHorizon: '1 week',
        rationale: '소재 업종 회복 기대가 붙을 때 주간 관찰 리스트에 올릴 수 있는 후보입니다.',
        riskNote: '배터리 소재 수요와 원재료 가격 변동을 확인해야 합니다.'
      },
      {
        rank: 3,
        symbol: '068270.KS',
        companyName: 'Celltrion',
        sector: 'Healthcare',
        score: 79.8,
        signal: 'defensive growth',
        targetHorizon: '1 week',
        rationale: '방어적 성장주 성격이 있어 지수 변동성이 커질 때 상대적으로 관찰 가치가 있습니다.',
        riskNote: '바이오시밀러 가격 경쟁과 승인 이벤트 리스크가 있습니다.'
      }
    ]
  },
  NIKKEI225: {
    daily: [
      {
        rank: 1,
        symbol: '7203.T',
        companyName: 'Toyota Motor',
        sector: 'Automobiles',
        score: 85.5,
        signal: 'yen sensitivity',
        targetHorizon: '1 trading day',
        rationale: '엔화와 수출주 흐름을 함께 볼 때 단기 시장 대표 후보로 적합합니다.',
        riskNote: '환율 급변과 글로벌 자동차 수요 둔화에 유의해야 합니다.'
      },
      {
        rank: 2,
        symbol: '6758.T',
        companyName: 'Sony Group',
        sector: 'Consumer Electronics',
        score: 82.9,
        signal: 'breakout watch',
        targetHorizon: '1 trading day',
        rationale: '엔터테인먼트와 전자 부문 기대가 함께 반영되는 대형 성장 후보입니다.',
        riskNote: '콘텐츠 실적과 글로벌 소비 둔화에 영향을 받습니다.'
      },
      {
        rank: 3,
        symbol: '9984.T',
        companyName: 'SoftBank Group',
        sector: 'Telecom and Investments',
        score: 80.2,
        signal: 'high beta',
        targetHorizon: '1 trading day',
        rationale: '기술주 투자심리 개선 시 지수 대비 탄력적인 움직임을 기대할 수 있습니다.',
        riskNote: '보유 투자자산 평가 변동성이 큽니다.'
      }
    ],
    weekly: [
      {
        rank: 1,
        symbol: '8035.T',
        companyName: 'Tokyo Electron',
        sector: 'Semiconductor Equipment',
        score: 88.6,
        signal: 'sector leadership',
        targetHorizon: '1 week',
        rationale: '반도체 장비 업종 강세가 이어질 때 주간 리더 후보로 분류됩니다.',
        riskNote: '수출 규제와 설비투자 사이클 변화에 취약합니다.'
      },
      {
        rank: 2,
        symbol: '7203.T',
        companyName: 'Toyota Motor',
        sector: 'Automobiles',
        score: 84.7,
        signal: 'quality value',
        targetHorizon: '1 week',
        rationale: '실적 안정성과 주주환원 기대를 함께 볼 수 있는 대표 대형주입니다.',
        riskNote: '엔화 강세 전환 시 투자심리가 약해질 수 있습니다.'
      },
      {
        rank: 3,
        symbol: '4063.T',
        companyName: 'Shin-Etsu Chemical',
        sector: 'Chemicals',
        score: 80.5,
        signal: 'steady compounder',
        targetHorizon: '1 week',
        rationale: '소재와 반도체 밸류체인을 함께 반영하는 안정적 후보입니다.',
        riskNote: '글로벌 제조업 지표 부진 시 모멘텀이 둔화될 수 있습니다.'
      }
    ]
  },
  SP500: {
    daily: [
      {
        rank: 1,
        symbol: 'MSFT',
        companyName: 'Microsoft',
        sector: 'Technology',
        score: 88.1,
        signal: 'quality momentum',
        targetHorizon: '1 trading day',
        rationale: '클라우드와 AI 기대가 지속될 때 S&P 500 내 단기 핵심 후보로 적합합니다.',
        riskNote: '대형 기술주 밸류에이션 부담과 금리 변화에 민감합니다.'
      },
      {
        rank: 2,
        symbol: 'NVDA',
        companyName: 'NVIDIA',
        sector: 'Semiconductors',
        score: 87.6,
        signal: 'growth momentum',
        targetHorizon: '1 trading day',
        rationale: 'AI 반도체 수요 기대가 강한 구간에서 단기 모멘텀 후보로 분류됩니다.',
        riskNote: '기대치가 높아 실적 이벤트 전후 변동성이 큽니다.'
      },
      {
        rank: 3,
        symbol: 'LLY',
        companyName: 'Eli Lilly',
        sector: 'Healthcare',
        score: 82.4,
        signal: 'defensive growth',
        targetHorizon: '1 trading day',
        rationale: '헬스케어 성장주 성격으로 기술주 쏠림 완화 시 대안 후보가 될 수 있습니다.',
        riskNote: '임상, 규제, 약가 관련 뉴스에 영향을 받습니다.'
      }
    ],
    weekly: [
      {
        rank: 1,
        symbol: 'MSFT',
        companyName: 'Microsoft',
        sector: 'Technology',
        score: 90.3,
        signal: 'compounder',
        targetHorizon: '1 week',
        rationale: '실적 안정성과 AI 인프라 노출을 동시에 가진 주간 대표 후보입니다.',
        riskNote: '거시 금리 상승 시 성장주 전반의 할인율 부담이 커질 수 있습니다.'
      },
      {
        rank: 2,
        symbol: 'JPM',
        companyName: 'JPMorgan Chase',
        sector: 'Financials',
        score: 82.7,
        signal: 'macro balance',
        targetHorizon: '1 week',
        rationale: '금융 섹터로 포트폴리오 균형을 맞출 때 관찰할 수 있는 대형주입니다.',
        riskNote: '신용 비용과 경기 둔화 신호를 함께 봐야 합니다.'
      },
      {
        rank: 3,
        symbol: 'XOM',
        companyName: 'Exxon Mobil',
        sector: 'Energy',
        score: 79.9,
        signal: 'inflation hedge',
        targetHorizon: '1 week',
        rationale: '유가 상승 또는 인플레이션 재부각 구간에서 방어적 후보로 활용할 수 있습니다.',
        riskNote: '원유 가격 급락과 정책 변화에 민감합니다.'
      }
    ]
  }
};
