import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/router/page_transitions.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/features/auth/presentation/screens/login_screen.dart';
import 'package:grabbit/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:grabbit/features/chat/presentation/screens/chat_detail_screen.dart';
import 'package:grabbit/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:grabbit/features/chat/presentation/shop/screens/shop_chats_screen.dart';
import 'package:grabbit/features/customer_shell/presentation/widgets/customer_shell.dart';
import 'package:grabbit/features/home/presentation/screens/home_screen.dart';
import 'package:grabbit/features/profile/presentation/screens/profile_screen.dart';
import 'package:grabbit/features/profile/presentation/screens/customer_profile_detail_screens.dart';
import 'package:grabbit/features/profile/presentation/shop/screens/shop_profile_screen.dart';
import 'package:grabbit/features/requests/presentation/screens/post_request_screen.dart';
import 'package:grabbit/features/requests/presentation/screens/request_responses_screen.dart';
import 'package:grabbit/features/requests/presentation/screens/requests_screen.dart';
import 'package:grabbit/features/requests/presentation/shop/screens/shop_request_detail_screen.dart';
import 'package:grabbit/features/requests/presentation/shop/screens/shop_requests_screen.dart';
import 'package:grabbit/features/shop_dashboard/presentation/screens/shop_dashboard_screen.dart';
import 'package:grabbit/features/shop_shell/presentation/widgets/shop_shell.dart';
import 'package:grabbit/features/marketplace/presentation/screens/store_details_screen.dart';
import 'package:grabbit/features/auth/domain/entities/user_role.dart';
import 'package:grabbit/features/auth/presentation/controllers/auth_controller.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final routerRefresh = ref.watch(_routerRefreshProvider);

  return GoRouter(
    initialLocation: RoutePaths.login,
    refreshListenable: routerRefresh,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final user = authState.valueOrNull;

      if (authState.isLoading) {
        return null;
      }

      final location = state.uri.path;
      final isAuthRoute =
          location == RoutePaths.login || location == RoutePaths.signUp;
      final isCustomerRoute = location.startsWith('/customer');
      final isShopRoute = location.startsWith('/shop');

      if (user == null) {
        return isAuthRoute ? null : RoutePaths.login;
      }

      if (isAuthRoute) {
        return RoutePaths.homeForRole(user.role);
      }

      if (user.role == UserRole.customer && isShopRoute) {
        return RoutePaths.home;
      }

      if (user.role == UserRole.shop && isCustomerRoute) {
        return RoutePaths.shopDashboard;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.login,
        pageBuilder: (context, state) =>
            fadeSlidePage(state: state, child: const LoginScreen()),
      ),
      GoRoute(
        path: RoutePaths.signUp,
        pageBuilder: (context, state) =>
            fadeSlidePage(state: state, child: const SignUpScreen()),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return CustomerShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.home,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: HomeScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.requests,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: RequestsScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.chats,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ChatListScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.profile,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ProfileScreen()),
              ),
            ],
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ShopShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.shopDashboard,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ShopDashboardScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.shopRequests,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ShopRequestsScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.shopChats,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ShopChatsScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.shopProfile,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ShopProfileScreen()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.editProfile,
        pageBuilder: (context, state) =>
            fadeSlidePage(state: state, child: const EditProfileScreen()),
      ),
      GoRoute(
        path: RoutePaths.savedAddresses,
        pageBuilder: (context, state) =>
            fadeSlidePage(state: state, child: const SavedAddressesScreen()),
      ),
      GoRoute(
        path: RoutePaths.myReviews,
        pageBuilder: (context, state) =>
            fadeSlidePage(state: state, child: const MyReviewsScreen()),
      ),
      GoRoute(
        path: RoutePaths.notificationSettings,
        pageBuilder: (context, state) => fadeSlidePage(
          state: state,
          child: const NotificationSettingsScreen(),
        ),
      ),
      GoRoute(
        path: RoutePaths.requestDefaults,
        pageBuilder: (context, state) =>
            fadeSlidePage(state: state, child: const RequestDefaultsScreen()),
      ),
      GoRoute(
        path: RoutePaths.helpSupport,
        pageBuilder: (context, state) =>
            fadeSlidePage(state: state, child: const HelpSupportScreen()),
      ),
      GoRoute(
        path: RoutePaths.termsConditions,
        pageBuilder: (context, state) =>
            fadeSlidePage(state: state, child: const TermsConditionsScreen()),
      ),
      GoRoute(
        path: RoutePaths.chatDetail,
        pageBuilder: (context, state) => fadeSlidePage(
          state: state,
          child: ChatDetailScreen(
            peerName: state.uri.queryParameters['peer'] ??
                state.uri.queryParameters['shop'] ??
                'Conversation',
            peerUserId: state.uri.queryParameters['peerUserId'],
            requestId: state.uri.queryParameters['requestId'],
          ),
        ),
      ),
      GoRoute(
        path: RoutePaths.requestResponses,
        pageBuilder: (context, state) => fadeSlidePage(
          state: state,
          child: RequestResponsesScreen(
            requestId: state.pathParameters['requestId'] ??
                RoutePaths.defaultRequestId,
          ),
        ),
      ),
      GoRoute(
        path: RoutePaths.legacyRequestResponsesStatic,
        redirect: (_, __) =>
            RoutePaths.requestResponsesPath(RoutePaths.defaultRequestId),
      ),
      GoRoute(
        path: RoutePaths.legacyRequestResponses,
        redirect: (_, __) =>
            RoutePaths.requestResponsesPath(RoutePaths.defaultRequestId),
      ),
      GoRoute(
        path: RoutePaths.postRequest,
        pageBuilder: (context, state) =>
            fadeSlidePage(state: state, child: const PostRequestScreen()),
      ),
      GoRoute(
        path: RoutePaths.storeDetails,
        pageBuilder: (context, state) => fadeSlidePage(
          state: state,
          child: StoreDetailsScreen(
            shopId: state.pathParameters['shopId'] ?? RoutePaths.defaultShopId,
          ),
        ),
      ),
      GoRoute(
        path: RoutePaths.legacyStoreDetails,
        redirect: (_, __) =>
            RoutePaths.storeDetailsPath(RoutePaths.defaultShopId),
      ),
      GoRoute(
        path: RoutePaths.shopRequestDetail,
        pageBuilder: (context, state) => fadeSlidePage(
          state: state,
          child: ShopRequestDetailScreen(
            requestId: state.pathParameters['requestId'] ??
                RoutePaths.defaultRequestId,
          ),
        ),
      ),
      GoRoute(
        path: RoutePaths.shopChatDetail,
        pageBuilder: (context, state) => fadeSlidePage(
          state: state,
          child: ChatDetailScreen(
            peerName: state.uri.queryParameters['peer'] ??
                state.uri.queryParameters['shop'] ??
                'Customer',
            peerUserId: state.uri.queryParameters['peerUserId'],
            requestId: state.uri.queryParameters['requestId'],
          ),
        ),
      ),
    ],
  );
});

final _routerRefreshProvider = Provider<Listenable>((ref) {
  final notifier = _RouterRefreshNotifier();
  ref.listen(authControllerProvider, (_, __) => notifier.notify());
  ref.onDispose(notifier.dispose);
  return notifier;
});

class _RouterRefreshNotifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}
