-- kamus.sql (idempotent seed)
SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS kamus_python CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE kamus_python;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS favorites;
DROP TABLE IF EXISTS terms;
DROP TABLE IF EXISTS users;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  role ENUM('admin','user') NOT NULL DEFAULT 'user'
);

CREATE TABLE terms (
  id INT AUTO_INCREMENT PRIMARY KEY,
  term VARCHAR(255) NOT NULL,
  definition TEXT,
  example TEXT
);

CREATE TABLE favorites (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  term_id INT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (term_id) REFERENCES terms(id) ON DELETE CASCADE
);

INSERT INTO terms (term, definition, example) VALUES
('List', 'Tipe data berisi kumpulan nilai yang bisa diubah.', '[1, 2, 3]'),
('Tuple', 'Tipe data mirip list tapi tidak bisa diubah.', '(1, 2, 3)'),
('Dictionary', 'Pasangan key:value.', '{"a": 1}');

-- Insert admin if not exists (idempotent). 
-- Use password hash that may already be present on your DB; this INSERT will only run when username 'admin' not present.
INSERT INTO users (username, password, role)
SELECT 'admin', '$2b$10$JW.opeDqNUnMGmhwizCD6eo.BKuhUjfD72VAFdsLJp.F6MdHttk9O', 'admin'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'admin');
