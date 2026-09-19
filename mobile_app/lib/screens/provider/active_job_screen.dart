import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;

import '../../models/service_request.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/rating_stars.dart';

class ActiveJobScreen extends StatelessWidget {
  const ActiveJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final requestId = ModalRoute.of(context)!.settings.arguments as String;

    return pv.Consumer<AppState>(builder: (context, appState, _) {
      final request = appState.requestById(requestId);
      final client = appState.userById(request.clientId);

      return Scaffold(
        appBar: AppBar(title: const Text('الشغلانة الحالية')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(backgroundColor: AppColors.primaryLight, child: Icon(Icons.person, color: AppColors.primary)),
                            const SizedBox(width: 10),
                            Text(client?.name ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(client?.address ?? '-', style: const TextStyle(color: Colors.black54)),
                        const SizedBox(height: 10),
                        Text(request.description.isEmpty ? 'بدون وصف' : request.description),
                        const SizedBox(height: 10),
                        Text('السعر المتفق عليه: ${request.finalPrice?.toStringAsFixed(0) ?? '-'} ج.م', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (request.status == RequestStatus.providerSelected)
                  PrimaryButton(label: 'بدء الخدمة', onPressed: () => appState.startService(requestId)),
                if (request.status == RequestStatus.inProgress)
                  PrimaryButton(label: 'إنهاء الخدمة', color: AppColors.success, onPressed: () => _finishAndRate(context, appState, requestId)),
                if (request.status == RequestStatus.completedUnpaid || request.status == RequestStatus.paid)
                  const Text('الخدمة اتقفلت، بانتظار دفع العميل.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black45)),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _finishAndRate(BuildContext context, AppState appState, String requestId) {
    appState.completeService(requestId);
    double stars = 5;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('قيّم العميل'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InteractiveRatingStars(rating: stars, onChanged: (v) => setState(() => stars = v)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                appState.rate(requestId: requestId, clientRatesProvider: false, stars: stars, comment: '');
                Navigator.of(context).pop();
              },
              child: const Text('إرسال'),
            ),
          ],
        ),
      ),
    );
  }
}
