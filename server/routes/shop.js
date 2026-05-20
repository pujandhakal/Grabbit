const express = require("express");
const CustomerRequest = require("../models/customer_request");
const ShopProfile = require("../models/shop_profile");
const ShopReview = require("../models/shop_review");
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

function reviewDto(review) {
  const customer = review.customerId;
  const name = customer?.name || "Customer";
  return {
    id: review._id.toString(),
    initials: initialsFor(name),
    name,
    rating: review.rating,
    timeAgo: formatAgo(review.createdAt),
    body: review.body || "",
  };
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
    customerId: request.customerId?.toString() || "",
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
    status: request.status,
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
  const hasReviews = (profile.reviewCount || 0) > 0;
  return {
    id: profile._id.toString(),
    name: profile.businessName,
    rating: hasReviews ? Number(profile.rating || 0).toFixed(1) : "No ratings yet",
    reviewCount: `${profile.reviewCount || 0} reviews`,
    distance: "Nearby",
    openStatus: profile.openStatus || "Hours unavailable",
    closingTime: profile.closingTime || "",
    description: profile.description,
    specialties: profile.specialties || [],
    reviews: profile.reviews || [],
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

async function recalculateShopRating(profileId) {
  const reviews = await ShopReview.find({ shopProfileId: profileId });
  const reviewCount = reviews.length;
  const rating =
    reviewCount === 0
      ? 0
      : reviews.reduce((sum, review) => sum + review.rating, 0) / reviewCount;

  await ShopProfile.findByIdAndUpdate(profileId, {
    rating,
    reviewCount,
  });
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

      const ownResponses = await ShopResponse.find({
        shopUserId: req.user.userId,
      })
        .sort({ updatedAt: -1 })
        .limit(50);
      const ownResponseRequestIds = ownResponses.map(
        (response) => response.requestId
      );

      const visibilityFilters = [];
      if (categories.length > 0) {
        visibilityFilters.push({
          category: { $in: categories },
          status: { $in: ["active", "pending"] },
        });
      }
      if (ownResponseRequestIds.length > 0) {
        visibilityFilters.push({ _id: { $in: ownResponseRequestIds } });
      }

      if (visibilityFilters.length === 0) {
        return res.json({ requests: [] });
      }

      const requests = await CustomerRequest.find({
        deletedAt: null,
        $or: visibilityFilters,
      })
        .sort({ createdAt: -1 })
        .limit(50);

      const requestIds = requests.map((request) => request._id);
      const responses = ownResponses.filter((response) =>
        requestIds.some((requestId) => requestId.equals(response.requestId))
      );
      const missingResponses = await ShopResponse.find({
        requestId: { $in: requestIds },
        shopUserId: req.user.userId,
      });
      const responsesByRequestId = new Map(
        [...responses, ...missingResponses].map((response) => [
          response.requestId.toString(),
          response,
        ])
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

    const reviews = await ShopReview.find({ shopProfileId: profile._id })
      .populate("customerId")
      .sort({ createdAt: -1 })
      .limit(10);

    return res.json({
      shop: publicShopDetails({
        ...profile.toObject(),
        _id: profile._id,
        reviews: reviews.map(reviewDto),
      }),
    });
  } catch (error) {
    return res.status(500).json({ err: error.message });
  }
});

shopRouter.post(
  "/api/shops/:shopId/reviews",
  auth,
  requireRole("customer"),
  async (req, res) => {
    try {
      const { requestId, rating, body = "" } = req.body;
      const numericRating = Number(rating);

      if (!requestId || !Number.isInteger(numericRating)) {
        return res.status(400).json({ msg: "Request id and rating are required." });
      }
      if (numericRating < 1 || numericRating > 5) {
        return res.status(400).json({ msg: "Rating must be between 1 and 5." });
      }

      const profile = await ShopProfile.findById(req.params.shopId);
      if (!profile) {
        return res.status(404).json({ msg: "Shop not found." });
      }

      const request = await CustomerRequest.findById(requestId);
      if (!request || request.customerId.toString() !== req.user.userId) {
        return res.status(404).json({ msg: "Request not found." });
      }
      if (
        request.status !== "completed" ||
        request.purchasedShopUserId?.toString() !== profile.userId.toString()
      ) {
        return res
          .status(403)
          .json({ msg: "Rate the shop after marking a purchase complete." });
      }

      const review = await ShopReview.create({
        shopProfileId: profile._id,
        shopUserId: profile.userId,
        customerId: req.user.userId,
        requestId,
        rating: numericRating,
        body,
      });

      await recalculateShopRating(profile._id);
      const populated = await ShopReview.findById(review._id).populate("customerId");
      const updatedProfile = await ShopProfile.findById(profile._id);

      return res.status(201).json({
        review: reviewDto(populated),
        rating: Number(updatedProfile.rating || 0).toFixed(1),
        reviewCount: updatedProfile.reviewCount || 0,
      });
    } catch (error) {
      if (error.code === 11000) {
        return res.status(400).json({ msg: "You already rated this purchase." });
      }
      return res.status(500).json({ err: error.message });
    }
  }
);

module.exports = shopRouter;
