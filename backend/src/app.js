import cors from 'cors';
import express from 'express';
import apiRouter from './routes/api.js';

export function createApp() {
  const app = express();

  app.use(cors({
    origin: process.env.FRONTEND_ORIGIN || 'http://localhost:5173'
  }));
  app.use(express.json());

  app.use('/api', apiRouter);

  app.use((error, _req, res, _next) => {
    if (error.name === 'ZodError') {
      return res.status(400).json({
        message: 'Invalid request parameters',
        issues: error.issues
      });
    }

    console.error(error);
    return res.status(500).json({ message: 'Internal server error' });
  });

  return app;
}
