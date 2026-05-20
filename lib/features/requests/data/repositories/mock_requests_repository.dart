import 'package:grabbit/core/errors/app_exception.dart';
import 'package:grabbit/features/requests/domain/entities/create_request_payload.dart';
import 'package:grabbit/features/requests/domain/entities/create_shop_response_payload.dart';
import 'package:grabbit/features/requests/domain/entities/request_responses.dart';
import 'package:grabbit/features/requests/domain/entities/request_summary.dart';
import 'package:grabbit/features/requests/domain/entities/shop_request.dart';
import 'package:grabbit/features/requests/domain/entities/shop_response.dart';
import 'package:grabbit/features/requests/domain/repositories/requests_repository.dart';

const defaultRequestId = 'red-hoodie-size-l';

class MockRequestsRepository implements RequestsRepository {
  const MockRequestsRepository();

  @override
  Future<List<RequestSummary>> fetchRequests() async {
    return _requests;
  }

  @override
  Future<RequestResponses> fetchRequestResponses(String requestId) async {
    RequestSummary? request;
    for (final item in _requests) {
      if (item.id == requestId) {
        request = item;
        break;
      }
    }

    if (request == null) {
      throw const AppException(message: 'Request not found.');
    }

    return RequestResponses(
      request: request,
      responses: _responsesByRequest[requestId] ?? const [],
    );
  }

  @override
  Future<RequestSummary> createRequest(CreateRequestPayload payload) async {
    return RequestSummary(
      id: 'mock-created-request',
      title: payload.title,
      subtitle: payload.description,
      status: RequestStatus.active,
      time: 'Posted just now',
      responseText: '0 shops responded',
      category: payload.category,
      postedAt: 'Posted just now',
      description: payload.description,
      quantity: payload.quantity,
      urgency: payload.urgency,
      locationText: payload.locationText,
      budgetText: 'Budget open',
    );
  }

  @override
  Future<RequestSummary> completeRequestPurchase({
    required String requestId,
    required String shopUserId,
  }) async {
    for (final request in _requests) {
      if (request.id == requestId) {
        return RequestSummary(
          id: request.id,
          title: request.title,
          subtitle: request.subtitle,
          status: RequestStatus.completed,
          time: request.time,
          responseText: 'Completed',
          category: request.category,
          postedAt: request.postedAt,
          description: request.description,
          quantity: request.quantity,
          urgency: request.urgency,
          locationText: request.locationText,
          budgetText: request.budgetText,
          customerName: request.customerName,
        );
      }
    }
    throw const AppException(message: 'Request not found.');
  }

  @override
  Future<void> deleteRequest(String requestId) async {}

  @override
  Future<List<ShopRequest>> fetchShopRequests() async {
    return const [
      ShopRequest(
        id: defaultRequestId,
        title: 'Red Hoodie, Size L',
        subtitle: 'Customer needs cotton fleece, nearby pickup preferred.',
        description:
            'Need a red hoodie, size L, preferably cotton material. Looking for good quality.',
        category: 'Clothing',
        budget: 'Rs. 2,500',
        age: '12 min ago',
        distance: 'Kathmandu, New Baneshwor',
        customerName: 'Customer',
        isNew: true,
        isUrgent: true,
        hasResponded: false,
        responsePrice: '',
        responseMessage: '',
        respondedAgo: '',
      ),
      ShopRequest(
        id: 'iphone-14-pro-case',
        title: 'iPhone 14 Pro Case',
        subtitle: 'Customer wants drop protection and quick availability.',
        description:
            'Looking for a durable phone case for iPhone 14 Pro, preferably with drop protection.',
        category: 'Electronics',
        budget: 'Rs. 1,500',
        age: '25 min ago',
        distance: 'Kathmandu, Putalisadak',
        customerName: 'Customer',
        isNew: false,
        isUrgent: false,
        hasResponded: true,
        responsePrice: 'Rs. 1,450',
        responseMessage:
            'We have a shockproof clear case in stock with raised edges and camera protection.',
        respondedAgo: '8 mins ago',
      ),
      ShopRequest(
        id: 'completed-book-purchase',
        title: 'Second-hand textbooks',
        subtitle: 'Customer completed this purchase after your response.',
        description: 'Looking for used Grade 10 textbooks in good condition.',
        category: 'Books',
        budget: 'Rs. 1,200',
        age: '1 day ago',
        distance: 'Kathmandu, Baneshwor',
        customerName: 'Customer',
        isNew: false,
        isUrgent: false,
        hasResponded: true,
        responsePrice: 'Rs. 1,000',
        responseMessage: 'We kept the book set ready for pickup.',
        respondedAgo: '1 day ago',
        status: RequestStatus.completed,
      ),
    ];
  }

  @override
  Future<ShopResponse> createShopResponse(
    CreateShopResponsePayload payload,
  ) async {
    return ShopResponse(
      shopId: 'mock-shop',
      name: 'Mock Shop',
      distance: 'Nearby',
      respondedAgo: 'just now',
      rating: '4.8',
      reviews: '(0 reviews)',
      message: payload.message,
      price: payload.price,
    );
  }

  @override
  Future<ShopResponse> updateShopResponse(
    CreateShopResponsePayload payload,
  ) async {
    return ShopResponse(
      shopId: 'mock-shop',
      name: 'Mock Shop',
      distance: 'Nearby',
      respondedAgo: 'just now',
      rating: '4.8',
      reviews: '(0 reviews)',
      message: payload.message,
      price: payload.price,
    );
  }
}

const _requests = [
  RequestSummary(
    id: defaultRequestId,
    title: 'Red Hoodie, Size L',
    subtitle: 'Active request with multiple nearby fashion shop responses.',
    status: RequestStatus.active,
    time: 'Posted 2 hours ago',
    responseText: '8 shops responded',
    category: 'Clothing',
    postedAt: 'Posted 2 hours ago',
  ),
  RequestSummary(
    id: 'running-shoes',
    title: 'Running shoes',
    subtitle: 'Waiting for more stores to respond to your size request.',
    status: RequestStatus.pending,
    time: 'Updated 35 mins ago',
    responseText: '2 shops responded',
    category: 'Sports',
    postedAt: 'Posted 35 mins ago',
  ),
  RequestSummary(
    id: 'second-hand-textbooks',
    title: 'Second-hand textbooks',
    subtitle: 'Request closed after pickup confirmation.',
    status: RequestStatus.completed,
    time: 'Closed yesterday',
    responseText: 'Completed',
    category: 'Books',
    postedAt: 'Posted yesterday',
  ),
];

const _responsesByRequest = {
  defaultRequestId: [
    ShopResponse(
      shopId: 'fashion-hub-kathmandu',
      name: 'Fashion Hub Kathmandu',
      distance: '450m away',
      respondedAgo: '5 mins ago',
      rating: '4.8',
      reviews: '(234 reviews)',
      message:
          'We have red hoodie in stock! Available in size L, premium cotton material.',
      price: 'Rs. 2,500',
    ),
    ShopResponse(
      shopId: 'style-corner',
      name: 'Style Corner',
      distance: '800m away',
      respondedAgo: '12 mins ago',
      rating: '4.3',
      reviews: '(89 reviews)',
      message:
          'Available in red, size L. Good quality, slightly used condition.',
      price: 'Rs. 1,800',
    ),
    ShopResponse(
      shopId: 'clothing-paradise',
      name: 'Clothing Paradise',
      distance: '1.2km away',
      respondedAgo: '25 mins ago',
      rating: '4.9',
      reviews: '(456 reviews)',
      message:
          'Brand new red hoodie, size L available. Can deliver within 30 mins!',
      price: 'Rs. 2,800',
    ),
    ShopResponse(
      shopId: 'urban-wear-shop',
      name: 'Urban Wear Shop',
      distance: '1.5km away',
      respondedAgo: '35 mins ago',
      rating: '4.6',
      reviews: '(178 reviews)',
      message:
          'Red hoodie in size L - premium brand, 100% cotton. Visit our store!',
      price: 'Rs. 3,200',
    ),
    ShopResponse(
      shopId: 'trendy-boutique',
      name: 'Trendy Boutique',
      distance: '2.1km away',
      respondedAgo: '1 hour ago',
      rating: '4.4',
      reviews: '(92 reviews)',
      message: 'We have similar hoodie in maroon color, size L. Great quality!',
      price: 'Rs. 2,200',
    ),
    ShopResponse(
      shopId: 'fashion-express',
      name: 'Fashion Express',
      distance: '2.5km away',
      respondedAgo: '1 hour ago',
      rating: '4.7',
      reviews: '(312 reviews)',
      message:
          'Red hoodie available! Size L, brand new with tags. Free delivery.',
      price: 'Rs. 2,600',
    ),
    ShopResponse(
      shopId: 'clothify-store',
      name: 'Clothify Store',
      distance: '3km away',
      respondedAgo: '1.5 hours ago',
      rating: '4.2',
      reviews: '(67 reviews)',
      message:
          'Have red hoodie in L size. Visit us for best deals on winter wear!',
      price: 'Rs. 2,400',
    ),
    ShopResponse(
      shopId: 'street-style-nepal',
      name: 'Street Style Nepal',
      distance: '3.5km away',
      respondedAgo: '2 hours ago',
      rating: '4.5',
      reviews: '(145 reviews)',
      message:
          'Red hoodie, size L. Premium quality, imported material. Check it out!',
      price: 'Rs. 3,500',
    ),
  ],
};
