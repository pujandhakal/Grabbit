const mongoose = require("mongoose");

const chatThreadSchema = mongoose.Schema(
  {
    customerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    shopUserId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    requestId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "CustomerRequest",
      required: true,
    },
    lastMessageAt: {
      type: Date,
      default: null,
    },
    lastReadByCustomerAt: {
      type: Date,
      default: null,
    },
    lastReadByShopAt: {
      type: Date,
      default: null,
    },
  },
  { timestamps: true }
);

chatThreadSchema.index(
  { customerId: 1, shopUserId: 1, requestId: 1 },
  { unique: true }
);

const ChatThread = mongoose.model("ChatThread", chatThreadSchema);

module.exports = ChatThread;
