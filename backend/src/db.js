import mysql from 'mysql2/promise';

let pool;

export function getPool() {
  if (!pool) {
    pool = mysql.createPool({
      host: process.env.MYSQL_HOST || '127.0.0.1',
      port: Number(process.env.MYSQL_PORT || 3306),
      user: process.env.MYSQL_USER || 'stock_app',
      password: process.env.MYSQL_PASSWORD || 'stock_app_password',
      database: process.env.MYSQL_DATABASE || 'stock_recommendations',
      waitForConnections: true,
      connectionLimit: 10,
      namedPlaceholders: true
    });
  }

  return pool;
}

export async function canUseDatabase() {
  try {
    await getPool().query('SELECT 1');
    return true;
  } catch {
    return false;
  }
}
