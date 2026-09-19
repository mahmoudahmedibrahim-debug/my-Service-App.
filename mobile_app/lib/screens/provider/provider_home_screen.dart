import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;

import '../../models/service_category.dart';
import '../../models/service_request.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/support_sheet.dart';

class ProviderHomeScreen extends StatelessWidget {
  const ProviderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return pv.Consumer<AppState>(builder: (context, appState, _) {
      final provider = appState.currentUser!;
      final category = categoryById(provider.categoryId ?? '');
      final openRequests = appState.requestsForProviderCategory(provider.categoryId ?? '', provider.id);
      final activeJobs = appState.activeJobsForProvider(provider.id);

      return Scaffold(
        appBar: AppBar(
          title: Text('أهلاً، ${provider.name.split(' ').first}'),
          actions: [
            IconButton(icon: const Icon(Icons.support_agent), onPressed: () => showSupportSheet(context)),
            IconButton(icon: const Icon(Icons.person_outline), onPressed: () => Navigator.of(context).pushNamed('/provider/profile')),
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    Icon(category.icon, color: AppColors.primary, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text('كاتيجوري خدمتك: ${category.nameAr}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Text('عمولة ${(provider.commissionRate * 100).toStringAsFixed(0)}%', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (activeJobs.isNotEmpty) ...[
                const Text('شغلانتك الحالية', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ...activeJobs.map((r) => _RequestTile(
                      request: r,
                      onTap: () => Navigator.of(context).pushNamed('/provider/active-job', arguments: r.id),
                    )),
                const SizedBox(height: 24),
              ],
              const Text('طلبات جديدة متاحة', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              if (openRequests.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text('مفيش طلبات جديدة دلوقتي، هنبلغك أول ما يوصل طلب 🔔', style: TextStyle(color: Colors.black45))),
                )
              else
                ...openRequests.map((r) => _RequestTile(
                      request: r,
                      onTap: () => Navigator.of(context).pushNamed('/provider/request-detail', arguments: r.id),
                    )),
            ],
          ),
        ),
      );
    });
  }
}

class _RequestTile extends StatelessWidget {
  final ServiceRequestModel request;
  final VoidCallback onTap;
  const _RequestTile({required this.request, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        title: Text(request.description.isEmpty ? 'طلب خدمة' : request.description, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(request.type == RequestType.inspection ? 'كشف فقط' : 'صيانة / تصليح'),
        trailing: StatusBadge(status: request.status),
      ),
    );
  }
}
