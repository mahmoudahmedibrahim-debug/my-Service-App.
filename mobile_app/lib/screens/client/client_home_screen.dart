import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;

import '../../models/service_request.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/category_card.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/support_sheet.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return pv.Consumer<AppState>(builder: (context, appState, _) {
      final user = appState.currentUser!;
      final pendingRating = appState.pendingRatingRequest(user.id);
      final myRequests = appState.requestsForClient(user.id);

      return Scaffold(
        appBar: AppBar(
          title: Text('أهلاً، ${user.name.split(' ').first} 👋'),
          actions: [
            IconButton(icon: const Icon(Icons.support_agent), onPressed: () => showSupportSheet(context)),
            IconButton(icon: const Icon(Icons.person_outline), onPressed: () => Navigator.of(context).pushNamed('/client/profile')),
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (pendingRating != null)
                _PendingRatingBanner(
                  onTap: () => Navigator.of(context).pushNamed('/client/rating', arguments: pendingRating.id),
                ),
              const Text('محتاج عون في إيه النهاردة؟', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
                children: appState.categories
                    .map((c) => CategoryCard(
                          category: c,
                          onTap: () {
                            if (pendingRating != null) {
                              _blockedDialog(context);
                              return;
                            }
                            Navigator.of(context).pushNamed('/client/create-request', arguments: c.id);
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 28),
              const Text('طلباتك', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (myRequests.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text('لسه مفيش طلبات، اختار خدمة وابدأ 🙌', style: TextStyle(color: Colors.black45))),
                )
              else
                ...myRequests.map((r) => _RequestTile(request: r)),
            ],
          ),
        ),
      );
    });
  }

  void _blockedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('محتاج تقيّم الخدمة اللي فاتت'),
        content: const Text('عشان نحافظ على جودة الخدمة، لازم تقيّم آخر طلب قبل ما تفتح طلب جديد.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسنًا'))],
      ),
    );
  }
}

class _PendingRatingBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _PendingRatingBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.accentYellow.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            const Icon(Icons.star_rate_rounded, color: Colors.orange, size: 28),
            const SizedBox(width: 12),
            const Expanded(child: Text('قيّم آخر خدمة قبل ما تقدر تطلب تانية', style: TextStyle(fontWeight: FontWeight.bold))),
            const Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ),
    );
  }
}

class _RequestTile extends StatelessWidget {
  final ServiceRequestModel request;
  const _RequestTile({required this.request});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(request.description.isEmpty ? 'طلب خدمة' : request.description, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text('${request.fairPriceMin.toStringAsFixed(0)} - ${request.fairPriceMax.toStringAsFixed(0)} ج.م'),
        trailing: StatusBadge(status: request.status),
        onTap: () => _routeForStatus(context, request),
      ),
    );
  }

  void _routeForStatus(BuildContext context, ServiceRequestModel r) {
    switch (r.status) {
      case RequestStatus.awaitingOffers:
      case RequestStatus.offersReceived:
        Navigator.of(context).pushNamed('/client/offers', arguments: r.id);
        break;
      case RequestStatus.providerSelected:
      case RequestStatus.inProgress:
        Navigator.of(context).pushNamed('/client/tracking', arguments: r.id);
        break;
      case RequestStatus.completedUnpaid:
        Navigator.of(context).pushNamed('/client/payment', arguments: r.id);
        break;
      case RequestStatus.paid:
        if (!r.clientRated) {
          Navigator.of(context).pushNamed('/client/rating', arguments: r.id);
        }
        break;
      case RequestStatus.cancelled:
        break;
    }
  }
}
