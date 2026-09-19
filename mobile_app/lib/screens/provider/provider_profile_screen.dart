import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;

import '../../models/service_category.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/rating_stars.dart';
import '../../widgets/support_sheet.dart';

class ProviderProfileScreen extends StatelessWidget {
  const ProviderProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = pv.Provider.of<AppState>(context);
    final user = appState.currentUser!;
    final category = categoryById(user.categoryId ?? '');

    return Scaffold(
      appBar: AppBar(title: const Text('حسابي')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            CircleAvatar(radius: 36, backgroundColor: AppColors.primaryLight, child: Icon(category.icon, size: 32, color: AppColors.primary)),
            const SizedBox(height: 12),
            Center(child: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            Center(child: Text(category.nameAr, style: const TextStyle(color: Colors.black54))),
            const SizedBox(height: 6),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RatingStars(rating: user.ratingAverage),
                  const SizedBox(width: 6),
                  Text('${user.ratingAverage.toStringAsFixed(1)} (${user.ratingCount})'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.percent),
                    title: const Text('نسبة عمولة المنصة'),
                    trailing: Text('${(user.commissionRate * 100).toStringAsFixed(0)}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  if (!user.isTopRated)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text('حافظ على تقييم 4.5+ عشان تقل عمولتك لـ 12%  🎯', style: TextStyle(fontSize: 12, color: Colors.black45)),
                    ),
                  const Divider(height: 1),
                  ListTile(leading: const Icon(Icons.phone_outlined), title: const Text('رقم الموبايل'), subtitle: Text(user.phone)),
                  const Divider(height: 1),
                  ListTile(leading: const Icon(Icons.location_on_outlined), title: const Text('العنوان'), subtitle: Text(user.address)),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.support_agent),
                    title: const Text('خدمة العملاء'),
                    onTap: () => showSupportSheet(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
              onTap: () {
                appState.logout();
                Navigator.of(context).pushNamedAndRemoveUntil('/role', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
