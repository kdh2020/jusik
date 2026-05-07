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

const sourceLabel = computed(() => {
  if (source.value === 'naver-finance') {
    return 'Naver Finance';
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
    <section class="overview">
      <div>
        <p class="eyebrow">Daily & Weekly Stock Picks</p>
        <h1>3대 지수 기반 주식 추천 대시보드</h1>
        <p class="intro">
          KOSPI, Nikkei 225, S&amp;P 500을 기준으로 일일 및 주간 참고 후보를 비교합니다.
        </p>
      </div>
      <div class="status-panel">
        <span>데이터 소스</span>
        <strong>{{ sourceLabel }}</strong>
      </div>
    </section>

    <section class="toolbar" aria-label="추천 조건">
      <div class="market-tabs">
        <button
          v-for="market in markets"
          :key="market.code"
          :class="{ active: selectedMarket === market.code }"
          type="button"
          @click="selectedMarket = market.code"
        >
          <span>{{ market.name }}</span>
          <small>{{ market.country }}</small>
        </button>
      </div>

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
    </section>

    <section class="market-summary" v-if="selectedMarketMeta">
      <div>
        <span>선택 지수</span>
        <strong>{{ selectedMarketMeta.name }}</strong>
      </div>
      <div>
        <span>통화</span>
        <strong>{{ selectedMarketMeta.currency }}</strong>
      </div>
      <div>
        <span>기준일</span>
        <strong>{{ payload?.asOfDate || '-' }}</strong>
      </div>
      <div>
        <span>모델</span>
        <strong>{{ payload?.modelVersion || '-' }}</strong>
      </div>
    </section>

    <section class="market-feed" v-if="payload?.marketSignal">
      <div>
        <span>네이버 지수</span>
        <strong>{{ formatPrice(payload.marketSignal.latestPrice) }}</strong>
      </div>
      <div>
        <span>등락률</span>
        <strong :class="changeClass(payload.marketSignal.changeRate)">
          {{ payload.marketSignal.changeRate.toFixed(2) }}%
        </strong>
      </div>
      <a :href="payload.marketSignal.naverUrl" target="_blank" rel="noreferrer">네이버에서 보기</a>
    </section>

    <p v-if="error" class="error-message">{{ error }}</p>

    <section v-else class="recommendation-list" aria-live="polite">
      <div v-if="loading" class="loading-state">추천 데이터를 불러오는 중입니다.</div>

      <template v-else-if="recommendations.length">
        <article v-for="item in recommendations" :key="item.symbol" class="recommendation-card">
          <div class="rank-block">
            <span class="rank">#{{ item.rank }}</span>
            <strong>{{ item.score.toFixed(1) }}</strong>
          </div>
          <div class="stock-info">
            <div class="stock-title">
              <h2>{{ item.companyName }}</h2>
              <span>{{ item.symbol }}</span>
            </div>
            <p>{{ item.rationale }}</p>
            <div class="meta-row">
              <span>{{ item.sector }}</span>
              <span>{{ item.signal }}</span>
              <span>{{ item.targetHorizon }}</span>
            </div>
            <div v-if="item.latestPrice" class="price-row">
              <span>네이버 종가 {{ formatPrice(item.latestPrice) }}</span>
              <strong :class="changeClass(item.changeRate)">
                {{ item.changeRate.toFixed(2) }}%
              </strong>
              <a :href="item.naverUrl" target="_blank" rel="noreferrer">네이버</a>
            </div>
            <p class="risk">{{ item.riskNote }}</p>
          </div>
        </article>
      </template>

      <div v-else class="loading-state">표시할 추천 종목이 없습니다.</div>
    </section>

    <footer>
      이 화면은 투자 판단을 대신하지 않는 리서치용 예시입니다. 실제 매수 전 최신 가격, 공시, 재무정보를 확인하세요.
    </footer>
  </main>
</template>
