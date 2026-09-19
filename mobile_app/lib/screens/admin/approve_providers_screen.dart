import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;

import '../../models/service_category.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';

class ApproveProvidersScreen extends StatelessWidget {
  const ApproveProvidersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return pv.Consumer<AppState>(builder: (context, appState, _) {
      final pending = appState.pendingProviders;
      return Scaffold(
        appBar: AppBar(title: const Text('توثيق مقدمي الخدمة')),
        body: SafeArea(
          child: pending.isEmpty
              ? const Center(child: Text('مفيش طلبات جديدة للمراجعة', style: TextStyle(color: Colors.black45)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pending.length,
                  itemBuilder: (context, i) {
                    final p = pending[i];
                    final category = categoryById(p.categoryId ?? '');
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(backgroundColor: AppColors.primaryLight, child: Icon(category.icon, color: AppColors.primary)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      Text('${category.nameAr} · ${p.phone}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.badge_outlined, size: 16, color: Colors.black45),
                                const SizedBox(width: 6),
                                Text('مستند الهوية: ${p.idDocumentPath ?? '-'}', style: const TextStyle(fontSize: 12, color: Colors.black45)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('العنوان: ${p.address}', style: const TextStyle(fontSize: 12, color: Colors.black45)),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => appState.rejectProvider(p.id),
                                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
                                    child: const Text('رفض'),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => appState.approveProvider(p.id),
                                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                                    child: const Text('توثيق وموافقة'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      );
    });
  }
}
