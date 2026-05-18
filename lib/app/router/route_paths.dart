abstract final class RoutePaths {
  static const login = '/login';
  static const signUp = '/signup';
  static const home = '/home';
  static const requests = '/requests';
  static const defaultRequestId = 'red-hoodie-size-l';
  static const defaultShopId = 'fashion-hub-kathmandu';
  static const requestResponses = '/requests/:requestId/responses';
  static const legacyRequestResponsesStatic = '/requests/responses';
  static const legacyRequestResponses = '/request-responses';
  static const postRequest = '/post-request';
  static const chats = '/chats';
  static const chatDetail = '/chats/detail';
  static const profile = '/profile';
  static const storeDetails = '/shops/:shopId';
  static const legacyStoreDetails = '/stores/fashion-hub-kathmandu';
  static const shopDashboard = '/shop-dashboard';

  static String requestResponsesPath(String requestId) {
    return '/requests/$requestId/responses';
  }

  static String storeDetailsPath(String shopId) {
    return '/shops/$shopId';
  }
}
