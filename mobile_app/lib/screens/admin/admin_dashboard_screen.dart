import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;

import '../../state/app_state.dart';
import '../../theme/app_theme.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return pv.Consumer<AppState>(builder: (context, appState, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('لوحة تحكم شطبلي'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                appState.logout();
                Navigator.of(context).pushNamedAndRemoveUntil('/role', (route) => false);
              },
            ),
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.5,
                children: [
                  _StatCard(label: 'إجمالي المستخدمين', value: '${appState.totalUsers}', icon: Icons.people_outline),
                  _StatCard(label: 'إجمالي الطلبات', value: '${appState.totalRequests}', icon: Icons.receipt_long_outlined),
                  _StatCard(label: 'العمولات المحصلة', value: '${appState.totalCommissionCollected.toStringAsFixed(0)} ج.م', icon: Icons.payments_outlined),
                  _StatCard(label: 'مقدمين بانتظار المراجعة', value: '${appState.pendingProviders.length}', icon: Icons.pending_actions, highlight: appState.pendingProviders.isNotEmpty),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.verified_user_outlined, color: AppColors.primary),
                      title: const Text('الموافقة على مقدمي الخدمة'),
                      trailing: appState.pendingProviders.isEmpty ? null : CircleAvatar(radius: 12, backgroundColor: Colors.red, child: Text('${appState.pendingProviders.length}', style: const TextStyle(fontSize: 11, color: Colors.white))),
                      onTap: () => Navigator.of(context).pushNamed('/admin/approve-providers'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.report_gmailerrorred_outlined, color: AppColors.primary),
                      title: const Text('مراجعة الشكاوى'),
                      trailing: appState.complaints.isEmpty ? null : CircleAvatar(radius: 12, backgroundColor: Colors.orange, child: Text('${appState.complaints.length}', style: const TextStyle(fontSize: 11, color: Colors.white))),
                      onTap: () => Navigator.of(context).pushNamed('/admin/complaints'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'إعدادات المنصة: عمولة أساسية 15%، تُخفَّض لـ 12% لمقدمي الخدمة ذوي التقييم 4.5+.',
                style: TextStyle(fontSize: 12, color: Colors.black45),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool highlight;
  const _StatCard({required this.label, required this.value, required this.icon, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlight ? AppColors.accentYellow.withValues(alpha: 0.2) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }
}
