const assert = require("node:assert");
const { test, before, after, beforeEach } = require("node:test");
const mongoose = require("mongoose");
const { MongoMemoryReplSet } = require("mongodb-memory-server");

const User = require("../models/user");
const ShopProfile = require("../models/shop_profile");
const CustomerRequest = require("../models/customer_request");
const ShopResponse = require("../models/shop_response");
const ShopReview = require("../models/shop_review");
const ChatThread = require("../models/chat_thread");
const Message = require("../models/message");
const {
    deleteCustomerAccount,
    deleteShopAccount,
    runAccountDeletion,
} = require("../routes/auth");

let replSet;

before(async () => {
    // A replica set is required for transactions, which the cascade uses.
    replSet = await MongoMemoryReplSet.create({ replSet: { count: 1 } });
    await mongoose.connect(replSet.getUri());
});

after(async () => {
    await mongoose.disconnect();
    await replSet.stop();
});

beforeEach(async () => {
    await Promise.all([
        User.deleteMany({}),
        ShopProfile.deleteMany({}),
        CustomerRequest.deleteMany({}),
        ShopResponse.deleteMany({}),
        ShopReview.deleteMany({}),
        ChatThread.deleteMany({}),
        Message.deleteMany({}),
    ]);
});

// Seeds a customer + shop with a full related graph and returns their ids.
async function seedGraph() {
    const customer = await User.create({
        name: "Cust",
        email: "cust@example.com",
        password: "x",
        type: "customer",
        savedAddresses: [{ label: "Home", addressText: "Baneshwor" }],
        notificationSettings: { promotions: true },
    });
    const shopUser = await User.create({
        name: "Shoppe",
        email: "shop@example.com",
        password: "x",
        type: "shop",
    });
    const profile = await ShopProfile.create({
        userId: shopUser._id,
        businessName: "Shoppe",
        initials: "SH",
    });

    const activeReq = await CustomerRequest.create({
        customerId: customer._id,
        title: "Active",
        category: "Electronics & Mobile Accessories",
    });
    const softDeletedReq = await CustomerRequest.create({
        customerId: customer._id,
        title: "Deleted",
        category: "Electronics & Mobile Accessories",
        deletedAt: new Date(),
    });
    const completedReq = await CustomerRequest.create({
        customerId: customer._id,
        title: "Completed",
        category: "Electronics & Mobile Accessories",
        status: "completed",
        purchasedShopUserId: shopUser._id,
    });

    await ShopResponse.create({
        requestId: activeReq._id,
        shopUserId: shopUser._id,
        shopProfileId: profile._id,
        price: "Rs. 100",
        message: "Available",
    });
    await ShopReview.create({
        shopProfileId: profile._id,
        shopUserId: shopUser._id,
        customerId: customer._id,
        requestId: completedReq._id,
        rating: 5,
    });
    const thread = await ChatThread.create({
        customerId: customer._id,
        shopUserId: shopUser._id,
        requestId: activeReq._id,
    });
    await Message.create({
        threadId: thread._id,
        senderId: customer._id,
        content: "hi",
    });
    await Message.create({
        threadId: thread._id,
        senderId: shopUser._id,
        content: "hello",
    });

    return { customer, shopUser, profile, completedReq };
}

test("deleting a customer removes every trace of them", async () => {
    const { customer } = await seedGraph();

    await deleteCustomerAccount(customer._id);

    assert.equal(await User.countDocuments({ _id: customer._id }), 0);
    assert.equal(await CustomerRequest.countDocuments({ customerId: customer._id }), 0);
    assert.equal(await ShopReview.countDocuments({ customerId: customer._id }), 0);
    assert.equal(await ChatThread.countDocuments({ customerId: customer._id }), 0);
    // Offers on the customer's requests are gone, and no orphan messages remain.
    assert.equal(await ShopResponse.countDocuments({}), 0);
    assert.equal(await Message.countDocuments({}), 0);
});

test("deleting a shop removes every trace of them", async () => {
    const { shopUser, profile } = await seedGraph();

    await deleteShopAccount(shopUser._id);

    assert.equal(await User.countDocuments({ _id: shopUser._id }), 0);
    assert.equal(await ShopProfile.countDocuments({ userId: shopUser._id }), 0);
    assert.equal(await ShopResponse.countDocuments({ shopUserId: shopUser._id }), 0);
    assert.equal(
        await ShopReview.countDocuments({
            $or: [{ shopUserId: shopUser._id }, { shopProfileId: profile._id }],
        }),
        0,
    );
    assert.equal(await ChatThread.countDocuments({ shopUserId: shopUser._id }), 0);
    assert.equal(await Message.countDocuments({}), 0);
    // The customer's purchase record survives but the shop link is cleared.
    assert.equal(
        await CustomerRequest.countDocuments({ purchasedShopUserId: shopUser._id }),
        0,
    );
    assert.equal(await CustomerRequest.countDocuments({ status: "completed" }), 1);
});

test("runAccountDeletion commits the cascade in a transaction", async () => {
    const { customer } = await seedGraph();

    await runAccountDeletion(customer);

    assert.equal(await User.countDocuments({ _id: customer._id }), 0);
    assert.equal(await CustomerRequest.countDocuments({ customerId: customer._id }), 0);
    assert.equal(await ShopReview.countDocuments({ customerId: customer._id }), 0);
});
