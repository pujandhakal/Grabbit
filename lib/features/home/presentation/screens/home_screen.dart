import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/widgets/app_section_header.dart';
import 'package:grabbit/core/widgets/app_sticky_page.dart';
import 'package:grabbit/core/widgets/app_status_chip.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppStickyPage(
        header: Column(
          children: [
            const _Header(),
            const SizedBox(height: 16),
            _SearchBar(
              onTap: () => context.push(RoutePaths.postRequest),
            ),
          ],
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 130),
          children: [
            const AppSectionHeader(title: 'Quick Actions'),
            const SizedBox(height: 14),
            _QuickActions(
              onPostRequest: () => context.push(RoutePaths.postRequest),
              onNearbyShops: () => context.go(RoutePaths.requests),
              onOffersAndChats: () => context.go(RoutePaths.chats),
              onFavourites: () => context.go(RoutePaths.profile),
            ),
            const SizedBox(height: 20),
            const AppSectionHeader(
              title: 'Live Requests',
              actionLabel: 'View all',
            ),
            const SizedBox(height: 14),
            ..._liveRequests.map(
              (request) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _LiveRequestCard(request: request),
              ),
            ),
            const SizedBox(height: 14),
            const AppSectionHeader(
              title: 'Trending Deals',
              actionLabel: 'See all',
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 332,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                padding: const EdgeInsets.only(top: 8),
                itemCount: _trendingDeals.length,
                separatorBuilder: (_, __) => const SizedBox(width: 18),
                itemBuilder: (context, index) {
                  return _TrendingDealCard(
                    deal: _trendingDeals[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primaryDark,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.20),
                blurRadius: 24,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'G',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Grabbit',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Kathmandu, Nepal',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Row(
              children: [
                AppIconBadge(
                  icon: Icons.search_rounded,
                  size: 42,
                  backgroundColor: AppColors.accentSoft,
                  foregroundColor: AppColors.accent,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Search or request a product...',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onPostRequest,
    required this.onNearbyShops,
    required this.onOffersAndChats,
    required this.onFavourites,
  });

  final VoidCallback onPostRequest;
  final VoidCallback onNearbyShops;
  final VoidCallback onOffersAndChats;
  final VoidCallback onFavourites;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      clipBehavior: Clip.none,
      crossAxisSpacing: 18,
      mainAxisSpacing: 14,
      childAspectRatio: 1.42,
      children: [
        _QuickActionCard(
          title: 'Post a Request',
          icon: Icons.edit_note_rounded,
          gradient: const [AppColors.primary, AppColors.primaryDark],
          onTap: onPostRequest,
        ),
        _QuickActionCard(
          title: 'Nearby Shops',
          icon: Icons.store_mall_directory_outlined,
          gradient: const [AppColors.blue, Color(0xFF7F9BFF)],
          onTap: onNearbyShops,
        ),
        _QuickActionCard(
          title: 'Offers & Chats',
          icon: Icons.chat_bubble_outline_rounded,
          gradient: const [AppColors.accent, Color(0xFFFFBF62)],
          onTap: onOffersAndChats,
        ),
        _QuickActionCard(
          title: 'Favourites',
          icon: Icons.favorite_outline_rounded,
          gradient: const [Color(0xFFEF7C8E), Color(0xFFF4A0AE)],
          onTap: onFavourites,
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withValues(alpha: 0.38),
            blurRadius: 40,
            spreadRadius: 0,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: gradient.first.withValues(alpha: 0.20),
            blurRadius: 14,
            spreadRadius: -2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(28),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: Colors.white),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LiveRequestCard extends StatelessWidget {
  const _LiveRequestCard({
    required this.request,
  });

  final _LiveRequest request;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  request.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: 12),
              const AppStatusChip(label: 'Live'),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            request.timeAgo,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 6),
          Text(
            request.responses,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _TrendingDealCard extends StatelessWidget {
  const _TrendingDealCard({
    required this.deal,
  });

  final _TrendingDeal deal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: AppSurfaceCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 130,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        deal.assetPath,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: AppStatusChip(
                        label: deal.tag,
                        tone: deal.tag == 'Flash Deal'
                            ? AppStatusTone.accent
                            : AppStatusTone.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deal.product,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    deal.shop,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    deal.price,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deal.originalPrice,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          decoration: TextDecoration.lineThrough,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      AppStatusChip(
                        label: deal.discount,
                        tone: AppStatusTone.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          deal.joined,
                          textAlign: TextAlign.right,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveRequest {
  const _LiveRequest({
    required this.title,
    required this.timeAgo,
    required this.responses,
  });

  final String title;
  final String timeAgo;
  final String responses;
}

class _TrendingDeal {
  const _TrendingDeal({
    required this.tag,
    required this.product,
    required this.shop,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.joined,
    required this.assetPath,
  });

  final String tag;
  final String product;
  final String shop;
  final String price;
  final String originalPrice;
  final String discount;
  final String joined;
  final String assetPath;
}

const _liveRequests = [
  _LiveRequest(
    title: 'Looking for iPhone 14 Pro Max Cover',
    timeAgo: '2 mins ago',
    responses: '2 shops responded',
  ),
  _LiveRequest(
    title: 'Looking for Sony WH-1000XM5 Headphones',
    timeAgo: '15 mins ago',
    responses: '5 shops responded',
  ),
  _LiveRequest(
    title: 'Looking for Nike Air Max 270 - Size 42',
    timeAgo: '28 mins ago',
    responses: '3 shops responded',
  ),
  _LiveRequest(
    title: 'Looking for MacBook Air M2 Charger',
    timeAgo: '1 hour ago',
    responses: '1 shops responded',
  ),
];

const _trendingDeals = [
  _TrendingDeal(
    tag: 'GroupBuy',
    product: 'Samsung Galaxy Buds Pro',
    shop: 'Tech World',
    price: 'Rs. 9,500',
    originalPrice: 'Rs. 12,000',
    discount: '21% OFF',
    joined: '12 joined',
    assetPath: 'assets/images/earbuds.jpg',
  ),
  _TrendingDeal(
    tag: 'Flash Deal',
    product: 'Adidas Running Shoes',
    shop: 'Sports Zone',
    price: 'Rs. 6,800',
    originalPrice: 'Rs. 8,500',
    discount: '20% OFF',
    joined: '8 joined',
    assetPath: 'assets/images/shoe.jpg',
  ),
  _TrendingDeal(
    tag: 'GroupBuy',
    product: 'Instant Coffee 500g',
    shop: 'Daily Groceries',
    price: 'Rs. 950',
    originalPrice: 'Rs. 1,200',
    discount: '21% OFF',
    joined: '25 joined',
    assetPath: 'assets/images/shop.png',
  ),
];
