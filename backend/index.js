const express = require('express');
const cors = require('cors');
const pool = require('./db'); // Importa a conexão com o banco
require('dotenv').config();

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Log de conexão ao iniciar o servidor
async function checkDatabaseConnection() {
    try {
        const result = await pool.query('SELECT NOW()');
        console.log('✅ Conexão com o banco de dados estabelecida!');
        console.log('📍 Database timestamp:', result.rows[0].now);
    } catch (err) {
        console.error('❌ Erro ao conectar ao banco de dados:', err.message);
        process.exit(1); // Encerra o servidor se a conexão falhar
    }
}

// Iniciar o teste de conexão antes do servidor rodar
checkDatabaseConnection();

// Rota de teste
app.get('/', (req, res) => {
    res.json({ message: 'API funcionando!' });
});

// Rota para testar conexão com o banco
app.get('/test-db', async (req, res) => {
    try {
        const result = await pool.query('SELECT NOW()');
        res.json({
            success: true,
            message: 'Conexão com o banco estabelecida!',
            timestamp: result.rows[0].now,
            database: {
                host: process.env.DB_HOST,
                database: process.env.DB_NAME,
                port: process.env.DB_PORT
            }
        });
    } catch (err) {
        console.error('Erro no teste de conexão:', err);
        res.status(500).json({
            success: false,
            error: err.message,
            database: {
                host: process.env.DB_HOST,
                database: process.env.DB_NAME,
                port: process.env.DB_PORT
            }
        });
    }
});

// Rota para listar produtos
app.get('/api/products', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM products');
        res.json(result.rows);
    } catch (err) {
        console.error('Erro ao buscar produtos:', err);
        res.status(500).json({ error: 'Erro ao buscar produtos' });
    }
});

// Rota para criar pedido (com transação)
app.post('/api/orders', async (req, res) => {
    const client = await pool.connect(); // Inicia a conexão com o banco
    try {
        const { cliente, items, total } = req.body;

        // Iniciar transação
        await client.query('BEGIN');

        // Inserir cliente
        const clienteResult = await client.query(
            'INSERT INTO customers (nome, email, endereco, cidade, estado, cep) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id',
            [cliente.nome, cliente.email, cliente.endereco, cliente.cidade, cliente.estado, cliente.cep]
        );

        // Inserir pedido
        const pedidoResult = await client.query(
            'INSERT INTO orders (customer_id, total) VALUES ($1, $2) RETURNING id',
            [clienteResult.rows[0].id, total]
        );

        // Confirma a transação
        await client.query('COMMIT');

        res.json({
            message: 'Pedido criado com sucesso',
            orderId: pedidoResult.rows[0].id
        });
    } catch (err) {
        await client.query('ROLLBACK'); // Reverte a transação se houver erro
        console.error('Erro ao criar pedido:', err);
        res.status(500).json({ error: 'Erro ao criar pedido' });
    } finally {
        client.release(); // Libera a conexão com o banco
    }
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 Servidor rodando na porta ${PORT} e acessível externamente!`);
});
