#!/bin/bash

# Criar a estrutura de diretórios
mkdir -p ecommerce/{controllers,models,routes,views,tests}

# Criar o arquivo principal da aplicação
cat > ecommerce/app.js <<EOL
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
  console.log(\`Server running on port \${PORT}\`);
});

module.exports = app;
EOL

# Criar o arquivo de configuração do banco de dados
cat > ecommerce/config.js <<EOL
module.exports = {
  user: 'yourusername',
  host: 'localhost',
  database: 'ecommerce',
  password: 'yourpassword',
  port: 5432,
};
EOL

# Criar um controlador de exemplo
cat > ecommerce/controllers/userController.js <<EOL
const getAllUsers = async (req, res) => {
  try {
    const result = await req.app.locals.pool.query('SELECT * FROM users');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).send('Internal Server Error');
  }
};

module.exports = { getAllUsers };
EOL

# Criar um modelo de exemplo
cat > ecommerce/models/userModel.js <<EOL
// Modelos não serão usados diretamente, pois não estamos usando ORM
EOL

# Criar uma rota de exemplo
cat > ecommerce/routes/userRoutes.js <<EOL
const express = require('express');
const { getAllUsers } = require('../controllers/userController');

const router = express.Router();

router.get('/', getAllUsers);

module.exports = router;
EOL

# Criar uma visualização de exemplo (usaremos apenas JSON aqui)
cat > ecommerce/views/index.ejs <<EOL
<!-- Empty, ejs not used in this example -->
EOL

# Criar o arquivo SQL para modelagem do banco de dados
cat > ecommerce/schema.sql <<EOL
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL
);
EOL

# Criar um teste unitário de exemplo
cat > ecommerce/tests/userController.test.js <<EOL
const chai = require('chai');
const chaiHttp = require('chai-http');
const app = require('../app');
const { Pool } = require('pg');

chai.use(chaiHttp);
const { expect } = chai;

describe('User API', () => {
  before(async () => {
    // Configurar o banco de dados antes dos testes
    const pool = new Pool({
      user: 'yourusername',
      host: 'localhost',
      database: 'ecommerce_test',
      password: 'yourpassword',
      port: 5432,
    });
    app.locals.pool = pool;

    // Criar tabela para os testes
    await pool.query('CREATE TABLE IF NOT EXISTS users (id SERIAL PRIMARY KEY, username VARCHAR(50), email VARCHAR(100), password VARCHAR(255))');
  });

  after(async () => {
    // Limpar e fechar o banco de dados após os testes
    const pool = app.locals.pool;
    await pool.query('DROP TABLE IF EXISTS users');
    await pool.end();
  });

  it('should get all users', (done) => {
    chai.request(app)
      .get('/users')
      .end((err, res) => {
        expect(res).to.have.status(200);
        expect(res.body).to.be.an('array');
        done();
      });
  });
});
EOL

# Instalar dependências
cd ecommerce
npm init -y
npm install express pg mocha chai chai-http --save
npm install --save-dev
EOL

# Tornar o script executável
chmod +x setup.sh
