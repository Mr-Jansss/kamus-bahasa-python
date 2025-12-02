// src/routes/favorites.js
import express from 'express';
import pool from '../db.js';
import { authenticate } from '../middleware/auth.js';

const router = express.Router();

/**
 * POST /api/favorites
 * body: { term_id }  (create favorite for logged user)
 */
router.post('/', authenticate, async (req, res, next) => {
  try {
    const userId = req.user.id;
    const termId = req.body.term_id;
    if (!termId) return res.status(400).json({ error: 'term_id required' });

    // prevent duplicate
    const [exists] = await pool.query('SELECT id FROM favorites WHERE user_id = ? AND term_id = ?', [userId, termId]);
    if (exists.length > 0) return res.status(400).json({ error: 'already favorited' });

    const [result] = await pool.query('INSERT INTO favorites (user_id, term_id) VALUES (?, ?)', [userId, termId]);
    const insertedId = result.insertId;
    const [rows] = await pool.query('SELECT f.id, f.user_id, f.term_id, t.term, t.definition, t.example FROM favorites f JOIN terms t ON t.id = f.term_id WHERE f.id = ?', [insertedId]);
    return res.status(201).json(rows[0]);
  } catch (err) {
    next(err);
  }
});

/**
 * POST /api/favorites/list
 * body: {}  (uses user token to return favorites)
 */
router.post('/list', authenticate, async (req, res, next) => {
  try {
    const userId = req.user.id;
    const [rows] = await pool.query('SELECT f.id, f.term_id, t.term, t.definition, t.example FROM favorites f JOIN terms t ON t.id = f.term_id WHERE f.user_id = ?', [userId]);
    return res.json(rows);
  } catch (err) {
    next(err);
  }
});

/**
 * POST /api/favorites/delete
 * body: { id } (favorite id) - user can delete their favorite
 */
router.post('/delete', authenticate, async (req, res, next) => {
  try {
    const userId = req.user.id;
    const favId = req.body.id;
    if (!favId) return res.status(400).json({ error: 'id required' });

    const [rows] = await pool.query('SELECT user_id FROM favorites WHERE id = ?', [favId]);
    if (rows.length === 0) return res.status(404).json({ error: 'favorite not found' });
    if (rows[0].user_id !== userId) return res.status(403).json({ error: 'not allowed' });

    await pool.query('DELETE FROM favorites WHERE id = ?', [favId]);
    return res.json({ message: 'deleted' });
  } catch (err) {
    next(err);
  }
});

export default router;
