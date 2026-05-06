import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/features/auth/presentation/screens/login_screen.dart';
import 'package:grabbit/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:grabbit/features/chat/presentation/screens/chat_detail_screen.dart';
import 'package:grabbit/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:grabbit/features/home/presentation/screens/home_screen.dart';
import 'package:grabbit/features/profile/presentation/screens/profile_screen.dart';
import 'package:grabbit/features/requests/presentation/screens/post_request_screen.dart';
import 'package:grabbit/features/requests/presentation/screens/requests_screen.dart';
import 'package:grabbit/features/shell/presentation/widgets/app_shell.dart';
import 'package:grabbit/features/shop/presentation/screens/shop_dashboard_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.login,
    routes: [
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.signUp,
        builder: (context, state) => const SignUpScreen(),
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
                routes: [
                  GoRoute(
                    path: 'detail',
                    builder: (context, state) => ChatDetailScreen(
                      shopName:
                          state.uri.queryParameters['shop'] ?? 'Tech Haven',
                    ),
                  ),
                ],
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
        path: RoutePaths.postRequest,
        builder: (context, state) => const PostRequestScreen(),
      ),
      GoRoute(
        path: RoutePaths.shopDashboard,
        builder: (context, state) => const ShopDashboardScreen(),
      ),
    ],
  );
});
