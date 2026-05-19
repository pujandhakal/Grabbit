const jwt = require("jsonwebtoken");

const JWT_SECRET = process.env.JWT_SECRET || "grabbit-dev-secret";

function auth(req, res, next) {
  try {
    const header = req.header("Authorization") || "";
    const token = header.startsWith("Bearer ") ? header.substring(7) : null;

    if (!token) {
      return res.status(401).json({ msg: "Authentication required." });
    }

    req.user = jwt.verify(token, JWT_SECRET);
    return next();
  } catch (error) {
    return res.status(401).json({ msg: "Invalid or expired token." });
  }
}

function requireRole(role) {
  return (req, res, next) => {
    if (req.user?.role !== role) {
      return res.status(403).json({ msg: "You do not have access." });
    }
    return next();
  };
}

module.exports = {
  auth,
  requireRole,
  JWT_SECRET,
};
