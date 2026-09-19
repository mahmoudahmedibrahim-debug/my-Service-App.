import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;

import '../../models/service_request.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final requestId = ModalRoute.of(context)!.settings.arguments as String;

    return pv.Consumer<AppState>(builder: (context, appState, _) {
      final request = appState.requestById(requestId);
      final provider = appState.userById(request.selectedProviderId ?? '');

      return Scaffold(
        appBar: AppBar(title: const Text('متابعة الطلب')),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 220,
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(child: Icon(Icons.location_on, color: Colors.red, size: 54)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const CircleAvatar(radius: 24, backgroundColor: AppColors.primaryLight, child: Icon(Icons.engineering, color: AppColors.primary)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(provider?.name ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('${request.finalPrice?.toStringAsFixed(0) ?? '-'} ج.م', style: const TextStyle(color: Colors.black54, fontSize: 13)),
                            ],
                          ),
                        ),
                        IconButton(icon: const Icon(Icons.phone, color: AppColors.primary), onPressed: () {}),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _StepsTimeline(status: request.status),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: _BottomAction(request: request, appState: appState),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _StepsTimeline extends StatelessWidget {
  final RequestStatus status;
  const _StepsTimeline({required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = ['تم اختيار مقدم الخدمة', 'في الطريق إليك', 'جاري تنفيذ الخدمة', 'تم الانتهاء'];
    int activeIndex;
    switch (status) {
      case RequestStatus.providerSelected:
        activeIndex = 1;
        break;
      case RequestStatus.inProgress:
        activeIndex = 2;
        break;
      case RequestStatus.completedUnpaid:
      case RequestStatus.paid:
        activeIndex = 3;
        break;
      default:
        activeIndex = 0;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: List.generate(steps.length, (i) {
          final done = i <= activeIndex;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(done ? Icons.check_circle : Icons.radio_button_unchecked, size: 18, color: done ? AppColors.success : Colors.black26),
                const SizedBox(width: 10),
                Text(steps[i], style: TextStyle(color: done ? AppColors.text : Colors.black38, fontWeight: done ? FontWeight.bold : FontWeight.normal)),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _BottomAction extends StatelessWidget {
  final ServiceRequestModel request;
  final AppState appState;
  const _BottomAction({required this.request, required this.appState});

  @override
  Widget build(BuildContext context) {
    if (request.status == RequestStatus.completedUnpaid) {
      return PrimaryButton(
        label: 'الدفع الآن',
        onPressed: () => Navigator.of(context).pushReplacementNamed('/client/payment', arguments: request.id),
      );
    }
    if (request.status == RequestStatus.providerSelected || request.status == RequestStatus.inProgress) {
      return const Text(
        'هيوصلك إشعار أول ما مقدم الخدمة يبدأ وينهي الشغل.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black45, fontSize: 12),
      );
    }
    return const SizedBox.shrink();
  }
}
