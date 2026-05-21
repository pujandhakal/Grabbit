import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grabbit/core/config/app_config.dart';
import 'package:grabbit/core/network/api_client.dart';
import 'package:grabbit/features/profile/data/repositories/customer_profile_repository.dart';
import 'package:grabbit/features/profile/domain/entities/customer_profile.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('repository fetches customer profile', () async {
    final container = ProviderContainer(
      overrides: [
        appConfigProvider.overrideWithValue(
          const AppConfig(apiBaseUrl: 'http://localhost:3000'),
        ),
        httpClientProvider.overrideWithValue(
          MockClient((request) async {
            expect(request.url.toString(),
                'http://localhost:3000/api/account/profile');
            return http.Response(_profileResponse, 200);
          }),
        ),
      ],
    );
    addTearDown(container.dispose);

    final profile =
        await container.read(customerProfileRepositoryProvider).fetchProfile();

    expect(profile.user.name, 'Pujan Dhakal');
    expect(profile.stats.totalRequests, 24);
    expect(profile.addresses.single.isDefault, isTrue);
  });

  test('repository updates profile fields', () async {
    final container = ProviderContainer(
      overrides: [
        appConfigProvider.overrideWithValue(
          const AppConfig(apiBaseUrl: 'http://localhost:3000'),
        ),
        httpClientProvider.overrideWithValue(
          MockClient((request) async {
            expect(request.method, 'PUT');
            expect(request.url.toString(),
                'http://localhost:3000/api/account/profile');
            expect(request.body, contains('"name":"Pujan"'));
            expect(request.body, contains('"phone":"9800000000"'));
            return http.Response(_profileResponse, 200);
          }),
        ),
      ],
    );
    addTearDown(container.dispose);

    final profile =
        await container.read(customerProfileRepositoryProvider).updateProfile(
              name: 'Pujan',
              email: 'pujan@example.com',
              phone: '9800000000',
            );

    expect(profile.user.email, 'pujan@example.com');
  });

  test('repository saves settings and fetches reviews', () async {
    var call = 0;
    final container = ProviderContainer(
      overrides: [
        appConfigProvider.overrideWithValue(
          const AppConfig(apiBaseUrl: 'http://localhost:3000'),
        ),
        httpClientProvider.overrideWithValue(
          MockClient((request) async {
            call++;
            if (call == 1) {
              expect(request.method, 'PUT');
              expect(request.url.toString(),
                  'http://localhost:3000/api/account/settings');
              expect(request.body, contains('"requestResponses":true'));
              expect(
                request.body,
                contains(
                  '"categories":["Electronics & Mobile Accessories"]',
                ),
              );
              return http.Response(_profileResponse, 200);
            }
            expect(request.url.toString(),
                'http://localhost:3000/api/account/reviews');
            return http.Response(
              '{"reviews":[{"id":"review-1","shopId":"shop-1","shopName":"Tech Haven","shopInitials":"TH","requestId":"request-1","requestTitle":"Headphones","rating":5,"body":"Great","timeAgo":"1 day ago"}]}',
              200,
            );
          }),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(customerProfileRepositoryProvider).updateSettings(
          notificationSettings: const CustomerNotificationSettings(
            requestResponses: true,
            chatMessages: true,
            purchaseUpdates: true,
            promotions: false,
          ),
          preferences: const CustomerPreferences(
            categories: ['Electronics & Mobile Accessories'],
            budgetMin: 1000,
            budgetMax: 5000,
            searchRadiusKm: 5,
          ),
        );
    final reviews =
        await container.read(customerProfileRepositoryProvider).fetchReviews();

    expect(reviews.single.shopName, 'Tech Haven');
    expect(reviews.single.rating, 5);
  });
}

const _profileResponse = '''
{
  "profile": {
    "user": {
      "_id": "1",
      "name": "Pujan Dhakal",
      "email": "pujan@example.com",
      "phone": "9800000000",
      "type": "customer"
    },
    "memberSince": "Jan 2024",
    "stats": {
      "totalRequests": 24,
      "completedRequests": 18,
      "reviewCount": 4
    },
    "addresses": [
      {
        "id": "addr-1",
        "label": "Home",
        "addressText": "New Baneshwor, Kathmandu",
        "city": "Kathmandu",
        "landmark": "Near Civil Hospital",
        "phone": "9800000000",
        "isDefault": true
      }
    ],
    "notificationSettings": {
      "requestResponses": true,
      "chatMessages": true,
      "purchaseUpdates": true,
      "promotions": false
    },
    "preferences": {
      "categories": ["Electronics & Mobile Accessories"],
      "budgetMin": 1000,
      "budgetMax": 5000,
      "searchRadiusKm": 5
    },
    "enabledNotificationCount": 3
  }
}
''';
