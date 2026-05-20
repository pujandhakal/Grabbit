import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grabbit/app/app.dart';
import 'package:grabbit/app/router/app_router.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/core/network/connectivity_status.dart';
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
import 'package:grabbit/features/requests/domain/entities/request_summary.dart';
import 'package:grabbit/features/requests/domain/entities/shop_request.dart';
import 'package:grabbit/features/requests/domain/repositories/requests_repository.dart';

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
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

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
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('What are you looking for today?'), findsOneWidget);
    expect(find.text('Post once. Nearby shops respond with offers.'),
        findsOneWidget);
    expect(find.text('Post Request'), findsOneWidget);
    expect(find.text('Your Activity'), findsOneWidget);
    expect(find.text('Grabbit'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('GroupBuy'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('GroupBuy'), findsOneWidget);
    expect(find.text('GroupBuy is coming soon'), findsOneWidget);
    expect(find.text('Coming Soon'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, -500));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Grabbit'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('nav-requests')));
    await tester.pumpAndSettle();

    expect(find.text('My Requests'), findsOneWidget);
    expect(find.text('Pending (2)'), findsOneWidget);
    expect(find.text('Completed (1)'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(find.text('My Requests'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('nav-chats')));
    await tester.pumpAndSettle();

    expect(find.text('Chats'), findsOneWidget);
    expect(find.text('Search by shop, request, or message...'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(find.text('Chats'), findsOneWidget);
    expect(find.text('Search by shop, request, or message...'), findsOneWidget);

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

  testWidgets('chat search filters conversations and clears query',
      (tester) async {
    final container = _containerWithAuth(role: UserRole.customer);
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);
    router.go(RoutePaths.chats);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const GrabbitApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tech Haven'), findsOneWidget);
    expect(find.text('Fashion Hub Kathmandu'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'fashion');
    await tester.pumpAndSettle();

    expect(find.text('Tech Haven'), findsNothing);
    expect(find.text('Fashion Hub Kathmandu'), findsOneWidget);
    expect(find.byTooltip('Clear search'), findsOneWidget);

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();

    expect(find.text('Tech Haven'), findsOneWidget);
    expect(find.text('Fashion Hub Kathmandu'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'missing');
    await tester.pumpAndSettle();

    expect(find.text('No chats found for "missing".'), findsOneWidget);
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

    expect(find.text('Pending (2)'), findsOneWidget);
    expect(find.text('Completed (1)'), findsOneWidget);
    expect(find.text('Red Hoodie, Size L'), findsOneWidget);
    expect(find.text('Running shoes'), findsOneWidget);

    await tester.tap(find.text('Completed (1)'));
    await tester.pumpAndSettle();

    expect(find.text('Second-hand textbooks'), findsOneWidget);

    await tester.tap(find.text('Pending (2)'));
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

  testWidgets('customer can delete a request from request list',
      (tester) async {
    final repository = _DeletingRequestsRepository();
    final container = _containerWithAuth(
      role: UserRole.customer,
      requestsRepository: repository,
    );
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

    expect(find.text('Pending (2)'), findsOneWidget);
    expect(find.text('Red Hoodie, Size L'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete request').first);
    await tester.pumpAndSettle();
    expect(find.text('Delete request?'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(repository.deletedRequestIds, contains(defaultRequestId));
    expect(find.text('Red Hoodie, Size L'), findsNothing);
    expect(find.text('Pending (1)'), findsOneWidget);
    expect(find.text('Running shoes'), findsOneWidget);
  });

  testWidgets('pending requests empty state shows illustration',
      (tester) async {
    final container = _containerWithAuth(
      role: UserRole.customer,
      requestsRepository: const _CompletedOnlyRequestsRepository(),
    );
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

    expect(find.text('Pending (0)'), findsOneWidget);
    expect(find.text('Completed (1)'), findsOneWidget);
    expect(find.text('No pending requests right now.'), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);
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
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

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
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Incoming Requests'), findsOneWidget);
    await tester.tap(find.textContaining('Already Responded'));
    await tester.pumpAndSettle();
    expect(find.text('Second-hand textbooks'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('shop-nav-chats')));
    await tester.pumpAndSettle();

    expect(find.text('Shop Chats'), findsOneWidget);
    expect(
      find.text('Search by customer, request, or message...'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('shop-nav-profile')));
    await tester.pumpAndSettle();

    expect(find.text('Store Profile'), findsOneWidget);
  });

  testWidgets('shop requests empty state shows illustration', (tester) async {
    final container = _containerWithAuth(
      role: UserRole.shop,
      requestsRepository: const _EmptyShopRequestsRepository(),
    );
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);
    router.go(RoutePaths.shopRequests);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const GrabbitApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Incoming Requests'), findsOneWidget);
    expect(
      find.text(
        'No matching requests yet. Add categories in your shop profile to receive requests.',
      ),
      findsOneWidget,
    );
    expect(find.byType(SvgPicture), findsOneWidget);
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

ProviderContainer _containerWithAuth({
  required UserRole? role,
  RequestsRepository requestsRepository = const MockRequestsRepository(),
}) {
  return ProviderContainer(
    overrides: [
      authControllerProvider.overrideWith(() => _FakeAuthController(role)),
      requestsRepositoryProvider.overrideWithValue(
        requestsRepository,
      ),
      shopsRepositoryProvider.overrideWithValue(const MockShopsRepository()),
      networkConnectionProvider.overrideWith((ref) => Stream.value(true)),
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

class _DeletingRequestsRepository extends MockRequestsRepository {
  final deletedRequestIds = <String>{};

  @override
  Future<List<RequestSummary>> fetchRequests() async {
    final requests = await super.fetchRequests();
    return requests
        .where((request) => !deletedRequestIds.contains(request.id))
        .toList(growable: false);
  }

  @override
  Future<void> deleteRequest(String requestId) async {
    deletedRequestIds.add(requestId);
  }
}

class _CompletedOnlyRequestsRepository extends MockRequestsRepository {
  const _CompletedOnlyRequestsRepository();

  @override
  Future<List<RequestSummary>> fetchRequests() async {
    final requests = await super.fetchRequests();
    return requests
        .where((request) => request.status == RequestStatus.completed)
        .toList(growable: false);
  }
}

class _EmptyShopRequestsRepository extends MockRequestsRepository {
  const _EmptyShopRequestsRepository();

  @override
  Future<List<ShopRequest>> fetchShopRequests() async {
    return const [];
  }
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
  ChatThreadSummary(
    threadId: 'thread-2',
    peerUserId: 'shop-user-2',
    peerName: 'Fashion Hub Kathmandu',
    requestId: 'request-2',
    requestTitle: 'Blue Jeans, Size M',
    lastMessage: 'We can deliver the jeans today.',
    lastMessageAt: DateTime(2026, 5, 19, 10, 35),
    timeLabel: '20 min ago',
    unreadCount: 0,
    isUnread: false,
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
