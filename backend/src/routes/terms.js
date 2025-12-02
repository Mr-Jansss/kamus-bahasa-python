// src/routes/terms.js
import express from 'express';
import pool from '../db.js';
import { authenticate, isAdmin } from '../middleware/auth.js';

const router = express.Router();

/**
 * GET /api/terms
 * Query: ?q=search
 */
router.get('/', async (req, res, next) => {
  try {
    const q = (req.query.q || '').trim();
    if (q) {
      const [rows] = await pool.query(
        "SELECT id, term, definition, example FROM terms WHERE term LIKE ? OR definition LIKE ?",
        [`%${q}%`, `%${q}%`]
      );
      return res.json(rows);
    } else {
      const [rows] = await pool.query('SELECT id, term, definition, example FROM terms ORDER BY term ASC');
      return res.json(rows);
    }
  } catch (err) {
    next(err);
  }
});

/**
 * POST /api/terms  (admin only)
 * body: { term OR title, definition OR description, example }
 */
router.post('/', authenticate, isAdmin, async (req, res, next) => {
  try {
    const body = req.body;
    const term = body.term || body.title;
    const definition = body.definition || body.description || '';
    const example = body.example || '';

    if (!term || term.trim() === '') return res.status(400).json({ error: 'term/title required' });

    const [result] = await pool.query('INSERT INTO terms (term, definition, example) VALUES (?, ?, ?)', [term, definition, example]);
    const insertedId = result.insertId;
    const [rows] = await pool.query('SELECT id, term, definition, example FROM terms WHERE id = ?', [insertedId]);
    return res.status(201).json(rows[0]);
  } catch (err) {
    next(err);
  }
});

/**
 * PUT /api/terms/:id (admin only)
 */
router.put('/:id', authenticate, isAdmin, async (req, res, next) => {
  try {
    const id = req.params.id;
    const body = req.body;
    const term = body.term || body.title;
    const definition = body.definition || body.description;
    const example = body.example;

    if (!term || term.trim() === '') return res.status(400).json({ error: 'term/title required' });

    await pool.query('UPDATE terms SET term = ?, definition = ?, example = ? WHERE id = ?', [term, definition || '', example || '', id]);
    const [rows] = await pool.query('SELECT id, term, definition, example FROM terms WHERE id = ?', [id]);
    if (rows.length === 0) return res.status(404).json({ error: 'term not found' });
    return res.json(rows[0]);
  } catch (err) {
    next(err);
  }
});

/**
 * DELETE /api/terms/:id (admin only)
 */
router.delete('/:id', authenticate, isAdmin, async (req, res, next) => {
  try {
    const id = req.params.id;
    const [result] = await pool.query('DELETE FROM terms WHERE id = ?', [id]);
    if (result.affectedRows === 0) return res.status(404).json({ error: 'term not found' });
    return res.json({ message: 'deleted' });
  } catch (err) {
    next(err);
  }
});

export default router;
