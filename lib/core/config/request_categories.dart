abstract final class RequestCategories {
  static const groceriesFood = 'Groceries & Food';
  static const fashionClothing = 'Fashion & Clothing';
  static const electronicsMobileAccessories =
      'Electronics & Mobile Accessories';
  static const beautyPersonalCare = 'Beauty & Personal Care';
  static const homeKitchenAppliances = 'Home, Kitchen & Appliances';
  static const healthPharmacy = 'Health & Pharmacy';
  static const booksStationery = 'Books & Stationery';
  static const babyKids = 'Baby & Kids';
  static const sportsFitness = 'Sports & Fitness';
  static const giftsLifestyle = 'Gifts & Lifestyle';
  static const other = 'Other';

  static const all = [
    groceriesFood,
    fashionClothing,
    electronicsMobileAccessories,
    beautyPersonalCare,
    homeKitchenAppliances,
    healthPharmacy,
    booksStationery,
    babyKids,
    sportsFitness,
    giftsLifestyle,
    other,
  ];

  static const homeShortcuts = [
    electronicsMobileAccessories,
    fashionClothing,
    groceriesFood,
    beautyPersonalCare,
    homeKitchenAppliances,
  ];

  static const _legacyLabels = {
    'Groceries': groceriesFood,
    'Food & Beverages': groceriesFood,
    'Clothing': fashionClothing,
    'Electronics': electronicsMobileAccessories,
    'Health': healthPharmacy,
    'Sports': sportsFitness,
    'Books': booksStationery,
  };

  static String normalize(String category) {
    final trimmed = category.trim();
    return _legacyLabels[trimmed] ?? trimmed;
  }

  static List<String> normalizeList(Iterable<String> categories) {
    return categories
        .map(normalize)
        .where((category) => category.isNotEmpty)
        .toSet()
        .toList();
  }
}
