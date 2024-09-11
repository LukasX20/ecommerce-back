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
