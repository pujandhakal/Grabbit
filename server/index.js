const cors = require("cors");
const express = require("express");
const http = require("http");
const jwt = require("jsonwebtoken");
const mongoose = require("mongoose");
const { Server } = require("socket.io");

const authRouter = require("./routes/auth");
const requestsRouter = require("./routes/requests");
const shopRouter = require("./routes/shop");
const chatRouter = require("./routes/chat");
const ShopProfile = require("./models/shop_profile");
const { categoriesWithAliases } = require("./utils/request_categories");

const PORT = 3000;
const DB =
  "mongodb+srv://pujan:Grabbit2026@cluster0.jaokfcd.mongodb.net/?appName=Cluster0";
const JWT_SECRET = process.env.JWT_SECRET || "grabbit-dev-secret";

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: "*",
  },
});

app.set("io", io);
app.use(cors());
app.use(express.json());
app.get("/api/health", (req, res) => {
  res.json({ ok: true });
});
app.use(authRouter);
app.use(requestsRouter);
app.use(shopRouter);
app.use(chatRouter);

io.use((socket, next) => {
  try {
    const token = socket.handshake.auth && socket.handshake.auth.token;
    if (!token) {
      return next(new Error("Missing socket token."));
    }

    socket.user = jwt.verify(token, JWT_SECRET);
    return next();
  } catch (error) {
    return next(new Error("Invalid socket token."));
  }
});

io.on("connection", async (socket) => {
  const user = socket.user;
  socket.join(`user:${user.userId}`);

  if (user.role === "shop") {
    const profile = await ShopProfile.findOne({ userId: user.userId });
    for (const category of categoriesWithAliases(profile?.categories || [])) {
      socket.join(`category:${category}`);
    }
  }
});

mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection successful");
  })
  .catch((e) => {
    console.log(e);
  });

server.listen(PORT, "0.0.0.0", () => {
  console.log(`Connected at port ${PORT} hello`);
});
