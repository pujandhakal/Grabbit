const mongoose = require("mongoose");

const customerRequestSchema = mongoose.Schema(
  {
    customerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    title: {
      type: String,
      required: true,
      trim: true,
    },
    description: {
      type: String,
      trim: true,
      default: "",
    },
    category: {
      type: String,
      required: true,
      trim: true,
    },
    quantity: {
      type: String,
      trim: true,
      default: "",
    },
    urgency: {
      type: String,
      enum: ["need_soon", "this_week", "flexible"],
      default: "need_soon",
    },
    locationText: {
      type: String,
      trim: true,
      default: "Kathmandu, New Baneshwor",
    },
    latitude: {
      type: Number,
      default: null,
    },
    longitude: {
      type: Number,
      default: null,
    },
    budgetMin: {
      type: Number,
    },
    budgetMax: {
      type: Number,
    },
    status: {
      type: String,
      enum: ["active", "pending", "completed"],
      default: "active",
    },
    responseCount: {
      type: Number,
      default: 0,
    },
    purchasedShopUserId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      default: null,
    },
    deletedAt: {
      type: Date,
      default: null,
    },
  },
  { timestamps: true }
);

const CustomerRequest = mongoose.model(
  "CustomerRequest",
  customerRequestSchema
);

module.exports = CustomerRequest;
