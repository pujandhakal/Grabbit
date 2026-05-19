const mongoose = require('mongoose');

const userSchema = mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
    },

    email: {
      type: String,
      required: true,
      trim: true,
      validate: {
        validator: (value) => {
          const re =
            /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
          return value.match(re);
        },
        message: "Please enter a valid email address",
      },
    },

    password: {
      type: String,
      required: true,
    },

    phone: {
      type: String,
      trim: true,
    },

    type: {
      type: String,
      enum: ["customer", "shop"],
      default: "customer",
    },

    savedAddresses: [
      {
        label: {
          type: String,
          trim: true,
          default: "Home",
        },
        addressText: {
          type: String,
          trim: true,
          default: "",
        },
        city: {
          type: String,
          trim: true,
          default: "Kathmandu",
        },
        landmark: {
          type: String,
          trim: true,
          default: "",
        },
        phone: {
          type: String,
          trim: true,
          default: "",
        },
        isDefault: {
          type: Boolean,
          default: false,
        },
      },
    ],

    notificationSettings: {
      requestResponses: {
        type: Boolean,
        default: true,
      },
      chatMessages: {
        type: Boolean,
        default: true,
      },
      purchaseUpdates: {
        type: Boolean,
        default: true,
      },
      promotions: {
        type: Boolean,
        default: false,
      },
    },

    preferences: {
      categories: {
        type: [String],
        default: [],
      },
      budgetMin: {
        type: Number,
        default: null,
      },
      budgetMax: {
        type: Number,
        default: null,
      },
      searchRadiusKm: {
        type: Number,
        default: 5,
      },
    },
  },
  { timestamps: true }
);

const User = mongoose.model("User", userSchema);

module.exports = User;
