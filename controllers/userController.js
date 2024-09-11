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
