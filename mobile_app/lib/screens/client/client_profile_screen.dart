import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;

import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/support_sheet.dart';

class ClientProfileScreen extends StatelessWidget {
  const ClientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = pv.Provider.of<AppState>(context);
    final user = appState.currentUser!;

    return Scaffold(
      appBar: AppBar(title: const Text('حسابي')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            CircleAvatar(radius: 36, backgroundColor: AppColors.primaryLight, child: Text(user.name.isNotEmpty ? user.name.substring(0, 1) : '؟', style: const TextStyle(fontSize: 24, color: AppColors.primary))),
            const SizedBox(height: 12),
            Center(child: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            Center(child: Text(user.phone, style: const TextStyle(color: Colors.black54))),
            const SizedBox(height: 24),
            Card(
              child: Column(
                children: [
                  ListTile(leading: const Icon(Icons.location_on_outlined), title: const Text('العنوان'), subtitle: Text(user.address)),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.report_outlined),
                    title: const Text('تقديم شكوى'),
                    onTap: () => Navigator.of(context).pushNamed('/client/complaint'),
                  ),
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
