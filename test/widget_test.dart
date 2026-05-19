import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grabbit/app/app.dart';
import 'package:grabbit/app/router/app_router.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/features/auth/domain/entities/user_entity.dart';
import 'package:grabbit/features/auth/domain/entities/user_role.dart';
import 'package:grabbit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:grabbit/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:grabbit/features/chat/data/repositories/chat_repository.dart';
import 'package:grabbit/features/chat/domain/entities/chat_thread_summary.dart';
import 'package:grabbit/features/marketplace/data/repositories/api_shops_repository.dart';
import 'package:grabbit/features/marketplace/data/repositories/mock_shops_repository.dart';
import 'package:grabbit/features/profile/data/repositories/shop_profile_repository.dart';
import 'package:grabbit/features/profile/data/repositories/customer_profile_repository.dart';
import 'package:grabbit/features/profile/domain/entities/customer_profile.dart';
import 'package:grabbit/features/profile/domain/entities/shop_profile.dart';
import 'package:grabbit/features/profile/presentation/shop/screens/shop_profile_screen.dart';
import 'package:grabbit/features/requests/data/repositories/api_requests_repository.dart';
import 'package:grabbit/features/requests/data/repositories/mock_requests_repository.dart';

void main() {
  testWidgets('app boots into login', (tester) async {
    final container = _containerWithAuth(role: null);
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const GrabbitApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('Grabbit'), findsOneWidget);
  });

  testWidgets('shell navigation switches between main tabs', (tester) async {
    final container = _containerWithAuth(role: UserRole.customer);
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);
    router.go(RoutePaths.home);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const GrabbitApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Quick Actions'), findsOneWidget);
    expect(find.text('Grabbit'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.text('Grabbit'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('nav-requests')));
    await tester.pumpAndSettle();

    expect(find.text('My Requests'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(find.text('My Requests'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('nav-chats')));
    await tester.pumpAndSettle();

    expect(find.text('Chats'), findsOneWidget);
    expect(find.text('Search chats...'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(find.text('Chats'), findsOneWidget);
    expect(find.text('Search chats...'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('nav-profile')));
    await tester.pumpAndSettle();

    expect(find.text('Profile'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.text('Profile'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Danger Zone'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Delete Account'), findsOneWidget);
  });

  testWidgets('chat detail opens without bottom navigation', (tester) async {
    final container = _containerWithAuth(role: UserRole.customer);
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);
    router.go('${RoutePaths.chatDetail}?shop=Tech%20Haven');

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const GrabbitApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Type a message...'), findsOneWidget);
    expect(find.byKey(const ValueKey('nav-chats')), findsNothing);
    expect(find.byKey(const ValueKey('nav-profile')), findsNothing);
  });

  testWidgets('request card opens responses page without bottom navigation',
      (tester) async {
    final container = _containerWithAuth(role: UserRole.customer);
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);
    router.go(RoutePaths.requests);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const GrabbitApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Red Hoodie, Size L').first);
    await tester.pumpAndSettle();

    expect(find.text('Responses'), findsOneWidget);
    expect(find.text('8 shops have responded'), findsOneWidget);
    expect(find.text('Red Hoodie, Size L'), findsOneWidget);
    expect(find.text('Fashion Hub Kathmandu'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Street Style Nepal'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Street Style Nepal'), findsOneWidget);
    expect(find.byKey(const ValueKey('nav-requests')), findsNothing);
    expect(find.byKey(const ValueKey('nav-profile')), findsNothing);
  });

  testWidgets('view store opens store details without bottom navigation',
      (tester) async {
    final container = _containerWithAuth(role: UserRole.customer);
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);
    router.go(RoutePaths.requests);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const GrabbitApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Red Hoodie, Size L').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('View Store').first);
    await tester.pumpAndSettle();

    expect(find.text('Store Details'), findsOneWidget);
    expect(find.text('Fashion Hub Kathmandu'), findsOneWidget);
    expect(find.text('850m away'), findsOneWidget);
    expect(find.text('Open Now'), findsOneWidget);
    expect(find.text('About Store'), findsOneWidget);
    expect(find.text('Customer Reviews'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Recent Activity'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Recent Activity'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Location'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Location'), findsOneWidget);
    expect(find.text('Get Direction'), findsOneWidget);
    expect(find.byTooltip('Contact Store'), findsOneWidget);
    expect(find.byKey(const ValueKey('nav-requests')), findsNothing);
    expect(find.byKey(const ValueKey('nav-profile')), findsNothing);
  });

  testWidgets('sign up screen renders create account flow', (tester) async {
    final container = _containerWithAuth(role: null);
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: SignUpScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Join Grabbit'), findsOneWidget);
    expect(find.text('Customer'), findsOneWidget);
    expect(find.text('Shop'), findsOneWidget);
    expect(find.widgetWithText(InkWell, 'Create Account'), findsOneWidget);
  });

  testWidgets('shop shell navigation switches between shop tabs',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 6000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = _containerWithAuth(role: UserRole.shop);
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);
    router.go(RoutePaths.shopDashboard);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const GrabbitApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Shop Dashboard'), findsNothing);
    expect(find.text('Kathmandu Electronics'), findsOneWidget);
    expect(find.text('Store is visible'), findsOneWidget);
    expect(find.text('Today at a glance'), findsOneWidget);
    expect(find.text('Needs Response'), findsOneWidget);
    expect(find.text('Active Responses'), findsOneWidget);
    expect(find.text('Unread Chats'), findsOneWidget);
    expect(find.text('Quick actions'), findsOneWidget);
    expect(find.text('New Requests Near You'), findsNothing);
    expect(find.text('Filter & Sort Requests'), findsNothing);
    expect(find.text('Looking for Red Hoodie'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('shop-nav-requests')));
    await tester.pumpAndSettle();

    expect(find.text('Incoming Requests'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('shop-nav-chats')));
    await tester.pumpAndSettle();

    expect(find.text('Shop Chats'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('shop-nav-profile')));
    await tester.pumpAndSettle();

    expect(find.text('Store Profile'), findsOneWidget);
  });

  testWidgets('shop profile shows danger zone', (tester) async {
    tester.view.physicalSize = const Size(1080, 6000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = _containerWithAuth(role: UserRole.shop);
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: ShopProfileScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Store Profile'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, -1600));
    await tester.pumpAndSettle();
    expect(find.text('DANGER ZONE'), findsOneWidget);
    expect(find.text('Delete Account'), findsOneWidget);
  });

  testWidgets('customer profile rows open detail screens', (tester) async {
    tester.view.physicalSize = const Size(1080, 4200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = _containerWithAuth(role: UserRole.customer);
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);
    router.go(RoutePaths.profile);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const GrabbitApp(),
      ),
    );
    await tester.pumpAndSettle();

    final rows = <String, String>{
      'Edit Profile': 'Save Profile',
      'Saved Addresses': 'New Baneshwor, Kathmandu',
      'My Reviews': 'No reviews yet',
      'Notifications': 'Request responses',
      'Request Defaults': 'Preferred Categories',
      'Help & Support': 'Posting requests',
      'Terms & Conditions': 'Using Grabbit',
    };

    for (final entry in rows.entries) {
      await tester.tap(find.text(entry.key));
      await tester.pumpAndSettle();
      expect(find.text(entry.value), findsOneWidget);
      router.go(RoutePaths.profile);
      await tester.pumpAndSettle();
    }
  });
}

ProviderContainer _containerWithAuth({required UserRole? role}) {
  return ProviderContainer(
    overrides: [
      authControllerProvider.overrideWith(() => _FakeAuthController(role)),
      requestsRepositoryProvider.overrideWithValue(
        const MockRequestsRepository(),
      ),
      shopsRepositoryProvider.overrideWithValue(const MockShopsRepository()),
      chatThreadsProvider.overrideWith((ref) async => _mockChatThreads),
      customerProfileProvider.overrideWith((ref) async => _mockCustomerProfile),
      customerReviewsProvider.overrideWith((ref) async => const []),
      shopProfileProvider.overrideWith(
        (ref) async => const ShopProfile(
          businessName: 'Kathmandu Electronics',
          initials: 'KE',
          categories: ['Electronics'],
          addressText: 'New Baneshwor, Kathmandu',
          phone: '9800000000',
          description: 'Electronics, accessories, and repairs.',
          specialties: ['Electronics', 'Accessories'],
          openStatus: 'Open Now',
          closingTime: 'Closes 9:00 PM',
          typicalResponseTime: '15 minutes',
          landmark: 'Near Civil Hospital',
          isVerified: true,
          rating: 4.8,
          reviewCount: 127,
        ),
      ),
    ],
  );
}

final _mockChatThreads = [
  ChatThreadSummary(
    threadId: 'thread-1',
    peerUserId: 'shop-user-1',
    peerName: 'Tech Haven',
    requestId: defaultRequestId,
    requestTitle: 'Red Hoodie, Size L',
    lastMessage: 'We have your requested laptop in stock.',
    lastMessageAt: DateTime(2026, 5, 19, 10, 45),
    timeLabel: '10 min ago',
    unreadCount: 1,
    isUnread: true,
  ),
];

const _mockCustomerProfile = CustomerProfile(
  user: UserEntity(
    id: '1',
    name: 'Pujan Dhakal',
    email: 'pujan@example.com',
    phone: '9800000000',
    role: UserRole.customer,
    token: '',
  ),
  memberSince: 'Jan 2024',
  stats: CustomerProfileStats(
    totalRequests: 24,
    completedRequests: 18,
    reviewCount: 4,
  ),
  addresses: [
    CustomerAddress(
      id: 'addr-1',
      label: 'Home',
      addressText: 'New Baneshwor, Kathmandu',
      city: 'Kathmandu',
      landmark: 'Near Civil Hospital',
      phone: '9800000000',
      isDefault: true,
    ),
  ],
  notificationSettings: CustomerNotificationSettings(
    requestResponses: true,
    chatMessages: true,
    purchaseUpdates: true,
    promotions: false,
  ),
  preferences: CustomerPreferences(
    categories: ['Electronics'],
    budgetMin: 1000,
    budgetMax: 5000,
    searchRadiusKm: 5,
  ),
  enabledNotificationCount: 3,
);

class _FakeAuthController extends AuthController {
  _FakeAuthController(this.role);

  final UserRole? role;

  @override
  Future<UserEntity?> build() async {
    if (role == null) {
      return null;
    }

    return UserEntity(
      id: '1',
      name: role == UserRole.shop ? 'Fashion Hub' : 'Pujan Dhakal',
      email: role == UserRole.shop ? 'shop@example.com' : 'pujan@example.com',
      phone: '',
      role: role!,
      token: '',
    );
  }
}
