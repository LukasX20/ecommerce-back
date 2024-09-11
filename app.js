const express = require('express');
const { Pool } = require('pg');
const userRoutes = require('./routes/userRoutes');

const app = express();
app.use(express.json());

// Configurar o banco de dados
const pool = new Pool({
  user: 'yourusername',
  host: 'localhost',
  database: 'ecommerce',
  password: 'yourpassword',
  port: 5432,
});

// Adicionar a conexão ao pool à aplicação
app.locals.pool = pool;

// Configurar as rotas
app.use('/users', userRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

module.exports = app;
