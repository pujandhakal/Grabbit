import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grabbit/core/network/connectivity_status.dart';
import 'package:grabbit/features/chat/data/repositories/chat_repository.dart';
import 'package:grabbit/features/profile/data/repositories/customer_profile_repository.dart';
import 'package:grabbit/features/profile/data/repositories/shop_profile_repository.dart';
import 'package:grabbit/features/requests/presentation/controllers/request_providers.dart';

final signedInDataRefresherProvider = Provider<SignedInDataRefresher>((ref) {
  return SignedInDataRefresher(ref);
});

final connectivityAutoRefreshProvider = Provider<void>((ref) {
  ref.listen<AsyncValue<bool>>(networkConnectionProvider, (previous, next) {
    final wasOffline = previous?.valueOrNull == false;
    final isOnline = next.valueOrNull == true;

    if (wasOffline && isOnline) {
      ref.read(signedInDataRefresherProvider).refresh();
    }
  });
});

void refreshSignedInData(WidgetRef ref) {
  ref.invalidate(networkConnectionProvider);
  ref.read(signedInDataRefresherProvider).refresh();
}

class SignedInDataRefresher {
  const SignedInDataRefresher(this._ref);

  final Ref _ref;

  void refresh() {
    _ref.read(customerProfileCacheProvider.notifier).state = null;
    _ref.invalidate(customerProfileProvider);
    _ref.invalidate(customerReviewsProvider);
    _ref.invalidate(shopProfileProvider);
    _ref.invalidate(requestsProvider);
    _ref.invalidate(requestResponsesProvider);
    _ref.invalidate(shopRequestsProvider);
    _ref.invalidate(shopRequestDetailProvider);
    _ref.invalidate(chatThreadsProvider);
  }
}
