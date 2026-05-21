import 'package:grabbit/features/auth/domain/entities/user_role.dart';

abstract final class RoutePaths {
  static const login = '/login';
  static const signUp = '/signup';
  static const home = '/customer/home';
  static const requests = '/customer/requests';
  static const defaultRequestId = 'red-hoodie-size-l';
  static const defaultShopId = 'fashion-hub-kathmandu';
  static const requestResponses = '/customer/requests/:requestId/responses';
  static const legacyRequestResponsesStatic = '/requests/responses';
  static const legacyRequestResponses = '/request-responses';
  static const postRequest = '/customer/post-request';
  static const chats = '/customer/chats';
  static const chatDetail = '/customer/chats/detail';
  static const profile = '/customer/profile';
  static const editProfile = '/customer/profile/edit';
  static const savedAddresses = '/customer/profile/addresses';
  static const myReviews = '/customer/profile/reviews';
  static const notificationSettings = '/customer/profile/notifications';
  static const requestDefaults = '/customer/profile/request-defaults';
  static const helpSupport = '/customer/profile/help';
  static const termsConditions = '/customer/profile/terms';
  static const storeDetails = '/customer/shops/:shopId';
  static const legacyStoreDetails = '/stores/fashion-hub-kathmandu';
  static const shopDashboard = '/shop/dashboard';
  static const shopRequests = '/shop/requests';
  static const shopChats = '/shop/chats';
  static const shopProfile = '/shop/profile';
  static const shopSettings = '/shop/settings';
  static const shopRequestDetail = '/shop/requests/:requestId';
  static const shopChatDetail = '/shop/chats/detail';

  static String requestResponsesPath(String requestId) {
    return '/customer/requests/$requestId/responses';
  }

  static String postRequestPath({String? category}) {
    if (category == null || category.isEmpty) {
      return postRequest;
    }

    return Uri(
      path: postRequest,
      queryParameters: {'category': category},
    ).toString();
  }

  static String storeDetailsPath(String shopId) {
    return '/customer/shops/$shopId';
  }

  static String shopRequestDetailPath(String requestId) {
    return '/shop/requests/$requestId';
  }

  static String homeForRole(UserRole role) {
    return switch (role) {
      UserRole.customer => home,
      UserRole.shop => shopDashboard,
    };
  }
}
