// src/initAdmin.js
import pool from './db.js';
import bcrypt from 'bcryptjs';
import dotenv from 'dotenv';
dotenv.config();

async function ensureAdmin() {
  try {
    const adminUsername = 'admin';
    const [rows] = await pool.query('SELECT id FROM users WHERE username = ?', [adminUsername]);
    if (rows.length > 0) {
      console.log('Admin user already exists. Skipping creation.');
      process.exit(0);
    }

    const plain = 'admin123';
    const hash = bcrypt.hashSync(plain, 10);
    await pool.query('INSERT INTO users (username, password, role) VALUES (?, ?, ?)', [adminUsername, hash, 'admin']);
    console.log('Admin user created with username "admin" and password "admin123" (please change).');
    process.exit(0);
  } catch (err) {
    console.error('Error creating admin:', err);
    process.exit(1);
  }
}

ensureAdmin();
