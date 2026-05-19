const mongoose = require("mongoose");

const shopResponseSchema = mongoose.Schema(
  {
    requestId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "CustomerRequest",
      required: true,
    },
    shopUserId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    shopProfileId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "ShopProfile",
      required: true,
    },
    price: {
      type: String,
      required: true,
      trim: true,
    },
    message: {
      type: String,
      required: true,
      trim: true,
    },
  },
  { timestamps: true }
);

shopResponseSchema.index({ requestId: 1, shopUserId: 1 }, { unique: true });

const ShopResponse = mongoose.model("ShopResponse", shopResponseSchema);

module.exports = ShopResponse;
