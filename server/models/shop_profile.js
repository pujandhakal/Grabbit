const mongoose = require("mongoose");

const shopProfileSchema = mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      unique: true,
    },
    businessName: {
      type: String,
      required: true,
      trim: true,
    },
    initials: {
      type: String,
      required: true,
      trim: true,
      default: "SH",
    },
    categories: {
      type: [String],
      default: [],
    },
    addressText: {
      type: String,
      trim: true,
      default: "Kathmandu",
    },
    phone: {
      type: String,
      trim: true,
      default: "",
    },
    description: {
      type: String,
      trim: true,
      default: "",
    },
    specialties: {
      type: [String],
      default: [],
    },
    openStatus: {
      type: String,
      trim: true,
      default: "",
    },
    closingTime: {
      type: String,
      trim: true,
      default: "",
    },
    typicalResponseTime: {
      type: String,
      trim: true,
      default: "",
    },
    landmark: {
      type: String,
      trim: true,
      default: "",
    },
    latitude: {
      type: Number,
      default: null,
    },
    longitude: {
      type: Number,
      default: null,
    },
    isVerified: {
      type: Boolean,
      default: false,
    },
    verifiedAt: {
      type: Date,
    },
    rating: {
      type: Number,
      default: 4.8,
    },
    reviewCount: {
      type: Number,
      default: 0,
    },
  },
  { timestamps: true }
);

const ShopProfile = mongoose.model("ShopProfile", shopProfileSchema);

module.exports = ShopProfile;
