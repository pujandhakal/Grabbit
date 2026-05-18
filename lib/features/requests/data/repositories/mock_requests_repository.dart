import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grabbit/core/errors/app_exception.dart';
import 'package:grabbit/features/requests/domain/entities/request_responses.dart';
import 'package:grabbit/features/requests/domain/entities/request_summary.dart';
import 'package:grabbit/features/requests/domain/entities/shop_response.dart';
import 'package:grabbit/features/requests/domain/repositories/requests_repository.dart';

const defaultRequestId = 'red-hoodie-size-l';

final requestsRepositoryProvider = Provider<RequestsRepository>((ref) {
  return const MockRequestsRepository();
});

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
