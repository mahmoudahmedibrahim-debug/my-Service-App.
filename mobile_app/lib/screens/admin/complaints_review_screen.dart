import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;

import '../../models/complaint_model.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';

class ComplaintsReviewScreen extends StatelessWidget {
  const ComplaintsReviewScreen({super.key});

  static const _typeLabels = {
    ComplaintType.serviceIssue: 'مشكلة في الخدمة',
    ComplaintType.fraudOrMisconduct: 'نصب / سوء سلوك',
    ComplaintType.appIssue: 'مشكلة في التطبيق',
    ComplaintType.other: 'أخرى',
  };

  @override
  Widget build(BuildContext context) {
    return pv.Consumer<AppState>(builder: (context, appState, _) {
      final complaints = appState.complaints;
      return Scaffold(
        appBar: AppBar(title: const Text('الشكاوى')),
        body: SafeArea(
          child: complaints.isEmpty
              ? const Center(child: Text('مفيش شكاوى حاليًا', style: TextStyle(color: Colors.black45)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: complaints.length,
                  itemBuilder: (context, i) {
                    final c = complaints[i];
                    final user = appState.userById(c.userId);
                    final resolved = c.status == ComplaintStatus.resolved;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: Icon(resolved ? Icons.check_circle : Icons.error_outline, color: resolved ? AppColors.success : Colors.orange),
                        title: Text(_typeLabels[c.type] ?? ''),
                        subtitle: Text('${user?.name ?? '-'} — ${c.description}', maxLines: 2, overflow: TextOverflow.ellipsis),
                        trailing: resolved
                            ? null
                            : TextButton(onPressed: () => appState.resolveComplaint(c.id), child: const Text('إغلاق')),
                      ),
                    );
                  },
                ),
        ),
      );
    });
  }
}
