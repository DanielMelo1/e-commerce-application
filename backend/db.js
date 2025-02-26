const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
  ssl: process.env.DB_SSL === "true" ? { rejectUnauthorized: false } : false
});

// Testar conexão inicial ao banco de dados
const testConnection = async () => {
  try {
    const client = await pool.connect();
    console.log('✅ Conectado ao banco de dados PostgreSQL com sucesso!');
    client.release();
  } catch (err) {
    console.error('❌ Erro ao conectar ao banco de dados:', err.message);
    process.exit(1); // Sai do processo caso não consiga conectar
  }
};

// Executar teste de conexão
testConnection();

module.exports = pool;

