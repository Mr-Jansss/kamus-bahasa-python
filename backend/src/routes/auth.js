// src/routes/auth.js
import express from 'express';
import pool from '../db.js';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';
dotenv.config();

const router = express.Router();

/**
 * Register
 * body: { username, password }
 */
router.post('/register', async (req, res, next) => {
  try {
    const { username, password, role } = req.body;
    if (!username || !password) return res.status(400).json({ error: 'username & password required' });

    const [rows] = await pool.query('SELECT id FROM users WHERE username = ?', [username]);
    if (rows.length > 0) return res.status(400).json({ error: 'username sudah ada' });

    const hash = bcrypt.hashSync(password, 10);
    const userRole = role === 'admin' ? 'admin' : 'user';
    await pool.query('INSERT INTO users (username, password, role) VALUES (?, ?, ?)', [username, hash, userRole]);

    return res.json({ message: 'register berhasil' });
  } catch (err) {
    next(err);
  }
});

/**
 * Login
 * body: { username, password }
 * returns: { token }
 */
router.post('/login', async (req, res, next) => {
  try {
    const { username, password } = req.body;
    if (!username || !password) return res.status(400).json({ error: 'username & password required' });

    const [rows] = await pool.query('SELECT * FROM users WHERE username = ?', [username]);
    if (rows.length === 0) return res.status(401).json({ error: 'invalid credentials' });

    const user = rows[0];
    const match = bcrypt.compareSync(password, user.password);
    if (!match) return res.status(401).json({ error: 'invalid credentials' });

    const payload = { id: user.id, role: user.role };
    const token = jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '12h' });

    return res.json({ token });
  } catch (err) {
    next(err);
  }
});

export default router;
