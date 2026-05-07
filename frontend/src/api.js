const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || '/api';

async function request(path) {
  const response = await fetch(`${API_BASE_URL}${path}`);

  if (!response.ok) {
    throw new Error(`API request failed: ${response.status}`);
  }

  return response.json();
}

export function fetchIndices() {
  return request('/indices');
}

export function fetchRecommendations(market, period) {
  const params = new URLSearchParams({ market, period });
  return request(`/recommendations?${params.toString()}`);
}
