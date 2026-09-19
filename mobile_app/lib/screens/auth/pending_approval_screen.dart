import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;

import '../../models/user_model.dart';
import '../../state/app_state.dart';
import '../../widgets/primary_button.dart';

class PendingApprovalScreen extends StatelessWidget {
  const PendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return pv.Consumer<AppState>(builder: (context, appState, _) {
      final user = appState.currentUser;
      final rejected = user?.providerStatus == ProviderStatus.rejected;

      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(rejected ? Icons.cancel_outlined : Icons.hourglass_top_rounded,
                    size: 72, color: rejected ? Colors.red : Colors.orange),
                const SizedBox(height: 20),
                Text(
                  rejected ? 'للأسف تم رفض طلب الانضمام' : 'حسابك تحت المراجعة',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  rejected
                      ? 'تواصل مع خدمة العملاء لمعرفة السبب.'
                      : 'إدارة شطبلي بتراجع مستنداتك دلوقتي. هيوصلك إشعار أول ما يتم توثيق حسابك.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 32),
                if (!rejected)
                  PrimaryButton(
                    label: 'تحقق من حالة الحساب',
                    onPressed: () {
                      final refreshed = appState.userById(user!.id);
                      if (refreshed?.providerStatus == ProviderStatus.approved) {
                        Navigator.of(context).pushNamedAndRemoveUntil('/provider/home', (route) => false);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('لسه تحت المراجعة، حاول تاني بعد شوية')),
                        );
                      }
                    },
                  ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/role', (route) => false),
                  child: const Text('خروج'),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
