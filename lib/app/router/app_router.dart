import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/router/page_transitions.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/features/auth/presentation/screens/login_screen.dart';
import 'package:grabbit/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:grabbit/features/chat/presentation/screens/chat_detail_screen.dart';
import 'package:grabbit/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:grabbit/features/home/presentation/screens/home_screen.dart';
import 'package:grabbit/features/profile/presentation/screens/profile_screen.dart';
import 'package:grabbit/features/requests/presentation/screens/post_request_screen.dart';
import 'package:grabbit/features/requests/presentation/screens/request_responses_screen.dart';
import 'package:grabbit/features/requests/presentation/screens/requests_screen.dart';
import 'package:grabbit/features/shell/presentation/widgets/app_shell.dart';
import 'package:grabbit/features/shop/presentation/screens/shop_dashboard_screen.dart';
import 'package:grabbit/features/shop/presentation/screens/store_details_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.login,
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
          return AppShell(navigationShell: navigationShell);
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
      GoRoute(
        path: RoutePaths.chatDetail,
        pageBuilder: (context, state) => fadeSlidePage(
          state: state,
          child: ChatDetailScreen(
            shopName: state.uri.queryParameters['shop'] ?? 'Tech Haven',
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
        path: RoutePaths.shopDashboard,
        pageBuilder: (context, state) =>
            fadeSlidePage(state: state, child: const ShopDashboardScreen()),
      ),
    ],
  );
});
