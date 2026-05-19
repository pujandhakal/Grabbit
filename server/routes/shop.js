const express = require("express");
const CustomerRequest = require("../models/customer_request");
const ShopProfile = require("../models/shop_profile");
const ShopResponse = require("../models/shop_response");
const { auth, requireRole } = require("../middleware/auth");

const shopRouter = express.Router();

function initialsFor(name) {
  return (
    name
      .split(" ")
      .filter(Boolean)
      .slice(0, 2)
      .map((part) => part[0].toUpperCase())
      .join("") || "SH"
  );
}

function formatAgo(date) {
  const diffMs = Date.now() - new Date(date).getTime();
  const minutes = Math.max(1, Math.floor(diffMs / 60000));
  if (minutes < 60) return `${minutes} min${minutes === 1 ? "" : "s"} ago`;
  const hours = Math.floor(minutes / 60);
  if (hours < 24) return `${hours} hour${hours === 1 ? "" : "s"} ago`;
  const days = Math.floor(hours / 24);
  return `${days} day${days === 1 ? "" : "s"} ago`;
}

function budgetText(request) {
  if (request.budgetMin != null && request.budgetMax != null) {
    return `Rs. ${request.budgetMin}-${request.budgetMax}`;
  }
  if (request.budgetMin != null) return `From Rs. ${request.budgetMin}`;
  if (request.budgetMax != null) return `Up to Rs. ${request.budgetMax}`;
  return "Budget open";
}

function shopRequestDto(request, response) {
  return {
    id: request._id.toString(),
    title: request.title,
    subtitle: request.description || `${request.category} request`,
    description: request.description || "",
    category: request.category,
    budget: budgetText(request),
    age: formatAgo(request.createdAt),
    distance: request.locationText,
    customerName: "Customer",
    isNew: true,
    isUrgent: request.urgency === "need_soon",
    hasResponded: Boolean(response),
    responsePrice: response?.price || "",
    responseMessage: response?.message || "",
    respondedAgo: response ? formatAgo(response.updatedAt || response.createdAt) : "",
  };
}

function isProfileComplete(profile) {
  return Boolean(
    profile.businessName &&
      profile.phone &&
      profile.addressText &&
      profile.landmark &&
      profile.description &&
      profile.openStatus &&
      profile.closingTime &&
      profile.typicalResponseTime &&
      profile.categories?.length > 0 &&
      profile.specialties?.length > 0
  );
}

function normalizeCoord(value) {
  if (value === null || value === undefined || value === "") return null;
  const num = Number(value);
  return Number.isFinite(num) ? num : null;
}

function profileUpdateFromBody(reqBody) {
  const {
    businessName = "My Shop",
    categories = [],
    addressText = "Kathmandu",
    phone = "",
    description = "",
    specialties = [],
    openStatus = "",
    closingTime = "",
    typicalResponseTime = "",
    landmark = "",
    latitude,
    longitude,
  } = reqBody;

  const profile = {
    businessName,
    initials: initialsFor(businessName),
    categories,
    addressText,
    phone,
    description,
    specialties,
    openStatus,
    closingTime,
    typicalResponseTime,
    landmark,
    latitude: normalizeCoord(latitude),
    longitude: normalizeCoord(longitude),
  };
  const complete = isProfileComplete(profile);

  return {
    ...profile,
    isVerified: complete,
    verifiedAt: complete ? new Date() : undefined,
  };
}

function publicShopDetails(profile) {
  return {
    id: profile._id.toString(),
    name: profile.businessName,
    rating: String(profile.rating || 4.8),
    reviewCount: `${profile.reviewCount || 0} reviews`,
    distance: "Nearby",
    openStatus: profile.openStatus || "Hours unavailable",
    closingTime: profile.closingTime || "",
    description: profile.description,
    specialties: profile.specialties || [],
    reviews: [],
    activities: [],
    typicalResponseTime: profile.typicalResponseTime || "Not available",
    address: profile.addressText,
    landmark: profile.landmark,
    phone: profile.phone,
    isVerified: profile.isVerified,
    latitude: profile.latitude,
    longitude: profile.longitude,
  };
}

shopRouter.get(
  "/api/shop/profile",
  auth,
  requireRole("shop"),
  async (req, res) => {
    try {
      const profile = await ShopProfile.findOneAndUpdate(
        { userId: req.user.userId },
        {
          $setOnInsert: {
            userId: req.user.userId,
            businessName: "My Shop",
            initials: "MS",
            categories: [],
          },
        },
        { new: true, upsert: true }
      );

      return res.json({ profile });
    } catch (error) {
      return res.status(500).json({ err: error.message });
    }
  }
);

shopRouter.put(
  "/api/shop/profile",
  auth,
  requireRole("shop"),
  async (req, res) => {
    try {
      const update = profileUpdateFromBody(req.body);

      const profile = await ShopProfile.findOneAndUpdate(
        { userId: req.user.userId },
        {
          userId: req.user.userId,
          ...update,
        },
        { new: true, upsert: true }
      );

      return res.json({ profile });
    } catch (error) {
      return res.status(500).json({ err: error.message });
    }
  }
);

shopRouter.get(
  "/api/shop/requests",
  auth,
  requireRole("shop"),
  async (req, res) => {
    try {
      const profile = await ShopProfile.findOne({ userId: req.user.userId });
      const categories = profile?.categories || [];

      if (categories.length === 0) {
        return res.json({ requests: [] });
      }

      const requests = await CustomerRequest.find({
        category: { $in: categories },
        status: { $in: ["active", "pending"] },
      })
        .sort({ createdAt: -1 })
        .limit(50);

      const requestIds = requests.map((request) => request._id);
      const responses = await ShopResponse.find({
        requestId: { $in: requestIds },
        shopUserId: req.user.userId,
      });
      const responsesByRequestId = new Map(
        responses.map((response) => [response.requestId.toString(), response])
      );

      return res.json({
        requests: requests.map((request) =>
          shopRequestDto(request, responsesByRequestId.get(request._id.toString()))
        ),
      });
    } catch (error) {
      return res.status(500).json({ err: error.message });
    }
  }
);

shopRouter.get("/api/shops/:shopId", async (req, res) => {
  try {
    const profile = await ShopProfile.findById(req.params.shopId);

    if (!profile || !profile.isVerified) {
      return res
        .status(404)
        .json({ msg: "Store details are not available yet." });
    }

    return res.json({ shop: publicShopDetails(profile) });
  } catch (error) {
    return res.status(500).json({ err: error.message });
  }
});

module.exports = shopRouter;
