export default function handler(_req, res) {
  res.status(200).json({
    status: 'ok',
    database: process.env.MYSQL_HOST ? 'configured' : 'not-configured',
    runtime: 'vercel-serverless',
    timestamp: new Date().toISOString()
  });
}
