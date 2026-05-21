import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grabbit/app/app.dart';
import 'package:grabbit/app/router/app_router.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/core/network/api_client.dart';
import 'package:grabbit/core/network/connectivity_status.dart';
import 'package:grabbit/core/widgets/app_primary_button.dart';
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
import 'package:grabbit/features/profile/presentation/shop/screens/shop_settings_screen.dart';
import 'package:grabbit/features/profile/presentation/widgets/logout_confirmation_dialog.dart';
import 'package:grabbit/features/requests/data/repositories/api_requests_repository.dart';
import 'package:grabbit/features/requests/data/repositories/mock_requests_repository.dart';
import 'package:grabbit/features/requests/domain/entities/create_request_payload.dart';
import 'package:grabbit/features/requests/domain/entities/request_responses.dart';
import 'package:grabbit/features/requests/domain/entities/request_summary.dart';
import 'package:grabbit/features/requests/domain/entities/shop_response.dart';
import 'package:grabbit/features/requests/domain/entities/shop_request.dart';
import 'package:grabbit/features/requests/domain/repositories/requests_repository.dart';
import 'package:http/http.dart' as http;

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
      find.text('GroupBuy is coming soon'),
      800,
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

  testWidgets('home category shortcut preselects request category',
      (tester) async {
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

    await tester.tap(
      find.widgetWithText(ActionChip, 'Electronics & Mobile Accessories'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Post What You Need'), findsOneWidget);
    expect(find.text('Electronics & Mobile Accessories'), findsOneWidget);
    expect(find.text('Select a category'), findsNothing);
  });

  testWidgets('posting a request routes to my requests', (tester) async {
    final repository = _RecordingRequestsRepository();
    final container = _containerWithAuth(
      role: UserRole.customer,
      requestsRepository: repository,
    );
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);
    router.go(
      RoutePaths.postRequestPath(
        category: 'Electronics & Mobile Accessories',
      ),
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const GrabbitApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'e.g., Wireless Headphones'),
      'USB-C charger',
    );
    await tester.scrollUntilVisible(
      find.widgetWithText(AppPrimaryButton, 'Post Request'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.widgetWithText(AppPrimaryButton, 'Post Request'));
    await tester.pumpAndSettle();

    expect(repository.createdPayloads.single.title, 'USB-C charger');
    expect(find.text('My Requests'), findsOneWidget);
    expect(find.text('Pending (2)'), findsOneWidget);
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

  testWidgets('response chips sort nearest first and restore all shops',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 3600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = _containerWithAuth(
      role: UserRole.customer,
      requestsRepository: const _UnsortedResponsesRepository(),
    );
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);
    router.go(RoutePaths.requestResponsesPath(defaultRequestId));

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const GrabbitApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Far Bazaar'), findsOneWidget);
    expect(find.text('Near Mart'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Far Bazaar')).dy,
      lessThan(tester.getTopLeft(find.text('Near Mart')).dy),
    );

    await tester.tap(find.widgetWithText(ChoiceChip, 'Nearest First'));
    await tester.pumpAndSettle();

    expect(
      tester.getTopLeft(find.text('Near Mart')).dy,
      lessThan(tester.getTopLeft(find.text('Far Bazaar')).dy),
    );

    await tester.tap(find.widgetWithText(ChoiceChip, 'All Shops'));
    await tester.pumpAndSettle();

    expect(
      tester.getTopLeft(find.text('Far Bazaar')).dy,
      lessThan(tester.getTopLeft(find.text('Near Mart')).dy),
    );
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

  testWidgets('unverified shop can still view incoming requests',
      (tester) async {
    final container = _containerWithAuth(
      role: UserRole.shop,
      shopProfile: _unverifiedShopProfile,
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
    expect(find.text('Red Hoodie, Size L'), findsOneWidget);
    expect(find.text('iPhone 14 Pro Case'), findsNothing);
    await tester.tap(find.textContaining('Already Responded'));
    await tester.pumpAndSettle();
    expect(find.text('iPhone 14 Pro Case'), findsOneWidget);
  });

  testWidgets('unverified shop request detail locks responding',
      (tester) async {
    final container = _containerWithAuth(
      role: UserRole.shop,
      shopProfile: _unverifiedShopProfile,
    );
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);
    router.go(RoutePaths.shopRequestDetailPath(defaultRequestId));

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const GrabbitApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Request content stays visible.
    expect(find.text('Red Hoodie, Size L'), findsOneWidget);
    // Verification lock notice and CTA are shown instead of the send action.
    expect(
      find.textContaining('Your store is not verified yet'),
      findsOneWidget,
    );
    expect(find.text('Complete Store Profile'), findsOneWidget);
    expect(find.text('Send Response'), findsNothing);
  });

  testWidgets('shop profile settings button opens settings screen',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 6000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = _containerWithAuth(role: UserRole.shop);
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);
    router.go(RoutePaths.shopProfile);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const GrabbitApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Store Profile'), findsOneWidget);
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Show all requests'), findsOneWidget);
  });

  testWidgets('shop settings toggles request visibility', (tester) async {
    final repository = _RecordingShopProfileRepository();
    final container = ProviderContainer(
      overrides: [
        authControllerProvider.overrideWith(
          () => _FakeAuthController(UserRole.shop),
        ),
        shopProfileProvider.overrideWith((ref) async => _verifiedShopProfile),
        shopProfileRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: ShopSettingsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Show all requests'), findsOneWidget);

    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    expect(repository.lastShowAllRequests, isFalse);
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

  testWidgets('unverified shop profile shows verification progress',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 6000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = _containerWithAuth(
      role: UserRole.shop,
      shopProfile: _unverifiedShopProfile,
    );
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

    expect(find.text('Verify Your Store'), findsOneWidget);
    expect(find.textContaining('of 11 steps complete'), findsOneWidget);
    // Empty required fields surface a Required marker.
    expect(find.text('Required'), findsWidgets);
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

  testWidgets('logout confirmation dialog cancels and confirms',
      (tester) async {
    var confirmed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: OutlinedButton(
                  onPressed: () async {
                    confirmed = await showLogoutConfirmationDialog(context);
                  },
                  child: const Text('Show dialog'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Show dialog'));
    await tester.pumpAndSettle();

    expect(find.text('Log out?'), findsOneWidget);
    expect(
      find.text('Are you sure you want to log out of Grabbit?'),
      findsOneWidget,
    );

    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();

    expect(confirmed, isFalse);
    expect(find.text('Log out?'), findsNothing);

    await tester.tap(find.text('Show dialog'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log Out').last);
    await tester.pumpAndSettle();

    expect(confirmed, isTrue);
    expect(find.text('Log out?'), findsNothing);
  });
}

ProviderContainer _containerWithAuth({
  required UserRole? role,
  RequestsRepository requestsRepository = const MockRequestsRepository(),
  ShopProfile shopProfile = _verifiedShopProfile,
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
      shopProfileProvider.overrideWith((ref) async => shopProfile),
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

class _RecordingRequestsRepository extends MockRequestsRepository {
  final createdPayloads = <CreateRequestPayload>[];

  @override
  Future<RequestSummary> createRequest(CreateRequestPayload payload) async {
    createdPayloads.add(payload);
    return super.createRequest(payload);
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

class _UnsortedResponsesRepository extends MockRequestsRepository {
  const _UnsortedResponsesRepository();

  @override
  Future<RequestResponses> fetchRequestResponses(String requestId) async {
    return const RequestResponses(
      request: RequestSummary(
        id: defaultRequestId,
        title: 'Red Hoodie, Size L',
        subtitle: 'Active request with multiple nearby fashion shop responses.',
        status: RequestStatus.active,
        time: 'Posted 2 hours ago',
        responseText: '2 shops responded',
        category: 'Fashion & Clothing',
        postedAt: 'Posted 2 hours ago',
      ),
      responses: [
        ShopResponse(
          shopId: 'far-bazaar',
          shopUserId: 'far-shop-user',
          name: 'Far Bazaar',
          distance: '3km away',
          respondedAgo: '3 mins ago',
          rating: '4.8',
          reviews: '(20 reviews)',
          message: 'We have this in stock.',
          price: 'Rs. 2,900',
        ),
        ShopResponse(
          shopId: 'near-mart',
          shopUserId: 'near-shop-user',
          name: 'Near Mart',
          distance: '450m away',
          respondedAgo: '5 mins ago',
          rating: '4.5',
          reviews: '(12 reviews)',
          message: 'Available for pickup today.',
          price: 'Rs. 2,500',
        ),
      ],
    );
  }
}

class _EmptyShopRequestsRepository extends MockRequestsRepository {
  const _EmptyShopRequestsRepository();

  @override
  Future<List<ShopRequest>> fetchShopRequests() async {
    return const [];
  }
}

class _RecordingShopProfileRepository extends ShopProfileRepository {
  _RecordingShopProfileRepository()
      : super(ApiClient(baseUrl: '', client: http.Client()));

  bool? lastShowAllRequests;

  @override
  Future<ShopProfile> updateRequestVisibility(bool showAllRequests) async {
    lastShowAllRequests = showAllRequests;
    return ShopProfile.fromMap({'showAllRequests': showAllRequests});
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

const _verifiedShopProfile = ShopProfile(
  businessName: 'Kathmandu Electronics',
  initials: 'KE',
  categories: ['Electronics & Mobile Accessories'],
  addressText: 'New Baneshwor, Kathmandu',
  phone: '9800000000',
  description: 'Electronics, accessories, and repairs.',
  specialties: ['Mobile Accessories', 'Repairs'],
  openStatus: 'Open Now',
  closingTime: 'Closes 9:00 PM',
  typicalResponseTime: '15 minutes',
  landmark: 'Near Civil Hospital',
  isVerified: true,
  rating: 4.8,
  reviewCount: 127,
);

const _unverifiedShopProfile = ShopProfile(
  businessName: 'Kathmandu Electronics',
  initials: 'KE',
  categories: [],
  addressText: '',
  phone: '',
  description: '',
  specialties: [],
  openStatus: '',
  closingTime: '',
  typicalResponseTime: '',
  landmark: '',
  isVerified: false,
  rating: 0,
  reviewCount: 0,
);

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
    categories: ['Electronics & Mobile Accessories'],
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

  @override
  Future<void> logout() async {
    state = const AsyncData(null);
  }
}
