const express = require("express");
const User = require("../models/user");
const ShopProfile = require("../models/shop_profile");
const CustomerRequest = require("../models/customer_request");
const ShopResponse = require("../models/shop_response");
const ShopReview = require("../models/shop_review");
const ChatThread = require("../models/chat_thread");
const Message = require("../models/message");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { JWT_SECRET, auth } = require("../middleware/auth");

const authRouter = express.Router();

function formatAgo(date) {
    const diffMs = Date.now() - new Date(date).getTime();
    const minutes = Math.max(1, Math.floor(diffMs / 60000));
    if (minutes < 60) return `${minutes} min${minutes === 1 ? "" : "s"} ago`;
    const hours = Math.floor(minutes / 60);
    if (hours < 24) return `${hours} hour${hours === 1 ? "" : "s"} ago`;
    const days = Math.floor(hours / 24);
    return `${days} day${days === 1 ? "" : "s"} ago`;
}

function formatMemberSince(date) {
    return new Intl.DateTimeFormat("en", {
        month: "short",
        year: "numeric",
    }).format(new Date(date));
}

function initialsFor(name) {
    return (
        name
            .split(" ")
            .filter(Boolean)
            .slice(0, 2)
            .map((part) => part[0].toUpperCase())
            .join("") || "CU"
    );
}

function createToken(user) {
    return jwt.sign(
        {
            userId: user._id.toString(),
            role: user.type,
        },
        JWT_SECRET,
        { expiresIn: "30d" },
    );
}

function toClientUser(user) {
    return {
        _id: user._id,
        name: user.name,
        email: user.email,
        phone: user.phone || "",
        type: user.type,
    };
}

function addressDto(address) {
    return {
        id: address._id?.toString() || "",
        label: address.label || "Home",
        addressText: address.addressText || "",
        city: address.city || "Kathmandu",
        landmark: address.landmark || "",
        phone: address.phone || "",
        isDefault: Boolean(address.isDefault),
    };
}

function settingsDto(user) {
    const settings = user.notificationSettings || {};
    return {
        requestResponses: settings.requestResponses !== false,
        chatMessages: settings.chatMessages !== false,
        purchaseUpdates: settings.purchaseUpdates !== false,
        promotions: settings.promotions === true,
    };
}

function preferencesDto(user) {
    const preferences = user.preferences || {};
    return {
        categories: preferences.categories || [],
        budgetMin: preferences.budgetMin ?? null,
        budgetMax: preferences.budgetMax ?? null,
        searchRadiusKm: preferences.searchRadiusKm || 5,
    };
}

async function profilePayload(user) {
    const [totalRequests, completedRequests, reviewCount] = await Promise.all([
        CustomerRequest.countDocuments({ customerId: user._id }),
        CustomerRequest.countDocuments({ customerId: user._id, status: "completed" }),
        ShopReview.countDocuments({ customerId: user._id }),
    ]);
    const notificationSettings = settingsDto(user);

    return {
        user: toClientUser(user),
        memberSince: formatMemberSince(user.createdAt || Date.now()),
        stats: {
            totalRequests,
            completedRequests,
            reviewCount,
        },
        addresses: (user.savedAddresses || []).map(addressDto),
        notificationSettings,
        preferences: preferencesDto(user),
        enabledNotificationCount: Object.values(notificationSettings).filter(Boolean).length,
    };
}

function normalizeAddress(body) {
    return {
        label: body.label || "Home",
        addressText: body.addressText || "",
        city: body.city || "Kathmandu",
        landmark: body.landmark || "",
        phone: body.phone || "",
        isDefault: body.isDefault === true,
    };
}

function applyDefaultAddress(user, addressId) {
    if (!user.savedAddresses || user.savedAddresses.length === 0) return;
    const defaultId =
        addressId ||
        user.savedAddresses.find((address) => address.isDefault)?._id?.toString() ||
        user.savedAddresses[0]._id.toString();

    user.savedAddresses.forEach((address) => {
        address.isDefault = address._id.toString() === defaultId;
    });
}

function reviewListDto(review) {
    const profile = review.shopProfileId;
    const request = review.requestId;
    return {
        id: review._id.toString(),
        shopId: profile?._id?.toString() || "",
        shopName: profile?.businessName || "Deleted shop",
        shopInitials: initialsFor(profile?.businessName || "Shop"),
        requestId: request?._id?.toString() || "",
        requestTitle: request?.title || "Purchase",
        rating: review.rating,
        body: review.body || "",
        timeAgo: formatAgo(review.createdAt),
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

async function refreshRequestResponseCounts(requestIds) {
    const uniqueIds = [...new Set(requestIds.map((id) => id.toString()))];
    await Promise.all(
        uniqueIds.map(async (requestId) => {
            const responseCount = await ShopResponse.countDocuments({ requestId });
            await CustomerRequest.findByIdAndUpdate(requestId, { responseCount });
        }),
    );
}

async function deleteThreads(query) {
    const threads = await ChatThread.find(query).select("_id");
    const threadIds = threads.map((thread) => thread._id);
    if (threadIds.length > 0) {
        await Message.deleteMany({ threadId: { $in: threadIds } });
        await ChatThread.deleteMany({ _id: { $in: threadIds } });
    }
}

async function deleteCustomerAccount(userId) {
    const reviews = await ShopReview.find({ customerId: userId }).select("shopProfileId");
    const affectedProfileIds = reviews.map((review) => review.shopProfileId);
    const requests = await CustomerRequest.find({ customerId: userId }).select("_id");
    const requestIds = requests.map((request) => request._id);

    await deleteThreads({ customerId: userId });
    if (requestIds.length > 0) {
        await ShopResponse.deleteMany({ requestId: { $in: requestIds } });
    }
    await ShopReview.deleteMany({ customerId: userId });
    await CustomerRequest.deleteMany({ customerId: userId });
    await User.findByIdAndDelete(userId);

    await Promise.all(
        [...new Set(affectedProfileIds.map((id) => id.toString()))].map(
            recalculateShopRating,
        ),
    );
}

async function deleteShopAccount(userId) {
    const profile = await ShopProfile.findOne({ userId });
    const responses = await ShopResponse.find({ shopUserId: userId }).select("requestId");
    const affectedRequestIds = responses.map((response) => response.requestId);

    await deleteThreads({ shopUserId: userId });
    await ShopResponse.deleteMany({ shopUserId: userId });
    await ShopReview.deleteMany({
        $or: [
            { shopUserId: userId },
            ...(profile ? [{ shopProfileId: profile._id }] : []),
        ],
    });
    await ShopProfile.deleteOne({ userId });
    await CustomerRequest.updateMany(
        { purchasedShopUserId: userId },
        { $set: { purchasedShopUserId: null } },
    );
    await refreshRequestResponseCounts(affectedRequestIds);
    await User.findByIdAndDelete(userId);
}

//Sign up

authRouter.post('/api/signup', async (req, res)=>{
    

    try{
        const {name, email, password, type = 'customer'} = req.body;

        if(!['customer', 'shop'].includes(type)){
            return res.status(400).json({msg: "Invalid account type."});
        }

         const existingUser = await User.findOne({email});

    if(existingUser){
        return res.status(400).json({msg: "User with same email already exists!"});
    }

    const hashedPassword = await bcryptjs.hash(password, 8);

    let user = new User({
        email,
        password: hashedPassword,
        name,
        type,
    })
    user = await user.save();

    if(type === "shop"){
        await ShopProfile.findOneAndUpdate(
            { userId: user._id },
            {
                userId: user._id,
                businessName: name,
                initials: name
                    .split(" ")
                    .filter(Boolean)
                    .slice(0, 2)
                    .map((part) => part[0].toUpperCase())
                    .join("") || "SH",
                categories: [],
            },
            { upsert: true, new: true },
        );
    }

    res.json({user: toClientUser(user), token: createToken(user)});

    } catch(e){
        res.status(500).json({err: e.message})
    }

   
})

authRouter.post('/api/login', async (req, res)=>{
    try{
        const {email, password} = req.body;

        const user = await User.findOne({email});
        if(!user){
            return res.status(400).json({msg: "Invalid email or password."});
        }

        const isMatch = await bcryptjs.compare(password, user.password);
        if(!isMatch){
            return res.status(400).json({msg: "Invalid email or password."});
        }

        res.json({user: toClientUser(user), token: createToken(user)});
    } catch(e){
        res.status(500).json({err: e.message})
    }
})

authRouter.get("/api/account/profile", auth, async (req, res) => {
    try {
        const user = await User.findById(req.user.userId);
        if (!user) {
            return res.status(404).json({ msg: "Account not found." });
        }

        return res.json({ profile: await profilePayload(user) });
    } catch (e) {
        return res.status(500).json({ err: e.message });
    }
});

authRouter.put("/api/account/profile", auth, async (req, res) => {
    try {
        const { name, email, phone = "" } = req.body;
        if (!name || !email) {
            return res.status(400).json({ msg: "Name and email are required." });
        }

        const existing = await User.findOne({
            email,
            _id: { $ne: req.user.userId },
        });
        if (existing) {
            return res.status(400).json({ msg: "Email is already in use." });
        }

        const user = await User.findByIdAndUpdate(
            req.user.userId,
            { name, email, phone },
            { new: true, runValidators: true },
        );
        if (!user) {
            return res.status(404).json({ msg: "Account not found." });
        }

        return res.json({ profile: await profilePayload(user) });
    } catch (e) {
        return res.status(500).json({ err: e.message });
    }
});

authRouter.post("/api/account/addresses", auth, async (req, res) => {
    try {
        const user = await User.findById(req.user.userId);
        if (!user) {
            return res.status(404).json({ msg: "Account not found." });
        }

        const address = normalizeAddress(req.body);
        user.savedAddresses.push(address);
        if (address.isDefault || user.savedAddresses.length === 1) {
            applyDefaultAddress(user, user.savedAddresses[user.savedAddresses.length - 1]._id.toString());
        }
        await user.save();

        return res.status(201).json({ profile: await profilePayload(user) });
    } catch (e) {
        return res.status(500).json({ err: e.message });
    }
});

authRouter.put("/api/account/addresses/:addressId", auth, async (req, res) => {
    try {
        const user = await User.findById(req.user.userId);
        if (!user) {
            return res.status(404).json({ msg: "Account not found." });
        }

        const address = user.savedAddresses.id(req.params.addressId);
        if (!address) {
            return res.status(404).json({ msg: "Address not found." });
        }

        Object.assign(address, normalizeAddress(req.body));
        if (address.isDefault) {
            applyDefaultAddress(user, address._id.toString());
        }
        await user.save();

        return res.json({ profile: await profilePayload(user) });
    } catch (e) {
        return res.status(500).json({ err: e.message });
    }
});

authRouter.delete("/api/account/addresses/:addressId", auth, async (req, res) => {
    try {
        const user = await User.findById(req.user.userId);
        if (!user) {
            return res.status(404).json({ msg: "Account not found." });
        }

        const address = user.savedAddresses.id(req.params.addressId);
        if (!address) {
            return res.status(404).json({ msg: "Address not found." });
        }

        const wasDefault = address.isDefault;
        address.deleteOne();
        if (wasDefault) {
            applyDefaultAddress(user);
        }
        await user.save();

        return res.json({ profile: await profilePayload(user) });
    } catch (e) {
        return res.status(500).json({ err: e.message });
    }
});

authRouter.put("/api/account/settings", auth, async (req, res) => {
    try {
        const {
            notificationSettings = {},
            preferences = {},
        } = req.body;

        const user = await User.findById(req.user.userId);
        if (!user) {
            return res.status(404).json({ msg: "Account not found." });
        }

        user.notificationSettings = {
            requestResponses: notificationSettings.requestResponses !== false,
            chatMessages: notificationSettings.chatMessages !== false,
            purchaseUpdates: notificationSettings.purchaseUpdates !== false,
            promotions: notificationSettings.promotions === true,
        };
        user.preferences = {
            categories: Array.isArray(preferences.categories)
                ? preferences.categories
                : [],
            budgetMin:
                preferences.budgetMin === null || preferences.budgetMin === ""
                    ? null
                    : Number(preferences.budgetMin),
            budgetMax:
                preferences.budgetMax === null || preferences.budgetMax === ""
                    ? null
                    : Number(preferences.budgetMax),
            searchRadiusKm: Number(preferences.searchRadiusKm || 5),
        };
        await user.save();

        return res.json({ profile: await profilePayload(user) });
    } catch (e) {
        return res.status(500).json({ err: e.message });
    }
});

authRouter.get("/api/account/reviews", auth, async (req, res) => {
    try {
        const reviews = await ShopReview.find({ customerId: req.user.userId })
            .populate("shopProfileId")
            .populate("requestId")
            .sort({ createdAt: -1 });

        return res.json({ reviews: reviews.map(reviewListDto) });
    } catch (e) {
        return res.status(500).json({ err: e.message });
    }
});

authRouter.delete("/api/account", auth, async (req, res) => {
    try {
        const { password, confirmation } = req.body;

        if (!password || confirmation !== "DELETE") {
            return res
                .status(400)
                .json({ msg: "Password and DELETE confirmation are required." });
        }

        const user = await User.findById(req.user.userId);
        if (!user) {
            return res.status(404).json({ msg: "Account not found." });
        }

        const isMatch = await bcryptjs.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ msg: "Invalid password." });
        }

        if (user.type === "shop") {
            await deleteShopAccount(user._id);
        } else {
            await deleteCustomerAccount(user._id);
        }

        return res.json({ msg: "Account deleted." });
    } catch (e) {
        return res.status(500).json({ err: e.message });
    }
});

module.exports = authRouter;
