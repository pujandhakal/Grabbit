const mongoose = require("mongoose");

const shopReviewSchema = mongoose.Schema(
  {
    shopProfileId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "ShopProfile",
      required: true,
    },
    shopUserId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    customerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    requestId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "CustomerRequest",
      required: true,
    },
    rating: {
      type: Number,
      required: true,
      min: 1,
      max: 5,
    },
    body: {
      type: String,
      trim: true,
      default: "",
      maxlength: 1000,
    },
  },
  { timestamps: true }
);

shopReviewSchema.index(
  { customerId: 1, requestId: 1, shopUserId: 1 },
  { unique: true }
);

const ShopReview = mongoose.model("ShopReview", shopReviewSchema);

module.exports = ShopReview;
