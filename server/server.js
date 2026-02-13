const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const sqlite3 = require("sqlite3").verbose();
const bcrypt = require("bcrypt");

const app = express();
app.use(cors());
app.use(bodyParser.json());

const SALT_ROUNDS = 10;

const jwt = require("jsonwebtoken");

const JWT_SECRET = process.env.JWT_SECRET || "dev-secret-change-me";;

// Open DB
const db = new sqlite3.Database("./data.db");

// Create tables
db.serialize(() => {
  db.run(`
    CREATE TABLE IF NOT EXISTS users (
      username TEXT PRIMARY KEY,
      password_hash TEXT,
      role TEXT
    )
  `);

  db.run(`
    CREATE TABLE IF NOT EXISTS stats (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      student TEXT,
      created_at TEXT,
      stats_json TEXT
    )
  `);
});

// once the admin has been created this must be deleted
async function createAdmin() {
  const hash = await bcrypt.hash("123456", SALT_ROUNDS);

  db.run(
    "INSERT OR IGNORE INTO users (username, password_hash, role) VALUES (?, ?, ?)",
    ["admin", hash, "admin"]
  );
}

createAdmin();

// -----------------------------
// CREATE TEACHER
// -----------------------------
app.post(
  "/create-teacher",
  requireAuth,
  requireAdmin,
  async (req, res) => {
    const { username, password } = req.body;

    if (!username || !password) {
      return res.status(400).json({ success: false });
    }

    const hash = await bcrypt.hash(password, SALT_ROUNDS);

    db.run(
      "INSERT INTO users (username, password_hash, role) VALUES (?, ?, ?)",
      [username, hash, "teacher"],
      err => {
        if (err) {
          res.json({ success: false, error: "User exists" });
        } else {
          res.json({ success: true });
        }
      }
    );
  }
);

// -----------------------------
// Login
// -----------------------------
app.post("/login", (req, res) => {
  const { username, password } = req.body;

  db.get(
    "SELECT password_hash, role FROM users WHERE username = ?",
    [username],
    async (err, row) => {
      if (err || !row) {
        console.log("Error", req.body);
        return res.json({ success: false });
      }

      const match = await bcrypt.compare(password, row.password_hash);

      if (!match) {
        console.log("no match", req.body);
        return res.json({ success: false });
      }

      const token = jwt.sign(
        { username, role: row.role },
        JWT_SECRET,
        { expiresIn: "1h" }
      );
      console.log("Success "+ row.role, req.body);
      res.json({
        success: true,
        token,
        role: row.role
      });

    }
  );
});

// auth middleware
function requireAuth(req, res, next) {
  const authHeader = req.headers.authorization;
  if (!authHeader) return res.sendStatus(401);

  const token = authHeader.split(" ")[1];

  try {
    req.user = jwt.verify(token, JWT_SECRET) ;
    next();
  } catch {
    res.sendStatus(401);
  }
}

// admin auth middleware
function requireAdmin(req, res, next) {
  if (req.user.role !== "admin") {
    return res.sendStatus(403);
  }
  next();
}

// -----------------------------
// Save student statistics
// -----------------------------
app.post("/stats", (req, res) => {
  console.log("Incoming stats:", req.body);
  const { student, stats } = req.body;

  if (!student || !stats) {
    res.status(400).json({ success: false });
    return;
  }

  const stats_json = JSON.stringify(stats);
  const created_at = new Date().toISOString();

  db.run(
    "INSERT INTO stats (student, created_at, stats_json) VALUES (?, ?, ?)",
    [student, created_at, stats_json],
    err => {
      if (err) {
        res.status(500).json({ success: false });
      } else {
        res.json({ success: true });
      }
    }
  );
});

// -----------------------------
// GET ALL STATS (teacher)
// -----------------------------
app.get("/stats", requireAuth, (req, res) => {
  if (!["teacher", "admin"].includes(req.user.role)) {
    return res.sendStatus(403);
  }

  db.all(
    "SELECT id, student, created_at, stats_json FROM stats ORDER BY id DESC",
    [],
    (err, rows) => {
      if (err) return res.sendStatus(500);

      const parsed = rows.map(row => ({
        id: row.id,
        student: row.student,
        created_at: row.created_at,
        stats: JSON.parse(row.stats_json)
      }));

      res.json(parsed);
    }
  );
});

const path = require("path");

// Admin login page
app.get("/admin-login", (req, res) => {
  res.sendFile(path.join(__dirname, "admin-login.html"));
});

// Teacher creation page (admin only)
app.get("/teacher-creation", (req, res) => {
  res.sendFile(path.join(__dirname, "teacher-creation.html"));
});

app.listen(3000, () => {
  console.log("Server running on port 3000");
});

app.get("/", (req, res) => {
  res.redirect("/admin-login");
});

