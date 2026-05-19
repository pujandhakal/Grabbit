import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grabbit/core/network/api_client.dart';
import 'package:grabbit/features/profile/domain/entities/shop_profile.dart';

final shopProfileRepositoryProvider = Provider<ShopProfileRepository>((ref) {
  return ShopProfileRepository(ref.watch(apiClientProvider));
});

final shopProfileProvider = FutureProvider.autoDispose<ShopProfile>((ref) {
  return ref.watch(shopProfileRepositoryProvider).fetchProfile();
});

class ShopProfileRepository {
  const ShopProfileRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<ShopProfile> fetchProfile() async {
    final data = await _apiClient.get('/api/shop/profile');
    final profile = data['profile'];
    if (profile is Map<String, dynamic>) {
      return ShopProfile.fromMap(profile);
    }
    return ShopProfile.fromMap(const {});
  }

  Future<ShopProfile> saveProfile({
    required String businessName,
    required List<String> categories,
    required String addressText,
    required String phone,
    required String description,
    required List<String> specialties,
    required String openStatus,
    required String closingTime,
    required String typicalResponseTime,
    required String landmark,
    double? latitude,
    double? longitude,
  }) async {
    final data = await _apiClient.put(
      '/api/shop/profile',
      body: {
        'businessName': businessName,
        'categories': categories,
        'addressText': addressText,
        'phone': phone,
        'description': description,
        'specialties': specialties,
        'openStatus': openStatus,
        'closingTime': closingTime,
        'typicalResponseTime': typicalResponseTime,
        'landmark': landmark,
        'latitude': latitude,
        'longitude': longitude,
      },
    );
    final profile = data['profile'];
    if (profile is Map<String, dynamic>) {
      return ShopProfile.fromMap(profile);
    }
    return ShopProfile.fromMap(const {});
  }
}
