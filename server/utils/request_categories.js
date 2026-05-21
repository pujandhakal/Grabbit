const canonicalCategories = [
  "Groceries & Food",
  "Fashion & Clothing",
  "Electronics & Mobile Accessories",
  "Beauty & Personal Care",
  "Home, Kitchen & Appliances",
  "Health & Pharmacy",
  "Books & Stationery",
  "Baby & Kids",
  "Sports & Fitness",
  "Gifts & Lifestyle",
  "Other",
];

const legacyToCanonical = {
  Groceries: "Groceries & Food",
  "Food & Beverages": "Groceries & Food",
  Clothing: "Fashion & Clothing",
  Electronics: "Electronics & Mobile Accessories",
  Health: "Health & Pharmacy",
  Sports: "Sports & Fitness",
  Books: "Books & Stationery",
};

const aliasesByCanonical = {
  "Groceries & Food": ["Groceries & Food", "Groceries", "Food & Beverages"],
  "Fashion & Clothing": ["Fashion & Clothing", "Clothing"],
  "Electronics & Mobile Accessories": [
    "Electronics & Mobile Accessories",
    "Electronics",
  ],
  "Health & Pharmacy": ["Health & Pharmacy", "Health"],
  "Books & Stationery": ["Books & Stationery", "Books"],
  "Sports & Fitness": ["Sports & Fitness", "Sports"],
};

function normalizeCategory(category) {
  const trimmed = String(category || "").trim();
  if (!trimmed) return "";
  return legacyToCanonical[trimmed] || trimmed;
}

function normalizeCategories(categories) {
  if (!Array.isArray(categories)) return [];
  return [...new Set(categories.map(normalizeCategory).filter(Boolean))];
}

function categoryAliases(category) {
  const canonical = normalizeCategory(category);
  if (!canonical) return [];
  return aliasesByCanonical[canonical] || [canonical];
}

function categoriesWithAliases(categories) {
  return [
    ...new Set(
      normalizeCategories(categories).flatMap((category) =>
        categoryAliases(category),
      ),
    ),
  ];
}

function categoryMatches(profileCategories, requestCategory) {
  const profileValues = new Set(categoriesWithAliases(profileCategories));
  return categoryAliases(requestCategory).some((category) =>
    profileValues.has(category),
  );
}

module.exports = {
  canonicalCategories,
  normalizeCategory,
  normalizeCategories,
  categoryAliases,
  categoriesWithAliases,
  categoryMatches,
};
