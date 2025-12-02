// src/index.js
import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import authRoutes from './routes/auth.js';
import termRoutes from './routes/terms.js';
import favRoutes from './routes/favorites.js';

dotenv.config();

const app = express();
app.use(cors()); // dev: allow all origins
app.use(express.json());

// routes
app.use('/api/auth', authRoutes);
app.use('/api/terms', termRoutes);
app.use('/api/favorites', favRoutes);

// basic health
app.get('/api/health', (req, res) => res.json({ status: 'ok' }));

// error handler (centralized)
app.use((err, req, res, next) => {
  console.error(err);
  res.status(err.status || 500).json({ error: err.message || 'Internal Server Error' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Backend berjalan di port ${PORT}`);
});
