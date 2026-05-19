const express = require("express");
const mongoose = require("mongoose");
const ChatThread = require("../models/chat_thread");
const Message = require("../models/message");
const CustomerRequest = require("../models/customer_request");
const ShopResponse = require("../models/shop_response");
const ShopProfile = require("../models/shop_profile");
const User = require("../models/user");
const { auth } = require("../middleware/auth");

const chatRouter = express.Router();

function messageDto(message, requestId = "") {
  return {
    id: message._id.toString(),
    threadId: message.threadId.toString(),
    requestId,
    senderId: message.senderId.toString(),
    content: message.content,
    sentAt: message.createdAt.toISOString(),
  };
}

function formatAgo(date) {
  if (!date) return "";
  const diffMs = Date.now() - new Date(date).getTime();
  const minutes = Math.max(1, Math.floor(diffMs / 60000));
  if (minutes < 60) return `${minutes} min${minutes === 1 ? "" : "s"} ago`;
  const hours = Math.floor(minutes / 60);
  if (hours < 24) return `${hours} hour${hours === 1 ? "" : "s"} ago`;
  const days = Math.floor(hours / 24);
  return `${days} day${days === 1 ? "" : "s"} ago`;
}

function resolveTuple(currentUser, peerUserId) {
  if (currentUser.role === "customer") {
    return { customerId: currentUser.userId, shopUserId: peerUserId };
  }
  return { customerId: peerUserId, shopUserId: currentUser.userId };
}

async function findOrCreateThread({ customerId, shopUserId, requestId }) {
  const existing = await ChatThread.findOne({
    customerId,
    shopUserId,
    requestId,
  });
  if (existing) return existing;
  try {
    return await ChatThread.create({ customerId, shopUserId, requestId });
  } catch (error) {
    if (error.code === 11000) {
      return ChatThread.findOne({ customerId, shopUserId, requestId });
    }
    throw error;
  }
}

async function resolveAuthorizedChat({ currentUser, peerUserId, requestId }) {
  const request = await CustomerRequest.findById(requestId);
  if (!request) {
    return { status: 404, message: "Request not found." };
  }

  const { customerId, shopUserId } = resolveTuple(currentUser, peerUserId);
  const isCustomer = currentUser.role === "customer";

  if (request.customerId.toString() !== customerId.toString()) {
    return { status: 403, message: "You do not have access to this request." };
  }

  const response = await ShopResponse.findOne({
    requestId,
    shopUserId,
  });

  if (!response) {
    return {
      status: 403,
      message: "Chat is available after the shop responds to this request.",
    };
  }

  if (!isCustomer && shopUserId.toString() !== currentUser.userId) {
    return { status: 403, message: "You do not have access to this chat." };
  }

  return { request, customerId, shopUserId };
}

function readFieldFor(role) {
  return role === "customer" ? "lastReadByCustomerAt" : "lastReadByShopAt";
}

async function threadDto({ thread, currentUser, lastMessage }) {
  const isCustomer = currentUser.role === "customer";
  const peerUserId = isCustomer ? thread.shopUserId : thread.customerId;
  const readAt = thread[readFieldFor(currentUser.role)];
  const unreadQuery = {
    threadId: thread._id,
    senderId: { $ne: currentUser.userId },
  };

  if (readAt) {
    unreadQuery.createdAt = { $gt: readAt };
  }

  const [unreadCount, request, shopProfile, customer] = await Promise.all([
    Message.countDocuments(unreadQuery),
    CustomerRequest.findById(thread.requestId).select("title"),
    isCustomer
      ? ShopProfile.findOne({ userId: thread.shopUserId }).select("businessName")
      : null,
    isCustomer ? null : User.findById(thread.customerId).select("name"),
  ]);

  return {
    threadId: thread._id.toString(),
    peerUserId: peerUserId.toString(),
    peerName: isCustomer
      ? shopProfile?.businessName || "Shop"
      : customer?.name || "Customer",
    requestId: thread.requestId.toString(),
    requestTitle: request?.title || "Request",
    lastMessage: lastMessage?.content || "",
    lastMessageAt: (lastMessage?.createdAt || thread.lastMessageAt || thread.updatedAt)
      .toISOString(),
    timeLabel: formatAgo(lastMessage?.createdAt || thread.lastMessageAt),
    unreadCount,
    isUnread: unreadCount > 0,
  };
}

chatRouter.get("/api/chat/threads", auth, async (req, res) => {
  try {
    const query =
      req.user.role === "customer"
        ? { customerId: req.user.userId }
        : { shopUserId: req.user.userId };

    const threads = await ChatThread.find({
      ...query,
      lastMessageAt: { $ne: null },
    })
      .sort({ lastMessageAt: -1 })
      .limit(50);

    const summaries = await Promise.all(
      threads.map(async (thread) => {
        const lastMessage = await Message.findOne({ threadId: thread._id }).sort({
          createdAt: -1,
        });
        return threadDto({ thread, currentUser: req.user, lastMessage });
      })
    );

    return res.json({ threads: summaries });
  } catch (error) {
    return res.status(500).json({ err: error.message });
  }
});

chatRouter.post("/api/chat/messages", auth, async (req, res) => {
  try {
    const { peerUserId, requestId, content } = req.body;
    if (!peerUserId || !requestId || !content || !content.trim()) {
      return res
        .status(400)
        .json({ msg: "peerUserId, requestId, and content are required." });
    }
    if (
      !mongoose.Types.ObjectId.isValid(peerUserId) ||
      !mongoose.Types.ObjectId.isValid(requestId)
    ) {
      return res.status(400).json({ msg: "Invalid peerUserId or requestId." });
    }

    const authorized = await resolveAuthorizedChat({
      currentUser: req.user,
      peerUserId,
      requestId,
    });
    if (authorized.status) {
      return res.status(authorized.status).json({ msg: authorized.message });
    }

    const { customerId, shopUserId } = authorized;
    const thread = await findOrCreateThread({
      customerId,
      shopUserId,
      requestId,
    });

    const message = await Message.create({
      threadId: thread._id,
      senderId: req.user.userId,
      content: content.trim(),
    });

    thread.lastMessageAt = message.createdAt;
    await thread.save();

    const payload = messageDto(message, requestId);
    const io = req.app.get("io");
    const recipientId =
      req.user.userId === customerId.toString()
        ? shopUserId.toString()
        : customerId.toString();

    io.to(`user:${req.user.userId}`)
      .to(`user:${recipientId}`)
      .emit("message:new", payload);

    return res.status(201).json({ message: payload });
  } catch (error) {
    return res.status(500).json({ err: error.message });
  }
});

chatRouter.get("/api/chat/messages", auth, async (req, res) => {
  try {
    const { peerUserId, requestId } = req.query;
    if (!peerUserId || !requestId) {
      return res
        .status(400)
        .json({ msg: "peerUserId and requestId are required." });
    }
    if (
      !mongoose.Types.ObjectId.isValid(peerUserId) ||
      !mongoose.Types.ObjectId.isValid(requestId)
    ) {
      return res.json({ messages: [] });
    }

    const { customerId, shopUserId } = resolveTuple(req.user, peerUserId);
    const authorized = await resolveAuthorizedChat({
      currentUser: req.user,
      peerUserId,
      requestId,
    });
    if (authorized.status) {
      return res.status(authorized.status).json({ msg: authorized.message });
    }

    const thread = await ChatThread.findOne({
      customerId,
      shopUserId,
      requestId,
    });
    if (!thread) {
      return res.json({ messages: [] });
    }

    const messages = await Message.find({ threadId: thread._id })
      .sort({ createdAt: 1 })
      .limit(200);

    return res.json({
      messages: messages.map((message) => messageDto(message, requestId)),
    });
  } catch (error) {
    return res.status(500).json({ err: error.message });
  }
});

chatRouter.put("/api/chat/read", auth, async (req, res) => {
  try {
    const { peerUserId, requestId } = req.body;
    if (!peerUserId || !requestId) {
      return res
        .status(400)
        .json({ msg: "peerUserId and requestId are required." });
    }
    if (
      !mongoose.Types.ObjectId.isValid(peerUserId) ||
      !mongoose.Types.ObjectId.isValid(requestId)
    ) {
      return res.status(400).json({ msg: "Invalid peerUserId or requestId." });
    }

    const authorized = await resolveAuthorizedChat({
      currentUser: req.user,
      peerUserId,
      requestId,
    });
    if (authorized.status) {
      return res.status(authorized.status).json({ msg: authorized.message });
    }

    const { customerId, shopUserId } = authorized;
    const thread = await ChatThread.findOne({
      customerId,
      shopUserId,
      requestId,
    });

    if (!thread) {
      return res.json({ ok: true });
    }

    thread[readFieldFor(req.user.role)] = new Date();
    await thread.save();

    return res.json({ ok: true });
  } catch (error) {
    return res.status(500).json({ err: error.message });
  }
});

module.exports = chatRouter;
