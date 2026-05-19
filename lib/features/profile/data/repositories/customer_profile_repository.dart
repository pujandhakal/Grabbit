import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grabbit/core/errors/app_exception.dart';
import 'package:grabbit/core/network/api_client.dart';
import 'package:grabbit/features/profile/domain/entities/customer_profile.dart';

final customerProfileRepositoryProvider =
    Provider<CustomerProfileRepository>((ref) {
  return CustomerProfileRepository(ref.watch(apiClientProvider));
});

final customerProfileCacheProvider = StateProvider<CustomerProfile?>((ref) {
  return null;
});

final customerProfileProvider = FutureProvider.autoDispose<CustomerProfile>((
  ref,
) async {
  final cachedProfile = ref.watch(customerProfileCacheProvider);
  if (cachedProfile != null) {
    return cachedProfile;
  }

  final profile =
      await ref.watch(customerProfileRepositoryProvider).fetchProfile();
  ref.read(customerProfileCacheProvider.notifier).state = profile;
  return profile;
});

final customerReviewsProvider =
    FutureProvider.autoDispose<List<CustomerReview>>((
  ref,
) {
  return ref.watch(customerProfileRepositoryProvider).fetchReviews();
});

class CustomerProfileRepository {
  const CustomerProfileRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<CustomerProfile> fetchProfile() async {
    final data = await _apiClient.get('/api/account/profile');
    return _profileFromResponse(data);
  }

  Future<CustomerProfile> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    final data = await _apiClient.put(
      '/api/account/profile',
      body: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    );
    return _profileFromResponse(data);
  }

  Future<CustomerProfile> addAddress(CustomerAddress address) async {
    final data = await _apiClient.post(
      '/api/account/addresses',
      body: address.toMap(),
    );
    return _profileFromResponse(data);
  }

  Future<CustomerProfile> updateAddress(CustomerAddress address) async {
    final data = await _apiClient.put(
      '/api/account/addresses/${address.id}',
      body: address.toMap(),
    );
    return _profileFromResponse(data);
  }

  Future<CustomerProfile> deleteAddress(String addressId) async {
    final data = await _apiClient.delete(
      '/api/account/addresses/$addressId',
      body: const {},
    );
    return _profileFromResponse(data);
  }

  Future<CustomerProfile> updateSettings({
    required CustomerNotificationSettings notificationSettings,
    required CustomerPreferences preferences,
  }) async {
    final data = await _apiClient.put(
      '/api/account/settings',
      body: {
        'notificationSettings': notificationSettings.toMap(),
        'preferences': preferences.toMap(),
      },
    );
    return _profileFromResponse(data);
  }

  Future<List<CustomerReview>> fetchReviews() async {
    final data = await _apiClient.get('/api/account/reviews');
    final reviews = data['reviews'];
    if (reviews is! List) {
      return const [];
    }
    return reviews
        .whereType<Map<String, dynamic>>()
        .map(CustomerReview.fromMap)
        .toList();
  }

  CustomerProfile _profileFromResponse(Map<String, dynamic> data) {
    final profile = data['profile'];
    if (profile is Map<String, dynamic>) {
      return CustomerProfile.fromMap(profile);
    }
    throw const AppException(message: 'Unable to load profile.');
  }
}
