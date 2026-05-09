<script setup>
import { computed, onMounted, ref, watch } from 'vue';
import { fetchIndices, fetchRecommendations } from './api';

const markets = ref([]);
const selectedMarket = ref('KOSPI');
const selectedPeriod = ref('daily');
const payload = ref(null);
const source = ref('sample-data');
const loading = ref(true);
const error = ref('');

const periodOptions = [
  { value: 'daily', label: '일일' },
  { value: 'weekly', label: '주간' }
];

const selectedMarketMeta = computed(() => {
  return markets.value.find((market) => market.code === selectedMarket.value);
});

const recommendations = computed(() => payload.value?.recommendations || []);

const activePeriodLabel = computed(() => {
  return periodOptions.find((period) => period.value === selectedPeriod.value)?.label || '';
});

const sourceLabel = computed(() => {
  if (source.value === 'naver-daum-finance') {
    return 'Naver + Daum';
  }

  if (source.value === 'naver-yahoo-finance') {
    return 'Naver + Yahoo';
  }

  if (source.value === 'naver-finance') {
    return 'Naver';
  }

  return source.value === 'mysql' ? 'MySQL' : 'Sample Data';
});

function formatPrice(value) {
  if (value === null || value === undefined) {
    return '-';
  }

  return Number(value).toLocaleString();
}

function changeClass(value) {
  return Number(value || 0) >= 0 ? 'up' : 'down';
}

function signedPercent(value) {
  const numericValue = Number(value || 0);
  const sign = numericValue > 0 ? '+' : '';
  return `${sign}${numericValue.toFixed(2)}%`;
}

async function loadMarkets() {
  const response = await fetchIndices();
  markets.value = response.data;
  source.value = response.source;
}

async function loadRecommendations() {
  loading.value = true;
  error.value = '';

  try {
    const response = await fetchRecommendations(selectedMarket.value, selectedPeriod.value);
    payload.value = response.data;
    source.value = response.source;
  } catch (requestError) {
    error.value = '추천 데이터를 불러오지 못했습니다. 백엔드 서버 상태를 확인해 주세요.';
    console.error(requestError);
  } finally {
    loading.value = false;
  }
}

watch([selectedMarket, selectedPeriod], loadRecommendations);

onMounted(async () => {
  try {
    await loadMarkets();
    await loadRecommendations();
  } catch (requestError) {
    loading.value = false;
    error.value = 'API 서버에 연결할 수 없습니다. backend 서버가 실행 중인지 확인해 주세요.';
    console.error(requestError);
  }
});
</script>

<template>
  <main class="app-shell">
    <header class="site-header">
      <a class="brand-mark" href="/" aria-label="Jusik Today 홈">
        <span>J</span>
        Jusik Today
      </a>
      <nav class="header-nav" aria-label="주요 메뉴">
        <a href="#markets">Markets</a>
        <a href="#picks">Picks</a>
        <a href="https://github.com/kdh2020/jusik" target="_blank" rel="noreferrer">GitHub</a>
      </nav>
    </header>

    <section class="hero-band">
      <div class="hero-copy">
        <p class="eyebrow">Naver Finance Signal</p>
        <h1>오늘의 시장을 가볍게 열어보는 주식 추천 보드</h1>
      </div>
      <div class="hero-status">
        <span>데이터</span>
        <strong>{{ sourceLabel }}</strong>
        <small>{{ payload?.asOfDate || 'loading' }}</small>
      </div>
    </section>

    <section id="markets" class="quick-section">
      <div class="section-heading">
        <h2>시장 선택</h2>
        <div class="period-switch">
          <button
            v-for="period in periodOptions"
            :key="period.value"
            :class="{ active: selectedPeriod === period.value }"
            type="button"
            @click="selectedPeriod = period.value"
          >
            {{ period.label }}
          </button>
        </div>
      </div>

      <div class="market-grid">
        <button
          v-for="market in markets"
          :key="market.code"
          :class="{ active: selectedMarket === market.code }"
          type="button"
          @click="selectedMarket = market.code"
        >
          <span>{{ market.name }}</span>
          <strong>{{ market.code }}</strong>
          <small>{{ market.country }} · {{ market.currency }}</small>
        </button>
      </div>
    </section>

    <section class="signal-strip" v-if="selectedMarketMeta">
      <div>
        <span>선택 지수</span>
        <strong>{{ selectedMarketMeta.name }}</strong>
      </div>
      <div>
        <span>추천 주기</span>
        <strong>{{ activePeriodLabel }}</strong>
      </div>
      <div>
        <span>모델</span>
        <strong>{{ payload?.modelVersion || '-' }}</strong>
      </div>
      <a
        v-if="payload?.marketSignal"
        :href="payload.marketSignal.naverUrl"
        target="_blank"
        rel="noreferrer"
      >
        네이버 지수 {{ signedPercent(payload.marketSignal.changeRate) }}
      </a>
    </section>

    <p v-if="error" class="error-message">{{ error }}</p>

    <section id="picks" v-else class="recommendation-section" aria-live="polite">
      <div class="section-heading">
        <h2>추천 종목</h2>
        <p>{{ payload?.summary }}</p>
      </div>

      <div v-if="loading" class="loading-state">추천 데이터를 불러오는 중입니다.</div>

      <div v-else-if="recommendations.length" class="recommendation-list">
        <article v-for="item in recommendations" :key="item.symbol" class="recommendation-card">
          <div class="rank-block">
            <span class="rank">#{{ item.rank }}</span>
            <strong>{{ item.score.toFixed(1) }}</strong>
            <small>score</small>
          </div>
          <div class="stock-info">
            <div class="stock-title">
              <div>
                <h3>{{ item.companyName }}</h3>
                <span>{{ item.symbol }}</span>
              </div>
              <a v-if="item.naverUrl" :href="item.naverUrl" target="_blank" rel="noreferrer">Naver</a>
            </div>
            <div v-if="item.latestPrice" class="price-row">
              <strong>{{ formatPrice(item.latestPrice) }}</strong>
              <span :class="changeClass(item.changeRate)">{{ signedPercent(item.changeRate) }}</span>
            </div>
            <p>{{ item.rationale }}</p>
            <ul class="meta-row">
              <li>{{ item.sector }}</li>
              <li>{{ item.signal }}</li>
              <li>{{ item.targetHorizon }}</li>
            </ul>
            <p class="risk">{{ item.riskNote }}</p>
          </div>
        </article>
      </div>

      <div v-else class="loading-state">표시할 추천 종목이 없습니다.</div>
    </section>

    <footer>
      이 화면은 투자 판단을 대신하지 않는 리서치용 예시입니다. 실제 매수 전 최신 가격, 공시, 재무정보를 확인하세요.
    </footer>
  </main>
</template>
