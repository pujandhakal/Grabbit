const express = require("express");
const mongoose = require("mongoose");
const CustomerRequest = require("../models/customer_request");
const ShopProfile = require("../models/shop_profile");
const ShopResponse = require("../models/shop_response");
const { auth, requireRole } = require("../middleware/auth");

const requestsRouter = express.Router();

function formatAgo(date) {
  const diffMs = Date.now() - new Date(date).getTime();
  const minutes = Math.max(1, Math.floor(diffMs / 60000));
  if (minutes < 60) {
    return `${minutes} min${minutes === 1 ? "" : "s"} ago`;
  }
  const hours = Math.floor(minutes / 60);
  if (hours < 24) {
    return `${hours} hour${hours === 1 ? "" : "s"} ago`;
  }
  const days = Math.floor(hours / 24);
  return `${days} day${days === 1 ? "" : "s"} ago`;
}

function budgetText(request) {
  if (request.budgetMin != null && request.budgetMax != null) {
    return `Rs. ${request.budgetMin}-${request.budgetMax}`;
  }
  if (request.budgetMin != null) {
    return `From Rs. ${request.budgetMin}`;
  }
  if (request.budgetMax != null) {
    return `Up to Rs. ${request.budgetMax}`;
  }
  return "Budget open";
}

function requestSummary(request) {
  const responseCount = request.responseCount || 0;
  return {
    id: request._id.toString(),
    title: request.title,
    subtitle:
      request.description || `${request.category} request near ${request.locationText}`,
    status: request.status,
    time: `Posted ${formatAgo(request.createdAt)}`,
    responseText:
      responseCount === 1
        ? "1 shop responded"
        : `${responseCount} shops responded`,
    category: request.category,
    postedAt: `Posted ${formatAgo(request.createdAt)}`,
    description: request.description || "",
    quantity: request.quantity || "",
    urgency: request.urgency,
    locationText: request.locationText,
    budgetText: budgetText(request),
    customerName: "Customer",
  };
}

function responseDto(response) {
  const profile = response.shopProfileId;
  return {
    id: response._id.toString(),
    shopId:
      profile?._id?.toString() ||
      response.shopProfileId?._id?.toString() ||
      response.shopProfileId?.toString() ||
      response.shopUserId.toString(),
    name: profile?.businessName || "Shop",
    distance: profile?.addressText || "Nearby",
    respondedAgo: `${formatAgo(response.createdAt)}`,
    rating: String(profile?.rating || 4.8),
    reviews: `(${profile?.reviewCount || 0} reviews)`,
    message: response.message,
    price: response.price,
  };
}

requestsRouter.post(
  "/api/requests",
  auth,
  requireRole("customer"),
  async (req, res) => {
    try {
      const {
        title,
        description = "",
        category,
        quantity = "",
        urgency = "need_soon",
        locationText = "Kathmandu, New Baneshwor",
        budgetMin,
        budgetMax,
      } = req.body;

      if (!title || !category) {
        return res.status(400).json({ msg: "Title and category are required." });
      }

      const request = await CustomerRequest.create({
        customerId: req.user.userId,
        title,
        description,
        category,
        quantity,
        urgency,
        locationText,
        budgetMin: budgetMin === "" ? undefined : budgetMin,
        budgetMax: budgetMax === "" ? undefined : budgetMax,
      });

      const payload = requestSummary(request);
      req.app.get("io").to(`category:${category}`).emit("request:created", payload);

      return res.status(201).json({ request: payload });
    } catch (error) {
      return res.status(500).json({ err: error.message });
    }
  }
);

requestsRouter.get(
  "/api/requests/mine",
  auth,
  requireRole("customer"),
  async (req, res) => {
    try {
      const requests = await CustomerRequest.find({ customerId: req.user.userId })
        .sort({ createdAt: -1 })
        .limit(50);

      return res.json({ requests: requests.map(requestSummary) });
    } catch (error) {
      return res.status(500).json({ err: error.message });
    }
  }
);

requestsRouter.get(
  "/api/requests/:requestId/responses",
  auth,
  async (req, res) => {
    try {
      const request = await CustomerRequest.findById(req.params.requestId);
      if (!request) {
        return res.status(404).json({ msg: "Request not found." });
      }

      if (
        req.user.role === "customer" &&
        request.customerId.toString() !== req.user.userId
      ) {
        return res.status(403).json({ msg: "You do not have access." });
      }

      const responses = await ShopResponse.find({ requestId: request._id })
        .populate("shopProfileId")
        .sort({ createdAt: -1 });

      return res.json({
        request: requestSummary(request),
        responses: responses.map(responseDto),
      });
    } catch (error) {
      return res.status(500).json({ err: error.message });
    }
  }
);

requestsRouter.post(
  "/api/requests/:requestId/responses",
  auth,
  requireRole("shop"),
  async (req, res) => {
    try {
      const { price, message } = req.body;
      if (!price || !message) {
        return res.status(400).json({ msg: "Price and message are required." });
      }

      if (!mongoose.Types.ObjectId.isValid(req.params.requestId)) {
        return res.status(404).json({ msg: "Request not found." });
      }

      const request = await CustomerRequest.findById(req.params.requestId);
      if (!request) {
        return res.status(404).json({ msg: "Request not found." });
      }

      const profile = await ShopProfile.findOne({ userId: req.user.userId });
      if (!profile) {
        return res.status(400).json({ msg: "Complete your shop profile first." });
      }

      if (!profile.categories.includes(request.category)) {
        return res.status(403).json({ msg: "This request does not match your shop categories." });
      }

      const response = await ShopResponse.create({
        requestId: request._id,
        shopUserId: req.user.userId,
        shopProfileId: profile._id,
        price,
        message,
      });

      request.responseCount += 1;
      request.status = "active";
      await request.save();

      const populated = await ShopResponse.findById(response._id).populate(
        "shopProfileId"
      );
      const responsePayload = responseDto(populated);
      const requestPayload = requestSummary(request);

      const io = req.app.get("io");
      io.to(`user:${request.customerId.toString()}`).emit("response:created", {
        requestId: request._id.toString(),
        response: responsePayload,
      });
      io.to(`user:${request.customerId.toString()}`).emit(
        "request:updated",
        requestPayload
      );

      return res.status(201).json({ response: responsePayload });
    } catch (error) {
      if (error.code === 11000) {
        return res.status(400).json({ msg: "You already responded to this request." });
      }
      return res.status(500).json({ err: error.message });
    }
  }
);

requestsRouter.put(
  "/api/requests/:requestId/responses/me",
  auth,
  requireRole("shop"),
  async (req, res) => {
    try {
      const { price, message } = req.body;
      if (!price || !message) {
        return res.status(400).json({ msg: "Price and message are required." });
      }

      if (!mongoose.Types.ObjectId.isValid(req.params.requestId)) {
        return res.status(404).json({ msg: "Request not found." });
      }

      const request = await CustomerRequest.findById(req.params.requestId);
      if (!request) {
        return res.status(404).json({ msg: "Request not found." });
      }

      const profile = await ShopProfile.findOne({ userId: req.user.userId });
      if (!profile) {
        return res.status(400).json({ msg: "Complete your shop profile first." });
      }

      if (!profile.categories.includes(request.category)) {
        return res.status(403).json({ msg: "This request does not match your shop categories." });
      }

      const response = await ShopResponse.findOneAndUpdate(
        {
          requestId: request._id,
          shopUserId: req.user.userId,
        },
        {
          price,
          message,
          shopProfileId: profile._id,
        },
        { new: true }
      ).populate("shopProfileId");

      if (!response) {
        return res.status(404).json({ msg: "Respond before editing this request." });
      }

      const responsePayload = responseDto(response);
      const requestPayload = requestSummary(request);
      const io = req.app.get("io");

      io.to(`user:${request.customerId.toString()}`).emit("response:updated", {
        requestId: request._id.toString(),
        response: responsePayload,
      });
      io.to(`user:${request.customerId.toString()}`).emit(
        "request:updated",
        requestPayload
      );

      return res.json({ response: responsePayload });
    } catch (error) {
      return res.status(500).json({ err: error.message });
    }
  }
);

module.exports = requestsRouter;
