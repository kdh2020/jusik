# Stock Pick App

Node.js backend, Vue.js frontend, and MySQL schema for a stock recommendation web app covering:

- Korea KOSPI
- Japan Nikkei 225
- US S&P 500

The app displays daily and weekly reference recommendations. It is designed as a research dashboard, not financial advice.

## Structure

```text
backend/    Express API with MySQL support and sample-data fallback
frontend/   Vue 3 web app powered by Vite
database/   MySQL schema and seed data
```

## Run Locally

```powershell
copy .env.example .env
npm.cmd run install:all
npm.cmd run dev:backend
npm.cmd run dev:frontend
```

Backend: http://localhost:4000/api

Frontend: http://localhost:5173

## MySQL Setup

Create the database and seed it:

```powershell
mysql -u root -p < database/schema.sql
mysql -u root -p stock_recommendations < database/seed.sql
```

Then update `.env` with your MySQL credentials. If MySQL is not available, the backend serves built-in sample data so the frontend can still be previewed.

## API

- `GET /api/health`
- `GET /api/indices`
- `GET /api/recommendations?market=KOSPI&period=daily`

Allowed `market` values are `KOSPI`, `NIKKEI225`, and `SP500`.
Allowed `period` values are `daily` and `weekly`.
